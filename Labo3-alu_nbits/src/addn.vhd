-----------------------------------------------------------------------
-- HEIG-VD, Haute Ecole d'Ingenierie et de Gestion du canton de Vaud
-- Institut REDS, Reconfigurable & Embedded Digital Systems
--
-- Fichier      : Add4_c.vhd
-- Description  : Additionneur 4 bits avec carry in & carry out
--
-- Auteur       : E. Messerli
-- Date         : 10.10.2014
-- Version      : 1.0
--
-- Utilise      : Exercice cours VHDL
--
--| Modifications |-----------------------------------------------------------
-- Ver   Auteur    Date        Description
-- 2.0    EMI      16.10.2020  Additionneur 4 bits avec carry in/out
-- 3.0   RDE & EBO 14.03.2024  Généralisation de l'additionneur pour N bits avec carry in/out
------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY addn IS
  GENERIC (N : POSITIVE RANGE 1 TO 32 := 4);
  PORT (
    nbr_a_i : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
    nbr_b_i : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
    cin_i   : IN STD_LOGIC;
    somme_o : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
    cout_o  : OUT STD_LOGIC
  ); 
END addn;

ARCHITECTURE flot_don OF addn IS

  -- signaux internes

  SIGNAL nbr_a_s : unsigned(N DOWNTO 0);
  SIGNAL nbr_b_s : unsigned(N DOWNTO 0);
  SIGNAL somme_s : unsigned(N DOWNTO 0);
  SIGNAL cin_s   : unsigned(0 DOWNTO 0);
BEGIN


  nbr_a_s <= '0' & unsigned(nbr_a_i);
  nbr_b_s <= '0' & unsigned(nbr_b_i);

  cin_s(0) <= cin_i;

  somme_s <= nbr_a_s + nbr_b_s + cin_s;

  somme_o <= STD_LOGIC_VECTOR(somme_s(N - 1 DOWNTO 0));
  cout_o  <= somme_s(N);

END flot_don;
