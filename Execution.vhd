library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Executor is
port(PR1 : in std_logic_vector(15 downto 0); --This is the RREX register
	ALU_SEL : out std_logic_vector(1 downto 0);
    ALU_MUXA_SEL : out std_logic_vector(1 downto 0); --these mux selects will be going to the forwarding units.
	ALU_MUXB_SEL : out std_logic_vector(1 downto 0)
);
end entity Executor;

architecture Executor_arch of Executor is
--no signals as of yet.
begin
process(PR1)
begin
case PR1(15 downto 12) is --conditioning on the opcode.
    when "0001" => --for all 8 types of ADD
		ALU_MUXA_SEL <= "00";--RA
		ALU_MUXB_SEL <= "01";--RB
		ALU_SEL <= "00";--using mode 1 of alu which is addition
				
	when "0000"=>   --ADI
	    ALU_MUXA_SEL <= "00";--RA
		ALU_MUXB_SEL <= "00";--SE output
		ALU_SEL <= "00";

	when "0010"=> --for all 6 types of NAND
		ALU_MUXA_SEL <= "00";--RA
		ALU_MUXB_SEL <= "01";--RB
		ALU_SEL <= "01";--Nanding
			
	when "0011" => --LLI
		ALU_MUXA_SEL <= "00";--RA, though alu wont be using this data
		ALU_MUXB_SEL <= "00";--SE, will be directly broadcasted at output
		ALU_SEL <= "00";
		      --NO USE OF ALU (for calculation) FOR THIS---
			  --using it just to pass through the value.
		
    when "0100" => --LW
		ALU_MUXA_SEL <= "01";   --DATA2 OF REGB
		ALU_MUXB_SEL <= "00";   --SE output
		ALU_SEL <= "00"; --adding for BTA(branch target address) calculation
		
	when "0101" => --SW
		ALU_MUXA_SEL <= "01";   --DATA2 OF REGB
		ALU_MUXB_SEL <= "00";   --SE output
		ALU_SEL <= "00"; --adding for BTA(branch target address) calculation

	when "0110" => --LM
	    ALU_MUXA_SEL <= "00";
		 ALU_MUXB_SEL <= "10";
		 ALU_SEL <= "00";
	when "0111" => --SM
	   ALU_MUXA_SEL <= "00";
		 ALU_MUXB_SEL <= "10";
		 ALU_SEL <= "00";
		
	when "1000" => --BEQ
	--change to subb
	--for comparison
	--and change to ra and rb
	    ALU_MUXA_SEL <= "00";--RA
		ALU_MUXB_SEL <= "01";--RB
		ALU_SEL <= "10";
		
	when "1001" => --BEQ
	--change to subb
	--for comparison
	--and change to ra and rb
	    ALU_MUXA_SEL <= "00";--RA
		ALU_MUXB_SEL <= "01";--RB
		ALU_SEL <= "10";
	
	when "1010" => --BEQ
	--change to subb
	--for comparison
	--and change to ra and rb
	    ALU_MUXA_SEL <= "00";--RA
		ALU_MUXB_SEL <= "01";--RB
		ALU_SEL <= "10";
	
	when "1100" =>--jal
		ALU_MUXA_SEL <= "10"; --pc
		ALU_MUXB_SEL <="10";--+1
		ALU_SEL <="00";

	when "1101" =>--jlr
		ALU_MUXA_SEL <= "10"; --pc
		ALU_MUXB_SEL <="10";--+1
		ALU_SEL <="00";

	when "1111" =>--jri
		ALU_MUXA_SEL <= "00"; --RA
		ALU_MUXB_SEL <="00";--SE(immediate)
		ALU_SEL <="00";
	
	when others =>--for nop doesnt matter as WE are 0.
		ALU_MUXA_SEL <= "00";--RA
		ALU_MUXB_SEL <= "01";--RB
		ALU_SEL <= "00";

	end case;
end process;

end Executor_arch;