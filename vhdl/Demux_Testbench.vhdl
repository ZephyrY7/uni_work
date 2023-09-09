library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity demux_testbench is
end demux_testbench;

architecture testbench of demux_testbench is
component demux is
port(
MUX_IN : in std_logic;
Sel : in std_logic_vector (2 downto 0);
MUX_OUT : out std_logic_vector (7 downto 0)
);
end component demux;

signal MUX_IN :  std_logic;
signal Sel : std_logic_vector (2 downto 0);
signal MUX_OUT : std_logic_vector (7 downto 0);

begin
UUT : entity work.demux PORT MAP(MUX_IN=>MUX_IN,Sel=>Sel,MUX_OUT=>MUX_OUT);

MUX_IN <= '1';

Sel <= "000",
"001" after 20 ns,
"010" after 40 ns,
"011" after 60 ns,
"100" after 80 ns,
"101" after 100 ns,
"110" after 120 ns,
"111" after 140 ns;

end testbench;