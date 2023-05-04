library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity InstructionMemory is
    port(
        address : in std_logic_vector(15 downto 0);
        output : out std_logic_vector(15 downto 0);
        --
        clk: in std_logic
        --if Memory_write_enable is high then we write to the Memory (i.e. input to the Memory). if low then we read from it.
    );
end InstructionMemory;
architecture InstructionMemory_arch of InstructionMemory is
    type Memory is array (0 to 127) of std_logic_vector (15 downto 0);
    signal Instructions: Memory := (1=>"1100010000000010",2 => "0001001010011000",3 => "0001001010110000",4=>"0011111111111111",others => x"b000") ;
    begin
    process(clk,address)
        begin
            output <= Instructions(to_integer(unsigned(address(6 downto 0))));
    end process;
    
end InstructionMemory_arch;
