library ieee;
use ieee.std_logic_1164.all;

-- Registrador com 2 FlipFlops D
entity Register3 is 
	port (D: in std_logic_vector(1 downto 0);
			clock, reset: in std_logic;
			Q: out std_logic_vector(1 downto 0));
end Register3;

-- Metodo para resetar o Registrador
architecture Resetar of Register3 is 
begin 
	process (clock, reset)
	begin 
		if reset = '1' then
			Q <= "01";
		elsif clock'event and clock = '1' then Q<=D;
		end if;
	end process;
end Resetar;
