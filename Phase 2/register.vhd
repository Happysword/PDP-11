LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY mREGISTER IS
	GENERIC (n : INTEGER := 16);
	PORT (
		clk, reset, enable, outEnable : IN STD_LOGIC;
		d : IN STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
		uniBus : OUT STD_LOGIC_VECTOR(n - 1 DOWNTO 0));
END mREGISTER;

ARCHITECTURE arch_register OF mREGISTER IS

	COMPONENT tristate IS GENERIC (num : INTEGER);
		PORT (
			enable : IN STD_LOGIC;
			d : IN STD_LOGIC_VECTOR(num - 1 DOWNTO 0);
			q : OUT STD_LOGIC_VECTOR(num - 1 DOWNTO 0));
	END COMPONENT;

	SIGNAL q : STD_LOGIC_VECTOR(n - 1 DOWNTO 0);

BEGIN

	t : tristate GENERIC MAP(num => n) PORT MAP(outEnable, q, uniBus);

	PROCESS (clk, reset, enable)
	BEGIN
		IF reset = '1' THEN
			q <= (OTHERS => '0');
		ELSIF rising_edge(clk) AND enable = '1' THEN
			q <= d;
		END IF;
	END PROCESS;
END arch_register;