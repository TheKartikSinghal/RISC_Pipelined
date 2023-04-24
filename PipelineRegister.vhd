library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity LargeRegister is
    port(
    data_in : in std_logic_vector(100 downto 0);
    data_out : out std_logic_vector(100 downto 0);
    clk: in std_logic
    );
end LargeRegister;

architecture arch_LargeRegister of LargeRegister is
    signal data : std_logic_vector(100 downto 0) := (others => "0");
    begin
        p1: process(clk)
        begin
        if(clk='0') then
            data <= data_in;
            data_out <= data_in;
        elsif(clk='1') then
            data_out <= data;
            
        end if;
    end process;
end arch_LargeRegister;