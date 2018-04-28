Library ieee;
use ieee.std_logic_1164.all;

Entity Verificador IS
port (teclas: IN std_logic_vector (7 downto 0);
		cs, clock, reset : IN std_logic;
		modo, abre, broqueado : OUT std_logic);
end Verificador;

Architecture config OF Verificador IS
	signal res: std_logic; -- Resultado da Verificacao
	signal s: std_logic_vector(2 downto 0) :="000"; -- Estado anteior da maquina
	signal aux: std_logic; -- Sinal para auxiliar a verificacao dos estados
	signal estado: std_logic_vector(2 downto 0); -- Novo estado da maquina
	signal pw: std_logic_vector(7 downto 0); -- Senha Digitada

	-- Compara as duas senhas
	component Comparador is
		port (teclas1, teclas2: IN std_logic_vector (7 downto 0);
				clock: in std_logic;
				estado: IN std_logic_vector(2 downto 0);
				resultado: OUT std_logic);
	end component;
	
	-- Registrador para estados
	component Register3 is
		port (D: in std_logic_vector(2 downto 0);
				clock, reset: in std_logic;
				Q: out std_logic_vector(2 downto 0));
	end component;

	-- Registrador para teclas
	component Register8 is
		port (teclas: in std_logic_vector(7 downto 0);
				estado: in std_logic_vector(2 downto 0);
				cs, clock, reset: in std_logic;
				senha: out std_logic_vector(7 downto 0));
	end component;
	
	BEGIN

		abre <= not (s(1) and s(2) and not s(0));
		broqueado <= not s(0) and not s(1) and s(2);
		modo <= s(2) or s(1);

		-- pw = nova senha digitada
		senha_r8 : Register8 port map (teclas, s, cs, clock, reset, pw); --registrador que ira salvar a senha

		-- sinal que eh igual a 1 quando a sua entrada eh igual a senha salva
		comparar : Comparador port map (teclas, pw, clock, estado, res); -- res = resultado da verificacao

		-- Preenchendo o estado da maquina
		aux <= not s(0) and s(1) and not s(2); -- Verifica se o estado eh config

		estado(0) <= cs and not reset and ((not res and aux) or (not (s(0) or s(1) or s(2))));
		--estado(1) <= cs and ((not s(0) and not s(1) and s(2)) or (not reset and ((res and aux) or (not s(0) and s(1) and s(2)))));
		estado(1) <= ((s(1) and not reset and not s(2)) and ((not s(0) or s(1) or s(2)) or (res and not s(2) and s(1) and not s(0))));
		--estado(2) <= (not reset nor s(0)) and not(s(0) or s(1) or s(2)) and res and aux;
		estado(2) <= (not reset and not s(0)) and ((s(1) and not s(2) and not res and cs) or (not s(1) and s(2)));

		-- registrador que ira mudar os estados da maquina
		estados_r3: Register3 port map (estado, clock, reset, s);

END config;
