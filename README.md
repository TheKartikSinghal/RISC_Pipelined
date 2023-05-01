6 stage pipelines (Instruction fetch, instruction decode, register  read,  execute,  memory  access, and  write  back)

Pipeline register division
00-15  Instruction
16-31  Data1
32-47  Data2
48-49  ALU control bits (currently vestigial)
50     C_WE
51     Z_WE
52     RF_WE
53-68  Imm(after sign extension)
69-84  PC
85-100 ALU_output
101    throw bit (controls: RF_WE, C_WE, Z_WE, MEM_WE, PC_WE)
102    PC_WE

--throw_sig in datapath carries the value of the throw bit for the pipeline registers prior to EXMEM.
    --at the end of this cycle the branch instruction will enter mem stage and the last useless
    --instruction would have entered the IF stage.
    --so the throw bit needs to be set for IFID,IDRR,RREX.
    --ALSO CARE NEEDS TO BE TAKEN FOR THROWN INSTRUCTIONS WHICH CAN CAUSE DAMAGE EVEN WITHOUT WRITING 
    --INTO RF OR MEM (LIKE BRANCH INSTRUCTIONS)
    --possible solution => make all bits 0 so it becomes a add instruction and then make WEs 0 so that 
    -- there is no danger.