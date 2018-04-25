library ieee;
use ieee.std_logic_1164.all;

entity Verificador is
port (teclas: in std_logic_vector (7 downto 0)
		cs, clock, reset: in std_logic;
		modo, abre, blk: out std_logic);
end Verificador;

architecture cfr of Verificador is 
	signal a: in std_logic;
	signal s: in std_logic_vector(2 downto 0);
	signal n: out std_logic_vector(2 downto 0);
	signal K: out std_logic_vector(7 downto 0);
	
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
	entity comparador is --compara se dois vetores de 8 bits sao iguais
		port (m, n: in std_logic_vector (7 downto 0);
				c: out std_logic);
	end component;
	
	
	s := "101";
	
	abre <= clock and not s(0) and s(1) and s(2);
	blk <= clock and s(0) and not s(1) and not s(2);
	modo <= clock and s(0) and s(1);
	R8: Register8 port map (teclas, s, cs, clock, reset, K) --registrador que ira salvar a senha
	
	comp: comparador port map (teclas, K, a); -- sinal que eh igual a 1 quando a sua entrada eh igual a senha salva
	n(0) <= clock and not reset and ((not a and not s(0) and s(1) and not s(2)) or (s(0) and not s(1) and not s(2)));
	n(1) <= (not s(0) and not s(1) and s(2)) or (not reset and ((a and not s(0) and s(1) and not s(2)) or (not s(0) and s(1) and s(2)))); 
	n(2) <= not reset and (not(s(0) or s(1) or s(2)) and (a not s(0) and s(1) and not s(2)));
	R3: Register3 port map (n, clock, reset, s); -- registrador que ira mudar os estados da maquina

end cfr;