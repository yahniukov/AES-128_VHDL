library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Encryption_Module is
    Generic ( DATA_LENGTH : integer := 128 );
    Port ( cypher_text  : out STD_LOGIC_VECTOR (DATA_LENGTH-1 downto 0);
           finish_round : out STD_LOGIC;
    
           plain_text : in STD_LOGIC_VECTOR (DATA_LENGTH-1 downto 0);
           key        : in STD_LOGIC_VECTOR (DATA_LENGTH-1 downto 0);
           
           clock         : in STD_LOGIC;
           reset         : in STD_LOGIC;
           start_round   : in STD_LOGIC;
           current_round : in integer range 0 to 11
           );
end Encryption_Module;

architecture RTL of Encryption_Module is

    -----------------------------
    ---------- SIGNALS ----------
    -----------------------------
    
    -- Signal that store current round
    signal round : integer;
    
    -- Signal that module done work
    signal finish : std_logic;
    
    -- Current key
    signal current_key : std_logic_vector (DATA_LENGTH-1 downto 0);
    
    -- Registers to store:
    signal result_register_bank                  : std_logic_vector (DATA_LENGTH-1 downto 0);
    
    -- Signals to start general blocks
    signal start_subbytes_module        : std_logic;
    signal start_shiftrows_module       : std_logic;
    signal start_mixcolumns_module      : std_logic; 
    signal start_addroundkey_module     : std_logic;
    
    -- Signals that block finished work
    signal finish_subbytes_module        : std_logic;
    signal finish_shiftrows_module       : std_logic;
    signal finish_mixcolumns_module      : std_logic;  
    signal finish_addroundkey_module     : std_logic; 
    
    -- Signals thats store state between the components
    signal to_subbytes_module      : std_logic_vector (DATA_LENGTH-1 downto 0);
    signal from_subbytes_module    : std_logic_vector (DATA_LENGTH-1 downto 0);
    signal to_shiftrows_module     : std_logic_vector (DATA_LENGTH-1 downto 0);
    signal from_shiftrows_module   : std_logic_vector (DATA_LENGTH-1 downto 0);
    signal to_mixcolumns_module    : std_logic_vector (DATA_LENGTH-1 downto 0);
    signal from_mixcolumns_module  : std_logic_vector (DATA_LENGTH-1 downto 0);
    signal to_addroundkey_module   : std_logic_vector (DATA_LENGTH-1 downto 0);
    signal from_addroundkey_module : std_logic_vector (DATA_LENGTH-1 downto 0);
    
    -----------------------------
    --------- COMPONENTS --------
    -----------------------------
    
    component SubBytes_module is
        Generic ( DATA_LENGTH : integer := 128 );
        Port ( data_out : out STD_LOGIC_VECTOR (DATA_LENGTH-1 downto 0);
               finish : out STD_LOGIC;
               
               data_in : in STD_LOGIC_VECTOR (DATA_LENGTH-1 downto 0);
               start : in STD_LOGIC;
               
               clock : in STD_LOGIC;
               reset : in STD_LOGIC);    
    end component; 
    
    component ShiftRows_module is
        Generic ( DATA_LENGTH : integer := 128 );
        Port ( data_out : out STD_LOGIC_VECTOR (DATA_LENGTH-1 downto 0);
               finish : out STD_LOGIC;
               
               data_in : in STD_LOGIC_VECTOR (DATA_LENGTH-1 downto 0);
               start : in STD_LOGIC;
               
               clock : in STD_LOGIC;
               reset : in STD_LOGIC);
    end component;
    
    component MixColumns_module is
        Generic ( DATA_LENGTH : integer := 128 );
        Port ( data_out : out STD_LOGIC_VECTOR (DATA_LENGTH-1 downto 0);
               finish : out STD_LOGIC;
               
               data_in : in STD_LOGIC_VECTOR (DATA_LENGTH-1 downto 0);
               start : in STD_LOGIC;
               
               clock : in STD_LOGIC;
               reset : in STD_LOGIC);
    end component;
    
    component AddRoundKey_module is
        Generic ( DATA_LENGTH : integer := 128 );
        Port ( data_out : out STD_LOGIC_VECTOR (DATA_LENGTH-1 downto 0);
               finish   : out STD_LOGIC;
               
               data_in : in STD_LOGIC_VECTOR (DATA_LENGTH-1 downto 0);
               key     : in STD_LOGIC_VECTOR (DATA_LENGTH-1 downto 0);
               start   : in STD_LOGIC;
               
               clock : in STD_LOGIC;
               reset : in STD_LOGIC);
    end component;

begin

    -- Initialize and Reset process
    reset_n_init_process : process(reset)
    begin
        if(rising_edge(reset)) then
            round <= 0;
            finish <= '0';
            current_key <= (others => '0');
            result_register_bank <= (others => '0');
            start_subbytes_module <= '0';
            start_shiftrows_module <= '0';
            start_mixcolumns_module <= '0';
            start_addroundkey_module <= '0';
            finish_subbytes_module <= '0';
            finish_shiftrows_module <= '0';
            finish_mixcolumns_module <= '0';
            finish_addroundkey_module <= '0';
            to_subbytes_module <= (others => '0');
            from_subbytes_module <= (others => '0');
            to_shiftrows_module <= (others => '0');
            from_shiftrows_module <= (others => '0');
            to_mixcolumns_module <= (others => '0');
            from_mixcolumns_module <= (others => '0');
            to_addroundkey_module <= (others => '0');
            from_addroundkey_module <= (others => '0');
        end if;
    end process reset_n_init_process;    

    -- Structure of signals transmission
    
    round <= current_round when rising_edge(start_round);
    current_key <= key when rising_edge(start_round);
    
    to_subbytes_module <= plain_text when rising_edge(start_round);
    start_subbytes_module <= '1' when rising_edge(start_round);
    
    to_shiftrows_module <= from_subbytes_module when clock = '1';
    start_shiftrows_module <= finish_subbytes_module when clock = '1';
    
    to_mixcolumns_module <= from_shiftrows_module when clock = '1';
    start_mixcolumns_module <= finish_shiftrows_module when clock = '1';
    
    to_addroundkey_module <= from_shiftrows_module when (round = 10 and clock = '1')  
                             else from_mixcolumns_module when clock = '1';
    start_addroundkey_module <= finish_shiftrows_module when (round = 10 and clock = '1')
                             else finish_mixcolumns_module when clock = '1';
    
    result_register_bank <= from_addroundkey_module when clock = '1';
    finish <= finish_addroundkey_module when clock = '1';
    
    SubBytes_module_1 : SubBytes_module 
    port map ( data_out => from_subbytes_module,
               finish => finish_subbytes_module,
               data_in => to_subbytes_module,
               start => start_subbytes_module,
               clock => clock,
               reset => reset ); 
               
    ShiftRows_module_1 : ShiftRows_module
    port map ( data_out => from_shiftrows_module,
               finish => finish_shiftrows_module,
               data_in => to_shiftrows_module,
               start => start_shiftrows_module,
               clock => clock,
               reset => reset );
               
    MixColumns_module_1 : MixColumns_module
    port map ( data_out => from_mixcolumns_module,
               finish => finish_mixcolumns_module,
               data_in => to_mixcolumns_module,
               start => start_mixcolumns_module,
               clock => clock,
               reset => reset );
               
    AddRoundKey_module_1 : AddRoundKey_module
    port map ( data_out => from_addroundkey_module,
               finish => finish_addroundkey_module,
               data_in => to_addroundkey_module,
               key => current_key,
               start => start_addroundkey_module,
               clock => clock,
               reset => reset );

    -- After work - outstandings result
    cypher_text <= result_register_bank when clock = '1' and finish = '1';
    finish_round <= finish when clock = '1';

end RTL;
