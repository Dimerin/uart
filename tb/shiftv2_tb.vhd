library ieee;
use ieee.std_logic_1164.all;

entity tb_shift_left_register is
end tb_shift_left_register;

architecture tb of tb_shift_left_register is
    constant clk_period : time := 8 ns;
    constant Nbit: positive := 12;
    signal clk: std_logic := '0';
    signal reset: std_logic := '0';
    signal load: std_logic := '0';
    signal data_in: std_logic_vector(Nbit-1 downto 0) := (others => '0');
    signal shift_out: std_logic;
    signal testing : boolean := true;
begin
    clk <= not clk after clk_period/2 when testing else '0';
    uut: entity work.shift_left_register
        generic map (Nbit => Nbit)
        port map (clk => clk, reset => reset, load => load, data_in => data_in, shift_out => shift_out);

    stimulus_process: process
    begin
        -- Apply reset
        reset <= '1';
        wait for 20 ns;
        reset <= '0';
        wait for 20 ns;
    
        -- Apply test vectors
        load <= '1';
        data_in <= "100110011001";
        wait for 8696 ns;
        load <= '0';
        wait for 104256 ns;
        load <= '1';
        data_in <= "011001100110";
        wait for 8 ns;
        load <= '0';
        wait for 96 ns;
        testing <= false;
    
        -- Finish simulation

    end process;
end tb;