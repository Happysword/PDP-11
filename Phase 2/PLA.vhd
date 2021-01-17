LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
use ieee.numeric_std.all;


-- @TODO
-- CHECK THE RESET AND HOW TO DO IT
-- CHECK THE HLT AND HOW TO DO IT
-- HOW TO DEAL WITH BRANCH INSTRUCTIONS

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
SIGNAL F5: STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL F6: STD_LOGIC_VECTOR(1 DOWNTO 0);
SIGNAL F10: STD_LOGIC;


BEGIN
	
	-- THE MICRO PC OUT CONNECTION
	MICRO_PC <= MICRO_PC_COUNTER;

	--EXTRACTING MICROBRANCH AND END FROM MICROINSTRUCION
	F6 <= MICRO_INSTRUCTION(5 DOWNTO 4);
	F5 <= MICRO_INSTRUCTION(9 DOWNTO 6);
	F10 <= MICRO_INSTRUCTION(0);


	PROCESS(CLK,RST)
	BEGIN
		-- IF RESET SET THE COUNTER TO ZERO
		IF RST = '1' THEN
			MICRO_PC_COUNTER <= std_logic_vector(to_unsigned(0, MICRO_PC_COUNTER'length));
		

		-- MICRO BRANCH SWITCH CASE OVER THE CURRENT VALUE OF MICRO PC TO KNOW WHERE TO GO NEXT
		ELSIF FALLING_EDGE(CLK) THEN

			-- @TODO CHECK EVERY MICRO BRANCH AND BIT ORING THAT ARE NEEDED
			-- HOW TO HANDLE BIT ORING????????
			IF F6 = "11" THEN

				--NUMEBRS IN UPPER COMMENTS ARE OCTAL NUMBERS
				--NUMBERS IN LOWER COMMENTS ARE DECIMAL NUMBERS
				CASE to_integer(unsigned( MICRO_PC_COUNTER )) IS

					--3 JUMP TO CURRENT COMMAND
					--3
					


					--13, 15, 17, 21, 23, 25, 27, 31, 33, 35, 37, 41, 43, 45, 47, 51, 53 ===>> 274 OR 275
					--11, 13, 15, 17, 19, 21, 23, 25, 27, 29, 31, 33, 35, 37, 39, 41, 43 ===>> 188 OR 189
					WHEN 13 | 15 | 17 | 19 | 21 | 23 | 25 | 27 | 29 | 31 | 33 | 35| 37 | 39 | 41 | 43 =>
						IF IR_REGISTER(9) = '1' THEN
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
						IF IR_REGISTER(9) = '1' THEN
							MICRO_PC_COUNTER <= std_logic_vector(to_unsigned(119, MICRO_PC_COUNTER'length));
						ELSE
							MICRO_PC_COUNTER <= std_logic_vector(to_unsigned(118, MICRO_PC_COUNTER'length));
						END IF;


					--170 ==>> 201 OR ALOT OF STUFF
					--120 ==>> 129
					WHEN 120 =>
						MICRO_PC_COUNTER <= std_logic_vector(to_unsigned(129, MICRO_PC_COUNTER'length));
						MICRO_PC_COUNTER( 5 DOWNTO 4) <= IR_REGISTER( 5 DOWNTO 4);
						MICRO_PC_COUNTER(3) <= NOT IR_REGISTER(5);



					--212 ==>> 267
					--138 ==>> 183
					WHEN 138 =>
						MICRO_PC_COUNTER <= std_logic_vector(to_unsigned(183, MICRO_PC_COUNTER'length));


					--223, 243 ==>> 266 OR 267
					--147, 163 ==>> 182 OR 183
					WHEN 147 | 163 =>
						IF IR_REGISTER(9) = '1' THEN
							MICRO_PC_COUNTER <= std_logic_vector(to_unsigned(183, MICRO_PC_COUNTER'length));
						ELSE
							MICRO_PC_COUNTER <= std_logic_vector(to_unsigned(182, MICRO_PC_COUNTER'length));
						END IF;


					--270,202 ==>> ALU OPERATIONS
					--184,130
					WHEN 130 | 184 =>
						-- SWITCH CASE OVER ALU VALUES
						CASE F5 IS 
							WHEN "0000" =>
								MICRO_PC_COUNTER <= std_logic_vector(to_unsigned(10, MICRO_PC_COUNTER'length));
							WHEN "0001" =>
								MICRO_PC_COUNTER <= std_logic_vector(to_unsigned(12, MICRO_PC_COUNTER'length));
							WHEN "0010" =>
								MICRO_PC_COUNTER <= std_logic_vector(to_unsigned(14, MICRO_PC_COUNTER'length));
							WHEN "0011" =>
								MICRO_PC_COUNTER <= std_logic_vector(to_unsigned(16, MICRO_PC_COUNTER'length));
							WHEN "0100" =>
								MICRO_PC_COUNTER <= std_logic_vector(to_unsigned(18, MICRO_PC_COUNTER'length));
							WHEN "0101" =>
								MICRO_PC_COUNTER <= std_logic_vector(to_unsigned(20, MICRO_PC_COUNTER'length));
							WHEN "0110" =>
								MICRO_PC_COUNTER <= std_logic_vector(to_unsigned(22, MICRO_PC_COUNTER'length));
							WHEN "0111" =>
								MICRO_PC_COUNTER <= std_logic_vector(to_unsigned(24, MICRO_PC_COUNTER'length));
							WHEN "1000" =>
								MICRO_PC_COUNTER <= std_logic_vector(to_unsigned(26, MICRO_PC_COUNTER'length));
							WHEN "1001" =>
								MICRO_PC_COUNTER <= std_logic_vector(to_unsigned(28, MICRO_PC_COUNTER'length));
							WHEN "1010" =>
								MICRO_PC_COUNTER <= std_logic_vector(to_unsigned(30, MICRO_PC_COUNTER'length));
							WHEN "1011" =>
								MICRO_PC_COUNTER <= std_logic_vector(to_unsigned(32, MICRO_PC_COUNTER'length));
							WHEN "1100" =>
								MICRO_PC_COUNTER <= std_logic_vector(to_unsigned(34, MICRO_PC_COUNTER'length));
							WHEN "1101" =>
								MICRO_PC_COUNTER <= std_logic_vector(to_unsigned(36, MICRO_PC_COUNTER'length));
							WHEN "1110" =>
								MICRO_PC_COUNTER <= std_logic_vector(to_unsigned(38, MICRO_PC_COUNTER'length));
							WHEN "1111" =>
								MICRO_PC_COUNTER <= std_logic_vector(to_unsigned(42, MICRO_PC_COUNTER'length));
							WHEN OTHERS =>
								MICRO_PC_COUNTER <= std_logic_vector(to_unsigned(255, MICRO_PC_COUNTER'length));
						END CASE;

					--OTHER VALUES
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
