library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- File: ALU.vhd
-- Entity: ALU_VHDL
-- Description: 32-bit combinational ALU with zero flag.
-- Author: <author>
-- Date: <date>

entity ALU_VHDL is
    port (
        a           : in  std_logic_vector(31 downto 0);
        b           : in  std_logic_vector(31 downto 0);
        alu_control : in  std_logic_vector(2 downto 0);
        alu_result  : out std_logic_vector(31 downto 0);
        zero        : out std_logic
    );
end ALU_VHDL;

architecture Behavioral of ALU_VHDL is
begin
    -- Combinational ALU operation selection.
    process (alu_control, a, b)
        variable result_var : std_logic_vector(31 downto 0);
    begin
        case alu_control is
            when "000" =>
                result_var := std_logic_vector(signed(a) + signed(b));
            when "001" =>
                result_var := std_logic_vector(signed(a) - signed(b));
            when "010" =>
                result_var := a and b;
            when "011" =>
                result_var := a or b;
            when "100" =>
                if signed(a) < signed(b) then
                    result_var := x"00000001";
                else
                    result_var := x"00000000";
                end if;
            when others =>
                result_var := std_logic_vector(signed(a) + signed(b));
        end case;

        alu_result <= result_var;

        if result_var = x"00000000" then
            zero <= '1';
        else
            zero <= '0';
        end if;
    end process;
end Behavioral;
