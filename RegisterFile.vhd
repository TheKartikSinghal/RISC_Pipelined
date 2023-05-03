library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
--The register file contains 8 registers with 16 bits or 2 bytes capacity each.
--R0 being the PC.
entity RegisterFile is
    port(
        address1,address2,address3 : in std_logic_vector(2 downto 0);
        data_out1,data_out2 : out std_logic_vector(15 downto 0);
        data_in3 : in std_logic_vector(15 downto 0);
        clk: in std_logic;
        RF_write_enable: in std_logic;
        PC_in: in std_logic_vector(15 downto 0) := (others => '0');
        PC_out: out std_logic_vector(15 downto 0);
        PC_WE: in std_logic
    );
end RegisterFile;
architecture RegisterFile_arch of RegisterFile is
    type RF is array (1 to 7) of std_logic_vector (15 downto 0);
    signal RF_data: RF := (1 => x"0fff",2 => x"00f0",others => x"0000");
	signal regzero : std_logic_vector(15 downto 0) := x"0000";
    begin
    write: process(clk)
		variable address3num : integer:=1;
        begin
			if (address3 = "000" or address3 = "001") then
				address3num := 1;
			elsif(address3 = "010" ) then
				address3num := 2;
			elsif(address3 = "011" )then
				address3num := 3;
			elsif(address3 = "100" )then
				address3num := 4;
			elsif(address3 = "101" )then
				address3num := 5;
			elsif(address3 = "110" )then
				address3num := 6;
			elsif(address3 = "111" )then
				address3num := 7;
			end if;

			if (clk'event and clk='0') then
					if(address3 = "000") then
						if(RF_write_enable = '1') then
							regzero <= data_in3;
						else
							if (PC_WE='1') then
							regzero <= PC_in;
							end if;
						end if;
					else
                		if (PC_WE='1') then
							regzero <= PC_in;
                  		end if;
						if(RF_write_enable = '1') then
							RF_data(address3num) <= data_in3;
						end if;
					end if;
			 end if;
    end process;
	 
    PC_out <= regzero;
	 
	 process(address1,clk)
	 begin
		if(address1="000") then
			data_out1 <= regzero;
		elsif (address1="001" or address1="010" or address1="011" or address1="100" or address1="101" or address1="110" or address1="111") then
			data_out1 <= RF_data(to_integer(unsigned(address1)));
		end if;
	 end process;
	 
	 process(address2,clk)
	 begin
		if(address2="000") then
			data_out2 <= regzero;
		elsif (address2="001" or address2="010" or address2="011" or address2="100" or address2="101" or address2="110" or address2="111") then 
			data_out2 <= RF_data(to_integer(unsigned(address2)));
		end if;
	 end process;
 
end RegisterFile_arch;
