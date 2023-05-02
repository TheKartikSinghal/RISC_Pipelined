library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity PipelineRegister is
    port(
    data_in : in std_logic_vector(122 downto 0);
    data_out : out std_logic_vector(122 downto 0);
    clk: in std_logic;
    rst: in std_logic;
    PR_WE: in std_logic
    );
end PipelineRegister;

architecture arch_PipelineRegister of PipelineRegister is
    signal data : std_logic_vector(122 downto 0) := (others => '0');
    begin
        process(clk,rst,PR_WE)
        begin
        if(clk'event and clk='0')then
            if (rst='1') then
                data <=(others => '0');
                data_out <= (others => '0');
			else
                if(PR_WE='1') then
                    data <= data_in;
                    data_out <= data_in;
                else
                    data_out <= data;
		        end if;
            end if;
        end if;
    end process;
end arch_PipelineRegister;