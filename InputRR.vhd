library ieee ;
use ieee.std_logic_1164.all ;

entity RRINDECIDER is
port (LSDETECT:in std_logic_vector(0 downto 0);
 IDRRREG:IN std_logic_vector(122 downto 0);
 MEMWBREG : in std_logic_vector(122 downto 0);
 INPUTRR : OUT STD_LOGIC_VECTOR(122 DOWNTO 0));
 
end RRINDECIDER ;

architecture struct of RRINDECIDER IS

BEGIN

PROC : PROCESS(LSDETECT , IDRRREG, MEMWBREG)

BEGIN

IF (LSDETECT = "0") THEN
INPUTRR(122 DOWNTO 0) <= IDRRREG(122 DOWNTO 0);
ELSE
IF ( (MEMWBREG(15 DOWNTO 12) = "0110" OR MEMWBREG(15 DOWNTO 12) = "0111") ) THEN
INPUTRR(122 DOWNTO 0) <= MEMWBREG(122 DOWNTO 0);
ELSE
INPUTRR(122 DOWNTO 0) <= IDRRREG(122 DOWNTO 0);
END IF;
END IF;

END PROCESS;

END struct;




