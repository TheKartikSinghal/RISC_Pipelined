library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity SignExtender is
    port(input : in std_logic_vector(8 downto 0);
    OpCode: in std_logic_vector(3 downto 0);
    output : out std_logic_vector(15 downto 0));
end entity;

architecture arch_SignExtender of SignExtender is 
begin 
    # I type instructions : ADI-0000, LW-0100, SW-0101, BEQ-1000, BLT-1001, BLE-1010;
    # J type instructions : LLI-0011, JAL-1100, JRI-1111;
    # LLI needs unsigned extension
    p1: process(clk)
    begin
    if (OpCode="0000" || OpCode="0100" ||OpCode="0101" || OpCode="1000" ||OpCode="1001"||OpCode="1010") then
        output(5 downto 0) <= input(5 downto 0);
        fill: for i in 6 to 15 generate
            output(i) <= input(6);
        end generate;
    elsif (OpCode="1100" ||OpCode="1111") then
        output(8 downto 0) <= input(8 downto 0);
        fill: for i in 9 to 15 generate
            output(i) <= input(8);
        end generate;
    elsif (OpCode= "0011") then
        output(8 downto 0) <= input(8 downto 0);
        fill: for i in 9 to 15 generate
            output(15 downto 9) <= "000000");
        end generate;
        end if;

    end process;
end architecture;
