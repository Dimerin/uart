library IEEE;
    use IEEE.std_logic_1164.all;
    use IEEE.numeric_std.all;

entity dff_n is
    generic(
        Nbit : positive := 8
    );

    port(
        clk_i : in std_logic;
        resetn_i : in std_logic;
        di : in std_logic_vector(NBit-1 downto 0);
        en : in std_logic;
        do : out std_logic_vector(Nbit-1 downto 0)
    );
end entity;

architecture rtl of dff_n is
    signal di_s : std_logic_vector(Nbit-1 downto 0);
    signal do_s : std_logic_vector(Nbit-1 downto 0);

begin
    p_DFCE: process(clk_i, resetn_i)
    begin
        if resetn_i = '1' then
            do_s <= (others =>'0');
        elsif rising_edge(clk_i) then
            do_s <= di_s;
        end if;
    end process;
    
    di_s <= di when en = '1' else do_s;
    do <= do_s;
end architecture;

