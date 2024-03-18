library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
  use ieee.std_logic_misc.all;

entity uart is 
  generic(
    Nbit : positive := 7; -- number of bits in the input
    Mbit : positive := 12 -- number of bits for the parallel shifter
);

  port(
    clk_i : in std_logic;
    resetn_i : in std_logic;
    x : in std_logic_vector(Nbit-1 downto 0);
    x_valid : in std_logic;
    tx: out std_logic
  );
end entity;

architecture rtl of uart is 
    -- x_1 is the output of the first flip flop and it is in input of the xorNto1
    signal x_1 : std_logic_vector(Nbit-1 downto 0);
    -- x_3 is the signal that is loaded in the parallel shifter
    signal x_3 : std_logic_vector(Mbit-1 downto 0);
    -- xor_out is the signal that is the output of the xorNto1
    signal xor_out : std_logic := '0';
    -- valid_s is the signal that is the output of the second flip flop which store the x_valid value
    signal valid_s : std_logic := '0';
    -- psl_out signal is the output of the parallel shifter
    signal psl_out : std_logic;

    component dff_n is --Flip flop with N bits
    generic(
        Nbit : positive := 7
    );
    port(
      clk_i : in std_logic;
      resetn_i : in std_logic;
      di : in std_logic_vector(Nbit-1 downto 0);
      en : in std_logic;
      do : out std_logic_vector(Nbit-1 downto 0)
    );
    end component;

    component DFC is --Flip flop with 1 bit
        port(
            clk_i : in std_logic;
            resetn_i :  in std_logic;
            d : in std_logic;
            q : out std_logic
        );
    end component;
   
    component shift_left_register is
    -- Shift register with parallel loading

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
    end component;

    -- XOR with 7 inputs and 1 output
    component seven_input_xor is
        port(
            xor_input : in std_logic_vector(Nbit-1 downto 0);
            y : out std_logic
        );
    end component;
  
  begin 
    --Instantiate the components
    ff1: dff_n
    generic map(
        Nbit => 7
    )
    port map(
        clk_i => clk_i,
        resetn_i => resetn_i,
        di => x, -- mapping the input x to the input of the first flip flop
        en => '1',
        do => x_1 -- mapping the output of the first flip flop to the input of the xorNto1
    );


    ff2: DFC
    port map(
        clk_i => clk_i,
        resetn_i => resetn_i,
        d => x_valid, -- mapping the input x_valid to the input of the second flip flop
        q => valid_s -- mapping the output of the second flip flop to the input of the parallel shifter
    );

    parallel_shifter: shift_left_register
    generic map(
        Nbit => 12
    )
    port map(
        clk => clk_i,
        reset => resetn_i,
        load => valid_s, -- useful to load the parallel shifter only when the input x_valid is asserted
        data_in => x_3,  -- mapping the input x_3 to the input of the parallel shifter
        shift_out => psl_out -- mapping the output of the parallel shifter to the input of the third flip flop
    );

    ff3: DFC
    port map(
        clk_i => clk_i,
        resetn_i => resetn_i,
        d => psl_out, -- mapping the output of the parallel shifter to the input of the third flip flop
        q => tx -- mapping the output of the third flip flop to the output tx
    );
    -- combining all the start/stop bits and the parity bit with the input x
    x_3(11 downto 10) <= (others =>'0');
    x_3(1 downto 0) <= (others =>'1');
    x_3(2) <= xor_out;
    x_3(9 downto 3) <= x_1;   

    xor_seven: seven_input_xor
    port map(
        xor_input => x_1,
        y => xor_out
    );
   

end architecture;
                
