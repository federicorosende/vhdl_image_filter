library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.math_real.all;

entity pixel_filter_entity is
	port(
		clock_i : in std_logic;
		reset_i : in std_logic;
		pixel_i : in std_logic_vector(31 downto 0);
		valid_data_i : in std_logic;
		filtered_pixel_o : out std_logic_vector(31 downto 0);
		valid_data_o : out std_logic
	);
end entity;

architecture pixel_filter_architecture of pixel_filter_entity is

type state is (ZERO_PIXELS, ONE_PIXEL, TWO_PIXELS, THREE_PIXELS, FOUR_PIXELS, FIVE_PIXELS, SIX_PIXELS, SEVEN_PIXELS, EIGHT_PIXELS, NINE_PIXELS, ERROR_PIXELS);
signal current_filter_state: state := ZERO_PIXELS;
signal next_filter_state: state := ONE_PIXEL;

signal red_sum: unsigned(11 downto 0) := "000000000000";
signal green_sum: unsigned(11 downto 0) := "000000000000";
signal blue_sum: unsigned(11 downto 0) := "000000000000";
signal new_red: std_logic_vector(7 downto 0);
signal new_green: std_logic_vector(7 downto 0);
signal new_blue: std_logic_vector(7 downto 0);

alias red is pixel_i(31 downto 24);
alias green is pixel_i(23 downto 16);
alias blue is pixel_i(15 downto 8);
alias alpha is pixel_i(7 downto 0);

signal padding: std_logic_vector(3 downto 0) := "0000";

signal int_red_sum: integer range 0 to 2295;
signal int_green_sum: integer range 0 to 2295;
signal int_blue_sum: integer range 0 to 2295;

begin
	process(clock_i, reset_i)
	begin
		if (reset_i = '1') then
				current_filter_state <= ZERO_PIXELS;
		elsif (clock_i'event and clock_i = '1' and valid_data_i = '1') then
				current_filter_state <= next_filter_state;
		end if;
	end process;

	process(current_filter_state)
	begin 
		case current_filter_state is
			when ZERO_PIXELS => 
				next_filter_state <= ONE_PIXEL;
				red_sum <= "000000000000";
				green_sum <= "000000000000";
				blue_sum <= "000000000000";
			when ONE_PIXEL => 
				next_filter_state <= TWO_PIXELS; 
				red_sum <= unsigned(padding & red);
				green_sum <= unsigned(padding & green);
				blue_sum <= unsigned(padding & blue);
			when TWO_PIXELS => 
				next_filter_state <= THREE_PIXELS;
				red_sum <= red_sum + unsigned(padding & red);
				green_sum <= green_sum + unsigned(padding & green);
				blue_sum <= blue_sum + unsigned(padding & blue);
			when THREE_PIXELS => 
				next_filter_state <= FOUR_PIXELS;
				red_sum <= red_sum + unsigned(padding & red);
				green_sum <= green_sum + unsigned(padding & green);
				blue_sum <= blue_sum + unsigned(padding & blue);
			when FOUR_PIXELS => 
				next_filter_state <= FIVE_PIXELS;
				red_sum <= red_sum + unsigned(padding & red);
				green_sum <= green_sum + unsigned(padding & green);
				blue_sum <= blue_sum + unsigned(padding & blue);
			when FIVE_PIXELS => 
				next_filter_state <= SIX_PIXELS;
				red_sum <= red_sum + unsigned(padding & red);
				green_sum <= green_sum + unsigned(padding & green);
				blue_sum <= blue_sum + unsigned(padding & blue);
			when SIX_PIXELS => 
				next_filter_state <= SEVEN_PIXELS;
				red_sum <= red_sum + unsigned(padding & red);
				green_sum <= green_sum + unsigned(padding & green);
				blue_sum <= blue_sum + unsigned(padding & blue);
			when SEVEN_PIXELS => 
				next_filter_state <= EIGHT_PIXELS;
				red_sum <= red_sum + unsigned(padding & red);
				green_sum <= green_sum + unsigned(padding & green);
				blue_sum <= blue_sum + unsigned(padding & blue);
			when EIGHT_PIXELS => 
				next_filter_state <= NINE_PIXELS;
				red_sum <= red_sum + unsigned(padding & red);
				green_sum <= green_sum + unsigned(padding & green);
				blue_sum <= blue_sum + unsigned(padding & blue);
			when NINE_PIXELS => 
				next_filter_state <= ONE_PIXEL;
				red_sum <= red_sum + unsigned(padding & red);
				green_sum <= green_sum + unsigned(padding & green);
				blue_sum <= blue_sum + unsigned(padding & blue);
			when others => 
				next_filter_state <= ERROR_PIXELS;
		end case;
	end process;

	int_red_sum <= to_integer(red_sum);
  	rdu: entity work.divider_entity 
		port map (
			dividend => int_red_sum,
			quotient => new_red
		);

	int_green_sum <= to_integer(green_sum);
  	gdu: entity work.divider_entity 
		port map (
			dividend => int_green_sum,
			quotient => new_green
		);

	int_blue_sum <= to_integer(blue_sum);
  	bdu: entity work.divider_entity 
		port map (
			dividend => int_blue_sum,
			quotient => new_blue
		);

	valid_data_o <= '1' when (current_filter_state = NINE_PIXELS) else '0';
	filtered_pixel_o <= std_logic_vector(new_red) & std_logic_vector(new_green) & std_logic_vector(new_blue) & alpha;
end architecture;