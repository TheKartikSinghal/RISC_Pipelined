library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
--The register file contains 8 registers with 16 bits or 2 bytes capacity each.
entity Register_file is
    port(
        address1,address2,address3 : in std_logic_vector(2 downto 0);
        data_out1,data_out2 : out std_logic_vector(15 downto 0);
        
        data_in3 : in std_logic_vector(15 downto 0);
        --data_in3 is the only input bus. Have used '3' to imply corrspondence to address3.
        clk: in std_logic;
        RF_write_enable: in std_logic
        --if RF_write_enable is high then we write to the RF (i.e. input to the RF). if low then we read from it.
    );
end Register_file;
architecture Register_file_arch of Register_file is
    type RF is array (0 to 7) of std_logic_vector (15 downto 0);
    signal RF_data: RF := (others => x"0000");
    begin
    process(address1,address2,clk)
        begin
            if(RF_write_enable='1') then
            RF_data(to_integer(unsigned(address3))) <= data_in3;
				data_out1 <= RF_data(to_integer(unsigned(address1)));
            data_out2 <= RF_data(to_integer(unsigned(address2)));
            elsif(RF_write_enable='0') then
            data_out1 <= RF_data(to_integer(unsigned(address1)));
            data_out2 <= RF_data(to_integer(unsigned(address2)));
        end if;
    end process;
end Register_file_arch;
