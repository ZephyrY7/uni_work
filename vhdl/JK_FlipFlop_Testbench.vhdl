library ieee;
use ieee.std_logic_1164.all;

entity JK_FF_tb is
end JK_FF_tb;

architecture testbench of JK_FF_tb is

component JK_FF is
port(J, K, rst : in std_logic;
Q, Qbar : out std_logic
);
end component;

signal J, K : std_logic;
signal Q, Qbar : std_logic;

begin
uut: entity work.JK_FF port map(
J => J,
K => K,
Q => Q,
Qbar => Qbar);
Force: process
begin
J <= '0';
K <= '0';
wait for 30 ns;
J <= '0';
K <= '1';
wait for 30 ns;
J <= '1';
K <= '0';
wait for 30 ns;
J <= '1';
K <= '1';
wait for 30 ns;
J <= '1';
K <= '1';
wait for 30 ns;

J <= '0';
K <= '0';
wait for 30 ns;
J <= '0';
K <= '0';
wait for 30 ns;
end process;
end testbench;
