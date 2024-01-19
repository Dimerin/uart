library ieee;
use ieee.std_logic_1164.all;

entity uart_tb2 is
end uart_tb2;

architecture test2 of uart_tb2 is 
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
        
            -- Simulating scenario where while the UART is transmitting, the input is changed and wrongfully x_valid  is set to 1.
            -- After the wrong driving, the inputs are changed again (in this case driven correctly), in order to check if the trasmitter is still working.
            x_valid <= '1';
            x <= "1000000";
            wait for clk_period;
            x_valid <= '0';
            wait for clk_period*clk_per_bit*6;
            x_valid <= '1';
            x <= "0000000";
            wait for clk_period;
            x_valid <= '0';
            wait for clk_period*clk_per_bit*6;
            x_valid <= '1';
            x <= "0101010";
            wait for clk_period;
            x_valid <= '0';
            wait for clk_period*clk_per_bit*12;
            testing <= false;
           -- End of simulation
           wait;            
        end process;
end architecture;
    