library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity load_hazards is
 port( 
 PR1 : in std_logic_vector(106 downto 0);
 PR2 : in std_logic_vector(106 downto 0);
 CHECK_BIT : out std_logic
 --MUX_ALU2A_SEL : out std_logic_vector(1 downto 0);
 );
end load_hazards;


architecture arch_load_hazards of load_hazards is

signal inr: std_logic;
--signals


begin

load: process(PR1,PR2)
begin

if PR1(15 downto 12) = "0100" then

  if (PR2(15 downto 12) = "0001") or (PR2(15 downto 12) = "0000") or (PR2(15 downto 12) = "0010") or (PR2(15 downto 12) = "1000") or (PR2(15 downto 12) = "1001") then 

   if (PR1(11 downto 9) = PR2(11 downto 9)) or (PR1(11 downto 9) = PR2(8 downto 6)) then
	     inr <= 1;
   else 
	     inr<= 0;
   end if;
	
  elsif (PR2(15 downto 12) = "0110") or (PR2(15 downto 12) = "1111") then
    
	 if(PR1(11 downto 9) =  PR2(11 downto 9)) then
	     inr <= 1;
	 else 
	     inr <= 0;
	 end if;
	 
  elsif PR2(15 downto 12) = "1101" then
     if PR1(15 downto 12) =  PR2(8 downto 6) then
	     inr <= 1;
	  else 
	     inr <= 0; 

     end if;
		
  else
       inr <= 0;
		
  end if;
 
else 
inr <= 0;

end if;

end process;

CHECK_BIT <= inr;

end arch_load_hazards;