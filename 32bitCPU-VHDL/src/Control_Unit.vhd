library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- File: Control_Unit.vhd
-- Entity: Control_Unit_VHDL
-- Description: Main control decoder for 32-bit single-cycle MIPS.
-- Author: <author>
-- Date: <date>

entity Control_Unit_VHDL is
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
end Control_Unit_VHDL;

architecture Behavioral of Control_Unit_VHDL is
begin
    -- Combinational main control decode.
    process (reset, opcode)
    begin
        if reset = '1' then
            reg_dst      <= "00";
            mem_to_reg   <= "00";
            alu_op       <= "00";
            jump         <= '0';
            branch       <= '0';
            mem_read     <= '0';
            mem_write    <= '0';
            alu_src      <= '0';
            reg_write    <= '0';
            sign_or_zero <= '0';
        else
            case opcode is
                when "000000" =>
                    reg_dst      <= "01";
                    mem_to_reg   <= "00";
                    alu_op       <= "00";
                    jump         <= '0';
                    branch       <= '0';
                    mem_read     <= '0';
                    mem_write    <= '0';
                    alu_src      <= '0';
                    reg_write    <= '1';
                    sign_or_zero <= '0';
                when "100011" =>
                    reg_dst      <= "00";
                    mem_to_reg   <= "01";
                    alu_op       <= "11";
                    jump         <= '0';
                    branch       <= '0';
                    mem_read     <= '1';
                    mem_write    <= '0';
                    alu_src      <= '1';
                    reg_write    <= '1';
                    sign_or_zero <= '1';
                when "101011" =>
                    reg_dst      <= "00";
                    mem_to_reg   <= "00";
                    alu_op       <= "11";
                    jump         <= '0';
                    branch       <= '0';
                    mem_read     <= '0';
                    mem_write    <= '1';
                    alu_src      <= '1';
                    reg_write    <= '0';
                    sign_or_zero <= '1';
                when "000100" =>
                    reg_dst      <= "00";
                    mem_to_reg   <= "00";
                    alu_op       <= "01";
                    jump         <= '0';
                    branch       <= '1';
                    mem_read     <= '0';
                    mem_write    <= '0';
                    alu_src      <= '0';
                    reg_write    <= '0';
                    sign_or_zero <= '1';
                when "001000" =>
                    reg_dst      <= "00";
                    mem_to_reg   <= "00";
                    alu_op       <= "11";
                    jump         <= '0';
                    branch       <= '0';
                    mem_read     <= '0';
                    mem_write    <= '0';
                    alu_src      <= '1';
                    reg_write    <= '1';
                    sign_or_zero <= '1';
                when "001010" =>
                    reg_dst      <= "00";
                    mem_to_reg   <= "00";
                    alu_op       <= "10";
                    jump         <= '0';
                    branch       <= '0';
                    mem_read     <= '0';
                    mem_write    <= '0';
                    alu_src      <= '1';
                    reg_write    <= '1';
                    sign_or_zero <= '1';
                when "000010" =>
                    reg_dst      <= "00";
                    mem_to_reg   <= "00";
                    alu_op       <= "00";
                    jump         <= '1';
                    branch       <= '0';
                    mem_read     <= '0';
                    mem_write    <= '0';
                    alu_src      <= '0';
                    reg_write    <= '0';
                    sign_or_zero <= '0';
                when "000011" =>
                    reg_dst      <= "10";
                    mem_to_reg   <= "10";
                    alu_op       <= "00";
                    jump         <= '1';
                    branch       <= '0';
                    mem_read     <= '0';
                    mem_write    <= '0';
                    alu_src      <= '0';
                    reg_write    <= '1';
                    sign_or_zero <= '0';
                when others =>
                    reg_dst      <= "00";
                    mem_to_reg   <= "00";
                    alu_op       <= "00";
                    jump         <= '0';
                    branch       <= '0';
                    mem_read     <= '0';
                    mem_write    <= '0';
                    alu_src      <= '0';
                    reg_write    <= '0';
                    sign_or_zero <= '0';
            end case;
        end if;
    end process;
end Behavioral;
