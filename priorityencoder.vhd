--encodes the 8 bit input into 3 bit address with priority given to the highest 
--index having a '1'[since reverse order]
library ieee ;
use ieee.std_logic_1164.all ;

 entity PE is
port (PEin:in std_logic_vector(7 downto 0);
 PEout:out std_logic_vector(2 downto 0);
 PE_en : in std_logic_vector(0 downto 0));
 --all_zero : out std_logic_vector(0 downto 0));
end PE ;


 architecture Struct of PE is
 signal temp0 : std_logic := '0';
signal temp1 : std_logic := '0';
signal temp2 : std_logic := '0';
begin

--alz : process (PEin)
--begin
--if not(PEin(7) or PEin(6) or PEin(5) or PEin(4) or PEin(3) or PEin(2) or PEin(1) or PEin(0)) = '1' then
-- all_zero <= "1";
 --else
 --all_zero <= "0";
 --end if;
 --end process;
 proc : process(PE_en, PEin)
 begin
 if (PE_en = "1") then
temp0 <= (PEin(7)) or
 (PEin(5) and not PEin(6) and not PEin(7)) or
(PEin(3) and not PEin(4) and not PEin(5) and not PEin(6) and
 not PEin(7)) or
(PEin(1) and not PEin(2) and not PEin(3) and not PEin(4)
 and not PEin(5) and not PEin(6) and not PEin(7));

 temp1 <= (PEin(7) ) or
(PEin(6) and not PEin(7) ) or
 (PEin(3) and not PEin(5) and not PEin(4) and not PEin(6) and
not PEin(7) ) or
 (PEin(2) and not PEin(6) and not PEin(5) and not PEin(4) and
not PEin(3) and not PEin(7) );

 temp2 <= (PEin(4) and not PEin(5) and not PEin(6) and
not PEin(7) ) or
 (PEin(5) and not PEin(6) and not PEin(7) ) or
 (PEin(6) and not PEin(7) ) or
 (PEin(7) );
else 
null;
end if;
end process;

PEout(0) <= temp0;
PEout(1) <= temp1;
PEout(2) <= temp2;
 end Struct ;