library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Sub_testbench is
end Sub_testbench;

architecture testbench of Sub_testbench is
component Full_Sub is
port (Sub_in : in std_logic_vector (2 downto 0); 
DIFF,Borrow:out std_logic); 
end component Full_Sub;

signal Sub_in : std_logic_vector (2 downto 0);
signal DIFF,Borrow : std_logic;

begin
UUT: entity work.Full_Sub PORT MAP (Sub_in=>Sub_in, DIFF=>DIFF, Borrow=>Borrow);

Sub_in <= "000",
"001" after 20 ns,
"010" after 40 ns,
"011" after 60 ns,
"100" after 80 ns,
"101" after 100 ns,
"110" after 120 ns,
"111" after 140 ns;

end testbench;
