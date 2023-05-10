library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity MEMACCESS is 
    port(
        PR_EXMEM: in std_logic_vector(122 downto 0);
        datain: out std_logic_vector(15 downto 0);
        --dataout: out std_logic_vector(15 downto 0);
		  dataadd : out std_logic_vector(15 downto 0)
    );
end entity;

architecture MEMACCESS_arch of MEMACCESS is
begin
    process(PR_EXMEM)
    begin
	 
	 if ( PR_EXMEM(15 downto 12) = "0111" or PR_EXMEM(15 downto 12)= "0110") then
	 datain <= PR_EXMEM(68 downto 53);
	 dataadd <= PR_EXMEM(47 downto 32);
	 else
	 dataadd <= PR_EXMEM (100 downto 85);
	 datain <=   PR_EXMEM (31 downto 16);
	 end if;
	 end process;
	 
end architecture MEMACCESS_arch;
	 
	 