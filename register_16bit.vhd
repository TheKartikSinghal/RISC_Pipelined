library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity register_16bit is
    port(
    data_in : in std_logic_vector(15 downto 0);
    data_out : out std_logic_vector(15 downto 0);
    reg_WE : in std_logic;
    clk: in std_logic
    );
end register_16bit;

architecture arch_register_16bit of register_16bit is
    signal data : std_logic_vector(15 downto 0) := "0000000000000000";
    begin
        p1: process(clk,data_in)
        begin
        if(reg_WE='1') then
            data <= data_in;
				data_out <= data_in;
		  elsif(reg_WE='0') then
				data_out <= data;
        end if;
		  
        end process;
    
    
end arch_register_16bit;