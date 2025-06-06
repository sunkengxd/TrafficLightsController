library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity TrafficLightsController is
	port (
		clk      : in  std_logic;
		reset    : in  std_logic;

		l1_green  : out std_logic;
		l1_yellow : out std_logic;
		l1_red    : out std_logic;

		l2_green  : out std_logic;
		l2_yellow : out std_logic;
		l2_red    : out std_logic
	);
end TrafficLightsController;

architecture TrafficLightsControllerArch of TrafficLightsController is

	constant TIMINGS : integer_vector(0 to 3) := (30, 10, 20, 10);

	signal l1_counter : integer := 0;
	signal l2_counter : integer := 0;

	begin
		process(all)
		begin
			if reset = '1' then
				l1_counter <= 0;
			elsif rising_edge(clk) then
				l1_counter <= l1_counter + 1;
				l2_counter <= l1_counter + 1 + TIMINGS(0);
			end if;
		end process;

		light1: entity work.TrafficLight
			generic map (
				GREEN_TIME      => TIMINGS(0),
				YELLOW_TIME     => TIMINGS(1),
				RED_TIME        => TIMINGS(2),
				RED_YELLOW_TIME => TIMINGS(3)
			)
			port map (
				reset        => reset,
				counter      => l1_counter,
				light_green  => l1_green,
				light_yellow => l1_yellow,
				light_red    => l1_red
			);

		light2: entity work.TrafficLight
			generic map (
				GREEN_TIME      => TIMINGS(2),
				YELLOW_TIME     => TIMINGS(3),
				RED_TIME        => TIMINGS(0),
				RED_YELLOW_TIME => TIMINGS(1)
			)
			port map (
				reset        => reset,
				counter      => l2_counter,
				light_green  => l2_green,
				light_yellow => l2_yellow,
				light_red    => l2_red
			);
end TrafficLightsControllerArch;
