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
-- Ver   Auteur     Date         Description
-- 2.0    EMI       27-03-2019   Version additionneur avec c_in, c_out et ovr_out
-- 3.0   RDE & EBO  14.03.2024   Adaptation en générique pour N bits
------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY addN_full IS
  GENERIC (N : POSITIVE RANGE 1 TO 32 := 4);
  PORT (
    nbr_a_i : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
    nbr_b_i : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
    cin_i   : IN STD_LOGIC;
    somme_o : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
    cout_o  : OUT STD_LOGIC;
    ovr_o   : OUT STD_LOGIC);
END addN_full;

ARCHITECTURE struct OF addN_full IS

  -- signaux internes
  SIGNAL cout_1_s    : STD_LOGIC;
  SIGNAL cout_s      : STD_LOGIC;
  SIGNAL somme_MSB_s : STD_LOGIC_VECTOR(N - 2 DOWNTO 0);
  SIGNAL somme_1b_s  : STD_LOGIC_VECTOR(0 DOWNTO 0);

  --component declaration
  COMPONENT addn IS
    GENERIC (N : POSITIVE RANGE 1 TO 32 := 4);
    PORT (
      nbr_a_i : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
      nbr_b_i : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
      cin_i   : IN STD_LOGIC;
      somme_o : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
      cout_o  : OUT STD_LOGIC
    );
  END COMPONENT;
  FOR ALL : addn USE ENTITY work.addn(flot_don);

BEGIN

  addNm1 : addn
  GENERIC MAP(N => N - 1)
  PORT MAP(
    nbr_a_i => nbr_a_i(N - 2 DOWNTO 0),
    nbr_b_i => nbr_b_i(N - 2 DOWNTO 0),
    cin_i   => cin_i,
    somme_o => somme_MSB_s(N - 2 DOWNTO 0),
    cout_o  => cout_1_s
  );

  add1 : addn
  GENERIC MAP(N => 1)
  PORT MAP(
    nbr_a_i => nbr_a_i(N - 1 DOWNTO N - 1),
    nbr_b_i => nbr_b_i(N - 1 DOWNTO N - 1),
    cin_i   => cout_1_s,
    somme_o => somme_1b_s,
    cout_o  => cout_s
  );

  somme_o <= somme_1b_s & somme_MSB_s;
  cout_o <= cout_s;
  ovr_o <= cout_1_s XOR cout_s;

END struct;
