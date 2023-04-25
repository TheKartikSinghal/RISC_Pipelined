library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity testbench_tb is 
end entity testbench_tb;

architecture test_arch of testbench_tb is
    signal clk : std_logic := '0';
    signal rst : std_logic := '1';
    --signal we : std_logic := '0';

component IITB_CPU is
    port(clk: in std_logic
    );
    
end component;

begin
    clk <= not clk after 1 ns;
    rst <= '1','0' after 2 ns;
    instance: IITB_CPU port map(clk);

    stimulus : process 
    begin
		wait;
    end process stimulus;

                

end architecture;