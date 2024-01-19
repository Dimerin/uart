library ieee;
use ieee.std_logic_1164.all;
 

entity uart_tb1 is
end uart_tb1;

architecture test1 of uart_tb1 is 
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
            -- Simulating two words sent respecting timing constraints. At the end it will be driven a reset.
            -- Correctly driving both inputs in order to test the correct behaviour of the circuit.
            x_valid <= '1'; 
            x <= "1000000"; 
            wait for clk_period; 
            -- Driving correctly x_valid to start the transmission.
            x_valid <= '0';
            wait for clk_period*clk_per_bit*12; 
            -- Here the circuit has just finished the transmission of the first word and it's going to start the transmission of the second one.
            x_valid <= '1';
            x <= "1111111";
            wait for clk_period;
            x_valid <= '0';
            wait for clk_period*clk_per_bit*13;
            --In this case it's going to wait another cycle in order to test if the circuit drives tx to '1' when the latter is idle.
            resetn_i <= '1';
            wait for clk_period;
            -- End of simulation
            testing <= false;
            wait;            
        end process;
end architecture;
    