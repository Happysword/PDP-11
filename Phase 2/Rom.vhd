LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;

ENTITY rom IS
	PORT(
		address : IN  std_logic_vector(8 DOWNTO 0);
		dataout : OUT std_logic_vector(19 DOWNTO 0));
END rom;

ARCHITECTURE arch_rom OF rom IS

	TYPE rom_type IS ARRAY(0 TO 511) OF std_logic_vector(19 DOWNTO 0);
    
	SIGNAL rom : rom_type := (
        8#000# => "00010110100000011100",
        8#001# => "00110010000000000010",
        8#002# => "00100100000000000000",
        8#003# => "00000000000000110000",
        8#004# => "00011110010000000000",
        8#005# => "01110110000000000000",
        8#006# => "00110010000000000001",
        8#007# => "10000000000000000001",
        8#010# => "10010000000000000001",
        8#011# => "00000000000000000001",
        8#012# => "01100110000000000000",
        8#013# => "00000000000000110000",
        8#014# => "01100110000001000000",
        8#015# => "00000000000000110000",
        8#016# => "01100110000010000000",
        8#017# => "00000000000000110000",
        8#020# => "01100110000011000000",
        8#021# => "00000000000000110000",
        8#022# => "01100110000100000000",
        8#023# => "00000000000000110000",
        8#024# => "01100110000101000000",
        8#025# => "00000000000000110000",
        8#026# => "01100110000110000000",
        8#027# => "00000000000000110000",
        8#030# => "01100110000111000000",
        8#031# => "00000000000000110000",
        8#032# => "01100110001000000000",
        8#033# => "00000000000000110000",
        8#034# => "01100110001001000000",
        8#035# => "00000000000000110000",
        8#036# => "01100110001010000000",
        8#037# => "00000000000000110000",
        8#040# => "01100110001011000000",
        8#041# => "00000000000000110000",
        8#042# => "01100110001100000000",
        8#043# => "00000000000000110000",
        8#044# => "01100110001101000000",
        8#045# => "00000000000000110000",
        8#046# => "01100110001110000000",
        8#047# => "00000000000000110000",
        8#050# => "01100110001111001000",
        8#051# => "00000000000000110000",
        8#052# => "01100110011111000000",
        8#053# => "00000000000000110000",
        8#054# => "01100000000010000001",
        8#101# => "01001100000000000000",
        8#102# => "00000000000000110000",
        8#111# => "01000000100000010000",
        8#112# => "00000000000000110010",
        8#121# => "01000110100000011100",
        8#122# => "00111000000000000000",
        8#123# => "00000000000000110010",
        8#141# => "01000110000010001100",
        8#142# => "00111000100000010000",
        8#143# => "00000000000000110010",
        8#161# => "00110110100000011100",
        8#162# => "00110010000000000010",
        8#163# => "00100000010000000000",
        8#164# => "01000110000000000000",
        8#165# => "00110000100000010010",
        8#166# => "00100000100000010010",
        8#167# => "00101100000000000000",
        8#170# => "00000000000000110010",
        8#201# => "01010000010000000000",
        8#202# => "00000000000000110000",
        8#211# => "01010000100000010000",
        8#212# => "00000000000000110010",
        8#221# => "01010110100000011100",
        8#222# => "00111010000000000000",
        8#223# => "00000000000000110010",
        8#241# => "01010110001110000000",
        8#242# => "00111010100000010000",
        8#243# => "00000000000000110010",
        8#261# => "00010110100000011100",
        8#262# => "00110010000000000010",
        8#263# => "00100000010000000000",
        8#264# => "01010110000000000000",
        8#265# => "00110000100000010010",
        8#266# => "00100000100000010100",
        8#267# => "00100000010000000000",
        8#270# => "00000000000000110000",
        8#274# => "00110001000000100001",
        8#275# => "00111010000000000001",
        OTHERS => "00000000000000000000"
    );

	BEGIN
		dataout <= rom(to_integer(unsigned(address)));
END arch_rom;
