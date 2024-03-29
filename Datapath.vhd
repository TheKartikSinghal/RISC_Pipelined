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
            output1 : out std_logic_vector(7 downto 0);
            output2 : out std_logic_vector(7 downto 0);
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
        output : out std_logic_vector(15 downto 0)
        );
    end component;

     component PC_MUX_Control_unit is 
      port (
        instruction: in std_logic_vector(15 downto 0);
        C: in std_logic;
		Z: in std_logic; 
		LS_DETECT: in std_logic_vector(0 downto 0);
        con_sel: out std_logic_vector(1 downto 0);
        clk: in std_logic;
		throw_bit,LS_NOP: out std_logic
        --only purpose of the clock is for changing the control select lines using C/Z signals.
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
	INN_B_out : out std_logic_vector(15 downto 0);
	MUX_ALU2B_SEL_out : out std_logic_vector(1 downto 0)
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
      LM_SM_DETECTOR : in std_logic_vector(0 downto 0);
      CHECKBIT,THROWBIT,LSNOP : in std_logic;
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
	    INSTR : in std_logic_vector(122 downto 0);
	    C_OUT : in std_logic;
	    Z_OUT : in std_logic;
	    RF_WR_out : out std_logic;
	    C_WR_out : out std_logic;
	    Z_WR_out : out std_logic;
	    DMEM_WR_out : out std_logic;
	    clk : in std_logic
	    );
    end component;

    component loader is 
    port(
        PR_MEMWB: in std_logic_vector(122 downto 0);
        data: out std_logic_vector(15 downto 0);
        address: out std_logic_vector(2 downto 0)
        );
    end component;
	 
	 component RR is
   port( PR1 : in std_logic_vector(122 downto 0); --IDRR/MEMWB REG
      rstlsm_out : out std_logic_vector(7 downto 0);
		--clk : in std_logic;
	   rf_addr : out std_logic_vector(2 downto 0);
		unincremented_mem_addr : out std_logic_vector(15 downto 0);
		lm_sm_on : out std_logic_vector(0 downto 0)
      );

    end component;
	 
	 component RRINDECIDER is
    port (LSDETECT:in std_logic_vector(0 downto 0);
         IDRRREG:IN std_logic_vector(122 downto 0);
        MEMWBREG : in std_logic_vector(122 downto 0);
        INPUTRR : OUT STD_LOGIC_VECTOR(122 DOWNTO 0));
 
     end component ;
	  
	 COMPONENT Mux_2to1_3bit is
    port(
        con_sel: in std_logic_vector(0 downto 0);
        A,B: in std_logic_vector(2 downto 0);
        --clk: in std_logic;
        output: out std_logic_vector(2 downto 0)
    );
    end COMPONENT;
	 
	 COMPONENT Mux_2to1_8bit is
    port(
        con_sel: in std_logic_vector(0 downto 0);
        A,B: in std_logic_vector(7 downto 0);
        --clk: in std_logic;
        output: out std_logic_vector(7 downto 0)
    );
    end COMPONENT;
	 
	 COMPONENT Mux_2to1_16bit is
    port(
        con_sel: in std_logic_vector(0 downto 0);
        A,B: in std_logic_vector(15 downto 0);
        --clk: in std_logic;
        output: out std_logic_vector(15 downto 0)
    );
    end COMPONENT;
	 
	 component MEMACCESS is 
    port(
        PR_EXMEM: in std_logic_vector(122 downto 0);
        datain: out std_logic_vector(15 downto 0);
        --dataout: out std_logic_vector(15 downto 0);
		  dataadd : out std_logic_vector(15 downto 0)
    );
   end component;


    signal RF_D1, RF_D2, RF_D3, PC_out, alu1out, alu3out, alu2out, DataAdd, DataIn, DataOut, aluAin, aluBin, seOut, PC_in ,fwdtomuxA,fwdtomuxB:std_logic_vector(15 downto 0);
    signal RF_A1,RF_A2,RF_A3 : std_logic_vector(2 downto 0);
    signal IFID_in,IFID_out,IDRR_in,IDRR_out,RREX_in,RREX_out,EXMEM_in,EXMEM_out,MEMWB_in,MEMWB_out: std_logic_vector(122 downto 0);
    signal Cflagin,Cflagout,C_WE,Zflagin,Zflagout,Z_WE,DMem_WE,DMem_WE_out,RF_WE,RF_WE_out,lsnop_sig,throw_sig,check_sig,PC_WE: std_logic;
    signal muxpcCon,muxAluA_con,muxAluB_con,alu2con,exextofwderA,exextofwderB:std_logic_vector(1 downto 0);
    signal IFID_rst,IFID_WE,IDRR_rst,IDRR_WE,RREX_rst,RREX_WE,EXMEM_rst,EXMEM_WE,MEMWB_rst,MEMWB_WE: std_logic;
    signal Instruction1,Instruction2 : std_logic_vector(7 downto 0);
	 signal input_to_RR : std_logic_vector(122 downto 0);
	 signal output_from_RR, RREX_8 : std_logic_vector(7 downto 0);
	 signal pe_addr:std_logic_vector(2 downto 0);
	 signal LM_SM_DETECT : std_logic_vector(0 downto 0) := "0";
	 signal uninc_mem_addr, EXMEM_DATA1, RREXOUT_DATA2:std_logic_vector(15 downto 0);
begin
    IFID: PipelineRegister port map(IFID_in,IFID_out,clk,IFID_rst,IFID_WE);
    IDRR: PipelineRegister port map(IDRR_in,IDRR_out,clk,IDRR_rst,IDRR_WE);
    RREX: PipelineRegister port map(RREX_in,RREX_out,clk,RREX_rst,RREX_WE);
    EXMEM: PipelineRegister port map(EXMEM_in,EXMEM_out,clk,EXMEM_rst,EXMEM_WE);
    MEMWB: PipelineRegister port map(MEMWB_in,MEMWB_out,clk,MEMWB_rst,MEMWB_WE);
	
	IMem: InstructionMemory port map(PC_out,Instruction1,Instruction2,clk);
    DMem: DataMemory port map(DataAdd,DataIn,DataOut,clk,DMem_WE);
    RF: RegisterFile port map(RF_A1,RF_A2,RF_A3, RF_D1, RF_D2, RF_D3,clk,RF_WE,PC_in,PC_out,PC_WE);
    muxAluA: Mux_4to1_16bit port map(muxAluA_con,RREX_out(31 downto 16),RREX_out(47 downto 32),RREX_out(84 downto 69),fwdtomuxA,clk,aluAin);
    muxpc: Mux_4to1_16bit port map(muxpcCon,alu1out,alu2out,alu3out,RREX_out(47 downto 32),clk,PC_in);
    muxAluB: Mux_4to1_16bit port map(muxAluB_con,seOut,RREX_out(47 downto 32),x"0002",fwdtomuxB,clk,aluBin);
    cflag: register_1bit port map(Cflagin,Cflagout,clk,C_WE);
    zflag: register_1bit port map(Zflagin,Zflagout,clk,Z_WE);
    
    pcController: PC_MUX_Control_unit port map(RREX_out(15 downto 0),Cflagin,Zflagin,LM_SM_DETECT,muxpcCon,clk,throw_sig,lsnop_sig);
    lm_sm : RR port map(input_to_RR, output_from_RR, pe_addr,uninc_mem_addr,LM_SM_DETECT );
	 RRINPUT : RRINDECIDER PORT MAP(LM_SM_DETECT, IDRR_out, MEMWB_out, input_to_RR);
    --throw_sig carries the value of the throw bit for the pipeline registers prior to EXMEM.
    --at the end of this cycle the branch instruction will enter mem stage and the last useless
    --instruction would have entered the IF stage.
    --so the throw bit needs to be set for IFID,IDRR,RREX.
    --ALSO CARE NEEDS TO BE TAKEN FOR THROWN INSTRUCTIONS WHICH CAN CAUSE DAMAGE EVEN WITHOUT WRITING 
    --INTO RF OR MEM (LIKE BRANCH INSTRUCTIONS)
    --possible solution => make all bits 0 so it becomes a add instruction and then make WEs 0 so that 
    -- there is no danger.
    RFA1_MUX : Mux_2to1_3bit PORT MAP(LM_SM_DETECT,IFID_out(11 downto 9),pe_addr,RF_A1);
    fwderA: FwdA port map (MEMWB_out,EXMEM_out,RREX_out,exextofwderA,fwdtomuxA,muxAluA_con);
    fwderB: FwdB port map (MEMWB_out,EXMEM_out,RREX_out,exextofwderB,fwdtomuxB,muxAluB_con);
    exec: Executor port map(RREX_out(15 downto 0),alu2con,exextofwderA,exextofwderB);

    ST: stall_and_throw port map(LM_SM_DETECT,check_sig,throw_sig,lsnop_sig,IFID_WE,IFID_rst,IDRR_WE,IDRR_rst,RREX_WE,RREX_rst,EXMEM_WE,EXMEM_rst,MEMWB_WE,MEMWB_rst,PC_WE);
    LH: load_hazards port map(IDRR_out,IFID_out,check_sig) ;
    rfcz1: RFCZ port map(RREX_out,Cflagout,Zflagout,RF_WE_out,C_WE,Z_WE,DMem_WE_out,clk);
    loader1: loader port map (MEMWB_out,RF_D3,RF_A3);
    memaccess1 : MEMACCESS port map(EXMEM_out, DataIn, DataAdd);
    se: SignExtender port map(RREX_out(15 downto 0),seOut);
    alu1: ALU port map(PC_out,x"0002",Cflagout,x"b000","00",open,open,open,clk,alu1out);
    alu2: ALU port map(aluAin,aluBin,Cflagout,RREX_out(15 downto 0),alu2Con,Cflagin,Zflagin,open,clk,alu2out);
    alu3: ALU port map(RREX_out(84 downto 69),seOut,Cflagout,x"b000","00",open,open,open,clk,alu3out);
	 EXMEMIN_DATA1_MUX : Mux_2to1_16bit PORT MAP(LM_SM_DETECT,RREX_out (31 downto 16),alu2out, EXMEM_DATA1);
	 RREXOUT_LAST8_MUX : Mux_2to1_8bit PORT MAP(LM_SM_DETECT,IDRR_out(7 downto 0), output_from_RR, RREX_8);
	 RREXOUT_DATA2_MUX : Mux_2to1_16bit PORT MAP(LM_SM_DETECT,IDRR_out (47 downto 32),uninc_mem_addr(15 downto 0),RREXOUT_DATA2);
	 
	IF_ID:process(clk,Instruction1,Instruction2,PC_out)
	begin
    -- 1st Pipeline Register
    --IFID will only take in instrucion and PC
    IFID_in(7 downto 0) <= Instruction2;
    IFID_in(15 downto 8) <= Instruction1;
    IFID_in(84 downto 69) <= PC_out;
	end process;
	 
    ID_RR: process(clk,IFID_out)
    begin
    
    -- 2nd Pipeline Register
    IDRR_in(15 downto 0)<=IFID_out(15 downto 0);--just copying instruction
    IDRR_in(84 downto 69)<=IFID_out(84 downto 69);--just copying PC
    --control signals which are supposed to be decided during the ID stage also need to added here. 
    --and also forwarded to other registers.
	 --RF_A1 <= IDRR_out(11 downto 9);--incase of ADA encoding was 0001/RA*/RB/RC/0/00
    RF_A2 <= IFID_out(8 downto 6);--incase of ADA encoding was 0001/RA/RB*/RC/0/00
	 IDRR_in (31 downto 16) <= RF_D1;-- fetching data RA
    IDRR_in (47 downto 32) <= RF_D2;-- fetching data RB
    end process;

    RR_EX: process(clk,IDRR_out,RF_D1,RF_D2)
    begin
    

    -- 3rd Pipeline Register
    RREX_in (15 downto 0)  <= IDRR_out(15 downto 0);--just copying instruction
    RREX_in (84 downto 69)<= IDRR_out(84 downto 69);--just copying PC
	 RREX_in(105 downto 103) <= pe_addr;
	 RREX_in (31 downto 16) <= IDRR_out (31 downto 16);--forwarding the data RA
	 RREX_in(7 downto 0) <= RREX_8;
	 RREX_in(47 downto 32) <= RREXOUT_DATA2;
	 RREX_in(68 downto 53) <= RF_D1; --sm
    
    end process;

    EX_MEM: process(clk,RREX_out,alu1out,RF_WE_out,DMem_WE_out)
    begin
    -- 4th Pipeline Register
    EXMEM_in (15 downto 0)  <= RREX_out(15 downto 0);--just copying instruction
    EXMEM_in (84 downto 69) <= RREX_out(84 downto 69);--just copying PC
    --EXMEM_in (31 downto 16) <= RREX_out (31 downto 16);--forwarding the data RA
    EXMEM_in (47 downto 32) <= RREX_out (47 downto 32);--forwarding the data RB
    EXMEM_in (100 downto 85) <= alu2out; 
    EXMEM_in(52)<=RF_WE_out; --RF_WE
    EXMEM_in(49)<=DMem_WE_out; --DMEM_WE
	 EXMEM_in (68 downto 53) <= RREX_out(68 downto 53);--sm data
	 EXMEM_in (105 downto 103) <= RREX_out(105 downto 103);--peaddr
	 EXMEM_in(31 downto 16) <= EXMEM_DATA1;

    --WE signals might also need to be changed here.
    --also add the wires from EXMEM to DMem
    -- and from DMem to MEMWB
    end process;

    MEM_WB: process(clk,EXMEM_out)
    begin
    -- 5th/last Pipeline Registersim:/testbench_tb/instance/RF/RF_data(3)

    MEMWB_in (15 downto 0)  <=EXMEM_out(15 downto 0);--just copying instruction
    MEMWB_in (84 downto 69) <=EXMEM_out(84 downto 69);--just copying PC
    MEMWB_in (31 downto 16) <=EXMEM_out (31 downto 16);--forwarding the data RA
    MEMWB_in (47 downto 32) <=EXMEM_out (47 downto 32);--forwarding the data RB
    MEMWB_in (100 downto 85) <=EXMEM_out (100 downto 85);--alu out in general
    MEMWB_in(52) <= EXMEM_out(52);
    DMem_WE<=EXMEM_out(49);
    --DataAdd <= EXMEM_out (100 downto 85);--alu out from address calculation
    --DataIn <= EXMEM_out (31 downto 16);--data from RA in RF into MEM.
    MEMWB_in(122 downto 107) <= DataOut;
    end process;

    last: process(clk,MEMWB_out)
    begin
    RF_WE <= MEMWB_out(52);
    --####################
    --we need to put a mux here to choose between the aluout and memout to be loaded into rf
    -- and also to figure where to get the address from.
    --DONE BY LOADER.VHD
    --###################
    end process;
end arch_Datapath;