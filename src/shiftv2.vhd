library ieee;
use ieee.std_logic_1164.all;

entity shift_left_register is
    generic (
        ClksPerBit : positive := 1085;
        Nbit: positive := 12
    );
    port(
        clk : in std_logic;
        reset : in std_logic;
        load : in std_logic;
        data_in : in std_logic_vector(Nbit-1 downto 0);
        shift_out : out std_logic
    );
end shift_left_register;

architecture behavior of shift_left_register is
    signal reg : std_logic_vector(Nbit-1 downto 0) := (others => '0');
    signal clock_counter : integer range 0 to ClksPerBit-1 := 0;
    signal idle : std_logic := '1';
    signal count : integer range 0 to (ClksPerBit-1)*12 := 0;
begin
    
    process(clk, reset)

    begin
        if reset = '1' then
            reg <= (others => '0');
            clock_counter <= 0;
            --idle <= '1';
            count <= 0;
        elsif rising_edge(clk) then
            if load = '1' and count = 0 then
                reg <= data_in;
                idle <= '0';
                clock_counter <= 0;
                count <= 1;
            elsif clock_counter = ClksPerBit-1 and count /= 0 then
                reg <= reg(Nbit-2 downto 0) & '1';
                clock_counter <= 0;
                idle <= '0';
                count <= count+1;
            elsif count = 11 then
                count <= 0;
            elsif count /= 0 then 
                clock_counter <= clock_counter+1;
                idle <= '0';
            else 
                idle <= '1';
            end if;
        end if;
    end process;
    shift_out <=idle or reg(Nbit-1);
end behavior;
