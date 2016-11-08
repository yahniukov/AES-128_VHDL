library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity SBox_module is
    Generic ( BYTE_LENGTH : integer := 8 );
    Port ( data_out : out STD_LOGIC_VECTOR (BYTE_LENGTH-1 downto 0);
           finish : out STD_LOGIC;
           data_in : in STD_LOGIC_VECTOR (BYTE_LENGTH-1 downto 0);
           start : in STD_LOGIC);
end SBox_module;

architecture RTL of SBox_module is

begin


end RTL;
