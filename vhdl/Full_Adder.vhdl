
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity full_adder is port
(add_in : in std_logic_vector (2 downto 0); 
sum,carry:out std_logic); 
end full_adder;

architecture data of full_adder is
begin
   sum<= add_in(2) xor add_in(1) xor add_in(0); 
   carry <= ((add_in(2) and add_in(1)) or (add_in(1) and add_in(0)) or (add_in(2) and add_in(0))); 
end data;
