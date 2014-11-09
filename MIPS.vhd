----------------------------------------------------------------------------------
-- Company: NUS
-- Engineer: Rajesh Panicker
-- 
-- Create Date:   21:06:18 14/10/2014
-- Design Name: 	MIPS
-- Target Devices: Nexys 4 (Artix 7 100T)
-- Tool versions: ISE 14.7
-- Description: MIPS processor
--
-- Dependencies: PC, ALU, ControlUnit, RegFile
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: DO NOT modify the interface (entity). Implementation (architecture) can be modified.
--
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;

entity MIPS is -- DO NOT modify the interface (entity)
    Port ( 	
			Addr_Instr 		: out STD_LOGIC_VECTOR (31 downto 0);
			Instr 			: in STD_LOGIC_VECTOR (31 downto 0);
			Addr_Data		: out STD_LOGIC_VECTOR (31 downto 0);
			Data_In			: in STD_LOGIC_VECTOR (31 downto 0);
			Data_Out			: out  STD_LOGIC_VECTOR (31 downto 0);
			MemRead 			: out STD_LOGIC; 
			MemWrite 		: out STD_LOGIC; 
			RESET				: in STD_LOGIC;
			CLK				: in STD_LOGIC
			);
end MIPS;


architecture arch_MIPS of MIPS is

----------------------------------------------------------------
-- Program Counter
----------------------------------------------------------------
component PC is
	Port(	
			PC_in 	: in STD_LOGIC_VECTOR (31 downto 0);
			PC_out 	: out STD_LOGIC_VECTOR (31 downto 0);
			RESET		: in STD_LOGIC;
			clk      : in std_logic);
end component;

----------------------------------------------------------------
-- Instruction Decoder
----------------------------------------------------------------
component InstrDecoder is
	Port(	
			  instr   : in  STD_LOGIC_vector(31 downto 0);
           opcode  : out  STD_LOGIC_vector(5 downto 0);
           rs      : out  STD_LOGIC_vector(4 downto 0);
           rt      : out  STD_LOGIC_vector(4 downto 0);
           rd      : out  STD_LOGIC_vector(4 downto 0);
           shamt   : out  STD_LOGIC_vector(4 downto 0);
           funct   : out  STD_LOGIC_vector(5 downto 0);
           immAddr : out  STD_LOGIC_vector(15 downto 0);
           jAddr   : out  STD_LOGIC_vector(25 downto 0));
end component;

----------------------------------------------------------------
-- Sign Extender
----------------------------------------------------------------
component signextender is
   generic(N: integer);
	Port(	
			se_in 	: in STD_LOGIC_VECTOR (n-1 downto 0);
			se_out 	: out STD_LOGIC_VECTOR (31 downto 0));
end component;

----------------------------------------------------------------
-- ALU
----------------------------------------------------------------
component ALU is
    Port ( 	
			ALU_InA 		: in  STD_LOGIC_VECTOR (31 downto 0);				
			ALU_InB 		: in  STD_LOGIC_VECTOR (31 downto 0);
			ALU_Out 		: out STD_LOGIC_VECTOR (31 downto 0);
			ALU_Control	: in  STD_LOGIC_VECTOR (7 downto 0);
			ALU_zero		: out STD_LOGIC);
end component;

----------------------------------------------------------------
-- Control Unit
----------------------------------------------------------------
component ControlUnit is
    Port ( 	
			opcode 		: in   STD_LOGIC_VECTOR (5 downto 0);
			ALUOp 		: out  STD_LOGIC_VECTOR (1 downto 0);
			Branch 		: out  STD_LOGIC;
			Jump	 		: out  STD_LOGIC;				
			MemRead 		: out  STD_LOGIC;	
			MemtoReg 	: out  STD_LOGIC;	
			InstrtoReg	: out  STD_LOGIC; -- true for LUI. When true, Instr(15 downto 0)&x"0000" is written to rt
			MemWrite		: out  STD_LOGIC;	
			ALUSrc 		: out  STD_LOGIC;	
			SignExtend 	: out  STD_LOGIC; -- false for ORI 
			RegWrite		: out  STD_LOGIC;	
			RegDst		: out  STD_LOGIC);
end component;

----------------------------------------------------------------
-- Register File
----------------------------------------------------------------
component RegFile is
    Port ( 	
			ReadAddr1_Reg 	: in  STD_LOGIC_VECTOR (4 downto 0);
			ReadAddr2_Reg 	: in  STD_LOGIC_VECTOR (4 downto 0);
			ReadData1_Reg 	: out STD_LOGIC_VECTOR (31 downto 0);
			ReadData2_Reg 	: out STD_LOGIC_VECTOR (31 downto 0);				
			WriteAddr_Reg	: in  STD_LOGIC_VECTOR (4 downto 0); 
			WriteData_Reg 	: in STD_LOGIC_VECTOR (31 downto 0);
			RegWrite 		: in STD_LOGIC; 
			CLK 				: in  STD_LOGIC);
end component;

----------------------------------------------------------------
-- PC Signals
----------------------------------------------------------------
	signal	PC_in 		   :  STD_LOGIC_VECTOR (31 downto 0) := x"00400000";
	signal	PC_out 		   :  STD_LOGIC_VECTOR (31 downto 0);
	signal   nextaddr       : std_logic_vector (31 downto 0);
	signal   seaddr         : std_logic_vector (31 downto 0); --sign extended address
	signal   leftshiftedaddr: std_logic_vector (31 downto 0); --left shifted by 2 after sign extended
	signal   branchaddr     : std_logic_vector (31 downto 0);
	signal   jumpaddr       : std_logic_vector (31 downto 0);

----------------------------------------------------------------
-- ALU Signals
----------------------------------------------------------------
	signal	ALU_InA 		:  STD_LOGIC_VECTOR (31 downto 0);
	signal	ALU_InB 		:  STD_LOGIC_VECTOR (31 downto 0);
	signal	ALU_Out 		:  STD_LOGIC_VECTOR (31 downto 0);
	signal	ALU_Control	:  STD_LOGIC_VECTOR (7 downto 0);
	signal	ALU_zero		:  STD_LOGIC;			

----------------------------------------------------------------
-- Control Unit Signals
----------------------------------------------------------------				
 	signal	opcode 		:  STD_LOGIC_VECTOR (5 downto 0);
	signal	ALUOp 		:  STD_LOGIC_VECTOR (1 downto 0);
	signal	Branch 		:  STD_LOGIC;
	signal	Jump	 		:  STD_LOGIC;	
	signal	MemtoReg 	:  STD_LOGIC;
	signal 	InstrtoReg	: 	STD_LOGIC;		
	signal	ALUSrc 		:  STD_LOGIC;	
	signal	SignExtend 	: 	STD_LOGIC;
	signal	RegWrite		: 	STD_LOGIC;	
	signal	RegDst		:  STD_LOGIC;

----------------------------------------------------------------
-- Register File Signals
----------------------------------------------------------------
 	signal	ReadAddr1_Reg 	:  STD_LOGIC_VECTOR (4 downto 0);
	signal	ReadAddr2_Reg 	:  STD_LOGIC_VECTOR (4 downto 0);
	signal	ReadData1_Reg 	:  STD_LOGIC_VECTOR (31 downto 0);
	signal	ReadData2_Reg 	:  STD_LOGIC_VECTOR (31 downto 0);
	signal	WriteAddr_Reg	:  STD_LOGIC_VECTOR (4 downto 0); 
	signal	WriteData_Reg 	:  STD_LOGIC_VECTOR (31 downto 0);

----------------------------------------------------------------
-- Instruction Decoder Signals
----------------------------------------------------------------
	signal rs      : STD_LOGIC_vector(4 downto 0);
   signal rt      : STD_LOGIC_vector(4 downto 0);
   signal rd      : STD_LOGIC_vector(4 downto 0);
   signal shamt   : STD_LOGIC_vector(4 downto 0);
   signal funct   : STD_LOGIC_vector(5 downto 0);
   signal immAddr : STD_LOGIC_vector(15 downto 0);
   signal jAddr   : STD_LOGIC_vector(25 downto 0);
 

----------------------------------------------------------------	
----------------------------------------------------------------
-- <MIPS architecture>
----------------------------------------------------------------
----------------------------------------------------------------
begin

----------------------------------------------------------------
-- PC port map
----------------------------------------------------------------
PC1				: PC port map
						(
						PC_in 	=> PC_in, 
						PC_out 	=> PC_out, 
						RESET 	=> RESET,
						clk      => clk
						);
						
----------------------------------------------------------------
-- Instruction Decoder port map
----------------------------------------------------------------
InstrDecoder1	: InstrDecoder port map
						(
						instr   => instr, 
						opcode  => opcode, 
						rs      => rs,
						rt      => rt,
						rd      => rd,
						shamt   => shamt,
						funct   => funct,
						immaddr => immaddr,
						jaddr   => jaddr
						);
						
----------------------------------------------------------------
-- sign extender port map
----------------------------------------------------------------
signextender1	: signextender generic map(n=>16)
                 port map
						(
						se_in 	=> immaddr, 
						se_out 	=> seaddr 
						);
						
----------------------------------------------------------------
-- ALU port map
----------------------------------------------------------------
ALU1 				: ALU port map
						(
						ALU_InA 		=> ALU_InA, 
						ALU_InB 		=> ALU_InB, 
						ALU_Out 		=> ALU_Out, 
						ALU_Control => ALU_Control, 
						ALU_zero  	=> ALU_zero
						);
						
----------------------------------------------------------------
-- Control unit port map
----------------------------------------------------------------
ControlUnit1 	: ControlUnit port map
						(
						opcode 		=> opcode, 
						ALUOp 		=> ALUOp, 
						Branch 		=> Branch, 
						Jump 			=> Jump, 
						MemRead 		=> MemRead, 
						MemtoReg 	=> MemtoReg, 
						InstrtoReg 	=> InstrtoReg, 
						MemWrite 	=> MemWrite, 
						ALUSrc 		=> ALUSrc, 
						SignExtend 	=> SignExtend, 
						RegWrite 	=> RegWrite, 
						RegDst 		=> RegDst
						);
						
----------------------------------------------------------------
-- Register file port map
----------------------------------------------------------------
RegFile1			: RegFile port map
						(
						ReadAddr1_Reg 	=>  ReadAddr1_Reg,
						ReadAddr2_Reg 	=>  ReadAddr2_Reg,
						ReadData1_Reg 	=>  ReadData1_Reg,
						ReadData2_Reg 	=>  ReadData2_Reg,
						WriteAddr_Reg 	=>  WriteAddr_Reg,
						WriteData_Reg 	=>  WriteData_Reg,
						RegWrite 		=>  RegWrite,
						CLK 				=>  CLK				
						);

----------------------------------------------------------------
-- Processor logic
----------------------------------------------------------------
nextaddr <= pc_out + "100";
leftshiftedaddr <= seaddr(29 downto 0) & "00" when signextend = '1' else
                   x"0000" & immaddr;
branchaddr <= nextaddr + leftshiftedaddr;
jumpaddr <= nextaddr(31 downto 28) & jaddr & "00";

alu_inA <= readdata1_reg;
alu_inB <= readdata2_reg when alusrc = '0' else
           seaddr;
alu_control <= aluop & funct;

writeaddr_reg <= rt when regdst = '0' else
                 rd;

writedata_reg <= data_in when instrtoreg = '0' and memtoreg = '1' else
                 alu_out when instrtoreg = '0' and memtoreg = '0' else
					  immaddr & x"0000";

readaddr1_reg <= rs;
readaddr2_reg <= rt;

addr_data <= alu_out;
data_out <= readdata2_reg;

pc_in <= branchaddr when branch = '1' and alu_zero = '1' else
         jumpaddr when jump = '1' else
			nextaddr;
			
addr_instr <= pc_out;
					  
end arch_MIPS;

----------------------------------------------------------------	
----------------------------------------------------------------
-- </MIPS architecture>
----------------------------------------------------------------
----------------------------------------------------------------	
