library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Mux_4to1_16bit is
    port(
        con_sel: in std_logic_vector(1 downto 0);
        A,B,C,D: in std_logic_vector(15 downto 0);
        clk: in std_logic;
        output: out std_logic_vector(15 downto 0)
    );
end Mux_4to1_16bit;

architecture arch_Mux_4to1_16bit of Mux_4to1_16bit is
    begin
        p51: process(clk,con_sel,A,B,C,D)
        begin
        if(con_sel="00") then
            output <= A;
        elsif(con_sel="01") then
            output <= B;
        elsif(con_sel="10") then
            output <= C;
        elsif(con_sel="11") then
            output <= D;
        end if;
        end process;
end arch_Mux_4to1_16bit;