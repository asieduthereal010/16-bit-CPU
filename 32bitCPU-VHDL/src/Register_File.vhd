library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- File: Register_File.vhd
-- Entity: Register_File_VHDL
-- Description: 32x32 register file with sync write and comb read.
-- Author: <author>
-- Date: <date>

entity Register_File_VHDL is
    port (
        clk             : in  std_logic;
        rst             : in  std_logic;
        reg_write_en    : in  std_logic;
        reg_write_dest  : in  std_logic_vector(4 downto 0);
        reg_write_data  : in  std_logic_vector(31 downto 0);
        reg_read_addr_1 : in  std_logic_vector(4 downto 0);
        reg_read_addr_2 : in  std_logic_vector(4 downto 0);
        reg_read_data_1 : out std_logic_vector(31 downto 0);
        reg_read_data_2 : out std_logic_vector(31 downto 0)
    );
end Register_File_VHDL;

architecture Behavioral of Register_File_VHDL is
    type reg_array_type is array (0 to 31) of std_logic_vector(31 downto 0);
    signal registers : reg_array_type := (others => (others => '0'));
begin
    -- Synchronous reset and write process.
    process (clk, rst)
        variable write_idx : integer range 0 to 31;
    begin
        if rst = '1' then
            registers <= (others => x"00000000");
            registers(0) <= x"00000000";
            registers(1) <= x"00000001";
            registers(2) <= x"00000002";
            registers(3) <= x"00000003";
            registers(4) <= x"00000004";
            registers(5) <= x"00000005";
            registers(6) <= x"00000006";
            registers(7) <= x"00000007";
        elsif rising_edge(clk) then
            write_idx := to_integer(unsigned(reg_write_dest));
            if reg_write_en = '1' and write_idx /= 0 then
                registers(write_idx) <= reg_write_data;
            end if;
            registers(0) <= x"00000000";
        end if;
    end process;

    -- Combinational read port 1 with hardwired register 0 behavior.
    reg_read_data_1 <= x"00000000" when reg_read_addr_1 = "00000"
                       else registers(to_integer(unsigned(reg_read_addr_1)));

    -- Combinational read port 2 with hardwired register 0 behavior.
    reg_read_data_2 <= x"00000000" when reg_read_addr_2 = "00000"
                       else registers(to_integer(unsigned(reg_read_addr_2)));
end Behavioral;
