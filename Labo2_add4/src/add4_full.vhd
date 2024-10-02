-----------------------------------------------------------------------
-- HEIG-VD, Haute Ecole d'Ingenierie et de Gestion du canton de Vaud
-- Institut REDS, Reconfigurable & Embedded Digital Systems
--
-- Fichier      : add4_full.vhd
-- Description  : Additionneur 4 bits avec carry in,
--                carry out et overflow out
--
-- Auteur       : E. Messerli
-- Date         : 10.10.2014
-- Version      : 1.0
--
-- Utilise      : Exercice cours VHDL
--
--| Modifications |-----------------------------------------------------------
-- Ver   Auteur Date         Description
-- 2.0    EMI   27-03-2019   Version additionneur avec c_in, c_out et ovr_out
--
------------------------------------------------------------------------------

library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity add4_full is
  port (nbr_a_i    : in  std_logic_Vector(3 downto 0);
        nbr_b_i    : in  std_logic_Vector(3 downto 0);
        cin_i      : in  std_logic;
        somme_o    : out std_logic_Vector(3 downto 0);
        cout_o     : out std_Logic;
        ovr_o      : out std_logic  );
end add4_full;

architecture struct of add4_full is

  -- signaux internes
  signal cout_1_s : std_logic;
  signal cout_s : std_logic;
  signal somme_3b_s : std_logic_Vector(2 downto 0);
  signal somme_1b_s : std_logic_Vector(0 downto 0);

  --component declaration
  component addn is
  generic( N : Positive range 1 to 32 := 4);
  port (nbr_a_i   : in  std_logic_Vector(N-1 downto 0);
        nbr_b_i   : in  std_logic_Vector(N-1 downto 0);
        cin_i     : in  std_logic;
        somme_o   : out std_logic_Vector(N-1 downto 0);
        cout_o     : out std_Logic
        );
   end component;
   for all : addn use entity work.addn(flot_don);  
  
begin

	add3: addn
	generic map(N => 3)
	port map(nbr_a_i => nbr_a_i(2 downto 0),
		 nbr_b_i => nbr_b_i(2 downto 0),
		 cin_i => cin_i,
		 somme_o => somme_3b_s(2 downto 0),
		 cout_o => cout_1_s
	);

	add1 : addn
	generic map(N => 1)
	port map( nbr_a_i => nbr_a_i(3 downto 3),
		 nbr_b_i => nbr_b_i(3 downto 3),
		 cin_i => cout_1_s,
		 somme_o => somme_1b_s,
		 cout_o => cout_s
	);
	
	somme_o <= somme_1b_s & somme_3b_s;
	cout_o <= cout_s;
	ovr_o <= cout_1_s xor cout_s;


end struct;
