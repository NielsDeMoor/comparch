
entity IO is
    generic(
                C_F_CLK : natural := 100000000;
             C_DELAY_MS : natural := 20;
           C_ADDR_WIDTH : natural := 6;
           C_DATA_WIDTH : natural := 8;
              C_NR_BTNS : natural := 5;
                C_NR_SW : natural := 16;
              C_NR_LEDS : natural := 16
    );
    port(
            -- global system clock and reset
                    clk : in  std_logic;
                  reset : in  std_logic;
            -- connections to system bus
            address_bus : in  std_logic_vector(C_ADDR_WIDTH-1 downto 0);
            data_bus_in : in  std_logic_vector(C_DATA_WIDTH-1 downto 0);
           data_bus_out : out std_logic_vector(C_DATA_WIDTH-1 downto 0);
                read_en : in  std_logic;
               write_en : in  std_logic;
                    irq : out std_logic;
                  ready : out std_logic;
            -- connections to FPGA pins       
                     sw : in  std_logic_vector(C_NR_SW-1 downto 0);
                   btns : in  std_logic_vector(C_NR_BTNS-1 downto 0);
                   leds : out std_logic_vector(C_NR_LEDS-1 downto 0);
                    seg : out std_logic_vector(6 downto 0);
                     an : out std_logic_vector(7 downto 0)  --lengte van 4 naar 8
    );
end IO;

-- aanpassing van 16 naar 32 (4x8)
signal bcd_reg_i       : std_logic_vector(31 downto 0) := (others=>'0');

component Driver_7seg_4 is
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
           an : out std_logic_vector(7 downto 0) --van 4 naar 8
    );
    end component;



-- 7 segment driver module
    DISP_SEG_DRIVER : Driver_7seg_4
    generic map(
        C_F_CLK => C_F_CLK
    )
    port map(
         clk => clk,
       reset => reset,
        bcd0 => bcd_reg_i(3 downto 0),
        bcd1 => bcd_reg_i(7 downto 4),
        bcd2 => bcd_reg_i(11 downto 8),
        bcd3 => bcd_reg_i(15 downto 12),
        -- toevoegen van 4 extra 7segment disp
        bcd4 => bcd_reg_i(19 downto 16),
        bcd5 => bcd_reg_i(23 downto 20),
        bcd6 => bcd_reg_i(27 downto 24),
        bcd7 => bcd_reg_i(31 downto 28),
         seg => seg,
          an => an
    );    