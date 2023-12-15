library ieee;
use ieee.std_logic_1164.all;

entity seven_input_xor is
    port(
        xor_input : in std_logic_vector(6 downto 0);
        y : out std_logic
    );
end entity seven_input_xor;

architecture xor_arch of seven_input_xor is
begin
    y <= xor_input(0) xor xor_input(1) xor xor_input(2) xor xor_input(3) xor xor_input(4) xor xor_input(5) xor xor_input(6);
end architecture;