library ieee ;
use ieee.std_logic_1164.all ;

entity RFA3INDECIDER is
port (LSDETECT:in std_logic_vector(0 downto 0);
 
 MEMWBREG : in std_logic_vector(122 downto 0);
 --peaddress : in std_logic_vector(2 downto 0);
 RFA3OUT : OUT STD_LOGIC_VECTOR(2 DOWNTO 0));
 
end RFA3INDECIDER ;

architecture struct of RFA3INDECIDER IS

BEGIN

PROC : PROCESS(LSDETECT , MEMWBREG)

BEGIN

IF (LSDETECT = "1" AND MEMWBREG(15 DOWNTO 12) = "0110") THEN
RFA3OUT(2 DOWNTO 0) <= MEMWBREG(105 downto 103);
ELSE
RFA3OUT(2 DOWNTO 0) <= MEMWBREG(5 DOWNTO 3);
END IF;


END PROCESS;

END struct;

