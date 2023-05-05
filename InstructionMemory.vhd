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
    signal Instructions: Memory := (0=>"00010010",1=>"10011000",2=>"00100100",3=>"10100110",
    4=>"10100110",5=>"10100110",6=>"00010100",7=>"01100001",others => x"b0") ;
    --1 0 1 ADD r1 r2 r3 //00010010/10011000 // sets C flag
    --2 2 3 NCC R2 R2 R4 //00100100/10100110 // sets Z flag
    --3 4 5 NDZ R1 R2 R5 //00100010/10101001
    --4 6 7 ADZ R2 R1 R4 //00010100/01100001
    --5 8 9 SW R6 R2 1
    --15 28 29 LLI
    begin
    process(clk,address)
        begin
            output1 <= Instructions(to_integer(unsigned(address(6 downto 0))));
            output2 <= Instructions(to_integer(unsigned(address(6 downto 0)))+1);
            
    end process;
    
end InstructionMemory_arch;
