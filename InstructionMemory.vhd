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
    signal Instructions: Memory := (0=>"1000001001000011",1 => "0001001010011000",2 => "0001001011111000",others => x"0000") ;
    begin
    process(clk,address)
        begin
            output <= Instructions(to_integer(unsigned(address(6 downto 0))));
    end process;
    
end InstructionMemory_arch;
