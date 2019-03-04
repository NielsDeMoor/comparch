entity Driver_7seg_4 is
    generic(
         C_F_CLK : natural := 50000000 -- system clock frequency
    );
    port(
          clk : in  std_logic;
        reset : in  std_logic;
         bcd0 : in  std_logic_vector(3 downto 0);
         bcd1 : in  std_logic_vector(3 downto 0);
         bcd2 : in  std_logic_vector(3 downto 0);
         bcd3 : in  std_logic_vector(3 downto 0);
         -- toevoegen van 4 extra 7 segmenten
         bcd4 : in  std_logic_vector(3 downto 0);
         bcd5 : in  std_logic_vector(3 downto 0);
         bcd6 : in  std_logic_vector(3 downto 0);
         bcd7 : in  std_logic_vector(3 downto 0);
          seg : out std_logic_vector(6 downto 0);
           an : out std_logic_vector(7 downto 0) -- nu 8 anodes
    );
end Driver_7seg_4;

architecture Behavioral of Driver_7seg_4 is
    constant C_F_REFRESH : natural := 400;
    constant C_REFRESH_COUNT_MAX : integer := (C_F_CLK / C_F_REFRESH) - 1;
   	-- aanpassing an_i std_logic_vectors naar juiste breedte (8 breed)
    signal pulse_refresh_i : std_logic := '0';
    signal select_cntr_i : std_logic_vector(2 downto 0) := "000";
    signal an_i : std_logic_vector(7 downto 0) := "00000000";
    signal bcd_i : std_logic_vector(3 downto 0) := "0000";
    signal seg_i : std_logic_vector(6 downto 0) := "0000000";
begin

    REFRESH_CLK_PROC: process(clk, reset) is
        variable cntr_i : integer range 0 to C_REFRESH_COUNT_MAX := 0;
    begin
        if reset='1' then
            cntr_i := 0;
            pulse_refresh_i <= '0';
        elsif rising_edge(clk) then
            if cntr_i=C_REFRESH_COUNT_MAX then
                cntr_i := 0;
                pulse_refresh_i <= '1';
            else
                cntr_i := cntr_i + 1;
                pulse_refresh_i <= '0';
            end if;
        end if;
    end process REFRESH_CLK_PROC;
    
    SELECT_CNT_PROC : process(clk, reset) is
    begin
        if reset='1' then
            select_cntr_i <= "000";
        elsif rising_edge(clk) then
            if pulse_refresh_i = '1' then
                select_cntr_i <= select_cntr_i + '1';
            end if;
        end if;
    end process SELECT_CNT_PROC;
    
    an <= an_i;
    with select_cntr_i select -- aanpassing van 4 naar 8 "0001" --> "00000001"
        an_i <= "11111110" when "000",
                "11111101" when "001",
                "11111011" when "010",
                "11110111" when "011",
                "11101111" when "100",
                "11011111" when "101",
                "10111111" when "110",
                "01111111" when "111";
                
    
    with select_cntr_i select
        bcd_i <= bcd0 when "000",
                 bcd1 when "001",
                 bcd2 when "010",
                 bcd3 when "011",
                 bcd4 when "100",
                 bcd5 when "101",
                 bcd6 when "110",
                 bcd7 when "111",
                 "11111111" when others;
    
    seg <= not seg_i;

    --...... not changed this code

end Behavioral;
