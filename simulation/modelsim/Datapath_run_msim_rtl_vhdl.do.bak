transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

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
