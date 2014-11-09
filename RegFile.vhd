----------------------------------------------------------------------------------
-- Company: NUS
-- Engineer: Rajesh Panicker
-- 
-- Create Date:   21:06:18 14/10/2014
-- Design Name: 	RegFile
-- Target Devices: Nexys 4 (Artix 7 100T)
-- Tool versions: ISE 14.7
-- Description: Register File for the MIPS processor
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
use ieee.numeric_std.all;

entity RegFile is
    Port ( 	ReadAddr1_Reg 	: in  STD_LOGIC_VECTOR (4 downto 0);
				ReadAddr2_Reg 	: in  STD_LOGIC_VECTOR (4 downto 0);
				ReadData1_Reg 	: out STD_LOGIC_VECTOR (31 downto 0);
				ReadData2_Reg 	: out STD_LOGIC_VECTOR (31 downto 0);				
				WriteAddr_Reg	: in  STD_LOGIC_VECTOR (4 downto 0); 
				WriteData_Reg 	: in  STD_LOGIC_VECTOR (31 downto 0);
				RegWrite 		: in  STD_LOGIC; 
				CLK 				: in  STD_LOGIC);
end RegFile;


architecture arch_RegFile of RegFile is
    type register_array is array (0 to 31) of std_logic_vector (31 downto 0);
    signal registers: register_array :=(others => x"00000000");
begin
    readdata1_reg <= registers(to_integer(unsigned(readaddr1_reg)));
	 readdata2_reg <= registers(to_integer(unsigned(readaddr2_reg)));
process(clk)
begin
	 if clk'event and clk = '0' then
	 if regwrite = '1' then
		  registers(to_integer(unsigned(writeaddr_reg))) <= writedata_reg;
	 end if;
	 end if;
end process;
end arch_RegFile;

