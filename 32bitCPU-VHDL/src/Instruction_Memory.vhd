library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- File: Instruction_Memory.vhd
-- Entity: Instruction_Memory_VHDL
-- Description: 16-slot combinational instruction ROM.
-- Author: <author>
-- Date: <date>

entity Instruction_Memory_VHDL is
    port (
        pc          : in  std_logic_vector(31 downto 0);
        instruction : out std_logic_vector(31 downto 0)
    );
end Instruction_Memory_VHDL;

architecture Behavioral of Instruction_Memory_VHDL is
    type rom_type is array (0 to 15) of std_logic_vector(31 downto 0);
    constant ROM : rom_type := (
        -- PC byte 0x00 (idx 0): add $t0,$t1,$t2
        0  => x"00430820",
        1  => x"00000000",
        2  => x"00000000",
        3  => x"00000000",
        -- PC byte 0x04 (idx 4): sub $t2,$t2,$t3
        4  => x"00641822",
        5  => x"00000000",
        6  => x"00000000",
        7  => x"00000000",
        -- PC byte 0x08 (idx 8): and $t1,$t2,$t0
        8  => x"00611024",
        9  => x"00000000",
        10 => x"00000000",
        11 => x"00000000",
        -- PC byte 0x0C (idx 12): or $t2,$t3,$t1
        12 => x"00821825",
        13 => x"00000000",
        14 => x"00000000",
        15 => x"00000000"
    );
begin
    -- Combinational fetch: index by low 4 bits of PC; guard high range.
    process (pc)
        variable idx : integer range 0 to 15;
    begin
        if unsigned(pc) > x"00000020" then
            instruction <= x"00000000";
        else
            idx := to_integer(unsigned(pc(3 downto 0)));
            instruction <= ROM(idx);
        end if;
    end process;
end Behavioral;
