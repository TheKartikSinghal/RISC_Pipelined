library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

-- for creating C,Z flags.

entity register_1bit is
    port(
        data_in : in std_logic;
        data_out : out std_logic;
        clk: in std_logic;
        reg_WE : in std_logic
    );
end register_1bit;

architecture arch_register_1bit of register_1bit is
    signal data: std_logic := '0';
    begin
        p5: process(clk,data_in)
        begin
        if(reg_WE = '1') then
            data <= data_in;
            data_out <= data_in;
        elsif(reg_WE = '0') then
            data_out <= data;
        end if;
        end process;
end arch_register_1bit;
