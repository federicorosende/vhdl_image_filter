library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.math_real.all;

entity pixel_filter_test_bench_entity is
end entity;

architecture pixel_filter_test_bench_architecture of pixel_filter_test_bench_entity is 

	--Inputs
	signal clock : std_logic := '1';
	signal reset: std_logic := '0';
	signal pixel : std_logic_vector(31 downto 0);
	signal valid_input_data : std_logic;

	--Outputs
	signal filtered_pixel : std_logic_vector(31 downto 0);
	signal valid_output_data : std_logic;

	-- Clock period definitions
	constant clk_period : time := 1000 ms;

	begin
		clk_process : process
			begin

		pixel <= "10010110010010100011100111111111";
		clock <= '0';
		wait for clk_period/2;
		clock <= '1';
		wait for clk_period/2;

		pixel <= "00001111000111000010110011111111";
		clock <= '0';
		wait for clk_period/2;
		clock <= '1';
		wait for clk_period/2;

		pixel <= "01000001010001100100101011111111";
		clock <= '0';
		wait for clk_period/2;
		clock <= '1';
		wait for clk_period/2;

		pixel <= "01010111011110001000110011111111";
		clock <= '0';
		wait for clk_period/2;
		clock <= '1';
		wait for clk_period/2;

		pixel <= "00101011001110000100100111111111";
		clock <= '0';
		wait for clk_period/2;
		clock <= '1';
		wait for clk_period/2;

		pixel <= "01100100000011010001111111111111";
		clock <= '0';
		wait for clk_period/2;
		clock <= '1';
		wait for clk_period/2;

		pixel <= "01100001001110100011010111111111";
		clock <= '0';
		wait for clk_period/2;
		clock <= '1';
		wait for clk_period/2;

		pixel <= "00001100000001100100000111111111";
		clock <= '0';
		wait for clk_period/2;
		clock <= '1';
		wait for clk_period/2;

		pixel <= "01010101001010010001011111111111";
		clock <= '0';
		wait for clk_period/2;
		clock <= '1';
		wait for clk_period/2;
		pixel <= "00001100000001100100000111111111";
		clock <= '0';
		wait for clk_period/2;
		clock <= '1';
		wait for clk_period/2;

		pixel <= "00101011001110000100100111111111";
		clock <= '0';
		wait for clk_period/2;
		clock <= '1';
		wait for clk_period/2;

		pixel <= "10010110010010100011100111111111";
		clock <= '0';
		wait for clk_period/2;
		clock <= '1';
		wait for clk_period/2;

		pixel <= "01100100000011010001111111111111";
		clock <= '0';
		wait for clk_period/2;
		clock <= '1';
		wait for clk_period/2;

		pixel <= "01100001001110100011010111111111";
		clock <= '0';
		wait for clk_period/2;
		clock <= '1';
		wait for clk_period/2;

		pixel <= "01010101001010010001011111111111";
		clock <= '0';
		wait for clk_period/2;
		clock <= '1';
		wait for clk_period/2;

		pixel <= "00001111000101010001110011111111";
		clock <= '0';
		wait for clk_period/2;
		clock <= '1';
		wait for clk_period/2;

		pixel <= "00000000000000110000010011111111";
		clock <= '0';
		wait for clk_period/2;
		clock <= '1';
		wait for clk_period/2;

		pixel <= "00000000000000000000000011111111";
		clock <= '0';
		wait for clk_period/2;
		clock <= '1';
		wait for clk_period/2;



		clock <= '0';

		wait;
	end process;

	reset <= '0';
	valid_input_data <= '1';

	pfe : entity work.pixel_filter_entity
	port map (
		clock_i => clock,
		reset_i => reset,
		pixel_i => pixel,
		valid_data_i => valid_input_data,
		filtered_pixel_o => filtered_pixel,
		valid_data_o => valid_output_data
	);
end architecture;