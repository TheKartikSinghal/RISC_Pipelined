library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity I_F is
    port(PC_in : in std_logic_vector(15 downto 0);
	      instruction : out std_logic_vector(15 downto 0);
			PC_out : out std_logic_vector(15 downto 0)
	 
	 );
	
end entity I_F;
	
architecture instr_fetch of I_F is 

component InstructionMemory is
  port(
		address : in std_logic_vector(15 downto 0);
		output : out std_logic_vector(15 downto 0);
		clk: in std_logic
		);
end component;

--signals
signal PC_out_mem_s, Instruction_s : std_logic_vector(15 downto 0);



begin
 instr_mem : InstructionMemory port map(PC_in, Instruction_s);
 instruction <= instruction_s;
 PC_out <= unsigned(PC_in) + unsigned(one);


end instr_fetch;






 
	 