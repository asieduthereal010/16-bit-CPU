library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- File: TB_Instruction_Memory.vhd
-- Entity: TB_Instruction_Memory
-- Description: Self-checking testbench for Instruction_Memory_VHDL.
-- Author: <author>
-- Date: <date>

entity TB_Instruction_Memory is
end TB_Instruction_Memory;

architecture Behavioral of TB_Instruction_Memory is
    signal pc          : std_logic_vector(31 downto 0) := (others => '0');
    signal instruction : std_logic_vector(31 downto 0);
begin
    uut: entity work.Instruction_Memory_VHDL
        port map (
            pc          => pc,
            instruction => instruction
        );

    stim_proc: process
    begin
        pc <= x"00000000";
        wait for 10 ns;
        assert instruction = x"00430820"
            report "Instruction at PC=0 mismatch"
            severity error;

        pc <= x"00000004";
        wait for 10 ns;
        assert instruction = x"00641822"
            report "Instruction at PC=0x04 mismatch"
            severity error;

        pc <= x"00000008";
        wait for 10 ns;
        assert instruction = x"00611024"
            report "Instruction at PC=0x08 mismatch"
            severity error;

        pc <= x"0000000C";
        wait for 10 ns;
        assert instruction = x"00821825"
            report "Instruction at PC=0x0C mismatch"
            severity error;

        report "Simulation complete" severity note;
        wait;
    end process;
end Behavioral;
