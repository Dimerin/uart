library IEEE;
    use IEEE.std_logic_1164.all;
 -----------------------------------------------------------------------------------
  -- Flip Flop D input lenght 1 bit
  -----------------------------------------------------------------------------------
entity DFC is
    port(
        clk_i : in std_logic;
        resetn_i :  in std_logic;
        d : in std_logic;
        q : out std_logic
    );

end entity;

architecture ff of DFC is
    begin
        p_DFC: process(clk_i, resetn_i) 
        begin
            if (resetn_i = '1') then
                q <= '0';
            elsif (rising_edge(clk_i)) then
                q <= d;
            end if;
        end process;
end architecture;