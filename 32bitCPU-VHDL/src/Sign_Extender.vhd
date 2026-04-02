library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- File: Sign_Extender.vhd
-- Entity: Sign_Extender_VHDL
-- Description: Combinational 16-to-32-bit sign or zero extender.
-- Inputs: sign_or_zero, data_in (16-bit immediate)
-- Outputs: data_out (32-bit extended)

entity Sign_Extender_VHDL is
    port (
        sign_or_zero : in  std_logic;
        data_in      : in  std_logic_vector(15 downto 0);
        data_out     : out std_logic_vector(31 downto 0)
    );
end Sign_Extender_VHDL;

architecture Behavioral of Sign_Extender_VHDL is
begin
    -- Extend immediate for I-type ALU operands / branch offset base.
    data_out <= x"0000" & data_in when sign_or_zero = '0'
                else (31 downto 16 => data_in(15)) & data_in;
end Behavioral;
