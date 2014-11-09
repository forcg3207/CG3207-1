----------------------------------------------------------------------------------
-- Company: NUS
-- Engineer: Rajesh Panicker
-- 
-- Create Date:   21:06:18 14/10/2014
-- Design Name: 	ControlUnit
-- Target Devices: Nexys 4 (Artix 7 100T)
-- Tool versions: ISE 14.7
-- Description: Control Unit for the basic MIPS processor
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: The interface (entity) as well as implementation (architecture) can be modified
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;

entity ControlUnit is
    Port ( 	opcode 		: in  STD_LOGIC_VECTOR (5 downto 0);
				ALUOp 		: out  STD_LOGIC_VECTOR (1 downto 0);
				Branch 		: out  STD_LOGIC;		
				Jump	 		: out  STD_LOGIC;	
				MemRead 		: out  STD_LOGIC;	
				MemtoReg 	: out  STD_LOGIC;	
				InstrtoReg	: out  STD_LOGIC;
				MemWrite		: out  STD_LOGIC;	
				ALUSrc 		: out  STD_LOGIC;	
				SignExtend 	: out  STD_LOGIC;
				RegWrite		: out  STD_LOGIC;	
				RegDst		: out  STD_LOGIC);
end ControlUnit;


architecture arch_ControlUnit of ControlUnit is  
begin   
process(opcode)
begin
case opcode is
when "100011" =>  --lw
    aluop      <= "00";
	 branch     <= '0';
	 jump       <= '0';
	 memread    <= '1';
	 memtoreg   <= '1';
	 instrtoreg <= '0';
	 memwrite   <= '0';
	 alusrc     <= '1';
	 signextend <= '1';
	 regwrite   <= '1';
	 regdst     <= '0';

when "101011" => --sw
    aluop      <= "00";
	 branch     <= '0';
	 jump       <= '0';
	 memread    <= '0';
	 memtoreg   <= '0';
	 instrtoreg <= '0';
	 memwrite   <= '1';
	 alusrc     <= '1';
	 signextend <= '1';
	 regwrite   <= '0';
	 regdst     <= '0';
	 
when "001111" => --lui
    aluop      <= "00";
	 branch     <= '0';
	 jump       <= '0';
	 memread    <= '0';
	 memtoreg   <= '0';
	 instrtoreg <= '1'; -- true for LUI. When true, Instr(15 downto 0)&x"0000" is written to rt
	 memwrite   <= '0';
	 alusrc     <= '0';
	 signextend <= '0';
	 regwrite   <= '1';
	 regdst     <= '0';
	 	 
when "001101" => --ori
    aluop      <= "11";
	 branch     <= '0';
	 jump       <= '0';
	 memread    <= '0';
	 memtoreg   <= '0';
	 instrtoreg <= '0';
	 memwrite   <= '0';
	 alusrc     <= '1';
	 signextend <= '0'; --imm is zero extended
	 regwrite   <= '1';
	 regdst     <= '0';
	 
when "000100" => --beq
    aluop      <= "01";
	 branch     <= '1';
	 jump       <= '0';
	 memread    <= '0';
	 memtoreg   <= '0';
	 instrtoreg <= '0';
	 memwrite   <= '0';
	 alusrc     <= '0';
	 signextend <= '1';
	 regwrite   <= '0';
	 regdst     <= '0';
	 
when "000010" => --j
    aluop      <= "00";
	 branch     <= '0';
	 jump       <= '1';
	 memread    <= '0';
	 memtoreg   <= '0';
	 instrtoreg <= '0';
	 memwrite   <= '0';
	 alusrc     <= '0';
	 signextend <= '0';
	 regwrite   <= '0';
	 regdst     <= '0';
	 
when "001000" => --addi
    aluop      <= "00";
	 branch     <= '0';
	 jump       <= '0';
	 memread    <= '0';
	 memtoreg   <= '0';
	 instrtoreg <= '0';
	 memwrite   <= '0';
	 alusrc     <= '1';
	 signextend <= '1';
	 regwrite   <= '1';
	 regdst     <= '0';
	 
----------------------------------------------------------------
-- R-type operations below
----------------------------------------------------------------
 
when "000000" => --add, sub, and, or, nor, slt
    aluop      <= "10";
	 branch     <= '0';
	 jump       <= '0';
	 memread    <= '0';
	 memtoreg   <= '0';
	 instrtoreg <= '0';
	 memwrite   <= '0';
	 alusrc     <= '0';
	 signextend <= '0';
	 regwrite   <= '1';
	 regdst     <= '1'; 

when others => null;	 
end case;
end process;
end arch_ControlUnit;

