library ieee; 
use ieee.std_logic_1164.all; 
 
entity parallelshift is 
  generic(
    Nbit : positive := 12
  );
  port( clk : in std_logic; 
        reset_n : in std_logic;
        x_3  : in std_logic_vector(Nbit-1 downto 0); 
        psl_out : out std_logic); 
end entity;

architecture architecture of parallelshift is 
  component dff_n is
    port( clk : in std_logic; 
          reset_n : in std_logic;
          d : in std_logic; 
          q : out std_logic);
  end component;

  signal q_s : std_logic_vector(Nbit-1 downto 0); 

  begin 
   g_DFC: for i in 1 to Nbit generate
    g_FIRST: if i = 1 generate
      g_DFF: dff_n port map( clk => clk, reset_n => reset_n, d => x_3(i-1), q => q_s(i-1));
    end generate g_FIRST;
    g_INTERNAL: if i > 1 and i < Nbit generate
      g_DFF: dff_n port map( clk => clk, reset_n => reset_n, d => q_s(i-2), q => q_s(i-1));
    end generate g_INTERNAL;
    g_LAST: if i = Nbit generate
      g_DFF: dff_n port map( clk => clk, reset_n => reset_n, d => q_s(i-2), q => psl_out);
    end generate g_LAST;
  end generate g_DFC;
end architecture;