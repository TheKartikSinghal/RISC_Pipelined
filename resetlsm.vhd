library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity reset_lsm is
  port ( address : in std_logic_vector(2 downto 0);
         instr : in std_logic_vector(7 downto 0);
			rstlsm_en : in std_logic_vector(0 downto 0);
         --all_zero : in std_logic;
			rstlsm : out std_logic_vector(7 downto 0)
			
		);
		
end entity reset_lsm;


architecture struct of reset_lsm is
signal temp : std_logic_vector(7 downto 0):= "00000000";
signal a: integer := 0; 
begin
   a <= to_integer(unsigned(address));
	proc : process(a, rstlsm_en)
	begin
	if (rstlsm_en = "1") then
	L : for i in 0 to 7 loop
	if (7-i = a) then
	temp(i) <= '0';
	else
	temp(i) <= instr(i);
	--if ( a = 0)then
	--temp(a) <= '0';
	--temp(7 downto a+1) <= instr(7 downto a+1);
   
	--else
	--temp(a-1 downto 0) <= instr(a-1 downto 0);
	--temp(a) <= '0';
	--temp(7 downto a+1) <= instr(7 downto a+1);
	end if;
	end loop;
	else
	null;
	end if;
	end process;
	rstlsm <= temp;
	
end;
