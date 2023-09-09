library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity SR_FF_tb is
end entity;

architecture testbench of SR_FF_tb is

component SR_FF is
Port ( S,R : in STD_LOGIC;
Q,Qb : out STD_LOGIC);
end component;

signal S, R, Q, Qb : STD_LOGIC;

begin
uut: entity work.SR_FF port map(
S => S,
R => R,
Q => Q,
Qb => Qb);

Force : process
begin

S <= '0';
R <= '0';
wait for 30 ns;

S <= '1';
R <= '1';
wait for 30 ns;

S <= '0';
R <= '1';
wait for 30 ns;

S <= '1';
R <= '0';
wait for 30 ns;

end process;
end testbench;
