Library ieee;
use ieee.std_logic_1164.all;

-- Registrador para teclas de senhas
Entity Comparador IS
Port (teclas1, teclas2: IN std_logic_vector (7 downto 0);
		clock: in std_logic;
		estado: in std_logic_vector(2 downto 0);
		resultado: OUT std_logic);
END Comparador;

-- Compara as duas senhas teclas1 e teclas2
Architecture comparar of Comparador is
BEGIN
	Process(estado)
	BEGIN
		if (teclas1 = teclas2) and estado = "010" and clock then 
			resultado <= '1';
		else 
			resultado <= '0';
		end if;
	END Process;
END comparar;