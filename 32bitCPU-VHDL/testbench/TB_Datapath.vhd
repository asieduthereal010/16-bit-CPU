library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- File: TB_Datapath.vhd
-- Entity: TB_Datapath
-- Description: End-to-end self-checking test for MIPS_Datapath.
-- Inputs: (stimulus via clk, rst only)
-- Outputs: (none — checks observation ports)

entity TB_Datapath is
end TB_Datapath;

architecture Behavioral of TB_Datapath is
    constant CLK_PERIOD : time := 10 ns;

    signal clk               : std_logic := '0';
    signal rst               : std_logic := '1';
    signal tb_pc             : std_logic_vector(31 downto 0);
    signal tb_instruction    : std_logic_vector(31 downto 0);
    signal tb_alu_result     : std_logic_vector(31 downto 0);
    signal tb_reg_write_data : std_logic_vector(31 downto 0);
    signal tb_reg_write_dest : std_logic_vector(4 downto 0);
    signal tb_reg_write_en   : std_logic;
begin
    uut : entity work.MIPS_Datapath
        port map (
            clk               => clk,
            rst               => rst,
            tb_pc             => tb_pc,
            tb_instruction    => tb_instruction,
            tb_alu_result     => tb_alu_result,
            tb_reg_write_data => tb_reg_write_data,
            tb_reg_write_dest => tb_reg_write_dest,
            tb_reg_write_en   => tb_reg_write_en
        );

    clk_process : process
    begin
        loop
            clk <= '0';
            wait for CLK_PERIOD / 2;
            clk <= '1';
            wait for CLK_PERIOD / 2;
        end loop;
    end process clk_process;

    stim : process
    begin
        rst <= '1';
        wait until rising_edge(clk);
        wait until rising_edge(clk);

        rst <= '0';
        wait for 1 ns;

        -- Cycle 1: add $t0,$t1,$t2 → R[1] = 5
        assert tb_pc = x"00000000"
            report "TB_Datapath cycle1: expected PC=0x00"
            severity error;
        assert tb_reg_write_dest = "00001"
            report "TB_Datapath cycle1: expected write reg R1"
            severity error;
        assert tb_reg_write_en = '1'
            report "TB_Datapath cycle1: expected reg_write enabled"
            severity error;
        assert tb_reg_write_data = x"00000005"
            report "TB_Datapath cycle1: expected write_data=5"
            severity error;
        assert tb_alu_result = x"00000005"
            report "TB_Datapath cycle1: expected alu_result=5"
            severity error;

        wait until rising_edge(clk);
        wait for 1 ns;

        -- Cycle 2: sub $t2,$t2,$t3 → R[3] = -1
        assert tb_pc = x"00000004"
            report "TB_Datapath cycle2: expected PC=0x04"
            severity error;
        assert tb_reg_write_dest = "00011"
            report "TB_Datapath cycle2: expected write reg R3"
            severity error;
        assert tb_reg_write_data = x"FFFFFFFF"
            report "TB_Datapath cycle2: expected write_data=-1"
            severity error;
        assert tb_alu_result = x"FFFFFFFF"
            report "TB_Datapath cycle2: expected alu_result=-1"
            severity error;

        wait until rising_edge(clk);
        wait for 1 ns;

        -- Cycle 3: and $t1,$t2,$t0 → R[2] = 5
        assert tb_pc = x"00000008"
            report "TB_Datapath cycle3: expected PC=0x08"
            severity error;
        assert tb_reg_write_dest = "00010"
            report "TB_Datapath cycle3: expected write reg R2"
            severity error;
        assert tb_reg_write_data = x"00000005"
            report "TB_Datapath cycle3: expected write_data=5"
            severity error;

        wait until rising_edge(clk);
        wait for 1 ns;

        -- Cycle 4: or $t2,$t3,$t1 → R[3] = 5
        assert tb_pc = x"0000000C"
            report "TB_Datapath cycle4: expected PC=0x0C"
            severity error;
        assert tb_reg_write_dest = "00011"
            report "TB_Datapath cycle4: expected write reg R3"
            severity error;
        assert tb_reg_write_data = x"00000005"
            report "TB_Datapath cycle4: expected write_data=5"
            severity error;

        report "TB_Datapath: All assertions passed. Simulation complete." severity note;
        wait;
    end process stim;
end Behavioral;
