library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Mux_2to1_3bit is
    port(
        con_sel: in std_logic_vector(0 downto 0);
        A,B: in std_logic_vector(2 downto 0);
        --clk: in std_logic;
        output: out std_logic_vector(2 downto 0)
    );
end Mux_2to1_3bit;

architecture arch_Mux_2to1_3bit of Mux_2to1_3bit is
    begin
        p54: process(con_sel,A,B)
        begin
        if(con_sel="0") then
            output <= A;
        elsif(con_sel="1") then
            output <= B;
		 ELSE
		 NULL;
        END IF;
        end process;
end arch_Mux_2to1_3bit;