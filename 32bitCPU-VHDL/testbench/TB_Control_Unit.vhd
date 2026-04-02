library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- File: TB_Control_Unit.vhd
-- Entity: TB_Control_Unit
-- Description: Self-checking testbench for Control_Unit_VHDL.
-- Author: <author>
-- Date: <date>

entity TB_Control_Unit is
end TB_Control_Unit;

architecture Behavioral of TB_Control_Unit is
    signal opcode       : std_logic_vector(5 downto 0) := (others => '0');
    signal reset        : std_logic := '0';
    signal reg_dst      : std_logic_vector(1 downto 0);
    signal mem_to_reg   : std_logic_vector(1 downto 0);
    signal alu_op       : std_logic_vector(1 downto 0);
    signal jump         : std_logic;
    signal branch       : std_logic;
    signal mem_read     : std_logic;
    signal mem_write    : std_logic;
    signal alu_src      : std_logic;
    signal reg_write    : std_logic;
    signal sign_or_zero : std_logic;
begin
    uut: entity work.Control_Unit_VHDL
        port map (
            opcode       => opcode,
            reset        => reset,
            reg_dst      => reg_dst,
            mem_to_reg   => mem_to_reg,
            alu_op       => alu_op,
            jump         => jump,
            branch       => branch,
            mem_read     => mem_read,
            mem_write    => mem_write,
            alu_src      => alu_src,
            reg_write    => reg_write,
            sign_or_zero => sign_or_zero
        );

    stim_proc: process
    begin
        -- Reset check.
        reset <= '1';
        opcode <= "000000";
        wait for 10 ns;
        assert reg_dst = "00" and mem_to_reg = "00" and alu_op = "00" and
               jump = '0' and branch = '0' and mem_read = '0' and mem_write = '0' and
               alu_src = '0' and reg_write = '0' and sign_or_zero = '0'
            report "Control reset output mismatch"
            severity error;

        reset <= '0';

        -- R-type (add).
        opcode <= "000000";
        wait for 10 ns;
        assert reg_dst = "01" and mem_to_reg = "00" and alu_op = "00" and
               jump = '0' and branch = '0' and mem_read = '0' and mem_write = '0' and
               alu_src = '0' and reg_write = '1' and sign_or_zero = '0'
            report "Control R-type output mismatch"
            severity error;

        -- slti.
        opcode <= "001010";
        wait for 10 ns;
        assert reg_dst = "00" and mem_to_reg = "00" and alu_op = "10" and
               jump = '0' and branch = '0' and mem_read = '0' and mem_write = '0' and
               alu_src = '1' and reg_write = '1' and sign_or_zero = '1'
            report "Control slti output mismatch"
            severity error;

        -- j.
        opcode <= "000010";
        wait for 10 ns;
        assert reg_dst = "00" and mem_to_reg = "00" and alu_op = "00" and
               jump = '1' and branch = '0' and mem_read = '0' and mem_write = '0' and
               alu_src = '0' and reg_write = '0' and sign_or_zero = '0'
            report "Control j output mismatch"
            severity error;

        -- jal.
        opcode <= "000011";
        wait for 10 ns;
        assert reg_dst = "10" and mem_to_reg = "10" and alu_op = "00" and
               jump = '1' and branch = '0' and mem_read = '0' and mem_write = '0' and
               alu_src = '0' and reg_write = '1' and sign_or_zero = '0'
            report "Control jal output mismatch"
            severity error;

        -- lw.
        opcode <= "100011";
        wait for 10 ns;
        assert reg_dst = "00" and mem_to_reg = "01" and alu_op = "11" and
               jump = '0' and branch = '0' and mem_read = '1' and mem_write = '0' and
               alu_src = '1' and reg_write = '1' and sign_or_zero = '1'
            report "Control lw output mismatch"
            severity error;

        -- sw.
        opcode <= "101011";
        wait for 10 ns;
        assert reg_dst = "00" and mem_to_reg = "00" and alu_op = "11" and
               jump = '0' and branch = '0' and mem_read = '0' and mem_write = '1' and
               alu_src = '1' and reg_write = '0' and sign_or_zero = '1'
            report "Control sw output mismatch"
            severity error;

        -- beq.
        opcode <= "000100";
        wait for 10 ns;
        assert reg_dst = "00" and mem_to_reg = "00" and alu_op = "01" and
               jump = '0' and branch = '1' and mem_read = '0' and mem_write = '0' and
               alu_src = '0' and reg_write = '0' and sign_or_zero = '1'
            report "Control beq output mismatch"
            severity error;

        -- addi.
        opcode <= "001000";
        wait for 10 ns;
        assert reg_dst = "00" and mem_to_reg = "00" and alu_op = "11" and
               jump = '0' and branch = '0' and mem_read = '0' and mem_write = '0' and
               alu_src = '1' and reg_write = '1' and sign_or_zero = '1'
            report "Control addi output mismatch"
            severity error;

        report "Simulation complete" severity note;
        wait;
    end process;
end Behavioral;
