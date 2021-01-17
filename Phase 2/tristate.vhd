LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY tristate IS
generic(num: integer:= 16);
PORT( enable : IN std_logic;
		   d : IN std_logic_vector(num-1 downto 0);
		   q : OUT std_logic_vector(num-1 downto 0));
END tristate;

ARCHITECTURE tristate_arch OF tristate IS
BEGIN
with enable select
	q <= 
		d when '1',
		(others=>'Z') when others;
END tristate_arch;

