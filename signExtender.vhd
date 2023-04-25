library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity SignExtender is
    port(nine_bit_in : in std_logic_vector(8 downto 0);
    OpCode: in std_logic_vector(3 downto 0);
    sixteen_bit_out : out std_logic_vector(15 downto 0));
end entity;

architecture arch_SignExtender of SignExtender is 
begin 
    # I type instructions : ADI-0000, LW-0100, SW-0101, BEQ-1000, BLT-1001, BLE-1001;
    # J type instructions : LLI-0011, JAL-1100, JRI-1111;
    # LLI needs unsigned extension
    p1: process(clk)
    begin
    if (OpCode="0000" || OpCode="0100" ||OpCode="0101" || OpCode="1000" ||OpCode="1001") then
        sixteen_bit_out(5 downto 0) <= nine_bit_in(5 downto 0);
        fill: for i in 6 to 15 generate
            sixteen_bit_out(i) <= nine_bit_in(6);
        end generate;
    elsif (OpCode="1100" ||OpCode="1111") then
        sixteen_bit_out(8 downto 0) <= nine_bit_in(8 downto 0);
        fill: for i in 9 to 15 generate
            sixteen_bit_out(i) <= nine_bit_in(8);
        end generate;
    elsif (OpCode= "0011") then
        sixteen_bit_out(8 downto 0) <= nine_bit_in(8 downto 0);
        fill: for i in 9 to 15 generate
            sixteen_bit_out(15 downto 9) <= "000000");
        end generate;
        end if;

    end process;
end architecture;
