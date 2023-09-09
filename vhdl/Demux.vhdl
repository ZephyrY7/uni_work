library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity demux is
port(MUX_IN:in std_logic;
Sel:in std_logic_vector(2 downto 0);
MUX_OUT:out std_logic_vector(7 downto 0));
end demux;

architecture dem of demux is
begin
MUX_OUT(0)<=MUX_IN when Sel="000"else'0';
MUX_OUT(1)<=MUX_IN when Sel="001"else'0';
MUX_OUT(2)<=MUX_IN when Sel="010"else'0';
MUX_OUT(3)<=MUX_IN when Sel="011"else'0';
MUX_OUT(4)<=MUX_IN when Sel="100"else'0';
MUX_OUT(5)<=MUX_IN when Sel="101"else'0';
MUX_OUT(6)<=MUX_IN when Sel="110"else'0';
MUX_OUT(7)<=MUX_IN when Sel="111"else'0';
end dem;