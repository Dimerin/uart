library ieee;
use ieee.std_logic_1164.all;

entity uart_tb1 is
end uart_tb1;

architecture test1 of uart_tb1 is 
    constant clk_period : time := 8 ns;
    constant clk_per_bit : positive := 1085;
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
        
            -- Apply test vectors
            x_valid <= '1';
            x <= "1000000";
            wait for clk_period;
            x_valid <= '0';
            wait for clk_period*clk_per_bit*6;
            x_valid <= '1';
            x <= "1111111";
            wait for clk_period;
            x_valid <= '0';
            wait for clk_period*clk_per_bit*12;
            testing <= false;
        
            -- Finish simulation
    
        end process;
end architecture;
    