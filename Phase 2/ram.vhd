LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY my_ram IS
        PORT (
                clk : IN STD_LOGIC;
                r : IN STD_LOGIC;
                w : IN STD_LOGIC;
                WMFC : IN STD_LOGIC;
                address : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
                datain : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
                dataout : OUT STD_LOGIC_VECTOR(15 DOWNTO 0));
END ENTITY my_ram;

ARCHITECTURE syncrama OF my_ram IS

        TYPE ram_type IS ARRAY(0 TO 1023) OF STD_LOGIC_VECTOR(15 DOWNTO 0);

BEGIN
        PROCESS (clk) IS
        BEGIN
                IF rising_edge(clk) THEN
                        IF w = '1' THEN
                                ram(to_integer(unsigned(address))) <= datain;
                        END IF;
                END IF;
        END PROCESS;
        dataout <= ram(to_integer(unsigned(address)));
END syncrama;