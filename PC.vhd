----------------------------------------------------------------------------------
-- Company: NUS
-- Engineer: Rajesh Panicker
-- 
-- Create Date:   21:06:18 14/10/2014
-- Design Name: 	PC
-- Target Devices: Nexys 4 (Artix 7 100T)
-- Tool versions: ISE 14.7
-- Description: PC for the basic MIPS processor
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

entity PC is
	Port(	PC_in 	: in STD_LOGIC_VECTOR (31 downto 0);
			PC_out 	: out STD_LOGIC_VECTOR (31 downto 0):= x"003FFFFC";
			RESET		: in STD_LOGIC;
			clk      : in std_logic);
end PC;


architecture arch_PC of PC is
begin
process(clk, reset)
begin
    if reset = '1' then
	     pc_out <= x"00400000";
	 elsif clk'event and clk = '1' then
	     pc_out <= pc_in;
	 end if;
end process;
end arch_PC;

