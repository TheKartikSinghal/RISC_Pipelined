library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity PipelineRegister is
    port(
    data_in : in std_logic_vector(100 downto 0);
    data_out : out std_logic_vector(100 downto 0);
    clk: in std_logic
    );
end PipelineRegister;

architecture arch_PipelineRegister of PipelineRegister is
    signal data : std_logic_vector(100 downto 0) := (others => '0');
    begin
        process(clk)
        begin
		  if(clk'event and clk='0') then
            data <= data_in;
            data_out <= data_in;
		  end if;
    end process;
end arch_PipelineRegister;