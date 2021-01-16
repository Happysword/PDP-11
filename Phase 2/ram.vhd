LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY ram IS
        GENERIC (n : INTEGER := 16);
        PORT (
        clk : IN STD_LOGIC;
        w : IN STD_LOGIC;
        r : IN STD_LOGIC;
        WMFC : INOUT STD_LOGIC;
        address : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        data : INOUT STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
END ram;

ARCHITECTURE arch_ram OF ram IS

        TYPE ram_type IS ARRAY(0 TO 2047) OF STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
        SIGNAL ram : ram_type;

BEGIN
        PROCESS (clk) IS
        BEGIN
                IF rising_edge(clk) THEN
                        IF w = '1' THEN
                                ram(to_integer(unsigned(address))) <= data;
                        ELSIF r = '1' THEN
                                data <= ram(to_integer(unsigned(address)));
                        END IF;
                END IF;
        END PROCESS;
END arch_ram;