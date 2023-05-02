library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity I_D is
port(PR1 : in std_logic_vector(15 downto 0);
     clk : in std_logic;
	  data_out1 : out std_logic_vector(15 downto 0);
	  data_out2 : out std_logic_vector(15 downto 0)
);
end entity I_D; 

architecture instr_decode of I_D is 

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

signal RFDATA_1_1, RFDATA_2_1 : std_logic_vector(15 downto 0);
signal RFDATA_1_2, RFDATA_2_2 : std_logic_vector(15 downto 0);
signal RFDATA_1_3, RFDATA_2_3 : std_logic_vector(15 downto 0);
--signals

begin
 if (PR1(15 downto 12) = "0001") or (PR1(15 downto 12) = "0010") then --add and nand
      RF_1 : Register_file port map(PR1(11 downto 9), PR1(8 downto 6),"000", RFDATA_1_1, RFDATA_2_1, x"0000", clk,'0');
      data_out1 <= RFDATA_1_1;
		data_out2 <= RFDATA_2_2;
		
 elsif (PR1(15 downto 12) = "0000") or (PR1(15 downto 12) = "0110") or (PR1(15 downto 12) = "0111") or (PR1(15 downto 12) = "1101") or (PR1(15 downto 12) = "1111") then --adi,lm,sm, jlr, jri
      RF_2 : Register_file port map(PR1(11 downto 9), "000","000", RFDATA_1_2, RFDATA_2_2, x"0000", clk,'0');
      data_out1 <= RFDATA_1_2;
		data_out2 <= x"0000";
		
 elsif (PR1(15 downto 12) = "0100") or (PR1(15 downto 12) = "0101") then --lw,sw
      RF_3 : Register_file port map("000", PR1(8 downto 6),"000", RFDATA_1_3, RFDATA_2_3, x"0000", clk,'0');
      data_out2 <= RFDATA_2_3;
		data_out1 <= x"0000";
		
 else 
     data_out1 <= x"0000";
	  data_out2 <= x"0000";
	  
 end process;
 end instr_decode;
		