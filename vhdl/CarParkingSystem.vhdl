library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.all;

entity digital_parking_system is
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
end digital_parking_system;

architecture system of digital_parking_system is
type ent_states is (ENT_IDLE,ALLOC_SLOT,WAIT_ENT_PASSCODE,ENT_SUCCESS);
signal ent_current_state,ent_next_state: ent_states;

type ext_states is (EXT_IDLE,WAIT_EXT_PASSCODE,RIGHT_CODE,WRONG_CODE,EXT_SUCCESS);
signal ext_current_state,ext_next_state: ext_states;

type passcode_all is array (0 to 7) of std_logic_vector (3 downto 0);
signal saved_codes : passcode_all;
signal ent_slot,ext_slot: std_logic;
signal slot_ent_ava, slot_ext_ava, slot_ava: std_logic_vector (7 downto 0) := "00000000";
signal assign_tmp: std_logic_vector (2 downto 0);
signal red_ent_tmp, green_ent_tmp, red_ext_tmp, green_ext_tmp: std_logic;

begin --start the process

process(clk,reset_n) --to simulate the clk and reset
begin
	if(reset_n='1') then 			
		ent_current_state <= ENT_IDLE;
		ext_current_state <= EXT_IDLE;
	elsif(rising_edge(clk)) then
		ent_current_state <= ent_next_state;
		ext_current_state <= ext_next_state;
	end if;
end process;

process(ent_current_state, ent_next_state, ent_sensor, ent_set_passcode)
begin
	case ent_current_state is
		when ENT_IDLE =>
			ent_slot<='0';
			assign_tmp<="XXX";
			if ent_sensor = '1' then
				ent_next_state <= ALLOC_SLOT;
			else
				ent_next_state <= ENT_IDLE;
			end if;
		when ALLOC_SLOT =>
			slot_ent_ava<=slot_ava;
			if slot_ent_ava(0) = '0' then
				assign_tmp <= "000";
				ent_next_state <= WAIT_ENT_PASSCODE;
			elsif slot_ent_ava(1) = '0' then
				assign_tmp <= "001";
				ent_next_state <= WAIT_ENT_PASSCODE;
			elsif slot_ent_ava(2) = '0' then
				assign_tmp <= "010";
				ent_next_state <= WAIT_ENT_PASSCODE;
			elsif slot_ent_ava(3) = '0' then
				assign_tmp <= "011";
				ent_next_state <= WAIT_ENT_PASSCODE;
			elsif slot_ent_ava(4) = '0' then
				assign_tmp <= "100";
				ent_next_state <= WAIT_ENT_PASSCODE;
			elsif slot_ent_ava(5) = '0' then
				assign_tmp <= "101";
				ent_next_state <= WAIT_ENT_PASSCODE;
			elsif slot_ent_ava(6) = '0' then
				assign_tmp <= "110";
				ent_next_state <= WAIT_ENT_PASSCODE;
			elsif slot_ent_ava(7) = '0' then
				assign_tmp <= "111";
				ent_next_state <= WAIT_ENT_PASSCODE;
			else 
				assign_tmp <= "XXX";
				ent_next_state <= ENT_IDLE;
			end if;
		when WAIT_ENT_PASSCODE =>
			if ent_sensor <= '0' then
				ent_next_state <= ENT_IDLE;
			elsif ent_set_passcode = '1' and ent_sensor = '1' then
				if assign_tmp = "000" then
					saved_codes(0) <= ent_inp_passcode;
				elsif assign_tmp = "001" then
					saved_codes(1) <= ent_inp_passcode;
				elsif assign_tmp = "010" then
					saved_codes(2) <= ent_inp_passcode;
				elsif assign_tmp = "011" then
					saved_codes(3) <= ent_inp_passcode;
				elsif assign_tmp = "100" then
					saved_codes(4) <= ent_inp_passcode;
				elsif assign_tmp = "101" then
					saved_codes(5) <= ent_inp_passcode;
				elsif assign_tmp = "110" then
					saved_codes(6) <= ent_inp_passcode;
				elsif assign_tmp = "111" then
					saved_codes(7) <= ent_inp_passcode;
				end if;
				ent_next_state <= ENT_SUCCESS;
			elsif ent_set_passcode = '0' then
				ent_next_state <= WAIT_ENT_PASSCODE;
			end if;
		when ENT_SUCCESS =>
			slot_ent_ava<=slot_ava;
			if assign_tmp = "000" then
				slot_ent_ava(0)<='1';
			elsif assign_tmp = "001" then
				slot_ent_ava(1)<='1';
			elsif assign_tmp = "010" then
				slot_ent_ava(2)<='1';
			elsif assign_tmp = "011" then
				slot_ent_ava(3)<='1';
			elsif assign_tmp = "100" then
				slot_ent_ava(4)<='1';
			elsif assign_tmp = "101" then
				slot_ent_ava(5)<='1';
			elsif assign_tmp = "110" then
				slot_ent_ava(6)<='1';
			elsif assign_tmp = "111" then
				slot_ent_ava(7)<='1';
			end if;
			ent_slot <= '1';
			ent_next_state <= ENT_IDLE;
	end case;
end process;

process(ext_current_state, ext_sensor, ext_set_passcode)
begin
	case ext_current_state is
		when EXT_IDLE =>
			ext_slot<='0';
			if ext_sensor = '1' then
				ext_next_state <= WAIT_EXT_PASSCODE;
			else 
				ext_next_state <= EXT_IDLE;
			end if;
		when WAIT_EXT_PASSCODE =>
			if ext_sensor = '0' then
				ext_next_state <= EXT_IDLE;
			elsif ext_set_passcode = '1' then
				if ext_sensor_v = "000" then
					if saved_codes(0) = ext_inp_passcode then
						ext_next_state <= RIGHT_CODE;
					else
						ext_next_state <= WRONG_CODE;
					end if;
				elsif ext_sensor_v = "001" then
					if saved_codes(1) = ext_inp_passcode then
						ext_next_state <= RIGHT_CODE;
					else
						ext_next_state <= WRONG_CODE;
					end if;
				elsif ext_sensor_v = "010" then
					if saved_codes(2) = ext_inp_passcode then
						ext_next_state <= RIGHT_CODE;
					else
						ext_next_state <= WRONG_CODE;
					end if;
				elsif ext_sensor_v = "011" then
					if saved_codes(3) = ext_inp_passcode then
						ext_next_state <= RIGHT_CODE;
					else
						ext_next_state <= WRONG_CODE;
					end if;
				elsif ext_sensor_v = "100" then
					if saved_codes(4) = ext_inp_passcode then
						ext_next_state <= RIGHT_CODE;
					else
						ext_next_state <= WRONG_CODE;
					end if;
				elsif ext_sensor_v = "101" then
					if saved_codes(5) = ext_inp_passcode then
						ext_next_state <= RIGHT_CODE;
					else
						ext_next_state <= WRONG_CODE;
					end if;
				elsif ext_sensor_v = "110" then
					if saved_codes(6) = ext_inp_passcode then
						ext_next_state <= RIGHT_CODE;
					else
						ext_next_state <= WRONG_CODE;
					end if;
				elsif ext_sensor_v = "111" then
					if saved_codes(7) = ext_inp_passcode then
						ext_next_state <= RIGHT_CODE;
					else
						ext_next_state <= WRONG_CODE;
					end if;
				else
					ext_next_state <= WAIT_EXT_PASSCODE;
				end if;
			elsif ext_set_passcode = '0' then
				ext_next_state <= WAIT_EXT_PASSCODE;
			end if;
		when RIGHT_CODE =>
			ext_next_state <= EXT_SUCCESS;
		when WRONG_CODE =>
			ext_next_state <= WAIT_EXT_PASSCODE;
		when EXT_SUCCESS =>
			slot_ext_ava<=slot_ava;
			if ext_sensor_v = "000" then 
				slot_ext_ava(0) <= '0';
			elsif ext_sensor_v = "001" then
				slot_ext_ava(1) <= '0';
			elsif ext_sensor_v = "010" then
				slot_ext_ava(2) <= '0';
			elsif ext_sensor_v = "011" then
				slot_ext_ava(3) <= '0';
			elsif ext_sensor_v = "100" then
				slot_ext_ava(4) <= '0';
			elsif ext_sensor_v = "101" then
				slot_ext_ava(5) <= '0';
			elsif ext_sensor_v = "110" then
				slot_ext_ava(6) <= '0';
			elsif ext_sensor_v = "111" then
				slot_ext_ava(7) <= '0';
			end if;
			ext_slot<='1';
			ext_next_state <= EXT_IDLE;
	end case;
end process;

process(clk)
begin
	if(rising_edge(clk)) then
		case(ent_current_state) is
			when ENT_IDLE =>		--both LED turned off since no car detected
				red_ent_tmp<='0';
				green_ent_tmp<='0';
			when WAIT_ENT_PASSCODE =>	--red LED blinking to wait passcode
				red_ent_tmp<=not red_ent_tmp;
				green_ent_tmp<='0';
			when ALLOC_SLOT =>
				red_ent_tmp<='1'; --red led to show driver it is finding slots in parking
				green_ent_tmp<='0';
			when ENT_SUCCESS =>
				green_ent_tmp <= '1';
				red_ent_tmp<='0';
			when others => 		-- turn off both LED when no state is running
				red_ent_tmp<='0';
				green_ent_tmp<='0';
		end case;
		case(ext_current_state) is
			when EXT_IDLE =>
				red_ext_tmp<='0';
				green_ext_tmp<='0';
			when WAIT_EXT_PASSCODE =>	--red led blinking to wait passcode
				red_ext_tmp<=not red_ext_tmp;
				green_ext_tmp<='0';
			when RIGHT_CODE =>		-- green led lights up, code correct
				red_ext_tmp<='0';
				green_ext_tmp<='1';
			when WRONG_CODE =>		--red led lights when wrong code
				red_ext_tmp<='1';
				green_ext_tmp<='0';
			when EXT_SUCCESS =>			--green led blinks, gate open, car exit
				red_ext_tmp<='0';
				green_ext_tmp<=not green_ext_tmp;
		end case;
		if ent_slot = '1' then
			slot_ava<=slot_ent_ava;
		elsif ext_slot = '1' then
			slot_ava<=slot_ext_ava;
		end if;
	end if;
end process;
	ENT_RED_LED <= red_ent_tmp;
	ENT_GREEN_LED <= green_ent_tmp;
	EXT_RED_LED <= red_ext_tmp;
	EXT_GREEN_LED <= green_ext_tmp;
	assign_slot <= assign_tmp;
	slot_ava_disp <= slot_ava;
end system;
		