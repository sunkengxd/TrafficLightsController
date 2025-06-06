library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity TrafficLight is
	generic (
		GREEN_TIME      : integer;
		YELLOW_TIME     : integer;
		RED_TIME        : integer;
		RED_YELLOW_TIME : integer
	);
	port (
		counter : in integer;
		reset   : in std_logic;
		light_green  : out std_logic;
		light_yellow : out std_logic;
		light_red    : out std_logic
	);
end TrafficLight;

architecture Behavioral of TrafficLight is

	type TrafficState is (GREEN, YELLOW, RED, RED_YELLOW);

	constant GREEN_END  : integer := GREEN_TIME;
	constant YELLOW_END : integer := GREEN_END + YELLOW_TIME;
	constant RED_END    : integer := YELLOW_END + RED_TIME;
	constant TOTAL_TIME : integer := RED_END + RED_YELLOW_TIME;

	signal state         : TrafficState := RED;
	signal state_counter : integer := 0;
begin

	overflow_handler_process : process(all)
	begin
		if reset = '1' then
			state_counter <= 0;
		else
			state_counter <= counter mod TOTAL_TIME;
		end if;
	end process;

	counter_reducer_process : process(state_counter)
	begin
		if state_counter < GREEN_END then
			state <= GREEN;
		elsif state_counter < YELLOW_END then
			state <= YELLOW;
		elsif state_counter < RED_END then
			state <= RED;
		else
			state <= RED_YELLOW;
		end if;
	end process;

	state_reducer_process : process(state)
	begin

		light_green  <= '0';
		light_red    <= '0';
		light_yellow <= '0';

		case state is
			when GREEN      => light_green  <= '1';
			when RED        => light_red    <= '1';
			when YELLOW     => light_yellow <= '1';
			when RED_YELLOW =>
				light_red    <= '1';
				light_yellow <= '1';
		end case;
	end process;

end Behavioral;
