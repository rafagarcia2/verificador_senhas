library ieee;
use ieee.std_logic_1164.all;

-- Registrador para teclas
entity Register8 is 
	port (Z: in std_logic_vector(7 downto 0);
			estado: in std_logic_vector(2 downto 0);
			cs, clock, reset: in std_logic;
			W: out std_logic_vector(7 downto 0));
end Register8;

-- Metodo para resetar o Registrador
architecture resetar of Register8 is 
begin 
	process (clock, reset, cs)
	begin 
		if reset = '1' then 
			W<= "00000000";
		elsif clock'event and clock = '1' 
			and cs='0' and estado="010" then W<=Z;
		end if;
	end process;
end resetar;
