library ieee;
use ieee.std_logic_1164.all;

entity shift_left_register is
    generic (
        ClksPerBit : positive := 1086; 
        -- This is the number of clock cycles per bit transmitter with Baud Rate 115200. Essentially it can be adjusted if the Baud Rate is changed.
        Nbit: positive := 12            
        -- Due to others protocols, the number of bits can be changed.
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
     -- A signal used to correctly shift the data.
    signal clock_counter : integer range 0 to ClksPerBit-1 := 0; 
    -- Counter needed to count the clock cycles.
    signal idle : std_logic := '1'; 
    -- A signal used to indicate that the data is not being transmitted.
    signal count : integer range 0 to Nbit+1 := 0; 
    -- A counter used to count the number of bits transmitted.
begin
    
    process(clk, reset)

    begin
        --We are in the reset state.
        if reset = '1' then 
        -- all the signals are set to 0 in order to avoid latches 
            reg <= (others => '0'); 
            clock_counter <= 0;
            count <= 0;
        elsif rising_edge(clk) then 
        -- We are in the rising edge of the clock.
            if load = '1' and count = 0 then 
            -- If the load signal is 1, the data is loaded into the register.
                reg <= data_in;        
                -- The data is loaded into the register.
                idle <= '0';      
                 -- The idle signal is set to 0 in order to indicate that the system is busy.
                clock_counter <= 0; 
                -- The clock counter is set to 0 in order to start counting the clock cycles.
                count <= 1; 
                -- The count is set to 1 in order to start counting the bits.
            elsif clock_counter = ClksPerBit-1 and  count > 0 and count < Nbit  then 
            -- If the clock counter is equal to the number of clock cycles per bit
                reg <= reg(Nbit-2 downto 0) & '1'; 
                -- The data is shifted to the left.
                clock_counter <= 0; 
                -- The clock counter is set to 0 in order to start counting the next clock cycles.
                idle <= '0'; 
                -- The idle signal is set to 0 in order to indicate that the system is busy.
                count <= count+1; 
                -- The count is incremented by 1 because a bit has been transmitted.
            elsif count = Nbit and clock_counter = ClksPerBit-1 then 
            -- If the count is equal to 12 and the clock counter is equal to the number of clock cycles per bit
                count <= 0; 
                -- All the bits have been transmitted, so the count is set to 0.
            elsif count /= 0 then 
            -- If the count is not equal to 0
                clock_counter <= clock_counter+1; 
                -- Increment the clock counter by 1.
                idle <= '0'; 
                -- The idle signal is set to 0 in order to indicate that the system is busy.
            else 
                idle <= '1'; 
                -- The idle signal is set to 1 in order to indicate that the system is idle.
            end if;
        end if;
    end process;
    shift_out <=idle or reg(Nbit-1); 
    -- The shift_out signal is set to 1 if the system is idle, otherwise it is set to the MSB of the register.
end behavior;
