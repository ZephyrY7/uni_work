library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity full_sub is
port( Sub_in : in std_logic_vector (2 downto 0);
DIFF, Borrow : out std_logic);
end entity;

architecture dataflow of full_sub is
begin

DIFF <= (Sub_in(2) xor Sub_in(1)) xor Sub_in(0);
Borrow <= ((NOT Sub_in(2) AND Sub_in(1)) OR (Sub_in(1) AND Sub_in(0)) OR (NOT Sub_in(2) AND Sub_in(0)));

end dataflow;
