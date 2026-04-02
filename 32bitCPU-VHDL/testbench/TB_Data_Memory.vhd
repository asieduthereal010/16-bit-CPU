library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- File: TB_Data_Memory.vhd
-- Entity: TB_Data_Memory
-- Description: Self-checking testbench for Data_Memory_VHDL.
-- Author: <author>
-- Date: <date>

entity TB_Data_Memory is
end TB_Data_Memory;

architecture Behavioral of TB_Data_Memory is
    signal clk             : std_logic := '0';
    signal mem_access_addr : std_logic_vector(31 downto 0) := (others => '0');
    signal mem_write_data  : std_logic_vector(31 downto 0) := (others => '0');
    signal mem_write_en    : std_logic := '0';
    signal mem_read        : std_logic := '0';
    signal mem_read_data   : std_logic_vector(31 downto 0);

    constant CLK_PERIOD : time := 10 ns;
begin
    uut: entity work.Data_Memory_VHDL
        port map (
            clk             => clk,
            mem_access_addr => mem_access_addr,
            mem_write_data  => mem_write_data,
            mem_write_en    => mem_write_en,
            mem_read        => mem_read,
            mem_read_data   => mem_read_data
        );

    clk_process: process
    begin
        while now < 300 ns loop
            clk <= '0';
            wait for CLK_PERIOD / 2;
            clk <= '1';
            wait for CLK_PERIOD / 2;
        end loop;
        wait;
    end process;

    stim_proc: process
    begin
        -- Test Case 1: Write/read address 2.
        mem_access_addr <= x"00000002";
        mem_write_data  <= x"00000400";
        mem_write_en    <= '1';
        mem_read        <= '0';
        wait for CLK_PERIOD;

        mem_write_en <= '0';
        mem_read     <= '1';
        wait for CLK_PERIOD;
        assert mem_read_data = x"00000400"
            report "Data Memory Test 1 failed: expected 0x00000400 at address 2"
            severity error;

        -- Test Case 2: Write/read address 4.
        mem_access_addr <= x"00000004";
        mem_write_data  <= x"00068EB8";
        mem_write_en    <= '1';
        mem_read        <= '0';
        wait for CLK_PERIOD;

        mem_write_en <= '0';
        mem_read     <= '1';
        wait for CLK_PERIOD;
        assert mem_read_data = x"00068EB8"
            report "Data Memory Test 2 failed: expected 0x00068EB8 at address 4"
            severity error;

        report "Simulation complete" severity note;
        wait;
    end process;
end Behavioral;
