library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity forwarding_unit_1 is
 port (
 PR1 : in std_logic_vector(122 downto 0);
 PR2 : in std_logic_vector(122 downto 0);
 PR3 : in std_logic_vector(122 downto 0);
 PR3_MUXA_SEL : in std_logic_vector(1 downto 0);
 PR3_MUXB_SEL : in std_logic_vector(1 downto 0);
 INN_A : out std_logic_vector(15 downto 0);
 MUX_ALU2A_SEL : out std_logic_vector(1 downto 0);
 INN_B : out std_logic_vector(15 downto 0);
 MUX_ALU2B_SEL : out std_logic_vector(1 downto 0)
 );
end forwarding_unit_1;


architecture behave of forwarding_unit_1 is 
--signals--
  begin
  
  FU: process(PR1,PR2,PR3,PR2_MUXA_SEL,PR2_MUXB_SEL)
  
begin
  
if (PR3(15 downto 12) = "0001") or (PR3(15 downto 12) = "0010") or(PR3(15 downto 12) = "1000") or (PR3(15 downto 12) = "1001") or (PR3(15 downto 12) = "1010") or (PR3(15 downto 12) = "1111") then  --AND,NAND,BEQ,BLT,BLE,JRI type of instructions(source wala instruction)
    if (PR1(15 downto 12) = "0001") or (PR1(15 downto 12) = "0010") then    --second immediate destination register also of ADD and NAND type                             --
      if(PR3(11 downto 9) = PR1(5 downto 3)) then   ---reg A matched
		  INN_A <= PR1(100 downto 85);   ---alu output stored in the PR2 of the 1st instruction
		  MUX_ALU2A_SEL <= "11";
		  
		else 
		  INN_A <= x"0000";  --dont care
		  MUX_ALU2A_SEL <= PR3_MUXA_SEL;  --original signal
		end if;
		  
	 elsif PR1(15 downto 12) = "0000" then	 ---destination register is ADI
	    if(PR3(11 downto 9) = PR1(8 downto 6)) then
	      INN_A <= PR1(100 downto 85);   ---alu output stored in the PR1 of the 1st instruction
		   MUX_ALU2A_SEL <= "11";
			
		 else 
		   INN_A <= x"0000";  --dont care
		   MUX_ALU2A_SEL <= PR3_MUXA_SEL;  --original signal
		 end if;
	 else 
	      INN_A <= x"0000";  --dont care
		   MUX_ALU2A_SEL <= PR3_MUXA_SEL;  --original signal
		  
		  
	 end if;
		 
	  
	 if (PR2(15 downto 12) = "0001") or (PR2(15 downto 12) = "0010") then    --immediate destination register also of ADD and NAND type                             --
      if(PR3(11 downto 9) = PR2(5 downto 3)) then   ---reg A matched
		  INN_A <= PR2(100 downto 85);   ---alu output stored in the PR2 of the 1st instruction
		  MUX_ALU2A_SEL <= "11";
		  
		else
		  INN_A <= x"0000";  --dont care
		  MUX_ALU2A_SEL <= PR3_MUXA_SEL;  --original signal;
		end if;
		  
	  elsif PR2(15 downto 12) = "0000" then	 ---destination register is ADI
	    if(PR3(11 downto 9) = PR2(8 downto 6)) then
	      INN_A <= PR2(100 downto 85);   ---alu output stored in the PR1 of the 1st instruction
		   MUX_ALU2A_SEL <= "11";
			
		 else 
		   INN_A <= x"0000";  --dont care
		   MUX_ALU2A_SEL <= PR3_MUXA_SEL;  --original signal
		 end if;
	  else
	    INN_A <= x"0000";  --dont care
		 MUX_ALU2A_SEL <= PR3_MUXA_SEL;  --original signal
	  end if;
	 

elsif (PR3(15 downto 12) = "0000") then 	  --source is an ADI operation(No difference in the inside loop seen here for mux A FU)

     if (PR1(15 downto 12) = "0001") or (PR1(15 downto 12) = "0010") then    --second immediate destination register also of ADD and NAND type                             --
      if(PR3(11 downto 9) = PR1(5 downto 3)) then   ---reg A matched
		  INN_A <= PR1(100 downto 85);   ---alu output stored in the PR2 of the 1st instruction
		  MUX_ALU2A_SEL <= "11";
		  
		else 
		  INN_A <= x"0000";  --dont care
		  MUX_ALU2A_SEL <= PR3_MUXA_SEL;  --original signal
		end if;
		  
	 elsif PR1(15 downto 12) = "0000" then	 ---destination register is ADI
	    if(PR3(11 downto 9) = PR1(8 downto 6)) then
	      INN_A <= PR1(100 downto 85);   ---alu output stored in the PR1 of the 1st instruction
		   MUX_ALU2A_SEL <= "11";
			
		 else 
		   INN_A <= x"0000";  --dont care
		   MUX_ALU2A_SEL <= PR3_MUXA_SEL;  --original signal
		 end if;
	 else 
	      INN_A <= x"0000";  --dont care
		   MUX_ALU2A_SEL <= PR3_MUXA_SEL;  --original signal
		  
		  
	 end if;
		 
	  
	 if (PR2(15 downto 12) = "0001") or (PR2(15 downto 12) = "0010") then    --immediate destination register also of ADD and NAND type                             --
      if(PR3(11 downto 9) = PR2(5 downto 3)) then   ---reg A matched
		  INN_A <= PR2(100 downto 85);   ---alu output stored in the PR2 of the 1st instruction
		  MUX_ALU2A_SEL <= "11";
		  
		else
		  INN_A <= x"0000";  --dont care
		  MUX_ALU2A_SEL <= PR3_MUXA_SEL;  --original signal;
		end if;
		  
	  elsif PR2(15 downto 12) = "0000" then	 ---destination register is ADI
	    if(PR3(11 downto 9) = PR2(8 downto 6)) then
	      INN_A <= PR2(100 downto 85);   ---alu output stored in the PR1 of the 1st instruction
		   MUX_ALU2A_SEL <= "11";
			
		 else 
		   INN_A <= x"0000";  --dont care
		   MUX_ALU2A_SEL <= PR3_MUXA_SEL;  --original signal
		 end if;
	  else
	    INN_A <= x"0000";  --dont care
		 MUX_ALU2A_SEL <= PR3_MUXA_SEL;  --original signal
	  end if;
	  
	
elsif (PR3(15 downto 12) = "0100") or(PR3(15 downto 12) = "0101") then  --source is load LW/SW instruction(same effect)

     if (PR1(15 downto 12) = "0001") or (PR1(15 downto 12) = "0010") then    --second immediate destination register also of ADD and NAND type                             --
      if(PR3(8 downto 6) = PR1(5 downto 3)) then   ---reg A matched
		  INN_A <= PR1(100 downto 85);   ---alu output stored in the PR2 of the 1st instruction
		  MUX_ALU2A_SEL <= "11";
		  
		else 
		  INN_A <= x"0000";  --dont care
		  MUX_ALU2A_SEL <= PR3_MUXA_SEL;  --original signal
		end if;
		  
	 elsif PR1(15 downto 12) = "0000" then	 ---destination register is ADI
	    if(PR3(8 downto 6) = PR1(8 downto 6)) then
	      INN_A <= PR1(100 downto 85);   ---alu output stored in the PR1 of the 1st instruction
		   MUX_ALU2A_SEL <= "11";
			
		 else 
		   INN_A <= x"0000";  --dont care
		   MUX_ALU2A_SEL <= PR3_MUXA_SEL;  --original signal
		 end if;
	 else 
	      INN_A <= x"0000";  --dont care
		   MUX_ALU2A_SEL <= PR3_MUXA_SEL;  --original signal
		  
		  
	 end if;
		 
	  
	 if (PR2(15 downto 12) = "0001") or (PR2(15 downto 12) = "0010") then    --immediate destination register also of ADD and NAND type                             --
      if(PR3(8 downto 6) = PR2(5 downto 3)) then   ---reg B matched
		  INN_A <= PR2(100 downto 85);   ---alu output stored in the PR2 of the 1st instruction
		  MUX_ALU2A_SEL <= "11";
		  
		else
		  INN_A <= x"0000";  --dont care
		  MUX_ALU2A_SEL <= PR3_MUXA_SEL;  --original signal;
		end if;
		  
	  elsif PR2(15 downto 12) = "0000" then	 ---destination register is ADI
	    if(PR3(8 downto 6) = PR2(8 downto 6)) then
	      INN_A <= PR2(100 downto 85);   ---alu output stored in the PR1 of the 1st instruction
		   MUX_ALU2A_SEL <= "11";
			
		 else 
		   INN_A <= x"0000";  --dont care
		   MUX_ALU2A_SEL <= PR3_MUXA_SEL;  --original signal
		 end if;
	  else
	    INN_A <= x"0000";  --dont care
		 MUX_ALU2A_SEL <= PR3_MUXA_SEL;  --original signal
	  end if;
	  
	  
else 
      INN_A <= x"0000";  --dont care
		MUX_ALU2A_SEL <= PR3_MUXA_SEL;  --original signal
end if;
    
  