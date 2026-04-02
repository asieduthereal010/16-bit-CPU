library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- File: TB_ALU.vhd
-- Entity: TB_ALU
-- Description: Self-checking testbench for ALU_VHDL.
-- Author: <author>
-- Date: <date>

entity TB_ALU is
end TB_ALU;

architecture Behavioral of TB_ALU is
    signal a           : std_logic_vector(31 downto 0) := (others => '0');
    signal b           : std_logic_vector(31 downto 0) := (others => '0');
    signal alu_control : std_logic_vector(2 downto 0) := (others => '0');
    signal alu_result  : std_logic_vector(31 downto 0);
    signal zero        : std_logic;
begin
    uut: entity work.ALU_VHDL
        port map (
            a           => a,
            b           => b,
            alu_control => alu_control,
            alu_result  => alu_result,
            zero        => zero
        );

    stim_proc: process
    begin
        -- i) ADD: 2500 + 25000 = 27500.
        a <= x"000009C4";
        b <= x"000061A8";
        alu_control <= "000";
        wait for 10 ns;
        assert alu_result = x"00006B6C" and zero = '0'
            report "ALU ADD test failed"
            severity error;

        -- ii) SUB: 540250 - 37800 = 502450.
        a <= x"00083E5A";
        b <= x"000093A8";
        alu_control <= "001";
        wait for 10 ns;
        assert alu_result = x"0007AAB2" and zero = '0'
            report "ALU SUB test failed"
            severity error;

        -- iii) AND: 53957 AND 30000 = 0x00005000.
        a <= x"0000D2C5";
        b <= x"00007530";
        alu_control <= "010";
        wait for 10 ns;
        assert alu_result = x"00005000" and zero = '0'
            report "ALU AND test failed"
            severity error;

        -- iv) OR: 746353 OR 846465 = 0x000FEBF1.
        a <= x"000B6371";
        b <= x"000CEA81";
        alu_control <= "011";
        wait for 10 ns;
        assert alu_result = x"000FEBF1" and zero = '0'
            report "ALU OR test failed"
            severity error;

        -- v) SLT: 58847537 < 72464383 => 1.
        a <= x"0381F131";
        b <= x"0451B7FF";
        alu_control <= "100";
        wait for 10 ns;
        assert alu_result = x"00000001" and zero = '0'
            report "ALU SLT test failed"
            severity error;

        report "Simulation complete" severity note;
        wait;
    end process;
end Behavioral;
