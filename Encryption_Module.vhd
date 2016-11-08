library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Encryption_Module is
    Generic ( DATA_LENGTH : integer := 128 );
    Port ( cypher_text  : out STD_LOGIC_VECTOR (DATA_LENGTH-1 downto 0);
           finish_round : out STD_LOGIC;
    
           plain_text : in STD_LOGIC_VECTOR (DATA_LENGTH-1 downto 0);
           key        : in STD_LOGIC_VECTOR (DATA_LENGTH-1 downto 0);
           
           clock       : in STD_LOGIC;
           reset       : in STD_LOGIC;
           start_round : in STD_LOGIC
           );
end Encryption_Module;

architecture RTL of Encryption_Module is

    -----------------------------
    ---------- SIGNALS ----------
    -----------------------------
    
    signal round : integer range 0 to 15;

begin


end RTL;
