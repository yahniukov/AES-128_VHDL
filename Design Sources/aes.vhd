library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity aes is
    Generic ( DATA_LENGTH : integer := 128;
              COUNT_ROUND : integer := 10  
              );
    Port ( out_data : out STD_LOGIC_VECTOR ( DATA_LENGTH-1 downto 0);
           finish   : out STD_LOGIC;
    
           in_data : in STD_LOGIC_VECTOR (DATA_LENGTH-1 downto 0);
           key     : in STD_LOGIC_VECTOR (DATA_LENGTH-1 downto 0);
           
           clock : in STD_LOGIC;
           reset : in STD_LOGIC;
           
           start_encryption      : in STD_LOGIC;
           start_decryption      : in STD_LOGIC;
           start_key_generation  : in STD_LOGIC;
           encryption_decryption : in STD_LOGIC
           );
end aes;

architecture RTL of aes is

    -----------------------------
    ---------- SIGNALS ----------
    -----------------------------
    
    -- Value of current round
    signal round : integer;
    
    -- Current key
    signal current_key : std_logic_vector (DATA_LENGTH-1 downto 0);
    
    -- Signal to get new key from Key_Expansion_Module
	signal get_next_key : std_logic;
    
    -- Registers to store:
    --   1. preround_register_bank - zero round value;
    --   2. result_register_bank - register for result;
    --   3. intermediate_register_bank_for_input - result between first and last round for input;
    --   4. intermediate_register_bank_for_output - result between first and last round for output;
    signal preround_register_bank                : std_logic_vector (DATA_LENGTH-1 downto 0);
    signal result_register_bank                  : std_logic_vector (DATA_LENGTH-1 downto 0);
    signal intermediate_register_bank_for_input  : std_logic_vector (DATA_LENGTH-1 downto 0);
    signal intermediate_register_bank_for_output : std_logic_vector (DATA_LENGTH-1 downto 0);
        
    -- Signals to start general blocks
    signal start_encryption_module       : std_logic;
    signal start_decryption_module       : std_logic;
    signal start_key_expansion_module    : std_logic; 
    
    -- Signals that block finished work
    signal finish_encryption_module       : std_logic;
    signal finish_decryption_module       : std_logic;
    signal finish_key_expansion_module    : std_logic;        

    -----------------------------
    --------- COMPONENTS --------
    -----------------------------
    
    component Encryption_Module is
        Generic ( DATA_LENGTH : integer := 128 );
        Port(  cypher_text  : out STD_LOGIC_VECTOR (DATA_LENGTH-1 downto 0);
               finish_round : out STD_LOGIC;
        
               plain_text : in STD_LOGIC_VECTOR (DATA_LENGTH-1 downto 0);
               key        : in STD_LOGIC_VECTOR (DATA_LENGTH-1 downto 0);
               
               clock         : in STD_LOGIC;
               reset         : in STD_LOGIC;
               start_round   : in STD_LOGIC;
               current_round : in integer range 0 to 11);
    end component;
    
    component Decryption_Module is
    end component;
    
    component Key_Expansion_Module is
    end component;

begin

    -- Initialize and Reset process
    reset_n_init_process : process(reset)
    begin
        if(rising_edge(reset)) then
            round <= 0;
            current_key <= (others => '0');
            preround_register_bank <= (others => '0');
            result_register_bank <= (others => '0');
            intermediate_register_bank_for_input <= (others => '0');
            intermediate_register_bank_for_output <= (others => '0');
            start_encryption_module <= '0';
            start_decryption_module <= '0';
            start_key_expansion_module <= '0';
            finish_encryption_module <= '0';
            finish_decryption_module <= '0';
            finish_key_expansion_module <= '0';
        end if;
    end process reset_n_init_process;
    
    -- Zero round - XOR user key and input data
    preround_register_bank <= in_data xor key when clock = '1';
    
    Encryption_Module_1 : Encryption_Module 
    port map ( cypher_text => intermediate_register_bank_for_output,
               finish_round => finish_encryption_module,
               plain_text => intermediate_register_bank_for_input,
               key => current_key,
               clock => clock,
               reset => reset,
               start_round => start_encryption_module,
               current_round => round);
    
    encrypt_process : process(clock, start_encryption, encryption_decryption) 
        variable i : integer;
    begin
        if(rising_edge(start_encryption) and encryption_decryption = '1') then
            for i in 0 to 15 loop
                if(clock = '1') then 
                    if(round = 0) then
                        round <= round + 1;
                        intermediate_register_bank_for_input <= preround_register_bank;
                        start_encryption_module <= '1';
                    elsif(round = 10) then
                        round <= round + 1;
                        result_register_bank <= intermediate_register_bank_for_output;
                        finish <= '1';
                        start_encryption_module <= '0';
                        exit;
                    else 
                        if(finish_encryption_module = '1') then
                            round <= round + 1;
                            start_encryption_module <= '0';
                            finish_encryption_module <= '0';
                            intermediate_register_bank_for_input <= intermediate_register_bank_for_output;
                            start_encryption_module <= '1';
                        end if;
                    end if;
                end if;
            end loop;
        end if;
    end process encrypt_process;
    
    -- After last round - outstandings result
    out_data <= result_register_bank when clock = '1';

end RTL;
