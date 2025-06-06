library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity TrafficLightsControllerTestbench is

end TrafficLightsControllerTestbench;

architecture Behavioral of TrafficLightsControllerTestbench is

	signal clk       : std_logic := '0';
	signal reset     : std_logic := '0';
	signal l1_green  : std_logic;
	signal l1_yellow : std_logic;
	signal l1_red    : std_logic;
	signal l2_green  : std_logic;
	signal l2_yellow : std_logic;
	signal l2_red    : std_logic;

	constant CLK_PERIOD : time := 1 sec;

	begin

	uut: entity work.TrafficLightsController
		port map (
			clk       => clk,
			reset     => reset,
			l1_green  => l1_green,
			l1_yellow => l1_yellow,
			l1_red    => l1_red,
			l2_green  => l2_green,
			l2_yellow => l2_yellow,
			l2_red    => l2_red
	);

	clk_process : process
	begin
		while True loop
			clk <= '0';
			wait for CLK_PERIOD / 2;
			clk <= '1';
			wait for CLK_PERIOD / 2;
		end loop;
	end process;

	stimulus_process : process
	begin
		--reset <= '1';
		--wait for 2 * CLK_PERIOD;
		reset <= '0';

		wait for 140 * CLK_PERIOD;

		wait;
	end process;

end Behavioral;
