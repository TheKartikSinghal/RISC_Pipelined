library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity DataMemory is
    port(
        address_memory : in std_logic_vector(15 downto 0);
        data_in_memory : in std_logic_vector(15 downto 0);
        data_out_memory : out std_logic_vector(15 downto 0);
        --
        clk: in std_logic;
        Memory_write_enable: in std_logic
        --if Memory_write_enable is high then we write to the Memory (i.e. input to the Memory). if low then we read from it.
    );
end DataMemory;
architecture DataMemory_arch of DataMemory is
    type Memory is array (0 to 63) of std_logic_vector (15 downto 0);
    signal Memory_data: Memory := (1 => x"0000", 2 => x"0000",15 => x"ffff",others => x"0000");
    begin
    process(clk,address_memory)
        begin
            if(Memory_write_enable='1') then
            Memory_data(to_integer(unsigned(address_memory(5 downto 0)))) <= data_in_memory;
            data_out_memory <= Memory_data(to_integer(unsigned(address_memory(5 downto 0))));
            elsif(Memory_write_enable='0') then
            data_out_memory <= Memory_data(to_integer(unsigned(address_memory(5 downto 0))));
        end if;
    end process;
    
end DataMemory_arch;
