library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity SubBytes_module is
    Generic ( DATA_LENGTH : integer := 128 );
    Port ( data_out : out STD_LOGIC_VECTOR (DATA_LENGTH-1 downto 0);
           finish : out STD_LOGIC;
           
           data_in : in STD_LOGIC_VECTOR (DATA_LENGTH-1 downto 0);
           start : in STD_LOGIC;
           
           clock : in STD_LOGIC;
           reset : in STD_LOGIC);
end SubBytes_module;

architecture RTL of SubBytes_module is

    -----------------------------
    --------- CONSTANTS ---------
    -----------------------------
    
    constant BYTES_COUNT : integer := 16;
    constant BYTE_LENGTH : integer := 8;

    -----------------------------
    ----------- TYPES -----------
    -----------------------------
    
    type REG_SBOX_VALUES is array (BYTES_COUNT-1 downto 0) of std_logic_vector (BYTE_LENGTH-1 downto 0);

    -----------------------------
    ---------- SIGNALS ----------
    -----------------------------    
    
    -- Memory to store 16 bytes
    signal bytes_memory_in  : REG_SBOX_VALUES;
    signal bytes_memory_out : REG_SBOX_VALUES;
    
    -- Managed signal
    signal start_sbox_module     : std_logic;
    
    signal finish_sbox_module_0  : std_logic;
    signal finish_sbox_module_1  : std_logic;
    signal finish_sbox_module_2  : std_logic;
    signal finish_sbox_module_3  : std_logic;
    signal finish_sbox_module_4  : std_logic;
    signal finish_sbox_module_5  : std_logic;
    signal finish_sbox_module_6  : std_logic;
    signal finish_sbox_module_7  : std_logic;
    signal finish_sbox_module_8  : std_logic;
    signal finish_sbox_module_9  : std_logic;
    signal finish_sbox_module_10 : std_logic;
    signal finish_sbox_module_11 : std_logic;
    signal finish_sbox_module_12 : std_logic;
    signal finish_sbox_module_13 : std_logic;
    signal finish_sbox_module_14 : std_logic;
    signal finish_sbox_module_15 : std_logic;
    
    signal finish_all_sbox : std_logic;
    
    -----------------------------
    --------- COMPONENTS --------
    -----------------------------
    
    component SBox_module is
        Generic ( BYTE_LENGTH : integer := 8 );
        Port ( data_out : out STD_LOGIC_VECTOR (BYTE_LENGTH-1 downto 0);
               finish : out STD_LOGIC;
               data_in : in STD_LOGIC_VECTOR (BYTE_LENGTH-1 downto 0);
               start : in STD_LOGIC);
    end component SBox_module;    

begin

    -- Initialize and Reset process
    reset_n_init_process : process(reset)
    begin
        if(rising_edge(reset)) then
            bytes_memory_in(BYTES_COUNT-1 downto 0) <= (others => X"0");
            start_sbox_module <= '0';
            finish_sbox_module_0 <= '0';
            finish_sbox_module_1 <= '0';
            finish_sbox_module_2 <= '0';
            finish_sbox_module_3 <= '0';
            finish_sbox_module_4 <= '0';
            finish_sbox_module_5 <= '0';
            finish_sbox_module_6 <= '0';
            finish_sbox_module_7 <= '0';
            finish_sbox_module_8 <= '0';
            finish_sbox_module_9 <= '0';
            finish_sbox_module_10 <= '0';
            finish_sbox_module_11 <= '0';
            finish_sbox_module_12 <= '0';
            finish_sbox_module_13 <= '0';
            finish_sbox_module_14 <= '0';
            finish_sbox_module_15 <= '0';
        end if;
    end process reset_n_init_process;
    
    -- Structure of signals transmission
    
    bytes_memory_in(0)  <= data_in(BYTE_LENGTH-1    downto BYTE_LENGTH-8)    when rising_edge(start);
    bytes_memory_in(1)  <= data_in(BYTE_LENGTH*2-1  downto BYTE_LENGTH*2-8)  when rising_edge(start);
    bytes_memory_in(2)  <= data_in(BYTE_LENGTH*3-1  downto BYTE_LENGTH*3-8)  when rising_edge(start);
    bytes_memory_in(3)  <= data_in(BYTE_LENGTH*4-1  downto BYTE_LENGTH*4-8)  when rising_edge(start);
    bytes_memory_in(4)  <= data_in(BYTE_LENGTH*5-1  downto BYTE_LENGTH*5-8)  when rising_edge(start);
    bytes_memory_in(5)  <= data_in(BYTE_LENGTH*6-1  downto BYTE_LENGTH*6-8)  when rising_edge(start);
    bytes_memory_in(6)  <= data_in(BYTE_LENGTH*7-1  downto BYTE_LENGTH*7-8)  when rising_edge(start);
    bytes_memory_in(7)  <= data_in(BYTE_LENGTH*8-1  downto BYTE_LENGTH*8-8)  when rising_edge(start);
    bytes_memory_in(8)  <= data_in(BYTE_LENGTH*9-1  downto BYTE_LENGTH*9-8)  when rising_edge(start);
    bytes_memory_in(9)  <= data_in(BYTE_LENGTH*10-1 downto BYTE_LENGTH*10-8) when rising_edge(start);
    bytes_memory_in(10) <= data_in(BYTE_LENGTH*11-1 downto BYTE_LENGTH*11-8) when rising_edge(start);
    bytes_memory_in(11) <= data_in(BYTE_LENGTH*12-1 downto BYTE_LENGTH*12-8) when rising_edge(start);
    bytes_memory_in(12) <= data_in(BYTE_LENGTH*13-1 downto BYTE_LENGTH*13-8) when rising_edge(start);
    bytes_memory_in(13) <= data_in(BYTE_LENGTH*14-1 downto BYTE_LENGTH*14-8) when rising_edge(start);
    bytes_memory_in(14) <= data_in(BYTE_LENGTH*15-1 downto BYTE_LENGTH*15-8) when rising_edge(start);
    bytes_memory_in(15) <= data_in(BYTE_LENGTH*16-1 downto BYTE_LENGTH*16-8) when rising_edge(start); 
    
    start_sbox_module <= '1' when rising_edge(start);
    
    data_out(BYTE_LENGTH-1    downto BYTE_LENGTH-8)    <= bytes_memory_out(0)  when clock = '1' and finish_sbox_module_0 = '1';
    data_out(BYTE_LENGTH*2-1  downto BYTE_LENGTH*2-8)  <= bytes_memory_out(1)  when clock = '1' and finish_sbox_module_1 = '1';
    data_out(BYTE_LENGTH*3-1  downto BYTE_LENGTH*3-8)  <= bytes_memory_out(2)  when clock = '1' and finish_sbox_module_2 = '1';
    data_out(BYTE_LENGTH*4-1  downto BYTE_LENGTH*4-8)  <= bytes_memory_out(3)  when clock = '1' and finish_sbox_module_3 = '1';
    data_out(BYTE_LENGTH*5-1  downto BYTE_LENGTH*5-8)  <= bytes_memory_out(4)  when clock = '1' and finish_sbox_module_4 = '1';
    data_out(BYTE_LENGTH*6-1  downto BYTE_LENGTH*6-8)  <= bytes_memory_out(5)  when clock = '1' and finish_sbox_module_5 = '1';
    data_out(BYTE_LENGTH*7-1  downto BYTE_LENGTH*7-8)  <= bytes_memory_out(6)  when clock = '1' and finish_sbox_module_6 = '1';
    data_out(BYTE_LENGTH*8-1  downto BYTE_LENGTH*8-8)  <= bytes_memory_out(7)  when clock = '1' and finish_sbox_module_7 = '1';
    data_out(BYTE_LENGTH*9-1  downto BYTE_LENGTH*9-8)  <= bytes_memory_out(8)  when clock = '1' and finish_sbox_module_8 = '1';
    data_out(BYTE_LENGTH*10-1 downto BYTE_LENGTH*10-8) <= bytes_memory_out(9)  when clock = '1' and finish_sbox_module_9 = '1';
    data_out(BYTE_LENGTH*11-1 downto BYTE_LENGTH*11-8) <= bytes_memory_out(10) when clock = '1' and finish_sbox_module_10 = '1';
    data_out(BYTE_LENGTH*12-1 downto BYTE_LENGTH*12-8) <= bytes_memory_out(11) when clock = '1' and finish_sbox_module_11 = '1';
    data_out(BYTE_LENGTH*13-1 downto BYTE_LENGTH*13-8) <= bytes_memory_out(12) when clock = '1' and finish_sbox_module_12 = '1';
    data_out(BYTE_LENGTH*14-1 downto BYTE_LENGTH*14-8) <= bytes_memory_out(13) when clock = '1' and finish_sbox_module_13 = '1';
    data_out(BYTE_LENGTH*15-1 downto BYTE_LENGTH*15-8) <= bytes_memory_out(14) when clock = '1' and finish_sbox_module_14 = '1';
    data_out(BYTE_LENGTH*16-1 downto BYTE_LENGTH*16-8) <= bytes_memory_out(15) when clock = '1' and finish_sbox_module_15 = '1';
    
    SBox_module_0 : SBox_module
    port map (bytes_memory_out(0), finish_sbox_module_0, bytes_memory_in(0), start_sbox_module); 
    SBox_module_1 : SBox_module
    port map (bytes_memory_out(1), finish_sbox_module_1, bytes_memory_in(1), start_sbox_module); 
    SBox_module_2 : SBox_module
    port map (bytes_memory_out(2), finish_sbox_module_2, bytes_memory_in(2), start_sbox_module); 
    SBox_module_3 : SBox_module
    port map (bytes_memory_out(3), finish_sbox_module_3, bytes_memory_in(3), start_sbox_module); 
    SBox_module_4 : SBox_module
    port map (bytes_memory_out(4), finish_sbox_module_4, bytes_memory_in(4), start_sbox_module); 
    SBox_module_5 : SBox_module
    port map (bytes_memory_out(5), finish_sbox_module_5, bytes_memory_in(5), start_sbox_module); 
    SBox_module_6 : SBox_module
    port map (bytes_memory_out(6), finish_sbox_module_6, bytes_memory_in(6), start_sbox_module); 
    SBox_module_7 : SBox_module
    port map (bytes_memory_out(7), finish_sbox_module_7, bytes_memory_in(7), start_sbox_module); 
    SBox_module_8 : SBox_module
    port map (bytes_memory_out(8), finish_sbox_module_8, bytes_memory_in(8), start_sbox_module); 
    SBox_module_9 : SBox_module
    port map (bytes_memory_out(9), finish_sbox_module_9, bytes_memory_in(9), start_sbox_module); 
    SBox_module_10 : SBox_module
    port map (bytes_memory_out(10), finish_sbox_module_10, bytes_memory_in(10), start_sbox_module); 
    SBox_module_11 : SBox_module
    port map (bytes_memory_out(11), finish_sbox_module_11, bytes_memory_in(11), start_sbox_module); 
    SBox_module_12 : SBox_module
    port map (bytes_memory_out(12), finish_sbox_module_12, bytes_memory_in(12), start_sbox_module); 
    SBox_module_13 : SBox_module
    port map (bytes_memory_out(13), finish_sbox_module_13, bytes_memory_in(13), start_sbox_module); 
    SBox_module_14 : SBox_module
    port map (bytes_memory_out(14), finish_sbox_module_14, bytes_memory_in(14), start_sbox_module); 
    SBox_module_15 : SBox_module
    port map (bytes_memory_out(15), finish_sbox_module_15, bytes_memory_in(15), start_sbox_module);
    
    finish_all_sbox <= finish_sbox_module_0  and finish_sbox_module_1  and finish_sbox_module_2  and 
                       finish_sbox_module_3  and finish_sbox_module_4  and finish_sbox_module_5  and
                       finish_sbox_module_6  and finish_sbox_module_7  and finish_sbox_module_8  and
                       finish_sbox_module_9  and finish_sbox_module_10 and finish_sbox_module_11 and
                       finish_sbox_module_12 and finish_sbox_module_13 and finish_sbox_module_14 and
                       finish_sbox_module_15;
    
    finish <= finish_all_sbox;

end RTL;
