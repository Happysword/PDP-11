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
        address : IN STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
        data : INOUT STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
        WRITE_TO_MDR : OUT STD_LOGIC);
END ram;

ARCHITECTURE arch_ram OF ram IS

        TYPE ram_type IS ARRAY(0 TO 2047) OF STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
        SIGNAL ram : ram_type;

BEGIN
        PROCESS (clk) IS
        BEGIN
                IF falling_edge(clk) THEN
                        IF w = '1' THEN
                                ram(to_integer(unsigned(address))) <= data;
                                WRITE_TO_MDR <= '0';
                        ELSIF r = '1' THEN
                                data <= ram(to_integer(unsigned(address)));
                                WRITE_TO_MDR <= '1';
                        ELSE
                                WRITE_TO_MDR <= '0';
                        END IF;
                        WMFC <= '0';
                END IF;
        END PROCESS;
END arch_ram;