LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

-- @TODO
-- CHECK THE RESET AND HOW TO DO IT
-- CHECK THE HLT AND HOW TO DO IT
-- HOW TO DEAL WITH BRANCH INSTRUCTIONS
-- WMFC WHAT TO DO WITH IT
-- HOW TO HANDLE BIT ORING (CURRENTLY WITH IF CONDITIONS)

ENTITY PLA_COMP IS 
	PORT( 	
		CLK,RST : STD_LOGIC;
		IR_REGISTER : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		FLAGS : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
		MICRO_INSTRUCTION : IN STD_LOGIC_VECTOR(19 DOWNTO 0);
		MICRO_PC: OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
END PLA_COMP;

ARCHITECTURE ARCH1 OF PLA_COMP IS


-- NEEDED SIGNALS
SIGNAL MICRO_PC_COUNTER: STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL F5,IR_FIRST_FOUR: STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL F6: STD_LOGIC_VECTOR(1 DOWNTO 0);
SIGNAL F10: STD_LOGIC;
SIGNAL IR_NEXT_SIX: STD_LOGIC_VECTOR(5 DOWNTO 0);


BEGIN
	
	-- THE MICRO PC OUT CONNECTION
	MICRO_PC <= MICRO_PC_COUNTER;

	--EXTRACTING MICROBRANCH AND END FROM MICROINSTRUCION
	F6 <= MICRO_INSTRUCTION(5 DOWNTO 4);
	F5 <= MICRO_INSTRUCTION(9 DOWNTO 6);
	F10 <= MICRO_INSTRUCTION(0);

	-- EXTRACT BITS FROM IR 
	IR_FIRST_FOUR <= IR_REGISTER(15 DOWNTO 12);
	IR_NEXT_SIX <= IR_REGISTER(11 DOWNTO 6);


	PROCESS(CLK,RST)
	BEGIN
		-- IF RESET SET THE COUNTER TO ZERO
		IF RST = '1' THEN
			MICRO_PC_COUNTER <= std_logic_vector(to_unsigned(255, MICRO_PC_COUNTER'length));
		

		-- MICRO BRANCH SWITCH CASE OVER THE CURRENT VALUE OF MICRO PC TO KNOW WHERE TO GO NEXT
		ELSIF RISING_EDGE(CLK) THEN

			-- IF THERE IS A MICRO BRANCH
			IF F6 = "11" THEN

				--NUMEBRS IN UPPER COMMENTS ARE OCTAL NUMBERS
				--NUMBERS IN LOWER COMMENTS ARE DECIMAL NUMBERS
				CASE to_integer(unsigned( MICRO_PC_COUNTER )) IS

					--3 JUMP TO CURRENT COMMAND
					--3
					WHEN 3 =>
						-- CHECK THE TYPE OF THE COMMAND
						CASE to_integer(unsigned( IR_FIRST_FOUR )) IS
							
							-- TWO OPERAND INSTRUCTIONS
							-- BRANCH TO 101 TO SRC REGISTER MODES
							-- 65
							WHEN 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 =>
								MICRO_PC_COUNTER <= std_logic_vector(to_unsigned(65, MICRO_PC_COUNTER'length));
								MICRO_PC_COUNTER( 5 DOWNTO 4) <= IR_REGISTER( 11 DOWNTO 10);
								MICRO_PC_COUNTER(3) <= IR_REGISTER(9) AND NOT IR_REGISTER(11) AND NOT IR_REGISTER(10);


							-- ONE OPERAND INSTRUCTIONS
							-- BRANCH TO 170 TO DST REGISTER MODE
							-- 120
							WHEN 9 =>
								MICRO_PC_COUNTER <= std_logic_vector(to_unsigned(120, MICRO_PC_COUNTER'length));
							

							-- BRANCHING INSTRUCTIONS
							-- BRANCH TO 4 
							-- 4
							WHEN 10 =>
								MICRO_PC_COUNTER <= std_logic_vector(to_unsigned(4, MICRO_PC_COUNTER'length));
								
							-- HLT INSTRUCTION
							-- BRANCH TO 7
							-- 7
							WHEN 11 =>
								MICRO_PC_COUNTER <= std_logic_vector(to_unsigned(7, MICRO_PC_COUNTER'length));
								
							-- NOP INSTRUCTION
							-- BRANCH TO 11
							-- 9
							WHEN 12 =>
								MICRO_PC_COUNTER <= std_logic_vector(to_unsigned(9, MICRO_PC_COUNTER'length));
								
							-- RESET INSTRUCTION
							-- BRANCH TO 10
							-- 8
							WHEN 13 =>
								MICRO_PC_COUNTER <= std_logic_vector(to_unsigned(8, MICRO_PC_COUNTER'length));
								  
							-- SHOULD NEVER REACH THIS BUT FOR ERROR HANDLING
							WHEN OTHERS =>
								MICRO_PC_COUNTER <= std_logic_vector(to_unsigned(255, MICRO_PC_COUNTER'length));
						END CASE;
								

					--13, 15, 17, 21, 23, 25, 27, 31, 33, 35, 37, 41, 43, 45, 47, 51, 53 ===>> 274 OR 275
					--11, 13, 15, 17, 19, 21, 23, 25, 27, 29, 31, 33, 35, 37, 39, 41, 43 ===>> 188 OR 189
					WHEN 11 | 13 | 15 | 17 | 19 | 21 | 23 | 25 | 27 | 29 | 31 | 33 | 35| 37 | 39 | 41 | 43 =>
						IF IR_REGISTER(3) = '0' THEN
							MICRO_PC_COUNTER <= std_logic_vector(to_unsigned(189, MICRO_PC_COUNTER'length));
						ELSE
							MICRO_PC_COUNTER <= std_logic_vector(to_unsigned(188, MICRO_PC_COUNTER'length));
						END IF;


					--102 ==>> 170 MAYBE GROUP IT WE 170????
					--66  ==>> 120 
					WHEN 66 =>
						MICRO_PC_COUNTER <= std_logic_vector(to_unsigned(120, MICRO_PC_COUNTER'length));


					--112 ==>> 167
					--74  ==>> 119
					WHEN 74 =>
						MICRO_PC_COUNTER <= std_logic_vector(to_unsigned(119, MICRO_PC_COUNTER'length));


					--123, 143 ==>> 166 OR 167
					--83 , 99  ==>> 118 OR 119
					WHEN 83 | 99 =>
						IF IR_REGISTER(9) = '0' THEN
							MICRO_PC_COUNTER <= std_logic_vector(to_unsigned(119, MICRO_PC_COUNTER'length));
						ELSE
							MICRO_PC_COUNTER <= std_logic_vector(to_unsigned(118, MICRO_PC_COUNTER'length));
						END IF;


					--170 ==>> 201 OR ALOT OF STUFF
					--120 ==>> 129
					WHEN 120 =>
						MICRO_PC_COUNTER <= std_logic_vector(to_unsigned(129, MICRO_PC_COUNTER'length));
						MICRO_PC_COUNTER( 5 DOWNTO 4) <= IR_REGISTER( 5 DOWNTO 4);
						MICRO_PC_COUNTER(3) <= IR_REGISTER(3) AND NOT IR_REGISTER(4) AND NOT IR_REGISTER(5);


					--212 ==>> 267
					--138 ==>> 183
					WHEN 138 =>
						MICRO_PC_COUNTER <= std_logic_vector(to_unsigned(183, MICRO_PC_COUNTER'length));


					--223, 243 ==>> 266 OR 267
					--147, 163 ==>> 182 OR 183
					WHEN 147 | 163 =>
						IF IR_REGISTER(3) = '0' THEN
							MICRO_PC_COUNTER <= std_logic_vector(to_unsigned(183, MICRO_PC_COUNTER'length));
						ELSE
							MICRO_PC_COUNTER <= std_logic_vector(to_unsigned(182, MICRO_PC_COUNTER'length));
						END IF;


					--270,202 ==>> ALU OPERATIONS
					--184,130
					WHEN 130 | 184 =>

						--CHECK IF WE ARE IN CMP OR CLR WE GO TO THEM ELSE WE CHECK THE ALUE OPERATION
						-- CMP BRANCH TO 54
						-- 44
						IF IR_FIRST_FOUR = "1000" THEN
							MICRO_PC_COUNTER <= std_logic_vector(to_unsigned(44, MICRO_PC_COUNTER'length));
						
						-- CLR BRANCH TO 50
						-- 40
						ELSIF IR_FIRST_FOUR = "1001" AND IR_NEXT_SIX = "000010" THEN
							MICRO_PC_COUNTER <= std_logic_vector(to_unsigned(40, MICRO_PC_COUNTER'length));
							
						-- SWITCH CASE OVER ALU VALUES
						ELSE CASE IR_FIRST_FOUR IS 
							WHEN "0001" =>
								MICRO_PC_COUNTER <= std_logic_vector(to_unsigned(10, MICRO_PC_COUNTER'length));
							WHEN "0010" =>
								MICRO_PC_COUNTER <= std_logic_vector(to_unsigned(12, MICRO_PC_COUNTER'length));
							WHEN "0011" =>
								MICRO_PC_COUNTER <= std_logic_vector(to_unsigned(14, MICRO_PC_COUNTER'length));
							WHEN "0100" =>
								MICRO_PC_COUNTER <= std_logic_vector(to_unsigned(16, MICRO_PC_COUNTER'length));
							WHEN "0101" =>
								MICRO_PC_COUNTER <= std_logic_vector(to_unsigned(18, MICRO_PC_COUNTER'length));
							WHEN "0110" =>
								MICRO_PC_COUNTER <= std_logic_vector(to_unsigned(20, MICRO_PC_COUNTER'length));
							WHEN "0111" =>
								MICRO_PC_COUNTER <= std_logic_vector(to_unsigned(22, MICRO_PC_COUNTER'length));
							WHEN "1001" =>
								CASE IR_NEXT_SIX IS
									WHEN "000011" =>
										MICRO_PC_COUNTER <= std_logic_vector(to_unsigned(24, MICRO_PC_COUNTER'length));
									WHEN "000100" =>
										MICRO_PC_COUNTER <= std_logic_vector(to_unsigned(26, MICRO_PC_COUNTER'length));
									WHEN "000101" =>
										MICRO_PC_COUNTER <= std_logic_vector(to_unsigned(28, MICRO_PC_COUNTER'length));
									WHEN "000110" =>
										MICRO_PC_COUNTER <= std_logic_vector(to_unsigned(30, MICRO_PC_COUNTER'length));
									WHEN "000111" =>
										MICRO_PC_COUNTER <= std_logic_vector(to_unsigned(32, MICRO_PC_COUNTER'length));
									WHEN "001000" =>
										MICRO_PC_COUNTER <= std_logic_vector(to_unsigned(34, MICRO_PC_COUNTER'length));
									WHEN "000000" =>
										MICRO_PC_COUNTER <= std_logic_vector(to_unsigned(36, MICRO_PC_COUNTER'length));
									WHEN "000001" =>
										MICRO_PC_COUNTER <= std_logic_vector(to_unsigned(38, MICRO_PC_COUNTER'length));
									WHEN OTHERS =>
										MICRO_PC_COUNTER <= std_logic_vector(to_unsigned(255, MICRO_PC_COUNTER'length));
								END CASE;
							WHEN "0000" =>
								MICRO_PC_COUNTER <= std_logic_vector(to_unsigned(42, MICRO_PC_COUNTER'length));
							WHEN OTHERS =>
								MICRO_PC_COUNTER <= std_logic_vector(to_unsigned(255, MICRO_PC_COUNTER'length));
						END CASE;
						END IF;

					-- SHOULD NEVER REACH THIS BUT FOR ERROR HANDLING
					WHEN OTHERS =>
						MICRO_PC_COUNTER <= std_logic_vector(to_unsigned(255, MICRO_PC_COUNTER'length));

				END CASE;

			-- END FOR A MICROINSTRUCTION IS REACHED
			ELSIF F10 = '1' THEN		
				MICRO_PC_COUNTER <= std_logic_vector(to_unsigned(0, MICRO_PC_COUNTER'length));		


			-- INCREMENT THE MICRO PC
			ELSE
			MICRO_PC_COUNTER <= std_logic_vector(to_unsigned(to_integer(unsigned( MICRO_PC_COUNTER )) + 1, MICRO_PC_COUNTER'LENGTH));

			END IF;
		END IF;
	END PROCESS;
END ARCHITECTURE; 
