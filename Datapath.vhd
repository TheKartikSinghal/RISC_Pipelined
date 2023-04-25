library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Datapath is 
    port (clk: in std_logic
        );
    end Datapath;

architecture arch_Datapath of Datapath is

    component InstructionMemory is
        port(
            address : in std_logic_vector(15 downto 0);
            output : out std_logic_vector(15 downto 0);
            clk: in std_logic
            );
    end component;

    component  DataMemory is 
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
    
    component PipelineRegister is 
        port(
            data_in : in std_logic_vector(100 downto 0);
            data_out : out std_logic_vector(100 downto 0);
            clk: in std_logic
            );
        end component;

    component RegisterFile is 
    port(
        address1,address2,address3 : in std_logic_vector(2 downto 0);
        data_out1,data_out2 : out std_logic_vector(15 downto 0);
        data_in3 : in std_logic_vector(15 downto 0);
        clk: in std_logic;
        RF_write_enable: in std_logic;
        PC_in: in std_logic_vector(15 downto 0) := (others => '0');
        PC_out: out std_logic_vector(15 downto 0):= (others => '0')
    );
        end component;
    
    component ALU is
        port (
            A: in std_logic_vector(15 downto 0);
            B: in std_logic_vector(15 downto 0);
            control_sel: in std_logic_vector(1 downto 0);
            C_flag, Z_flag, E_flag : out std_logic;
            clk: in std_logic;
            --only purpose of the clock is for changing the C/Z flags using C/Z signals.
            ALU_out: out std_logic_vector(15 downto 0)
        ); 
        end component;
    
    component register_1bit is
        port(
            data_in : in std_logic;
            data_out : out std_logic;
            clk: in std_logic;
            reg_WE : in std_logic
        );
        end component;
    
    component Mux_4to1_16bit is
        port(
            con_sel: in std_logic_vector(1 downto 0);
            A,B,C,D: in std_logic_vector(15 downto 0);
            clk: in std_logic;
            output: out std_logic_vector(15 downto 0)
        );
        end component;

    component SignExtender is
        port(instruction : in std_logic_vector(15 downto 0);
        output : out std_logic_vector(15 downto 0));
    end component;

    signal Instruction, RF_D1, RF_D2, RF_D3, PC_out, alu1out, alu3out, alu2out, DataAdd, DataIn, DataOut, aluAin, aluBin, seOut, PC_in :std_logic_vector(15 downto 0);
    signal RF_A1,RF_A2,RF_A3 : std_logic_vector(2 downto 0);
    signal IFID_in,IFID_out,IDRR_in,IDRR_out,RREX_in,RREX_out,EXMEM_in,EXMEM_out,MEMWB_in,MEMWB_out: std_logic_vector(100 downto 0);
    signal Cflagin,Cflagout,C_WE,Zflagin,Zflagout,Z_WE,DMem_WE,RF_WE: std_logic;
    signal muxpcCon,muxAluA_con,muxAluB_con,alu2con:std_logic_vector(1 downto 0);
begin
    IFID: PipelineRegister port map(IFID_in,IFID_out,clk);
    IDRR: PipelineRegister port map(IDRR_in,IDRR_out,clk);
    RREX: PipelineRegister port map(RREX_in,RREX_out,clk);
    EXMEM: PipelineRegister port map(EXMEM_in,EXMEM_out,clk);
    MEMWB: PipelineRegister port map(MEMWB_in,MEMWB_out,clk);
	
	IMem: InstructionMemory port map(PC_out,Instruction,clk);
    DMem: DataMemory port map(DataAdd,DataIn,DataOut,clk,DMem_WE);
    RF: RegisterFile port map(RF_A1,RF_A2,RF_A3, RF_D1, RF_D2, RF_D3,clk,RF_WE,PC_in,PC_out);
    muxAluA: Mux_4to1_16bit port map(muxAluA_con,RREX_out(31 downto 16),RREX_out(47 downto 32),RREX_out(84 downto 69),x"0000",clk,aluAin);
    muxpc: Mux_4to1_16bit port map(muxpcCon,alu1out,alu3out,alu2out,x"0000",clk,PC_in);
    muxAluB: Mux_4to1_16bit port map(muxAluB_con,seOut,RREX_out(47 downto 32),x"0001",x"0000",clk,aluBin);
    cflag: register_1bit port map(Cflagin,Cflagout,clk,C_WE);
    zflag: register_1bit port map(Zflagin,Zflagout,clk,Z_WE);
    
    se: SignExtender port map(RREX_out(15 downto 0),seOut);
    alu1: ALU port map(PC_out,x"0001","00",open,open,open,clk,alu1out);
    alu2: ALU port map(aluAin,aluBin,alu2Con,Cflagin,Zflagin,open,clk,alu2out);
    alu3: ALU port map(RREX_out(84 downto 69),seOut,"00",open,open,open,clk,alu3out);
	 
	 
    p1: process(clk)
    begin
	 if(clk'event and clk='0') then
    -- 1st Pipeline Register
    --IFID will only take in instrucion and PC
    IFID_in(15 downto 0) <= Instruction;
    IFID_in(84 downto 69) <= PC_out;
    
    -- 2nd Pipeline Register
    IDRR_in(15 downto 0)<=IFID_out(15 downto 0);--just copying instruction
    IDRR_in(84 downto 69)<=IFID_out(84 downto 69);--just copying PC
    --control signals which are supposed to be decided during the ID stage also need to added here. 
    --and also forwarded to other registers.
    RF_A1 <= IDRR_out(11 downto 9);--incase of ADA encoding was 0001/RA*/RB/RC/0/00
    RF_A2 <= IDRR_out(8 downto 6);--incase of ADA encoding was 0001/RA/RB*/RC/0/00
    
    -- 3rd Pipeline Register
    RREX_in (15 downto 0)  <= IDRR_in(15 downto 0);--just copying instruction
    RREX_in (84 downto 69)<= IDRR_in(84 downto 69);--just copying PC
    RREX_in (31 downto 16) <= RF_D1;-- fetching data RA
    RREX_in (47 downto 32) <= RF_D2;-- fetching data RB
    
    -- 4th Pipeline Register
    EXMEM_in (15 downto 0)  <= RREX_out(15 downto 0);--just copying instruction
    EXMEM_in (84 downto 69) <= RREX_out(84 downto 69);--just copying PC
    EXMEM_in (31 downto 16) <= RREX_out (31 downto 16);--forwarding the data RA
    EXMEM_in (47 downto 32) <= RREX_out (47 downto 32);--forwarding the data RB
    EXMEM_in (100 downto 85) <= alu2out; 
    --WE signals might also need to be changed here.
    --also add the wires from EXMEM to DMem
    -- and from DMem to MEMWB

    -- 5th/last Pipeline Register
    MEMWB_in (15 downto 0)  <=EXMEM_out(15 downto 0);--just copying instruction
    MEMWB_in (84 downto 69) <=EXMEM_out(84 downto 69);--just copying PC
    MEMWB_in (31 downto 16) <=EXMEM_out (31 downto 16);--forwarding the data RA
    MEMWB_in (47 downto 32) <=EXMEM_out (47 downto 32);--forwarding the data RB
    MEMWB_in (100 downto 85) <=EXMEM_out (100 downto 85);

    RF_D3 <= MEMWB_out (100 downto 85);
    RF_A3 <= MEMWB_out(5 downto 3);
	 end if;

    

    end process;
end arch_Datapath;
