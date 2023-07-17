library ieee;
use ieee.std_logic_1164.all;

entity divider_entity IS
  port ( 
    dividend: in integer range 0 to 2295;
    quotient: out std_logic_vector (7 downto 0)
  );
end divider_entity;

architecture divider_architecture of divider_entity is
begin
	process (dividend)
		variable temp1: integer range 0 to 2295;
		begin
			temp1 := dividend;
			for i in 7 downto 0 loop
				if(temp1 >= 9 * 2**i) then
					quotient(i) <= '1';
					temp1 := temp1 - 9 * 2**i;
				else 
					quotient(i) <= '0';
				end if;
			end loop;
	end process;
end architecture;