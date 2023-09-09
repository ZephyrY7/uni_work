library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity adder_testbench is
end adder_testbench;

architecture testbench of adder_testbench is
component Full_Adder is
port (add_in : in std_logic_vector (2 downto 0); 
sum,carry:out std_logic); 
end component Full_Adder;

signal add_in : std_logic_vector (2 downto 0);
signal sum,carry : std_logic;

begin
UUT: entity work.Full_Adder PORT MAP (add_in=>add_in, sum=>sum, carry=>carry);

add_in <= "000",
"001" after 20 ns,
"010" after 40 ns,
"011" after 60 ns,
"100" after 80 ns,
"101" after 100 ns,
"110" after 120 ns,
"111" after 140 ns;

end testbench;
