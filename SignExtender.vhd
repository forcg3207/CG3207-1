----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:45:50 10/20/2014 
-- Design Name: 
-- Module Name:    SignExtender - arch_SignExtender
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

entity SignExtender is
generic( n: integer);
    Port ( se_in  : in  STD_LOGIC_vector(n-1 downto 0);
           se_out : out  STD_LOGIC_vector(31 downto 0));
end SignExtender;

architecture arch_SignExtender of SignExtender is

begin
process(se_in)
begin
    se_out(n-1 downto 0) <= se_in(n-1 downto 0);
	 se_out(31 downto n) <= (others => se_in(n-1)); 
end process;
end arch_SignExtender;

