library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity EX is
port( PR1 : in std_logic_vector(107 downto 0);
      CARRY : in std_logic;
		ZERO : in std_logic;
		ALU_SEL : out std_logic_vector(1 downto 0);
      ALU_MUXA_SEL : out std_logic_vector(1 downto 0);
		ALU_MUXB_SEL : out std_logic_vector(1 downto 0)
	
);

end entity EX;

architecture behav of EX is
--signals


begin

Execution : process(PR1, CARRY, ZERO, ALU_SEL, ALU_MUXA_SEL, ALU_MUXB_SEL)
begin

if PR1(101) = '0' then =>   --active low bit representing the EX_EN for this instruction
case PR1(15 downto 12) is

      when "0001" =>
		      if(PR1(2 downto 0) = "000") then   --ADD
						ALU_MUXA_SEL <= "00";
						ALU_MUXB_SEL <= "01";
						ALU_SEL <= "00";
						
				
				elsif(PR1(2 downto 0) = "010") then   --ADC
				    if CARRY = '1' then
					  ALU_MUXA_SEL <= "00";
					  ALU_MUXB_SEL <= "01";
					  ALU_SEL <= "00";
					  
					  
				    else
					  null;
					  
					 end if;
					 
				elsif(PR1(2 downto 0) = "001")then  --ADZ
				    if ZERO = '1' then
					  ALU_MUXA_SEL <= "00";
					  ALU_MUXB_SEL <= "01";
					  ALU_SEL <= "00";
					  
					  
					  else 
					   null;
						
					  end if;
----------------------------------------------------------------					  
				elsif(PR1(2 downto 0) = "011") then  --AWC
					  ALU_MUXA_SEL <= "00";
					  ALU_MUXB_SEL <= "01";
					  ALU_SEL <= "00";
					 
					  
				

--------------------------------------------------------------------
            elsif(PR1(2 downto 0) = "100") then      --ACA
				     ALU_MUXA_SEL <= "00";
					  ALU_MUXB_SEL <= "01";
					  ALU_SEL <= "00";
					 
					  
					  
				elsif(PR1(2 downto 0) = "110") then  --ACC
				    
					 if CARRY = '1' then 
					  ALU_MUXA_SEL <= "00";
					  ALU_MUXB_SEL <= "01";
					  ALU_SEL <= "00";
					  
					 else
					  null;
					  
					 end if;
					 
				elsif(PR1(2 downto 0) = "101") then --ACZ
				     if ZERO = '1' then 
					  ALU_MUXA_SEL <= "00";
					  ALU_MUXB_SEL <= "01";
					  ALU_SEL <= "00";
					 
					  
					 else
					  null;
					  
					 end if;
		--------------------------------------------------------------------			 
				elsif(PR1(2 downto 0) = "111") then  --ACW
				     ALU_MUXA_SEL <= "00";
					  ALU_MUXB_SEL <= "01";
					  ALU_SEL <= "00";
					  
					  
		-------------------------------------------------------------			  
				else
				    null;
					 
				end if;
				
		 when "0000"=>   --ADI
		         ALU_MUXA_SEL <= "00";
					ALU_MUXB_SEL <= "00";
					ALU_SEL <= "00";
				   

		when "0010"=>   
		         if(PR1(2 downto 0) = "000") then  ---NDU
				     ALU_MUXA_SEL <= "00";
					  ALU_MUXB_SEL <= "01";
					  ALU_SEL <= "01";
					  
					  
					elsif(PR1(2 downto 0) = "010") then  --NDC
		           if CARRY = '1' then
					    ALU_MUXA_SEL <= "00";
					    ALU_MUXB_SEL <= "01";
					    ALU_SEL <= "01";
						
						 
						else
						 null;
						 
						end if;
						
					elsif(PR1(2 downto 0) = "001") then --NDZ
					  if ZERO = '1' then
					    ALU_MUXA_SEL <= "00";
					    ALU_MUXB_SEL <= "01";
					    ALU_SEL <= "01";
						
						 
						else
						 null;
						 
						end if;
						
					 elsif(PR1(2 downto 0) = "100") then --NCU
					    ALU_MUXA_SEL <= "00";
					    ALU_MUXB_SEL <= "01";
					    ALU_SEL <= "01";
						
						 
						 
					 elsif(PR1(2 downto 0) = "110") then --NCC
					    if CARRY = '1' then
							ALU_MUXA_SEL <= "00";
							ALU_MUXB_SEL <= "01";
							ALU_SEL <= "01";
							
							
						 else 
						  null;
						  
						 end if;
						 
					 elsif(PR1(2 downto 0) = "101") then --NCZ
					    if ZERO = '1' then
						   ALU_MUXA_SEL <= "00";
							ALU_MUXB_SEL <= "01";
							ALU_SEL <= "01";
							
						 
						 else
						  null;
						 end if;
						 
						else 
						 null;
						 
						end if;
					 
			when "0011" =>       --LLI
			      --NO USE OF ALU FOR THIS---
			
         when "0100" =>      --LW--
   			    ALU_MUXA_SEL <= "01";   --DATA2 OF REGB
					 ALU_MUXB_SEL <= "00";   --SE output
					 ALU_SEL <= "00";
					
					 
			when "0101" =>     --SW--
			       ALU_MUXA_SEL <= "01";   --DATA2 OF REGB
					 ALU_MUXB_SEL <= "00";   --SE output
					 ALU_SEL <= "00";
					 
					 
			--when "0110"  --LM
			--when "0111"  --SM
			
			when "1000" =>  --BEQ
			     if PR1(31 downto 16) = PR1(47 downto 32) then 
				     ALU_MUXA_SEL <= "10";
					  ALU_MUXB_SEL <= "00";
					  ALU_SEL <= "00";
					  
					   
	            else
					 null;
					 
					end if;
					 
			when "1001" => --BLT
			     if unsigned(PR1(31 downto 16)) < unsigned(PR1(47 downto 32)) then
				     ALU_MUXA_SEL <= "10";
					  ALU_MUXB_SEL <= "00";
					  ALU_SEL <= "00";
					
					   
	            else
					 null;
					 
					end if;
					 
			when "1010" =>
			     if unsigned(PR1(31 downto 16)) > unsigned(PR1(47 downto 32)) then
				     ALU_MUXA_SEL <= "10";
					  ALU_MUXB_SEL <= "00";
					  ALU_SEL <= "00";
					
					   
	            else
					 null;
					 
					end if;
					 
--			when "1100" =>
--			      if
				
end case;

else
 null;
 
end if;

end process;

end behav;