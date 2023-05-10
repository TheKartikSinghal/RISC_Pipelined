library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Stall_and_throw is
port(
LM_SM_DETECTOR : in std_logic_vector(0 downto 0);
CHECKBIT,THROWBIT,LSNOP : in std_logic;
IFID_PR_WR,IFID_RST,
IDRR_PR_WR,IDRR_RST,
RREX_PR_WR,RREX_RST,
EXMEM_PR_WR,EXMEM_RST,
MEMWB_PR_WR,MEMWB_RST,
PC_WR: out std_logic
);
end entity;

architecture behave of Stall_and_throw is
begin
process(CHECKBIT,THROWBIT,LM_SM_DETECTOR)
begin
if (CHECKBIT = '1') then  --means that there is a data hazard and thus we need to stall the IFID register and reset the IDRR register
   IFID_PR_WR <= '0';    --write disabled
	IDRR_RST <= '1';      --resetting the IDRR register
	PC_WR <= '0';  --don't change the PC coz stalling
	
	IFID_RST <= '0';
	RREX_RST <= '0';
	EXMEM_RST<= '0';
	MEMWB_RST<= '0';
	
	IDRR_PR_WR<= '1';
	RREX_PR_WR<= '1';
	EXMEM_PR_WR<='1';
	MEMWB_PR_WR<='1';
	
	
elsif (THROWBIT = '1') then  --means there is branching so throw the extra 3 instructions loaded
   IFID_RST<= '1';
	IDRR_RST<= '1';
	RREX_RST<= '1';
	
	
   EXMEM_RST<= '0';
	MEMWB_RST<= '0';
	
	IFID_PR_WR<= '1';
	IDRR_PR_WR<= '1';
	RREX_PR_WR<= '1';
	EXMEM_PR_WR<='1';
	MEMWB_PR_WR<='1';
	
	PC_WR <= '1';  --can update the PC
	
else 
  
   IFID_RST <= '0';
	IDRR_RST <= '0';
	RREX_RST <= '0';
	EXMEM_RST<= '0';
	MEMWB_RST<= '0';
	
	IFID_PR_WR<= '1';
	IDRR_PR_WR<= '1';
	RREX_PR_WR<= '1';
	EXMEM_PR_WR<='1';
	MEMWB_PR_WR<='1';
	
	PC_WR<= '1';

end if;

if (LM_SM_DETECTOR = "1") then --stalling if amd id stages

   PC_WR <= '0';
	IFID_PR_WR <= '0';
	IDRR_PR_WR <= '0';
	RREX_PR_WR<= '1';
	EXMEM_PR_WR<='1';
	MEMWB_PR_WR<='1';
	IFID_RST <= '0';
	IDRR_RST <= '0';
	RREX_RST <= '0';
	EXMEM_RST<= '0';
	MEMWB_RST<= '0';
	
elsIF (LSNOP = '1') THEN

   PC_WR <= '1';
	IFID_PR_WR <= '1';
	IDRR_PR_WR <= '1';
	RREX_PR_WR<= '1';
	EXMEM_PR_WR<='1';
	MEMWB_PR_WR<='1';
	IFID_RST <= '0';
	IDRR_RST <= '0';
	RREX_RST <= '1';
	EXMEM_RST<= '1';
	MEMWB_RST<= '1';

else
   IFID_RST <= '0';
	IDRR_RST <= '0';
	RREX_RST <= '0';
	EXMEM_RST<= '0';
	MEMWB_RST<= '0';
	
	IFID_PR_WR<= '1';
	IDRR_PR_WR<= '1';
	RREX_PR_WR<= '1';
	EXMEM_PR_WR<='1';
	MEMWB_PR_WR<='1';
	
	PC_WR<= '1';
   


end if;
end process;
end behave;