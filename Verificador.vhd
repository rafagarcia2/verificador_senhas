Library ieee;
use ieee.std_logic_1164.all;

Entity Verificador IS
port (teclas: IN std_logic_vector (7 downto 0);
		cs, clock, reset : IN std_logic;
		modo, abre, broqueado : OUT std_logic);
end Verificador;

Architecture config OF Verificador IS
	signal a: std_logic;
	signal s: std_logic_vector(2 downto 0);
	signal estado: std_logic_vector(2 downto 0);
	signal K: std_logic_vector(7 downto 0);
	
	component Register3 is  --registrador de 3 bits
		port (D: in std_logic_vector(2 downto 0);
				clock, reset: in std_logic;
				Q: out std_logic_vector(2 downto 0));
	end component;

	component Register8 is  --registrador de 8 bits
		port (Z: in std_logic_vector(7 downto 0);
				estado: in std_logic_vector(2 downto 0);
				cs, clock, reset: in std_logic;
				W: out std_logic_vector(7 downto 0));
	end component;

	component Comparador is --compara se dois vetores de 8 bits sao iguais
		port (teclas1, teclas2: IN std_logic_vector (7 downto 0);
				c: OUT std_logic);
	end component;
	
	
	BEGIN
	--s <= "000";
	abre <= clock and not s(0) and s(1) and s(2);
	broqueado <= clock and s(0) and not s(1) and not s(2);
	modo <= clock and s(0) and s(1);
	senha_r8 : Register8 port map (teclas, s, cs, clock, reset, K); --registrador que ira salvar a senha
	
	-- sinal que eh igual a 1 quando a sua entrada eh igual a senha salva
	comparar: Comparador port map (teclas, K, a);
	
	-- Preenchendo o estado da maquina
	estado(0) <= clock and not reset and ((not a and not s(0) and s(1) and not s(2)) or (s(0) and not s(1) and not s(2)));
	estado(1) <= (not s(0) and not s(1) and s(2)) or (not reset and ((a and not s(0) and s(1) and not s(2)) or (not s(0) and s(1) and s(2))));
	estado(2) <= not reset and (not(s(0) or s(1) or s(2)) and (a and not s(0) and s(1) and not s(2)));
	-- registrador que ira mudar os estados da maquina
	estados_r3: Register3 port map (estado, clock, reset, s);

END config;