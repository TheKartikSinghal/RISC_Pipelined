library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity PC_MUX_Control_unit is 
    port (
        instruction: in std_logic_vector(15 downto 0);
        C: in std_logic;
		  Z: in std_logic; 
        con_sel: out std_logic_vector(1 downto 0);
        clk: in std_logic;
		  throw_bit: out std_logic;
        --only purpose of the clock is for changing the control select lines using C/Z signals.
    ); 
end PC_MUX_Control_unit;

architecture arch_PC_MUX_Control_unit of PC_MUX_Control_unit is
signal throw: std_logic:= 0;
begin
OpCode <= instruction(15 downto 12);

    if(OpCode = "1000" and (Z=1)) then --BEQ
	     con_sel = "10"; --provide input to PC from output of ALU 3
		  
	 elsif(OpCode = "1001" and (C=1)) then --BLT
	     con_sel = "10"; --provide input to PC from output of ALU 3
		  
	 elsif(OpCode = "1010" and (Z=1 or C=1)) then --BLE
	     con_sel = "10"; --provide input to PC from output of ALU 3
		  
	 elsif(OpCode = "1100") then --JAL
	     con_sel = "10"; --provide input to PC from output of ALU 3
		  
	 elsif(OpCode = "1101") then --JLR
	     con_sel = "11"; --provide input to PC from content of reg B
		  
	 elsif(OpCode = "1111") then --JRI
	     con_sel = "01"; --provide input to PC from output of ALU 2
	 else
	     con_sel = "00";
		  throw = 1;
		  
throw_bit <= throw;		  
		  
end arch_PC_MUX_Control_unit;