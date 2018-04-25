library ieee;
use ieee.std_logic_1164.all;

-- Registrador para teclas de senhas
entity Comparador is
port (teclas1, teclas2: in std_logic_vector (7 downto 0);
		resultado: out std_logic);
end Comparador;

-- Compara as duas senhas teclas1 e teclas2
architecture comparar of Comparador is
begin
	process
	begin 
		if teclas1 = teclas2 
			then resultado <= '1';
		elsif resultado <= '0';
		end if;
	end process;
end comparar;