library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ALU is 
    port (
        A: in std_logic_vector(15 downto 0);
        B: in std_logic_vector(15 downto 0);
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
		  OpCode: std_logic_vector(3 downto 0);
		  complement: std_logic
		  --i have taken these to be the same name (refering to the variable names)
		  -- but they might as well have been different.
		  )
return std_logic_vector is
    variable sum   : std_logic_vector(15 downto 0);
    variable carry : std_logic_vector(15 downto 0);
begin
    
    if((OpCode = "0001" or OpCode = "0010") and complement = '1') then
	 -- always remember to put '' on single bit values.
    L1: for i in 0 to 15 loop
        if i = 0 then
        sum(i)  := A(i) xor (not B(i)) xor '0';
        carry(i):= A(i) and (not B(i));

        else 
        sum(i)  := A(i) xor (not B(i)) xor carry(i-1);
        carry(i):= (A(i) and (not B(i))) or  (carry(i-1) and (A(i) xor (not B(i))));

        end if;
    end loop L1;
	 
	 else 
	 L2: for i in 0 to 15 loop
        if i = 0 then
        sum(i)  := A(i) xor B(i) xor '0';
        carry(i):= A(i) and B(i);

        else 
        sum(i)  := A(i) xor B(i) xor carry(i-1);
        carry(i):= (A(i) and B(i)) or  (carry(i-1) and (A(i) xor B(i)));

        end if;
    end loop L2;
	 end if;
    return carry(15) & sum;
end add;

----
function to_nand (A: in std_logic_vector(15 downto 0);
        B: in std_logic_vector(15 downto 0))
return std_logic_vector is
    variable op_nand : std_logic_vector(15 downto 0);
begin 
    L2: for i in 0 to 15 loop
        op_nand(i) := A(i) nand B(i);
    end loop L2;
    return op_nand;
end to_nand;

----
function subtract(A: in std_logic_vector(15 downto 0);
        B: in std_logic_vector(15 downto 0))
return std_logic_vector is
    variable difference : std_logic_vector(15 downto 0);
    variable carry : std_logic_vector(15 downto 0);
begin 
    L3: for i in 0 to 15 loop
        if i = 0 then 
        difference(i) := A(i) xor not(B(i)) xor '1';
        carry(i) := A(i) and not(B(i));

        else
        difference(i)  := A(i) xor B(i) xor carry(i-1);
        carry(i):= (A(i) and B(i)) or  (carry(i-1) and (A(i) xor B(i)));

        end if;
    end loop L3;
    return carry(15) & difference;
end subtract;

----
begin
alu_process : process(A,B,clk)
variable temp_1,temp_2 : std_logic_vector(16 downto 0);

    begin
        temp_1 := add(A,B,OpCode,complement);
		  -- the changes while calling the function need to be made here (adding opcode and complement argument in this case.)
        temp_2 := subtract(A,B);
    case control_sel is 
    when "00" => 
            ALU_out <= temp_1(15 downto 0); -- for addition
            C <= temp_1(16);
            if (temp_1(15 downto 0)="0000000000000000") then
                Z <= '1';
            else Z <= '0';
            end if;
    when "01" =>
            ALU_out <= to_nand(A,B); -- for nand
            if (to_nand(A,B)="0000000000000000") then
                Z <= '1';
            else Z <= '0';
            end if;
    when "10" => 
            ALU_out <= temp_2(15 downto 0); -- for subtraction
            C <= temp_2(16);
            if (temp_2(15 downto 0)="0000000000000000") then
                Z <= '1';
            else Z <= '0';
            end if;
    when "11" => 
            
            if (A=B) then -- for equality check
                E<='1'; --return 0 if equal
            else E<='0'; -- else return 1
            end if;
    when others =>
            ALU_out <= temp_1(15 downto 0);
            C <= temp_1(16);
    end case;
	  C_flag <= C ;
     Z_flag <= Z ;
     E_flag <= E ;
    end process;
end ALU_arch;


