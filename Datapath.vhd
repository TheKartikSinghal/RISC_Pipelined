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
            PC_in: in std_logic_vector(15 downto 0);
            PC_out: out std_logic_vector(15 downto 0)
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
        port(nine_bit_in : in std_logic_vector(8 downto 0);
        OpCode: in std_logic_vector(3 downto 0);
        sixteen_bit_out : out std_logic_vector(15 downto 0));
    end component;

    signal Instruction, RF_D1, RF_D2, RF_D3, PC_out:std_logic_vector(15 downto 0);
    signal RF_A1,RF_A3,RF_A3 : std_logic_vector(2 downto 0);
    signal IFID_in,IFID_out,IDRR_in,IDRR_out,RREX_in,RREX_out,EXMEM_in,EXMEM_out,MEMWB_in,MEMWB_out: std_logic_vector(99 downto 0);
begin
    IFID: PipelineRegister port map(IFID_in,IFID_out,clk);
    IFID_in(15 downto 0) <= Instruction;
    IFID_in(68 downto 53) <= ;

    IDRR: PipelineRegister port map();
    IDRR: 

    RREX: PipelineRegister port map();
    RREX_in (31 downto 16) <= RF_D1;
    RREX_in (47 downto 32) <= RF_D1;
    
    EXMEM: PipelineRegister port map();
    MEMWB: PipelineRegister port map();
    
    IMem: InstructionMemory port map(PC_out,Instruction,clk);
end arch_Datapath;
