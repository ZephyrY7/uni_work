library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
entity SR_FF is
    Port ( S,R : in  STD_LOGIC;
           Q,Qb : out STD_LOGIC);
end SR_FF;

architecture SR of SR_FF is

begin

process (S,R)

begin
if (S /= R) then
Q <= S;
Qb <= R;
elsif (S = '1' AND R = '1') then
Q<='Z';
Qb<='Z';
else
null;
end if; 
end process;
end SR;
