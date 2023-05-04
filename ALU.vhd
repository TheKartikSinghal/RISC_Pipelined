library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--/////////////////////////////////////////
--KEEP THIS COMMENT UNTIL ISSUE RESOLVED.
--we also need to give the alu the current outputs of the z flags.
--current alu is incorrect as it has no way of checking the flags
-- which is need for 6 out of 8 add instructions and 4 of 6 nand 
--instructions
-- And when you make a change to the component ports you need to make that change 
--in port mapping to all the instances and not just one.
--/////////////////////////////////////////

entity ALU is 
    port (
        A: in std_logic_vector(15 downto 0);
        B: in std_logic_vector(15 downto 0);
        --we need to add input for current values of flag registers
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
end ALU;

architecture ALU_arch of ALU is
--we will define functions for different operations which the ALU needs to do.
signal C,Z,E: std_logic :='0' ;
signal OpCode: std_logic_vector(3 downto 0) := instruction(15 downto 12);
signal complement: std_logic := instruction(2); 
-- opcode and complement are best initialized here
----
function add(A: in std_logic_vector(15 downto 0);
        B: in std_logic_vector(15 downto 0);
        instruction: in std_logic_vector(15 downto 0);
		OpCode: std_logic_vector(3 downto 0);
		complement: std_logic;
        -- need to add arguments here for using them within the function.
        carry_in: in std_logic
        --added the carry_in signal for function use
		--i have taken these to be the same name (refering to the variable names)
		-- but they might as well have been different.
		)
return std_logic_vector is
    variable sum   : std_logic_vector(15 downto 0);
    variable carry : std_logic_vector(15 downto 0);
begin
    
    if(OpCode = "0001" and complement = '1' and not(instruction(0) = '1') and (instruction(1) = '1')) then 
    -- removed the opcode 0010 condition as that was for nand 
    --which is not needed here.
    -- always remember to put '' on single bit values.
	--for instructions //ACA, ACC, ACZ// we need to ADD with the complement of reg B
    -- we don't do here for ACW and the condition on CZ!=11.
    L1: for i in 0 to 15 loop
        if i = 0 then
        sum(i)  := A(i) xor (not B(i)) xor '0';
        carry(i):= A(i) and (not B(i));

        else 
        sum(i)  := A(i) xor (not B(i)) xor carry(i-1);
        carry(i):= (A(i) and (not B(i))) or  (carry(i-1) and (A(i) xor (not B(i))));

        end if;
    end loop L1;
	
	 elsif(OpCode = "0001" and complement = '1' and (instruction(0) = '1') and (instruction(1) = '1')) then
	 --for instruction //ACW//, we need to add the carry bit also, ACW executes only when carry flag is 1
	 --it is not included in the above if statement, because we may not want to add the carry bit everytime it is set
	 L2: for i in 0 to 15 loop
        if i = 0 then
        sum(i)  := A(i) xor not(B(i)) xor carry_in;
        carry(i):= A(i) and not(B(i));

        else 
        sum(i)  := A(i) xor not(B(i)) xor carry(i-1);
        carry(i):= (A(i) and not(B(i))) or  (carry(i-1) and (A(i) xor not(B(i))));

        end if;
    end loop L2;

    elsif(OpCode = "0001" and (instruction(0) = '1') and (instruction(1) = '1')) then
	--for instruction //AWC//, we need to add the carry bit also, AWC executes only when carry flag is 1
	--it is not included in the above if statement, because we may not want to add the carry bit everytime it is set
	L3: for i in 0 to 15 loop
        if i = 0 then
        sum(i)  := A(i) xor B(i) xor carry_in;
        carry(i):= A(i) and B(i);

        else 
        sum(i)  := A(i) xor B(i) xor carry(i-1);
        carry(i):= (A(i) and B(i)) or  (carry(i-1) and (A(i) xor B(i)));

        end if;
    end loop L3;

	elsif(OpCode="0011") then -- for LLI, we will directly give the SE value at input B to the alu output
	sum := B;
    carry :=x"0000";
    
    else 
    --for instructions //ADA,ADC,ADZ// which require simple addition of contents of reg A and B 
    --this is the setting under which alu1 and alu3 will permanently operate.
	L4: for i in 0 to 15 loop
        if i = 0 then
        sum(i)  := A(i) xor B(i) xor '0';
        carry(i):= A(i) and B(i);

        else 
        sum(i)  := A(i) xor B(i) xor carry(i-1);
        carry(i):= (A(i) and B(i)) or  (carry(i-1) and (A(i) xor B(i)));

        end if;
    end loop L4;
	end if;
    return carry(15) & sum;
end add;

----
function to_nand (A: in std_logic_vector(15 downto 0);
        B: in std_logic_vector(15 downto 0);
        OpCode: std_logic_vector(3 downto 0);
        complement: std_logic
        )
return std_logic_vector is
    variable op_nand : std_logic_vector(15 downto 0);
begin 
    if(OpCode = "0010" and complement = '1') then --for instructions NCU, NCC, NCZ, we need to NAND with the complement of reg B
    L4: for i in 0 to 15 loop
        op_nand(i) := A(i) nand (not B(i));
    end loop L4;
    else
    L5: for i in 0 to 15 loop
        op_nand(i) := A(i) nand B(i);
    end loop L5;
    end if;
    return op_nand;
end to_nand;
----
function subtract(A: in std_logic_vector(15 downto 0);
        B: in std_logic_vector(15 downto 0))
return std_logic_vector is
    variable difference : std_logic_vector(15 downto 0);
    variable carry : std_logic_vector(15 downto 0);
begin 
    L6: for i in 0 to 15 loop
        if i = 0 then 
        --difference(i) := A(i) xor (not (B(i))) xor '1';
        difference(i) := A(i) xor B(i);
        --carry(i) := A(i) and not(B(i));
        carry(i) := not(A(i)) and B(i);

        else
        --difference(i)  := A(i) xor B(i) xor carry(i-1);
        difference(i)  := (A(i) xor B(i)) xor carry(i-1);
        --carry(i):= (A(i) and B(i)) or  (carry(i-1) and (A(i) xor B(i)));
        carry(i):= (not(A(i)) and B(i)) or (not(A(i) xor B(i)) and carry(i-1));

        end if;
    end loop L6;
    return carry(15) & difference;
end subtract;

----
begin
alu_process : process(A,B,clk,instruction,control_sel,C,Z,E)
variable temp_1,temp_2 : std_logic_vector(16 downto 0);

    begin
        temp_1 := add(A,B,instruction,OpCode,complement,carry_in);
		-- the changes while calling the function need to be made here (adding instruction, opcode and complement argument in this case.)
        temp_2 := subtract(A,B);
    case control_sel is 
    when "00" => 
            ALU_out <= temp_1(15 downto 0); -- for addition
            C <= temp_1(16);
            if (temp_1(15 downto 0)=x"0000") then
                Z <= '1';
            else Z <= '0';
            end if;
    when "01" =>
            ALU_out <= to_nand(A,B,OpCode,complement); -- for nand
				C<='1';
            if (to_nand(A,B,OpCode,complement)=x"0000") then
            --added "Opcode and complement" into the function call
                Z <= '1';
            else Z <= '0';
            end if;
    when "10" => 
            ALU_out <= temp_2(15 downto 0); -- for subtraction
            C <= temp_2(16);
            if (temp_2(15 downto 0)=x"0000") then
                Z <= '1';
            else Z <= '0';
            end if;
    when "11" => 
            ALU_out <= x"0000";
				C<= '1';
				Z<='1';
            if (A=B) then -- for equality check
                E<='1'; --return 0 if equal
            else E<='0'; -- else return 1
            end if;
    when others =>
            ALU_out <= temp_1(15 downto 0);
            C <= temp_1(16);
				Z<='1';
    end case;
	  C_flag <= C ;
     Z_flag <= Z ;
     E_flag <= E ;
    end process;
end ALU_arch;


