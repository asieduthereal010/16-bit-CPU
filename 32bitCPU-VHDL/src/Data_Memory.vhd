library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- File: Data_Memory.vhd
-- Entity: Data_Memory_VHDL
-- Description: 32-bit synchronous data memory with 256 words.
-- Author: <author>
-- Date: <date>

entity Data_Memory_VHDL is
    port (
        clk             : in  std_logic;
        mem_access_addr : in  std_logic_vector(31 downto 0);
        mem_write_data  : in  std_logic_vector(31 downto 0);
        mem_write_en    : in  std_logic;
        mem_read        : in  std_logic;
        mem_read_data   : out std_logic_vector(31 downto 0)
    );
end Data_Memory_VHDL;

architecture Behavioral of Data_Memory_VHDL is
    type ram_type is array (0 to 255) of std_logic_vector(31 downto 0);
    signal RAM : ram_type := (others => (others => '0'));
begin
    -- Synchronous read and write process.
    process (clk)
        variable addr_idx : integer range 0 to 255;
    begin
        if rising_edge(clk) then
            addr_idx := to_integer(unsigned(mem_access_addr(7 downto 0)));

            if mem_write_en = '1' then
                RAM(addr_idx) <= mem_write_data;
            end if;

            if mem_read = '1' then
                mem_read_data <= RAM(addr_idx);
            else
                mem_read_data <= x"00000000";
            end if;
        end if;
    end process;
end Behavioral;
