LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY mREGISTER IS
	GENERIC (n : INTEGER := 16);
	PORT (
		clk, RST, enable : IN STD_LOGIC;
		d : IN STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
		q : OUT STD_LOGIC_VECTOR(n - 1 DOWNTO 0));
END mREGISTER;

ARCHITECTURE arch_register OF mREGISTER IS

BEGIN

	PROCESS (clk, enable, RST)
	BEGIN
		IF RST = '1' THEN
			Q <= (OTHERS => '0');
		ELSIF rising_edge(clk) AND enable = '1' THEN
			q <= d;
		END IF;
	END PROCESS;
END arch_register;