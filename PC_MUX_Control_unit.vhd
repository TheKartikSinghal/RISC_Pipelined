library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity PC_MUX_Control_unit is 
    port (
        instruction: in std_logic_vector(15 downto 0);
        C: in std_logic;
		Z: in std_logic; 
		LS_DETECT: in std_logic_vector(0 downto 0);
        con_sel: out std_logic_vector(1 downto 0);
        clk: in std_logic;
		throw_bit,LS_NOP: out std_logic
        --only purpose of the clock is for changing the control select lines using C/Z signals.
    ); 
end PC_MUX_Control_unit;

architecture arch_PC_MUX_Control_unit of PC_MUX_Control_unit is
--signal throw: std_logic:= '1'; -- one means throw
signal OpCode:std_logic_vector(3 downto 0) := instruction(15 downto 12);
begin
	process(instruction,clk,Z,C,LS_DETECT)
	begin
	OpCode<= instruction(15 downto 12);
	throw_bit <= '1';
    if(OpCode = "1000" and (Z='1')) then --BEQ
	    con_sel <= "10"; --provide input to PC from output of ALU 3
		 LS_NOP <= '0'; 
	elsif(OpCode = "1001" and (C='1')) then --BLT
	    con_sel <= "10"; --provide input to PC from output of ALU 3
		 LS_NOP <= '0'; 
	elsif(OpCode = "1010" and (Z='1' or C='1')) then --BLE
	    con_sel <= "10"; --provide input to PC from output of ALU 3
		  LS_NOP <= '0';
	elsif(OpCode = "1100") then --JAL
	    con_sel <= "10"; --provide input to PC from output of ALU 3
		  LS_NOP <= '0';
	elsif(OpCode = "1101") then --JLR
	    con_sel <= "11"; --provide input to PC from content of reg B
		 LS_NOP <= '0'; 
	elsif(OpCode = "1111") then --JRI
	    con_sel <= "01"; --provide input to PC from output of ALU 2
		 LS_NOP <= '0';
   elsif (Opcode = "0110" or Opcode = "0111") and (LS_DETECT = "0") then
	    con_sel <= "00";
		 LS_NOP <= '1';
	else
	    con_sel <= "00";
		throw_bit <= '0'; --means branch not taken so we don't throw
		LS_NOP <= '0';
	end if;	  
	end process;
end arch_PC_MUX_Control_unit;