library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
  use ieee.std_logic_misc.all;

entity uart is 
  generic(
    ClksPerBit : positive := 1086;
    Nbit : positive := 7;
    Mbit : positive := 12
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

    signal x_1 : std_logic_vector(Nbit-1 downto 0) := (others => '0');
    signal x_3 : std_logic_vector(Mbit-1 downto 0) := (others => '0');
    signal xor_out : std_logic := '0';
    signal valid_s : std_logic := '0';
    signal count : integer range 0 to ClksPerBit-1*12 := 0;
    signal psl_out : std_logic;

    component dff_n is 
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

    component DFC is
        port(
            clk_i : in std_logic;
            resetn_i :  in std_logic;
            d : in std_logic;
            q : out std_logic
        );
    end component;
   
    component shift_left_register is

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


    component seven_input_xor is
        port(
            xor_input : in std_logic_vector(Nbit-1 downto 0);
            y : out std_logic
        );
    end component;
  
  begin 

    ff1: dff_n
    generic map(
        Nbit => 7
    )
    port map(
        clk_i => clk_i,
        resetn_i => resetn_i,
        di => x,
        en => '1',
        do => x_1
    );


    ff2: DFC
    port map(
        clk_i => clk_i,
        resetn_i => resetn_i,
        d => x_valid,
        q => valid_s
    );

    parallel_shifter: shift_left_register
    generic map(
        Nbit => 12
    )
    port map(
        clk => clk_i,
        reset => resetn_i,
        load => valid_s,
        data_in => x_3,
        shift_out => psl_out
    );

    ff3: DFC
    port map(
        clk_i => clk_i,
        resetn_i => resetn_i,
        d => psl_out,
        q => tx
    );

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
                