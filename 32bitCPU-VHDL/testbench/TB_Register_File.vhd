library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- File: TB_Register_File.vhd
-- Entity: TB_Register_File
-- Description: Self-checking testbench for Register_File_VHDL.
-- Author: <author>
-- Date: <date>

entity TB_Register_File is
end TB_Register_File;

architecture Behavioral of TB_Register_File is
    signal clk             : std_logic := '0';
    signal rst             : std_logic := '0';
    signal reg_write_en    : std_logic := '0';
    signal reg_write_dest  : std_logic_vector(4 downto 0) := (others => '0');
    signal reg_write_data  : std_logic_vector(31 downto 0) := (others => '0');
    signal reg_read_addr_1 : std_logic_vector(4 downto 0) := (others => '0');
    signal reg_read_addr_2 : std_logic_vector(4 downto 0) := (others => '0');
    signal reg_read_data_1 : std_logic_vector(31 downto 0);
    signal reg_read_data_2 : std_logic_vector(31 downto 0);

    constant CLK_PERIOD : time := 10 ns;
begin
    uut: entity work.Register_File_VHDL
        port map (
            clk             => clk,
            rst             => rst,
            reg_write_en    => reg_write_en,
            reg_write_dest  => reg_write_dest,
            reg_write_data  => reg_write_data,
            reg_read_addr_1 => reg_read_addr_1,
            reg_read_addr_2 => reg_read_addr_2,
            reg_read_data_1 => reg_read_data_1,
            reg_read_data_2 => reg_read_data_2
        );

    clk_process: process
    begin
        while now < 400 ns loop
            clk <= '0';
            wait for CLK_PERIOD / 2;
            clk <= '1';
            wait for CLK_PERIOD / 2;
        end loop;
        wait;
    end process;

    stim_proc: process
    begin
        -- Reset register file to known initial state.
        rst <= '1';
        wait for CLK_PERIOD;
        rst <= '0';

        -- Write register 1 = 0x001D8BCA.
        reg_write_en   <= '1';
        reg_write_dest <= "00001";
        reg_write_data <= x"001D8BCA";
        wait for CLK_PERIOD;

        -- Write register 3 = 0x0082B16F.
        reg_write_dest <= "00011";
        reg_write_data <= x"0082B16F";
        wait for CLK_PERIOD;

        -- Write register 5 = 0x0C25BB60.
        reg_write_dest <= "00101";
        reg_write_data <= x"0C25BB60";
        wait for CLK_PERIOD;

        -- Write register 7 = 0x013B23D4.
        reg_write_dest <= "00111";
        reg_write_data <= x"013B23D4";
        wait for CLK_PERIOD;

        reg_write_en <= '0';

        -- Read and verify register 1 and 3.
        reg_read_addr_1 <= "00001";
        reg_read_addr_2 <= "00011";
        wait for 5 ns;
        assert reg_read_data_1 = x"001D8BCA"
            report "Register 1 read failed"
            severity error;
        assert reg_read_data_2 = x"0082B16F"
            report "Register 3 read failed"
            severity error;

        -- Read and verify register 5 and 7.
        reg_read_addr_1 <= "00101";
        reg_read_addr_2 <= "00111";
        wait for 5 ns;
        assert reg_read_data_1 = x"0C25BB60"
            report "Register 5 read failed"
            severity error;
        assert reg_read_data_2 = x"013B23D4"
            report "Register 7 read failed"
            severity error;

        -- Register 0 must always read zero.
        reg_read_addr_1 <= "00000";
        wait for 5 ns;
        assert reg_read_data_1 = x"00000000"
            report "Register 0 is not hardwired to zero"
            severity error;

        report "Simulation complete" severity note;
        wait;
    end process;
end Behavioral;
