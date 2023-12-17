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
    type state is (S0,S1,S2);
    signal current_state : state;
    signal reg : std_logic_vector(Nbit-1 downto 0) := (others => '0');
    signal clock_counter : integer range 0 to ClksPerBit-1 := 1;
    --signal idle : std_logic := '1';
    signal count : integer range 0 to 11 := 0;
begin
   
    process(clk, reset)

    begin
        if reset = '1' then
            current_state <= S0;
            reg <= (others => '0');
            clock_counter <= 1084;
            count <= 0;
        elsif rising_edge(clk) then
            --current_state <= next_state;
           case current_state is
            when S0 =>
            if load = '1' then
                current_state <= S1;
                reg <= data_in;
                clock_counter <= 1083;
                count <= 1;
            end if;

            when S1 => 
                if clock_counter = 0 then
                    current_state <= S2;
                    clock_counter <= 1083;
                else
                    clock_counter <= clock_counter - 1;
                end if;
            when S2 =>
                if count = 11 then
                    current_state <= S0;
                else 
                    reg <= reg(Nbit-2 downto 0) & '1';
                    clock_counter <= 1084;
                    count <= count+1;
                    current_state <= S1;
                end if;
            end case;
        end if;
    end process;

    p_OUTPUT_LOGIC: process(current_state, reg)
    begin
        shift_out <= '1';
        case current_state is
            when S0 =>
                shift_out <= '1';
            when S1 =>
                shift_out <= reg(Nbit-1);
            when S2 =>
                shift_out <= reg(Nbit-1);
        end case; 
    end process;    


end behavior;

