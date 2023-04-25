library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
--sign extender sits in the execute stage infront of mux for alu B input.
entity SignExtender is
    port(instruction : in std_logic_vector(15 downto 0);
    output : out std_logic_vector(15 downto 0));
end entity;

architecture arch_SignExtender of SignExtender is 
    -- I type instructions : ADI-0000, LW-0100, SW-0101, BEQ-1000, BLT-1001, BLE-1010;
    -- J type instructions : LLI-0011, JAL-1100, JRI-1111;
    -- LLI needs unsigned extension
	 signal OpCode: std_logic_vector(3 downto 0);
	 signal input: std_logic_vector(8 downto 0);
	 begin 
    p1: process(instruction)
    begin
    OpCode <= instruction(15 downto 12);
    input <= instruction(8 downto 0);
    if (OpCode="0000" or OpCode="0100" or OpCode="0101" or  OpCode="1000" or OpCode="1001"or OpCode="1010") then
        output(5 downto 0) <= input(5 downto 0);
        fill: for i in 6 to 15 loop
        output(i) <= input(6);
        end loop;
    elsif (OpCode="1100" or OpCode="1111") then
        output(8 downto 0) <= input(8 downto 0);
        fill1: for i in 9 to 15 loop
            output(i) <= input(8);
        end loop;
    elsif (OpCode= "0011") then
        output(8 downto 0) <= input(8 downto 0);
        fill2: for i in 9 to 15 loop
            output(15 downto 9) <= "0000000";
        end loop;
        end if;

    end process;
end architecture;
