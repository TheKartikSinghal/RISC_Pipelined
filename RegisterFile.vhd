library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
--The register file contains 8 registers with 16 bits or 2 bytes capacity each.
--R0 being the PC.
entity Register_file is
    port(
        address1,address2,address3 : in std_logic_vector(2 downto 0);
        data_out1,data_out2 : out std_logic_vector(15 downto 0);
        data_in3 : in std_logic_vector(15 downto 0);
        clk: in std_logic;
        RF_write_enable: in std_logic;
        PC_in: in std_logic_vector(15 downto 0);
        PC_out: out std_logic_vector(15 downto 0)
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

    process(clk)
    begin
        if (clk='0') then
            RF_data(0) <= PC_in;
            PC_out <= PC_in;
        else
            PC_out <= RF_data(0);
        end if;
    end process;
end Register_file_arch;
