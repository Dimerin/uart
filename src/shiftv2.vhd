library ieee;
use ieee.std_logic_1164.all;

-----------------------------------------------------------------------------------
  -- Parallel shift left register with load on 12 bits input.
  -----------------------------------------------------------------------------------
entity shift_left_register is
    generic (
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
    type state is (S0,S1,S2); -- Definition of the state machine
    constant ClksPerBit : positive := 1085; -- The aim of the project is to implement a UART Transmitter. The baud rate is 115200. The clock frequency is 125mhz. The number of clock cycles per bit is 1085.
    signal current_state : state;
    signal reg : std_logic_vector(Nbit-1 downto 0) := (others => '0'); -- It will be used a signal named reg to store the data in the actual shift_left_register.
    signal clock_counter : integer range 0 to ClksPerBit-1 := 1; -- It will be used a signal named clock_counter to count the number of clock cycles.
    signal count : integer range 0 to 12 := 0; -- It will be used a signal named count to count the number of bits transmitted.
begin
   
    process(clk, reset)

    begin
        if reset = '1' then -- The reset is asynchronous.
            current_state <= S0; -- The state machine is reset.
            reg <= (others => '0'); -- The register is reset.
            clock_counter <= 1084; -- The clock counter is reset.
            count <= 0;        -- The count is reset.
        elsif rising_edge(clk) then 
           case current_state is -- The state machine is implemented.
            when S0 =>  
            if load = '1' then -- When the load is high, the data_in is loaded in the register.
                current_state <= S1; -- The state machine goes to the next state.
                reg <= data_in; -- The data_in is loaded in the register.
                clock_counter <= 1083; -- The clock counter is reset, but with a value of 1083, because we're loading shift_out with the first bit of the parallel shift left register.
                count <= 1; -- Count is set to 1, because we're loading shift_out with the first bit of the parallel shift left register.
            end if;
            when S1 => 
                if clock_counter = 0 then -- We wait for the clock_counter to reach 0, we need to wait 1085 clock cycles to transmit a bit.
                    current_state <= S2; -- The state machine goes to the next state.
                    clock_counter <= 1083; -- The clock counter is reset, but with a value of 1083, because we're loading shift_out with the first bit of the parallel shift left register.
                else
                    clock_counter <= clock_counter - 1; -- The clock counter is decremented, because we're waiting for the clock_counter to reach 0.
                end if;
            when S2 =>
                if count = 12 then -- When the count reaches 11, we have transmitted all the bits.
                    current_state <= S0; -- The state machine is reset.
                else 
                    reg <= '1' & reg(Nbit-1 downto 1); -- The parallel shift left register is shifted left.
                    clock_counter <= 1084; -- The clock counter is reset, but with a value of 1084.
                    count <= count+1; -- The count is incremented, because we have transmitted a bit.
                    current_state <= S1; -- The state machine goes to the next state.
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
                shift_out <= reg(0);
            when S2 =>
                shift_out <= reg(0);
        end case; 
    end process;    


end behavior;

