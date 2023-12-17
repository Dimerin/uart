library ieee;
use ieee.std_logic_1164.all;

entity uart_tb3 is
end uart_tb3;

architecture test3 of uart_tb3 is 
    constant clk_period : time := 8 ns;
    constant clk_per_bit : positive := 1086;
    constant Nbit: positive := 7;
    signal clk_i: std_logic := '0';
    signal resetn_i: std_logic := '0';
    signal x_valid: std_logic := '0';
    signal x : std_logic_vector(Nbit-1 downto 0) := (others => '0');
    signal tx: std_logic;
    signal testing : boolean := true;

    begin
        clk_i <= not clk_i after clk_period/2 when testing else '0';
        DUT : entity work.uart
            port map (clk_i => clk_i,
            resetn_i => resetn_i,
            x_valid => x_valid,
            x => x,
            tx => tx);

        STIMULUS: process
        begin
            -- Apply reset
            resetn_i <= '1';
            wait for clk_period*clk_per_bit;
            resetn_i <= '0';
            wait for clk_period*clk_per_bit;
        
            -- Simulating a scenario where the input x is changed while x_valid is not driven correctly. Then we start a new transmission with a new x and a correct x_valid.
            x_valid <= '1';
            x <= "1000000";
            wait for clk_period;
            x_valid <= '0';
            wait for clk_period*clk_per_bit*12;
            x <= "0000000";
            wait for clk_period*clk_per_bit*6;
            x_valid <= '1';
            x <= "0101010";
            wait for clk_period;
            x_valid <= '0';
            wait for clk_period*clk_per_bit*12;
            testing <= false;
           -- Finish simulation
        end process;
end architecture;
    