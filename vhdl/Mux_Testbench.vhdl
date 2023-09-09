library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity mux_testbench is
end mux_testbench;

architecture testbench of mux_testbench is
component mux is
port(
SEL: IN STD_LOGIC_VECTOR(2 DOWNTO 0);
 MUX_IN :IN STD_LOGIC_VECTOR(7 downto 0);
MUX_OUT: OUT STD_LOGIC );
end component mux;

signal MUX_IN :  std_logic_vector (7 downto 0);
signal Sel : std_logic_vector (2 downto 0);
signal MUX_OUT : std_logic;

begin
UUT : entity work.mux PORT MAP(MUX_IN=>MUX_IN,Sel=>Sel,MUX_OUT=>MUX_OUT);

MUX_IN <= "00000001",
"00000010" after 20 ns,
"00000100" after 40 ns,
"00001000" after 60 ns,
"00010000" after 80 ns,
"00100000" after 100 ns,
"01000000" after 120 ns,
"10000000" after 140 ns,
"01000000" after 160 ns;

Sel <= "000",
"001" after 20 ns,
"010" after 40 ns,
"011" after 60 ns,
"100" after 80 ns,
"101" after 100 ns,
"110" after 120 ns,
"111" after 140 ns;

end testbench;
