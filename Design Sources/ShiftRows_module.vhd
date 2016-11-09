library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ShiftRows_module is
    Generic ( DATA_LENGTH : integer := 128 );
    Port ( data_out : out STD_LOGIC_VECTOR (DATA_LENGTH-1 downto 0);
           finish : out STD_LOGIC;
           
           data_in : in STD_LOGIC_VECTOR (DATA_LENGTH-1 downto 0);
           start : in STD_LOGIC;
           
           clock : in STD_LOGIC;
           reset : in STD_LOGIC);
end ShiftRows_module;

architecture RTL of ShiftRows_module is

    -----------------------------
    ----------- TYPES -----------
    -----------------------------
    
    TYPE matrix_index IS array (15 downto 0) OF std_logic_vector(7 downto 0);
    
    -----------------------------
    ---------- SIGNALS ----------
    -----------------------------
    
    SIGNAL matrix1, matrix2 : matrix_index;

begin

    -- Initialize and Reset process
    reset_n_init_process : process(reset)
    begin
        if(rising_edge(reset)) then
            for i in 15 downto 0 loop
                matrix1(15-i) <= (others => '0');
                matrix2(15-i) <= (others => '0');
            end loop;
        end if;
    end process reset_n_init_process;

    -- map the 128 bit input to matrix1 so we can shift it.

    vector_to_matrix1: PROCESS(start)
    BEGIN
        if(rising_edge(start) and clock = '1') then
            FOR i IN 15 downto 0 LOOP
	           matrix1(15-i) <= data_in(8*i+7 downto 8*i);
            END LOOP;
        end if;
    END PROCESS vector_to_matrix1;

    -- matrix2 is actually matrix1 shifted as shown in the above example.

    -- combinatorial logic

    -- first column
    matrix2(0)  <=  matrix1(0);
    matrix2(1)  <=  matrix1(5);
    matrix2(2)  <=  matrix1(10);
    matrix2(3)  <=  matrix1(15);
    -- second column
    matrix2(4)  <=  matrix1(4);
    matrix2(5)  <=  matrix1(9);
    matrix2(6)  <=  matrix1(14);
    matrix2(7)  <=  matrix1(3);
    -- third column
    matrix2(8)  <=  matrix1(8);
    matrix2(9)  <=  matrix1(13);
    matrix2(10) <=  matrix1(2);
    matrix2(11) <=  matrix1(7);
    -- forth column
    matrix2(12) <=  matrix1(12);
    matrix2(13) <=  matrix1(1);
    matrix2(14) <=  matrix1(6);
    matrix2(15) <=  matrix1(11);

    --map matrix2 back to 128 bit vector
    matrix2_to_vector: PROCESS(matrix2)
    BEGIN
        if(clock = '1') then
            FOR i IN 15 downto 0 LOOP
	           data_out(8*i+7 DOWNTO 8*i) <= matrix2(15-i);
            END LOOP;
            finish <= '1';
        end if;
    END PROCESS matrix2_to_vector;

end RTL;
