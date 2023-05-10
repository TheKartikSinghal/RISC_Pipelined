library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
--sign extender sits in the execute stage infront of mux for alu B instruction.
entity SignExtender is
    port(instruction : in std_logic_vector(15 downto 0);
    output : out std_logic_vector(15 downto 0)
    );
end entity;

architecture arch_SignExtender of SignExtender is 
    -- I type instructions : ADI-0000, LW-0100, SW-0101, BEQ-1000, BLT-1001, BLE-1010;
    -- J type instructions : LLI-0011, JAL-1100, JRI-1111;
    -- LLI needs unsigned extension
	--signal OpCode: std_logic_vector(3 downto 0);
	--signal input: std_logic_vector(8 downto 0);

    begin
    process(instruction)
    begin
    --OpCode <= instruction(15 downto 12);
    --input <= instruction(8 downto 0);
    if (instruction(15 downto 12)="0000" or instruction(15 downto 12)="0100" or instruction(15 downto 12)="0101") then
        if (instruction(5) = '1') then
            output <= "1111111111"&instruction(5 downto 0);
        elsif (instruction(5) = '0') then
            output <= "0000000000"&instruction(5 downto 0);
        end if;
    elsif(instruction(15 downto 12)="1000" or instruction(15 downto 12)="1001"or instruction(15 downto 12)="1010") then
        if (instruction(5) = '1') then
            output <= "111111111"&instruction(5 downto 0)&'0';
        elsif (instruction(5) = '0') then
            output <= "000000000"&instruction(5 downto 0)&'0';
        end if;
    elsif (instruction(15 downto 12)="1100" or instruction(15 downto 12)="1111") then
        if (instruction(8) = '1') then
            output <= "111111"&instruction(8 downto 0)&'0';
        elsif (instruction(8) = '0') then
            output <= "000000"&instruction(8 downto 0)&'0';
        end if;
    elsif (instruction(15 downto 12)= "0011") then
        output <= "0000000"&instruction(8 downto 0);
    else 
        output <= x"0000";
    end if;
    end process;
    
end architecture;
