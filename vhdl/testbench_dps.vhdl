library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;

entity tb_cps is
end tb_cps;

architecture testbench of tb_cps is

	component digital_parking_system
	port(
		clk,reset_n: in std_logic;	-- clock and reset value

		ent_sensor: in std_logic; 	-- entering sensor to scan incoming cars
		ent_inp_passcode: in std_logic_vector (3 downto 0); --input passcode by the driver when entering
		ent_set_passcode: in std_logic; -- driver confirm passcode set
		
		ext_sensor: in std_logic;
		ext_sensor_v: in std_logic_vector (2 downto 0);   -- exit sensor to scan which car is leaving
		ext_inp_passcode: in std_logic_vector (3 downto 0);
		ext_set_passcode: in std_logic;	

		assign_slot: out std_logic_vector (2 downto 0);	-- slot assign to the driver and display out
		slot_ava_disp: out std_logic_vector (7 downto 0); --display all available slots
		ENT_RED_LED, ENT_GREEN_LED, EXT_RED_LED, EXT_GREEN_LED: out std_logic	--led lights indicator
	);
	end component;

--Inputs
signal clk : std_logic :='0';
signal reset_n : std_logic :='0';

signal ent_sensor: std_logic:='0';
signal ent_inp_passcode: std_logic_vector (3 downto 0);
signal ent_set_passcode: std_logic;

signal ext_sensor: std_logic;
signal ext_sensor_v: std_logic_vector (2 downto 0);
signal ext_inp_passcode: std_logic_vector (3 downto 0);
signal ext_set_passcode: std_logic;

--Outputs
signal ENT_RED_LED, ENT_GREEN_LED, EXT_RED_LED, EXT_GREEN_LED : std_logic;
signal assign_slot: std_logic_vector (2 downto 0);
signal slot_ava_disp: std_logic_vector (7 downto 0) := "00000000";

--Clock time declaration
constant clk_period : time := 10 ns;

Begin
	UUT : digital_parking_system port map(
		clk => clk,
		reset_n => reset_n,
		ent_sensor => ent_sensor,
		ent_set_passcode => ent_set_passcode,
		ent_inp_passcode => ent_inp_passcode,
		assign_slot => assign_slot,
		slot_ava_disp => slot_ava_disp,
		ext_sensor => ext_sensor,
		ext_sensor_v => ext_sensor_v,
		ext_inp_passcode => ext_inp_passcode,
		ext_set_passcode => ext_set_passcode,
		ENT_RED_LED => ENT_RED_LED,
		ENT_GREEN_LED => ENT_GREEN_LED,
		EXT_RED_LED => EXT_RED_LED,
		EXT_GREEN_LED => EXT_GREEN_LED
	);

clk_process : process
begin
	clk <='0';
	wait for clk_period/2;
	clk <='1';
	wait for clk_period/2;
end process;

process
begin
	reset_n <= '1';
	wait for clk_period*10;
	reset_n <= '0';
	wait for clk_period*10;
	ent_sensor<='1';
	wait for clk_period*5;
	ent_inp_passcode<="0101";
	wait for clk_period*5;
	ent_set_passcode<='1';
	wait for clk_period;
	ent_set_passcode<='0';
	ent_sensor<='1';
	wait for clk_period*5;
	ent_sensor<='1';
	wait for clk_period*5;
	ent_inp_passcode<="1010";
	wait for clk_period*5;
	ent_set_passcode<='1';
	wait for clk_period;
	ent_set_passcode<='0';
	ent_sensor<='0';
	wait for clk_period*5;
	ext_sensor<='1';
	ext_sensor_v<="001";
	wait for clk_period*5;
	ext_inp_passcode<="1010";
	wait for clk_period*5;
	ext_set_passcode<='1';
	wait for clk_period;
	ext_set_passcode<='0';
	ext_sensor<='0';
	ent_sensor<='1';
	wait for clk_period*5;
	ent_inp_passcode<="1111";
	wait for clk_period*5;
	ent_set_passcode<='1';
	wait for clk_period;
	ent_set_passcode<='0';
	ent_sensor<='0';
	wait for clk_period*5;
	ent_sensor<='1';
	wait for clk_period*5;
	ext_sensor<='1';
	ext_sensor_v<="010";
	wait for clk_period*5;
	ent_inp_passcode<="1100";
	ext_inp_passcode<="1111";
	wait for clk_period*5;
	ent_set_passcode<='1';
	ext_set_passcode<='1';
	wait for clk_period;
	ent_set_passcode<='0';
	ext_set_passcode<='0';
	ent_sensor<='0';
	ext_sensor<='0';
	wait for clk_period*5;
	ent_sensor<='1';
	wait for clk_period*5;
	ent_inp_passcode<="1101";
	wait for clk_period*5;
	ent_set_passcode<='1';
	wait for clk_period;
	ent_set_passcode<='0';
	ent_sensor<='1';
	wait for clk_period*5;
	ent_inp_passcode<="0011";
	wait for clk_period*5;
	ent_set_passcode<='1';
	wait for clk_period;
	ent_set_passcode<='0';
	ent_sensor<='1';
	wait for clk_period*5;
	ent_inp_passcode<="0111";
	wait for clk_period*5;
	ent_set_passcode<='1';
	wait for clk_period;
	ent_set_passcode<='0';
	ent_sensor<='1';
	wait for clk_period*5;
	ent_inp_passcode<="1011";
	wait for clk_period*5;
	ent_set_passcode<='1';
	wait for clk_period;
	ent_set_passcode<='0';
	ent_sensor<='1';
	wait for clk_period*5;
	ent_inp_passcode<="0010";
	wait for clk_period*5;
	ent_set_passcode<='1';
	wait for clk_period;
	ent_set_passcode<='0';
	ent_sensor<='1';
	wait for clk_period*5;
	ent_inp_passcode<="0100";
	wait for clk_period*5;
	ent_set_passcode<='1';
	wait for clk_period;
	ent_set_passcode<='0';
	ent_sensor<='0';
	wait for clk_period*5;
	ent_sensor<='1';
	wait for clk_period*5;
	ent_sensor<='0';
	wait for clk_period*10;
	ent_sensor<='1';
	wait for clk_period*5;
	ext_sensor<='1';
	ext_sensor_v<="110";
	wait for clk_period*5;
	ext_inp_passcode<="0000";
	wait for clk_period*5;
	ext_set_passcode<='1';
	wait for clk_period;
	ext_set_passcode<='0';
	wait for clk_period*5;
	ext_inp_passcode<="0010";
	wait for clk_period*5;
	ext_set_passcode<='1';
	wait for clk_period;
	ext_sensor<='0';
	ext_set_passcode<='0';
	wait for clk_period*5;
	ent_inp_passcode<="1000";
	wait for clk_period*5;
	ent_set_passcode<='1';
	wait for clk_period;
	ent_set_passcode<='0';
	ent_sensor<='0';
	wait for clk_period*5;
	ent_sensor<='1';
	ext_sensor<='1';
	ext_sensor_v<="011";
	wait for clk_period*5;
	ext_inp_passcode<="0011";
	ent_inp_passcode<="1001";
	wait for clk_period*5;
	ext_set_passcode<='1';
	ent_set_passcode<='1';
	wait for clk_period;
	ext_set_passcode<='0';
	ent_set_passcode<='0';
	ext_sensor<='0';
	wait for clk_period*5;
	ent_set_passcode<='1';
	wait for clk_period;
	ent_set_passcode<='0';
	ent_sensor<='0';
	wait for clk_period*5;
	ext_sensor<='1';
	ext_sensor_v<="000";
	wait for clk_period*5;
	ext_inp_passcode<="0101";
	wait for clk_period*5;
	ext_set_passcode<='1';
	wait for clk_period;
	ext_set_passcode<='0';
	ext_sensor<='0';
	wait for clk_period*2;
	ext_sensor_v<="XXX";
	wait for clk_period*2;
	ent_sensor<='1';
	ent_inp_passcode<="XXXX";
	wait for clk_period*5;
	ent_sensor<='0';
	wait for clk_period*3;
	ext_sensor<='1';
	wait for clk_period*5;
	ext_sensor<='0';

	
	wait;
end process;

END;	