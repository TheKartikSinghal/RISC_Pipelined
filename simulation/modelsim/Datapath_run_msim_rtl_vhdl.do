transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vcom -93 -work work {/home/kartik/RISC_Pipelined/loader.vhd}
vcom -93 -work work {/home/kartik/RISC_Pipelined/RF_C_Z.vhd}
vcom -93 -work work {/home/kartik/RISC_Pipelined/Stall_and_throw.vhd}
vcom -93 -work work {/home/kartik/RISC_Pipelined/load_hazards.vhd}
vcom -93 -work work {/home/kartik/RISC_Pipelined/Execution.vhd}
vcom -93 -work work {/home/kartik/RISC_Pipelined/FU_A.vhd}
vcom -93 -work work {/home/kartik/RISC_Pipelined/FU_B.vhd}
vcom -93 -work work {/home/kartik/RISC_Pipelined/PC_MUX_Control_unit.vhd}
vcom -93 -work work {/home/kartik/RISC_Pipelined/signExtender.vhd}
vcom -93 -work work {/home/kartik/RISC_Pipelined/RegisterFile.vhd}
vcom -93 -work work {/home/kartik/RISC_Pipelined/register_1bit.vhd}
vcom -93 -work work {/home/kartik/RISC_Pipelined/PipelineRegister.vhd}
vcom -93 -work work {/home/kartik/RISC_Pipelined/Mux_4to1_16bit.vhd}
vcom -93 -work work {/home/kartik/RISC_Pipelined/InstructionMemory.vhd}
vcom -93 -work work {/home/kartik/RISC_Pipelined/Datapath.vhd}
vcom -93 -work work {/home/kartik/RISC_Pipelined/DataMemory.vhd}
vcom -93 -work work {/home/kartik/RISC_Pipelined/ALU.vhd}

vcom -93 -work work {/home/kartik/RISC_Pipelined/testbench.vhd}

vsim -t 1ps -L altera -L lpm -L sgate -L altera_mf -L altera_lnsim -L fiftyfivenm -L rtl_work -L work -voptargs="+acc"  testbench_tb

add wave *
view structure
view signals
run -all
