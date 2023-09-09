library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity JK_FF is
	port( J, K: in std_logic;
		Q, Qbar : out std_logic);
end JK_FF;

architecture JK of JK_FF is
begin
process(J,K)
variable qn : std_logic;
begin
if(J='0' and K='0')then
qn := qn;
elsif(J='0' and K='1')then
qn := '0';
elsif(J='1' and K='0')then
qn := '1';
elsif(J='1' and K='1')then
qn := not qn;
else
null;
end if;
Q <= qn;
Qbar <= not qn;

end process;
end JK;