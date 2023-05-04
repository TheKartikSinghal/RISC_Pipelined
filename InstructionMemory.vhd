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
    signal Instructions: Memory := (2=>"0100110010000000",3 => "0001110001011000",4=>"0101011010000001",15=>"0011111111111111",others => x"b000") ;
    --1 
    --2 LW R6 R2 0 // loads from mem16 to R6 
    --3 ADD R6 R1 R3 000
    --4 SW R3 R2 1
    --15 LLI
    begin
    process(clk,address)
        begin
            output <= Instructions(to_integer(unsigned(address(6 downto 0))));
    end process;
    
end InstructionMemory_arch;
