library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity RR is
port( PR1 : in std_logic_vector(122 downto 0); --IDRR/MEMWB REG
      rstlsm_out : out std_logic_vector(7 downto 0);
		--clk : in std_logic;
	   rf_addr : out std_logic_vector(2 downto 0);
		unincremented_mem_addr : out std_logic_vector(15 downto 0);
		lm_sm_on : out std_logic_vector(0 downto 0)
);

end entity RR;

architecture rr_arch of RR is

function PE 
(PEin:in std_logic_vector(7 downto 0);
 
 PE_en : in std_logic_vector(0 downto 0))
 --all_zero : out std_logic_vector(0 downto 0));
return  std_logic_vector is
  variable PEout : std_logic_vector(2 downto 0);
  
begin

--proc : process(PE_en)
--begin

--if (PE_en = "1") then
PEout(0) := (PEin(0)) or
 (PEin(2) and not PEin(1) and not PEin(0)) or
(PEin(4) and not PEin(3) and not PEin(2) and not PEin(1) and
 not PEin(0)) or
(PEin(6) and not PEin(5) and not PEin(4) and not PEin(3)
 and not PEin(2) and not PEin(1) and not PEin(0));

 PEout(1) := (PEin(0) ) or
(PEin(1) and not PEin(0) ) or
 (PEin(4) and not PEin(2) and not PEin(3) and not PEin(1) and
not PEin(0) ) or
 (PEin(5) and not PEin(1) and not PEin(2) and not PEin(3) and
not PEin(4) and not PEin(0) );

 PEout(2) := (PEin(3) and not PEin(2) and not PEin(1) and
not PEin(0) ) or
 (PEin(2) and not PEin(1) and not PEin(0) ) or
 (PEin(1) and not PEin(0) ) or
 (PEin(0) );
--else 
--null;
--end if;
--end process;
return PEout;
end PE;

function reset_lsm 
  ( address : in std_logic_vector(2 downto 0);
         instr : in std_logic_vector(7 downto 0);
			rstlsm_en : in std_logic_vector(0 downto 0)
         --all_zero : in std_logic;
			)
	return std_logic_vector is
	    variable rstlsm : std_logic_vector(7 downto 0);
		 --signal a: integer := 0;
 begin
   --a <= to_integer(unsigned(address));
   if (rstlsm_en = "1") then
	L : for i in 0 to 7 loop
	if (7-i = to_integer(unsigned(address))) then
	rstlsm(i) := '0';
	else
	rstlsm(i) := instr(i);
	end if;
	end loop L;
	else
	null;
	end if;
	
	return rstlsm;
		
end reset_lsm;




--signal PE_enable, rstlsm_enable : std_logic;

--PE1 : PE port map(PR1(7 downto 0), temp_addr, PE_enable);
--resetlsm : reset_lsm port map(temp_addr, PR1(7 DOWNTO 0), rstlsm_enable, rstlsmout);

begin

regread : process(PR1)

variable temp_addr : std_logic_vector(2 downto 0);
variable temp_rstlsmout : std_logic_vector(7 downto 0);

begin

--if (PR1(15 downto 12) = "0110") then
if( PR1(7 downto 0) /= "00000000" and PR1(7 downto 0) /= "10000000" and (PR1(15 downto 12) = "0110" or PR1(15 downto 12)="0111") ) then --lm

temp_addr := PE(PR1(7 downto 0),"1");
--rstlsm_enable <= '1';
lm_sm_on <= "1";
rf_addr <= temp_addr;
unincremented_mem_addr(15 downto 0) <= PR1(31 downto 16);
temp_rstlsmout := reset_lsm(temp_addr, PR1(7 downto 0), "1");
rstlsm_out <= temp_rstlsmout;

else

lm_sm_on <= "0";

end if; 

end process;

end rr_arch;
