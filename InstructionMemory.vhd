library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity InstructionMemory is
    port(
        address : in std_logic_vector(15 downto 0);
        output1 : out std_logic_vector(7 downto 0);
        output2 : out std_logic_vector(7 downto 0);
        --
        clk: in std_logic
        --if Memory_write_enable is high then we write to the Memory (i.e. input to the Memory). if low then we read from it.
    );
end InstructionMemory;
architecture InstructionMemory_arch of InstructionMemory is
    type Memory is array (0 to 127) of std_logic_vector (7 downto 0);
    signal Instructions: Memory := (2=>"01001100",
    3=> "10000000",6=>"01011100",7=>"10000001",28=>"00111111",29=>"11111111",others => x"b0") ;
    --1 0 1
    --2 2 3 LW R6 R2 0 // loads from mem16 to R6 
    --x3 4 5 ADD R6 R1 R3 000
    --4 6 7 SW R6 R2 1
    --15 28 29 LLI
    begin
    process(clk,address)
        begin
            output1 <= Instructions(to_integer(unsigned(address(6 downto 0))));
            output2 <= Instructions(to_integer(unsigned(address(6 downto 0)))+1);
            
    end process;
    
end InstructionMemory_arch;
