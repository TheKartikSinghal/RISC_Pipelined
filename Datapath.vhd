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
        data_in : in std_logic_vector(122 downto 0);
        data_out : out std_logic_vector(122 downto 0);
        clk: in std_logic;
        rst: in std_logic;
        PR_WE: in std_logic
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
        PC_out: out std_logic_vector(15 downto 0):= (others => '0');
        PC_WE: in std_logic
    );
        end component;
    
    component ALU is
        port (
            A: in std_logic_vector(15 downto 0);
            B: in std_logic_vector(15 downto 0);
            carry_in: in std_logic; 
        --carry in signal has been added to allow instructions 
        --with carry computation to work in single cycle
        --without extra alu.
		instruction: in std_logic_vector(15 downto 0);
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

     component PC_MUX_Control_unit is 
    port (
        instruction: in std_logic_vector(15 downto 0);
        C: in std_logic;
		  Z: in std_logic; 
        con_sel: out std_logic_vector(1 downto 0);
        clk: in std_logic;
		  throw_bit: out std_logic
	 ); 
    end component;

    component FwdA is
	port (
	    PR1 : in std_logic_vector(122 downto 0);--MEMWB
	    PR2 : in std_logic_vector(122 downto 0);--EXMEM --as fwding from EXMEM dominates fwding from MEMWB
	    --we first check for MEMWB and then overwrite if needed by EXMEM
	    --ie first check PR1 and then for PR2
	    PR3 : in std_logic_vector(122 downto 0);--RREX register
	    PR3_MUXA_SEL : in std_logic_vector(1 downto 0);--output for mux A without fwding which is provided by the executor.
	    INN_A : out std_logic_vector(15 downto 0);--fourth input for alumuxA which will be used incase of fwding
	    MUX_ALU2A_SEL : out std_logic_vector(1 downto 0)--final output for alumuxA
	    );
    end component;
    
    component FwdB is
	port (
	    PR1 : in std_logic_vector(122 downto 0);
	    PR2 : in std_logic_vector(122 downto 0);
	    PR3 : in std_logic_vector(122 downto 0);
	    PR3_MUXB_SEL : in std_logic_vector(1 downto 0);
	    INN_B : out std_logic_vector(15 downto 0);
	    MUX_ALU2B_SEL : out std_logic_vector(1 downto 0)
	    );
    end component;

    component Executor is
    port(
        PR1 : in std_logic_vector(15 downto 0); --This is the RREX register
	    ALU_SEL : out std_logic_vector(1 downto 0);
        ALU_MUXA_SEL : out std_logic_vector(1 downto 0); --these mux selects will be going to the forwarding units.
	    ALU_MUXB_SEL : out std_logic_vector(1 downto 0)
        );
    end component;

    component Stall_and_throw is
    port(
        CHECKBIT,THROWBIT : in std_logic;
        IFID_PR_WR,IFID_RST,
        IDRR_PR_WR,IDRR_RST,
        RREX_PR_WR,RREX_RST,
        EXMEM_PR_WR,EXMEM_RST,
        MEMWB_PR_WR,MEMWB_RST,
        PC_WR: out std_logic
        );
    end component;

    component load_hazards is
    port( 
	    PR1 : in std_logic_vector(122 downto 0);
	    PR2 : in std_logic_vector(122 downto 0);
	    CHECK_BIT : out std_logic
	    --MUX_ALU2A_SEL : out std_logic_vector(1 downto 0);
	    );
    end component;

    component RFCZ is
    port(
	    INSTR : in std_logic_vector(15 downto 0);
	    C_OUT : in std_logic;
	    Z_OUT : in std_logic;
	    RF_WR : out std_logic;
	    C_WR : out std_logic;
	    Z_WR : out std_logic;
	    DMEM_WR : out std_logic
	    );
    end component;


    signal Instruction, RF_D1, RF_D2, RF_D3, PC_out, alu1out, alu3out, alu2out, DataAdd, DataIn, DataOut, aluAin, aluBin, seOut, PC_in ,fwdtomuxA,fwdtomuxB:std_logic_vector(15 downto 0);
    signal RF_A1,RF_A2,RF_A3 : std_logic_vector(2 downto 0);
    signal IFID_in,IFID_out,IDRR_in,IDRR_out,RREX_in,RREX_out,EXMEM_in,EXMEM_out,MEMWB_in,MEMWB_out: std_logic_vector(122 downto 0);
    signal Cflagin,Cflagout,C_WE,Zflagin,Zflagout,Z_WE,DMem_WE,DMem_WE_out,RF_WE,RF_WE_out,throw_sig,check_sig,PC_WE: std_logic;
    signal muxpcCon,muxAluA_con,muxAluB_con,alu2con,exextofwderA,exextofwderB:std_logic_vector(1 downto 0);
    signal IFID_rst,IFID_WE,IDRR_rst,IDRR_WE,RREX_rst,RREX_WE,EXMEM_rst,EXMEM_WE,MEMWB_rst,MEMWB_WE: std_logic;
begin
    IFID: PipelineRegister port map(IFID_in,IFID_out,clk,IFID_rst,IFID_WE);
    IDRR: PipelineRegister port map(IDRR_in,IDRR_out,clk,IDRR_rst,IDRR_WE);
    RREX: PipelineRegister port map(RREX_in,RREX_out,clk,RREX_rst,RREX_WE);
    EXMEM: PipelineRegister port map(EXMEM_in,EXMEM_out,clk,EXMEM_rst,EXMEM_WE);
    MEMWB: PipelineRegister port map(MEMWB_in,MEMWB_out,clk,MEMWB_rst,MEMWB_WE);
	
	IMem: InstructionMemory port map(PC_out,Instruction,clk);
    DMem: DataMemory port map(DataAdd,DataIn,DataOut,clk,DMem_WE);
    RF: RegisterFile port map(RF_A1,RF_A2,RF_A3, RF_D1, RF_D2, RF_D3,clk,RF_WE,PC_in,PC_out,PC_WE);
    muxAluA: Mux_4to1_16bit port map(muxAluA_con,RREX_out(31 downto 16),RREX_out(47 downto 32),RREX_out(84 downto 69),fwdtomuxA,clk,aluAin);
    muxpc: Mux_4to1_16bit port map(muxpcCon,alu1out,alu3out,alu2out,x"0000",clk,PC_in);
    muxAluB: Mux_4to1_16bit port map(muxAluB_con,seOut,RREX_out(47 downto 32),x"0001",fwdtomuxB,clk,aluBin);
    cflag: register_1bit port map(Cflagin,Cflagout,clk,C_WE);
    zflag: register_1bit port map(Zflagin,Zflagout,clk,Z_WE);

    pcController: PC_MUX_Control_unit port map(RREX_out(15 downto 0),Cflagin,Zflagin,muxpcCon,clk,throw_sig);
    
    --throw_sig carries the value of the throw bit for the pipeline registers prior to EXMEM.
    --at the end of this cycle the branch instruction will enter mem stage and the last useless
    --instruction would have entered the IF stage.
    --so the throw bit needs to be set for IFID,IDRR,RREX.
    --ALSO CARE NEEDS TO BE TAKEN FOR THROWN INSTRUCTIONS WHICH CAN CAUSE DAMAGE EVEN WITHOUT WRITING 
    --INTO RF OR MEM (LIKE BRANCH INSTRUCTIONS)
    --possible solution => make all bits 0 so it becomes a add instruction and then make WEs 0 so that 
    -- there is no danger.

    fwderA: FwdA port map (MEMWB_out,EXMEM_out,RREX_out,exextofwderA,fwdtomuxA,muxAluA_con);
    fwderB: FwdB port map (MEMWB_out,EXMEM_out,RREX_out,exextofwderB,fwdtomuxB,muxAluB_con);
    exec: Executor port map(RREX_out(15 downto 0),alu2con,exextofwderA,exextofwderB);

    ST: stall_and_throw port map(check_sig,throw_sig,IFID_WE,IFID_rst,IDRR_WE,IDRR_rst,RREX_WE,RREX_rst,EXMEM_WE,EXMEM_rst,MEMWB_WE,MEMWB_rst,PC_WE);
    LH: load_hazards port map(IDRR_out,IFID_out,check_sig) ;
    rfcz1: RFCZ port map(RREX_out(15 downto 0),Cflagout,Zflagout,RF_WE_out,C_WE,Z_WE,DMem_WE_out);
    
    se: SignExtender port map(RREX_out(15 downto 0),seOut);
    alu1: ALU port map(PC_out,x"0001",Cflagout,x"0000","00",open,open,open,clk,alu1out);
    alu2: ALU port map(aluAin,aluBin,Cflagout,Instruction,alu2Con,Cflagin,Zflagin,open,clk,alu2out);
    alu3: ALU port map(RREX_out(84 downto 69),seOut,Cflagout,x"0000","00",open,open,open,clk,alu3out);
	 
	IF_ID:process(clk,Instruction,PC_out)
	begin
    -- 1st Pipeline Register
    --IFID will only take in instrucion and PC
    IFID_in(15 downto 0) <= Instruction;
    IFID_in(84 downto 69) <= PC_out;
	end process;
	 
    ID_RR: process(clk,IFID_out)
    begin
    
    -- 2nd Pipeline Register
    IDRR_in(15 downto 0)<=IFID_out(15 downto 0);--just copying instruction
    IDRR_in(84 downto 69)<=IFID_out(84 downto 69);--just copying PC
    --control signals which are supposed to be decided during the ID stage also need to added here. 
    --and also forwarded to other registers.
    end process;

    RR_EX: process(clk,IDRR_out,RF_D1,RF_D2)
    begin
    RF_A1 <= IDRR_out(11 downto 9);--incase of ADA encoding was 0001/RA*/RB/RC/0/00
    RF_A2 <= IDRR_out(8 downto 6);--incase of ADA encoding was 0001/RA/RB*/RC/0/00

    -- 3rd Pipeline Register
    RREX_in (15 downto 0)  <= IDRR_out(15 downto 0);--just copying instruction
    RREX_in (84 downto 69)<= IDRR_out(84 downto 69);--just copying PC
    RREX_in (31 downto 16) <= RF_D1;-- fetching data RA
    RREX_in (47 downto 32) <= RF_D2;-- fetching data RB
    end process;

    EX_MEM: process(clk,RREX_out,alu1out)
    begin
    -- 4th Pipeline Register
    EXMEM_in (15 downto 0)  <= RREX_out(15 downto 0);--just copying instruction
    EXMEM_in (84 downto 69) <= RREX_out(84 downto 69);--just copying PC
    EXMEM_in (31 downto 16) <= RREX_out (31 downto 16);--forwarding the data RA
    EXMEM_in (47 downto 32) <= RREX_out (47 downto 32);--forwarding the data RB
    EXMEM_in (100 downto 85) <= alu2out; 
    EXMEM_in(52)<=RF_WE_out; --RF_WE
    EXMEM_in(49)<=DMem_WE_out; --DMEM_WE

    --WE signals might also need to be changed here.
    --also add the wires from EXMEM to DMem
    -- and from DMem to MEMWB
    end process;

    MEM_WB: process(clk,EXMEM_out)
    begin
    -- 5th/last Pipeline Register
    MEMWB_in (15 downto 0)  <=EXMEM_out(15 downto 0);--just copying instruction
    MEMWB_in (84 downto 69) <=EXMEM_out(84 downto 69);--just copying PC
    MEMWB_in (31 downto 16) <=EXMEM_out (31 downto 16);--forwarding the data RA
    MEMWB_in (47 downto 32) <=EXMEM_out (47 downto 32);--forwarding the data RB
    MEMWB_in (100 downto 85) <=EXMEM_out (100 downto 85);
    DMem_WE<=EXMEM_out(49);
    end process;

    last: process(clk,MEMWB_out)
    begin
    RF_D3 <= MEMWB_out (100 downto 85);
    RF_WE <= MEMWB_out(52);
    --####################
    --we need to put a mux here to choose between the aluout and memout to be loaded into rf
    RF_A3 <= MEMWB_out(5 downto 3);
    --###################
    end process;
end arch_Datapath;