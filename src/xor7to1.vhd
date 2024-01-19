library ieee;
use ieee.std_logic_1164.all;

entity seven_input_xor is
    generic(
        N : integer := 7
    );
    port(
        xor_input : in std_logic_vector(N-1 downto 0);
        y : out std_logic
    );
end entity seven_input_xor;

architecture xor_arch of seven_input_xor is
begin
    p: process(xor_input)
    variable xor_result : std_logic;
    begin
        xor_result := xor_input(0);
        for i in 1 to N-1 loop
            xor_result := xor_result xor xor_input(i);
        end loop;
    y <= xor_result;
    end process;
end architecture;