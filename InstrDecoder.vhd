----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:33:06 10/20/2014 
-- Design Name: 
-- Module Name:    InstrDecoder - arch_InstrDecoder 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity InstrDecoder is
    Port ( instr   : in  STD_LOGIC_vector(31 downto 0);
           opcode  : out  STD_LOGIC_vector(5 downto 0);
           rs      : out  STD_LOGIC_vector(4 downto 0);
           rt      : out  STD_LOGIC_vector(4 downto 0);
           rd      : out  STD_LOGIC_vector(4 downto 0);
           shamt   : out  STD_LOGIC_vector(4 downto 0);
           funct   : out  STD_LOGIC_vector(5 downto 0);
           immAddr : out  STD_LOGIC_vector(15 downto 0);
           jAddr   : out  STD_LOGIC_vector(25 downto 0));
end InstrDecoder;

architecture arch_InstrDecoder of InstrDecoder is

begin
    opcode  <= instr(31 downto 26);
	 rs      <= instr(25 downto 21);
	 rt      <= instr(20 downto 16);
	 rd      <= instr(15 downto 11);
	 shamt   <= instr(10 downto 6);
	 funct   <= instr(5 downto 0);
	 immAddr <= instr(15 downto 0);
	 jAddr   <= instr(25 downto 0);

end arch_InstrDecoder;

