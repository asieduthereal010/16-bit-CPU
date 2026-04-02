library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- File: ALU_Control.vhd
-- Entity: ALU_Control_VHDL
-- Description: Decodes ALUOp and funct into 3-bit ALU control.
-- Author: <author>
-- Date: <date>

entity ALU_Control_VHDL is
    port (
        ALUOp       : in  std_logic_vector(1 downto 0);
        ALU_Funct   : in  std_logic_vector(5 downto 0);
        ALU_Control : out std_logic_vector(2 downto 0)
    );
end ALU_Control_VHDL;

architecture Behavioral of ALU_Control_VHDL is
begin
    -- Combinational decode for ALU control signal.
    process (ALUOp, ALU_Funct)
    begin
        case ALUOp is
            when "00" =>
                -- R-type: full MIPS funct (lower 3 bits alone are not unique).
                case ALU_Funct is
                    when "100000" => ALU_Control <= "000"; -- add
                    when "100010" => ALU_Control <= "001"; -- sub
                    when "100100" => ALU_Control <= "010"; -- and
                    when "100101" => ALU_Control <= "011"; -- or
                    when "101010" => ALU_Control <= "100"; -- slt
                    when others   => ALU_Control <= "000"; -- e.g. jr (funct 001000)
                end case;
            when "01" =>
                ALU_Control <= "001";
            when "10" =>
                ALU_Control <= "100";
            when "11" =>
                ALU_Control <= "000";
            when others =>
                ALU_Control <= "000";
        end case;
    end process;
end Behavioral;
