library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity RR is
port( PR1 : in std_logic_vector(107 downto 0);
      rstlsmout : out std_logic_vector(7 downto 0);
		
	clk , exe_en, wb_en, mem_en: in std_logic
);

end entity RR;

architecture rr_arch of RR is

component PE is
port (PEin:in std_logic_vector(7 downto 0);
 PEout:out std_logic_vector(2 downto 0);
 PE_en : in std_logic_vector(0 downto 0));
 --all_zero : out std_logic_vector(0 downto 0));
end component ;

component reset_lsm is
  port ( address : in std_logic_vector(2 downto 0);
         instr : in std_logic_vector(7 downto 0);
			rstlsm_en : in std_logic_vector(0 downto 0);
         --all_zero : in std_logic;
			rstlsm : out std_logic_vector(7 downto 0)
			
		);
		
end component reset_lsm;

component DataMemory is
    port(
        address_memory : in std_logic_vector(15 downto 0);
        data_in_memory : in std_logic_vector(15 downto 0);
        data_out_memory : out std_logic_vector(15 downto 0);
        --
        clk: in std_logic;
        Memory_write_enable: in std_logic
        --if Memory_write_enable is high then we write to the Memory (i.e. input to the Memory). if low then we read from it.
    );
end component;

component Register_file is
    port(
        address1,address2,address3 : in std_logic_vector(2 downto 0);
        data_out1,data_out2 : out std_logic_vector(15 downto 0);
        data_in3 : in std_logic_vector(15 downto 0);
        --data_in3 is the only input bus. Have used '3' to imply corrspondence to address3.
        clk: in std_logic;
        RF_write_enable: in std_logic_vector(0 downto 0)
        --if RF_write_enable is high then we write to the RF (i.e. input to the RF). if low then we read from it.
    );
end component;

signal temp_addr : std_logic_vector(2 downto 0) := "000";
signal data1, data2 : std_logic_vector(15 downto 0) := x"0000";
signal addr1, addr2 : std_logic_vector(2 downto 0) := "000";
signal load_data : std_logic_vector(15 downto 0):= x"0000"; 

begin

regread : process(PR1, temp_addr)

begin

if (PR1(15 downto 12) = "0110") then
if( PR1(7 downto 0) /= "00000000" ) then --lm
PE1 : PE port map(PR1(7 downto 0), temp_addr, '1');
DM1 : DataMemory port map(PR1(31 downto 16), x"0000", load_data, clk, '0');
if( temp_addr /= "000") then
rf : Register_file port map( addr1, addr2, temp_addr, data1, data2, load_data, clk, '1');
else
null;
end if;
resetlsm : reset_lsm port map(temp_addr, PR1(7 DOWNTO 0), '1', rstlsmout);
exe_en <= '1';
mem_en <= '1';
wb_en <= '1';
else
exe_en <= '0';
mem_en <= '0';
wb_en <= '0';
end if;
elsif (PR1(15 DOWNTO 12) = "0111") THEN
if( PR1(7 downto 0) /= "00000000" ) then --Sm
PE2 : PE port map(PR1(7 downto 0), addr1, '1');
rf2 : Register_file port map( addr1, addr2, temp_addr, data1, data2, load_data, clk, '1');
DM2 : DataMemory port map(PR1(31 downto 16), data1, load_data, clk, '1');
resetlsm : reset_lsm port map(addr1, PR1(7 DOWNTO 0), '1', rstlsmout);
exe_en <= '1';
mem_en <= '1';
wb_en <= '1';

else
exe_en <= '0';
mem_en <= '0';
wb_en <= '0';
end if;
else
null;
end if;

end process;

end rr_arch;
