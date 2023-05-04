library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity RFCZ is
port(
	INSTR : in std_logic_vector(122 downto 0);
	C_OUT : in std_logic;
	Z_OUT : in std_logic;
	RF_WR_out : out std_logic;
	C_WR_out : out std_logic;
	Z_WR_out : out std_logic;
	DMEM_WR_out : out std_logic;
	clk : in std_logic
	);
end entity;


architecture behave of RFCZ is
signal opcode : std_logic_vector(3 downto 0):= INSTR(15 downto 12);
signal RF_WR,C_WR,Z_WR,DMEM_WR : std_logic;
begin 

process(clk,INSTR,C_OUT,Z_OUT,RF_WR,C_WR,Z_WR,DMEM_WR)
begin
	opcode<=INSTR(15 downto 12);
	
 if (INSTR(48) = '1') then
	if opcode = "0001" or opcode = "0010" then  --arithmetic add and nand instructions
    	if INSTR(1 downto 0) = "10" then   --add/nand if carry set 
        	if C_OUT = '1' then
		    	RF_WR<= '1';  --enable RF
				C_WR<= '1';
				Z_WR<= '1';
				DMEM_WR<= '0';
			else
				RF_WR<= '0';  --disable RF
				C_WR<= '0';
				Z_WR<= '0';
				DMEM_WR<= '0';
			end if;
		  
		elsif INSTR(1 downto 0) = "01" then --add/nand if zero is set
			if Z_OUT = '1' then
				RF_WR<= '1';  --enable RF
				C_WR<= '1';
				Z_WR<= '1';
				DMEM_WR<= '0';
			else
				RF_WR<= '0';  --disable RF
				C_WR<= '0';
				Z_WR<= '0';
				DMEM_WR<= '0';
			end if;
			   
		else                           --remaining instructions
			RF_WR<= '1';
			C_WR<= '1';
			Z_WR<= '1';
			DMEM_WR<= '1';
		end if;
		
		
	elsif (opcode = "0000") or (opcode = "0011") then        --ADI;LLI
		RF_WR<= '1';
		C_WR<= '1';
		Z_WR<= '1';
		DMEM_WR<= '0';
			  
	elsif (opcode = "0100") then             --LW
        RF_WR<= '1';
		C_WR<= '0';
		Z_WR<= '1';
		DMEM_WR<= '0';
			
	elsif (opcode = "0101") then             --SW
        RF_WR<= '0';
		C_WR<= '0';
		Z_WR<= '0';
		DMEM_WR<= '1';
		
	elsif (opcode = "1000") or (opcode = "1001") or (opcode = "1010") then   ---BEQ, BLT, BLE
        RF_WR<= '0';
		C_WR<= '0';
		Z_WR<= '0';
		DMEM_WR<= '0';
  
	elsif (opcode = "1100") or (opcode = "1101") then
      RF_WR<= '1';
		C_WR<= '0';
		Z_WR<= '0';
		DMEM_WR<= '0';
			  
	else 
        RF_WR<= '0';
		C_WR<= '0';
		Z_WR<= '0';
		DMEM_WR<= '0';
  
	end if;
	
	
else 
     RF_WR<= '0';
	  C_WR<= '0';
	  Z_WR<= '0';
	  DMEM_WR<= '0';
	  
end if;
	
end process;
RF_WR_out<=RF_WR;
C_WR_out<=C_WR;
Z_WR_out<=Z_WR;
DMEM_WR_out<=DMEM_WR;
end behave;
