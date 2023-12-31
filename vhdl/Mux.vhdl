LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY Mux IS
PORT ( SEL: IN STD_LOGIC_VECTOR(2 DOWNTO 0);
 MUX_IN :IN STD_LOGIC_VECTOR(7 downto 0);
MUX_OUT: OUT STD_LOGIC );
END Mux;

ARCHITECTURE M OF Mux IS
BEGIN
PROCESS (SEL,MUX_IN)
BEGIN
CASE  SEL IS
	WHEN "000" => MUX_OUT <= MUX_IN(0);
	WHEN "001" => MUX_OUT <= MUX_IN(1);
	WHEN "010" => MUX_OUT <= MUX_IN(2);
	WHEN "011" => MUX_OUT <= MUX_IN(3);
	WHEN "100" => MUX_OUT <= MUX_IN(4);
	WHEN "101" => MUX_OUT <= MUX_IN(5);
	WHEN "110" => MUX_OUT <= MUX_IN(6);
	WHEN "111" => MUX_OUT <= MUX_IN(7);
	WHEN OTHERS => NULL;
END CASE;
END PROCESS;
END M;

