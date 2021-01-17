Library ieee;
Library work;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.my_nadder;

ENTITY ALU IS
GENERIC (n : integer:=16);
PORT ( A,B: IN std_logic_vector (n-1 DOWNTO 0);
SEL: IN std_logic_vector (3 DOWNTO 0);
FLAG : INOUT std_logic_vector (2 DOWNTO 0);
--COUT: OUT std_logic;
C : OUT std_logic_vector (n-1 DOWNTO 0));
END ENTITY ALU;

ARCHITECTURE ALU_arch OF ALU IS
COMPONENT my_nadder IS
	PORT (A, B : IN std_logic_vector(n-1 DOWNTO 0) ;
	CIN : IN std_logic;
    SUM : OUT std_logic_vector(n-1 DOWNTO 0);
    COUT: OUT std_logic);
END COMPONENT;
SIGNAL CARRY_IN,CARRY_OUT: std_logic := '0';
SIGNAL SECOND,ALU_OUT, ADDER_OUT: STD_LOGIC_VECTOR(n-1 DOWNTO 0):=(OTHERS => '0');
CONSTANT ZERO: STD_LOGIC_VECTOR(n-1 DOWNTO 0):=(OTHERS => '0');
BEGIN
    
    Second <= B                 WHEN SEL = b"0000" or SEL = b"0001"
        ELSE "not"(B)           WHEN SEL = b"0010" or SEL = b"0011"
        ELSE (OTHERS => '1')    WHEN SEL = b"1110"
        ELSE (OTHERS => '0');

    CARRY_IN  <= '0'            WHEN SEL = b"0000" OR SEL = b"1110"
        ELSE FLAG(0)            WHEN SEL = b"0001"
        ELSE '1'                WHEN SEL = b"0010" OR SEL = b"1101"
        ELSE "NOT"(FLAG(0))     WHEN SEL = b"0011"
        ELSE FLAG(0)            WHEN SEL = b"0001";

    u0: my_nadder GENERIC MAP(n) PORT MAP(A,Second,CARRY_IN,ADDER_OUT,CARRY_OUT);

    ALU_OUT <=  ADDER_OUT                   WHEN SEL = b"0000" OR SEL = b"0001" OR SEL = b"0010" OR SEL = b"0011" OR SEL = b"1101" OR SEL = b"1110"
        ELSE    A AND B                     WHEN SEL = b"0100"
        ELSE    A OR  B                     WHEN SEL = b"0101"
        ELSE    A XOR B                     WHEN SEL = b"0110"
        ELSE    "NOT"(A)                    WHEN SEL = b"0111"
        ELSE    '0' & A(N-1 DOWNTO 1)       WHEN SEL = b"1000"
        ELSE    A(0) & A(N-1 DOWNTO 1)      WHEN SEL = b"1001"
        ELSE    A(N-1) & A(N-1 DOWNTO 1)    WHEN SEL = b"1010"
        ELSE    A(N-2 DOWNTO 0) & '0'       WHEN SEL = b"1011"
        ELSE    A(N-2 DOWNTO 0) & A(15)     WHEN SEL = b"1100"
        ELSE    A                           WHEN SEL = b"1111";

    C <= ALU_OUT;

    FLAG(0) <=  CARRY_OUT   WHEN SEL = b"0000" OR SEL = b"0001" OR SEL = b"0010" OR SEL = b"0011"
        ELSE    A(0)        WHEN SEL = b"1000" OR SEL = b"1001" OR SEL = b"1010"
        ELSE    A(N-1)      WHEN SEL = b"1011" OR SEL = b"1100"
        ELSE    FLAG(0);

    FLAG(1) <= '1' WHEN ALU_OUT=ZERO ELSE '0';
    FLAG(2) <= ALU_OUT(N-1);

END ALU_arch;