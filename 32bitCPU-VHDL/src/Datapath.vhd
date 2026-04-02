library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- File: Datapath.vhd
-- Entity: MIPS_Datapath
-- Description: 32-bit single-cycle MIPS datapath (control inside).
-- Note: arithmetic uses NUMERIC_STD for GHDL without -fsynopsys.
-- Inputs: clk, rst
-- Outputs: tb_* observation ports for simulation

entity MIPS_Datapath is
    port (
        clk               : in  std_logic;
        rst               : in  std_logic;
        tb_pc             : out std_logic_vector(31 downto 0);
        tb_instruction    : out std_logic_vector(31 downto 0);
        tb_alu_result     : out std_logic_vector(31 downto 0);
        tb_reg_write_data : out std_logic_vector(31 downto 0);
        tb_reg_write_dest : out std_logic_vector(4 downto 0);
        tb_reg_write_en   : out std_logic
    );
end MIPS_Datapath;

architecture Structural of MIPS_Datapath is
    component Instruction_Memory_VHDL
        port (
            pc          : in  std_logic_vector(31 downto 0);
            instruction : out std_logic_vector(31 downto 0)
        );
    end component;

    component Control_Unit_VHDL
        port (
            opcode       : in  std_logic_vector(5 downto 0);
            reset        : in  std_logic;
            reg_dst      : out std_logic_vector(1 downto 0);
            mem_to_reg   : out std_logic_vector(1 downto 0);
            alu_op       : out std_logic_vector(1 downto 0);
            jump         : out std_logic;
            branch       : out std_logic;
            mem_read     : out std_logic;
            mem_write    : out std_logic;
            alu_src      : out std_logic;
            reg_write    : out std_logic;
            sign_or_zero : out std_logic
        );
    end component;

    component Register_File_VHDL
        port (
            clk             : in  std_logic;
            rst             : in  std_logic;
            reg_write_en    : in  std_logic;
            reg_write_dest  : in  std_logic_vector(4 downto 0);
            reg_write_data  : in  std_logic_vector(31 downto 0);
            reg_read_addr_1 : in  std_logic_vector(4 downto 0);
            reg_read_addr_2 : in  std_logic_vector(4 downto 0);
            reg_read_data_1 : out std_logic_vector(31 downto 0);
            reg_read_data_2 : out std_logic_vector(31 downto 0)
        );
    end component;

    component Sign_Extender_VHDL
        port (
            sign_or_zero : in  std_logic;
            data_in      : in  std_logic_vector(15 downto 0);
            data_out     : out std_logic_vector(31 downto 0)
        );
    end component;

    component ALU_Control_VHDL
        port (
            ALUOp       : in  std_logic_vector(1 downto 0);
            ALU_Funct   : in  std_logic_vector(5 downto 0);
            ALU_Control : out std_logic_vector(2 downto 0)
        );
    end component;

    component ALU_VHDL
        port (
            a           : in  std_logic_vector(31 downto 0);
            b           : in  std_logic_vector(31 downto 0);
            alu_control : in  std_logic_vector(2 downto 0);
            alu_result  : out std_logic_vector(31 downto 0);
            zero        : out std_logic
        );
    end component;

    component Data_Memory_VHDL
        port (
            clk             : in  std_logic;
            mem_access_addr : in  std_logic_vector(31 downto 0);
            mem_write_data  : in  std_logic_vector(31 downto 0);
            mem_write_en    : in  std_logic;
            mem_read        : in  std_logic;
            mem_read_data   : out std_logic_vector(31 downto 0)
        );
    end component;

    -- Instruction fields
    signal instruction       : std_logic_vector(31 downto 0);
    signal opcode_s          : std_logic_vector(5 downto 0);
    signal rs_s, rt_s, rd_s  : std_logic_vector(4 downto 0);
    signal shamt_s           : std_logic_vector(4 downto 0);
    signal funct_s           : std_logic_vector(5 downto 0);
    signal imm16_s           : std_logic_vector(15 downto 0);
    signal j_target_s        : std_logic_vector(25 downto 0);

    -- Control
    signal ctrl_reg_dst      : std_logic_vector(1 downto 0);
    signal ctrl_mem_to_reg   : std_logic_vector(1 downto 0);
    signal ctrl_alu_op       : std_logic_vector(1 downto 0);
    signal ctrl_jump         : std_logic;
    signal ctrl_branch       : std_logic;
    signal ctrl_mem_read     : std_logic;
    signal ctrl_mem_write    : std_logic;
    signal ctrl_alu_src      : std_logic;
    signal ctrl_reg_write    : std_logic;
    signal ctrl_sign_or_zero : std_logic;

    -- Datapath
    signal PC              : std_logic_vector(31 downto 0) := (others => '0');
    signal PC_next         : std_logic_vector(31 downto 0);
    signal PC_plus4        : std_logic_vector(31 downto 0);
    signal branch_target   : std_logic_vector(31 downto 0);
    signal jump_target     : std_logic_vector(31 downto 0);
    signal write_reg       : std_logic_vector(4 downto 0);
    signal write_data      : std_logic_vector(31 downto 0);
    signal reg_data_1      : std_logic_vector(31 downto 0);
    signal reg_data_2      : std_logic_vector(31 downto 0);
    signal sign_ext_imm    : std_logic_vector(31 downto 0);
    signal alu_in_b        : std_logic_vector(31 downto 0);
    signal alu_control_signal : std_logic_vector(2 downto 0);
    signal alu_result_s    : std_logic_vector(31 downto 0);
    signal alu_zero        : std_logic;
    signal mem_read_data_s : std_logic_vector(31 downto 0);

begin
    -- Instruction decode (concurrent)
    opcode_s   <= instruction(31 downto 26);
    rs_s       <= instruction(25 downto 21);
    rt_s       <= instruction(20 downto 16);
    rd_s       <= instruction(15 downto 11);
    shamt_s    <= instruction(10 downto 6);
    funct_s    <= instruction(5 downto 0);
    imm16_s    <= instruction(15 downto 0);
    j_target_s <= instruction(25 downto 0);

    PC_plus4 <= std_logic_vector(unsigned(PC) + 4);

    branch_target <= std_logic_vector(
        unsigned(PC_plus4) + unsigned(sign_ext_imm(29 downto 0) & "00")
    );

    jump_target <= PC_plus4(31 downto 28) & j_target_s & "00";

    -- RegDst mux
    write_reg <= rt_s when ctrl_reg_dst = "00" else
                 rd_s when ctrl_reg_dst = "01" else
                 "11111";

    -- ALUSrc mux
    alu_in_b <= reg_data_2 when ctrl_alu_src = '0' else sign_ext_imm;

    -- MemToReg mux
    write_data <= alu_result_s when ctrl_mem_to_reg = "00" else
                  mem_read_data_s when ctrl_mem_to_reg = "01" else
                  PC_plus4;

    -- PC next (combinational); jr highest priority
    pc_next_proc : process (
        opcode_s, funct_s, reg_data_1,
        ctrl_jump, ctrl_branch, alu_zero,
        jump_target, branch_target, PC_plus4
    )
    begin
        if opcode_s = "000000" and funct_s = "001000" then
            PC_next <= reg_data_1;
        elsif ctrl_jump = '1' then
            PC_next <= jump_target;
        elsif ctrl_branch = '1' and alu_zero = '1' then
            PC_next <= branch_target;
        else
            PC_next <= PC_plus4;
        end if;
    end process pc_next_proc;

    -- PC register
    pc_reg : process (clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                PC <= X"00000000";
            else
                PC <= PC_next;
            end if;
        end if;
    end process pc_reg;

    -- Observation ports
    tb_pc             <= PC;
    tb_instruction    <= instruction;
    tb_alu_result     <= alu_result_s;
    tb_reg_write_data <= write_data;
    tb_reg_write_dest <= write_reg;
    tb_reg_write_en   <= ctrl_reg_write;

    imem : Instruction_Memory_VHDL
        port map (
            pc          => PC,
            instruction => instruction
        );

    ctrl : Control_Unit_VHDL
        port map (
            opcode       => opcode_s,
            reset        => rst,
            reg_dst      => ctrl_reg_dst,
            mem_to_reg   => ctrl_mem_to_reg,
            alu_op       => ctrl_alu_op,
            jump         => ctrl_jump,
            branch       => ctrl_branch,
            mem_read     => ctrl_mem_read,
            mem_write    => ctrl_mem_write,
            alu_src      => ctrl_alu_src,
            reg_write    => ctrl_reg_write,
            sign_or_zero => ctrl_sign_or_zero
        );

    regfile : Register_File_VHDL
        port map (
            clk             => clk,
            rst             => rst,
            reg_write_en    => ctrl_reg_write,
            reg_write_dest  => write_reg,
            reg_write_data  => write_data,
            reg_read_addr_1 => rs_s,
            reg_read_addr_2 => rt_s,
            reg_read_data_1 => reg_data_1,
            reg_read_data_2 => reg_data_2
        );

    ext : Sign_Extender_VHDL
        port map (
            sign_or_zero => ctrl_sign_or_zero,
            data_in      => imm16_s,
            data_out     => sign_ext_imm
        );

    alu_dec : ALU_Control_VHDL
        port map (
            ALUOp       => ctrl_alu_op,
            ALU_Funct   => funct_s,
            ALU_Control => alu_control_signal
        );

    alu_core : ALU_VHDL
        port map (
            a           => reg_data_1,
            b           => alu_in_b,
            alu_control => alu_control_signal,
            alu_result  => alu_result_s,
            zero        => alu_zero
        );

    dmem : Data_Memory_VHDL
        port map (
            clk             => clk,
            mem_access_addr => alu_result_s,
            mem_write_data  => reg_data_2,
            mem_write_en    => ctrl_mem_write,
            mem_read        => ctrl_mem_read,
            mem_read_data   => mem_read_data_s
        );

end Structural;
