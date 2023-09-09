LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
 
entity BtoG_testbench is
end BtoG_testbench;

architecture testbench of BtoG_testbench is 
component BinarytoGray is
port ( Input : in std_logic_vector (3 downto 0);
Output : out std_logic_vector (3 downto 0));
end component BinarytoGray;

signal Input : std_logic_vector (3 downto 0);
signal Output : std_logic_vector (3 downto 0);

begin
UUT: entity work.BinarytoGray PORT MAP (Input=>Input, Output=>Output);

Input <= "0000",
"0001" after 20 ns,
"0010" after 40 ns,
"0011" after 60 ns,
"0100" after 80 ns,
"0101" after 100 ns,
"0110" after 120 ns,
"0111" after 140 ns,
"1000" after 160 ns,
"1001" after 180 ns,
"1010" after 200 ns,
"1011" after 220 ns,
"1100" after 240 ns,
"1101" after 260 ns,
"1110" after 280 ns,
"1111" after 300 ns;

end testbench;