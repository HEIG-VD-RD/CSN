-------------------------------------------------------------------------------
-- HEIG-VD, Haute Ecole d'Ingenierie et de Gestion du canton de Vaud
-- Institut REDS, Reconfigurable & Embedded Digital Systems
--
-- Fichier      : alu_nbits_top.vhd
--
-- Description  : ALU N bits comportant 6 fonctions arithmetiques et 
--                2 fonctions logique
-- 
-- Auteur       : Etienne Messerli
-- Date         : 20.03.2018 (version labo ALU 2018)
-- Version      : 0.0
-- 
--| Modifications |------------------------------------------------------------
-- Version  Date   Auteur     Description
--
-------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY alu_nbits_top IS
  GENERIC (N : POSITIVE RANGE 1 TO 16 := 6);
  PORT (
    opcode_i : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    na_i : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
    nb_i : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
    result_o : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
    z_o : OUT STD_LOGIC;
    dep_nsgn_o : OUT STD_LOGIC;
    dep_sgn_o : OUT STD_LOGIC
  );
END alu_nbits_top;
ARCHITECTURE struct OF alu_nbits_top IS

  -- TO COMPLETE: Internal signals

  SIGNAL na_s, nb_s, and_s, or_s, mult_s, result_s : STD_LOGIC_VECTOR(N - 1 DOWNTO 0);

  ------------------------------------------------------------------------
  SIGNAL sub1_s, sub2_s, inc_s, cin_s, SUB : STD_LOGIC;
  SIGNAL n_MUX_sub1_s, n_MUX_sub2_s, n_MUX_inc_s, result_add_s : STD_LOGIC_VECTOR(N - 1 DOWNTO 0);

  SIGNAL ovr_s, cout_s : STD_LOGIC;
  ------------------------------------------------------------------------

  -- TO COMPLETE: Component Declaration
  COMPONENT addn_full IS
    GENERIC (N : POSITIVE RANGE 1 TO 16 := 6);
    PORT (
      nbr_a_i : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
      nbr_b_i : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
      cin_i : IN STD_LOGIC;
      somme_o : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
      cout_o : OUT STD_LOGIC;
      ovr_o : OUT STD_LOGIC
    );
  END COMPONENT;
  FOR ALL : addn_full USE ENTITY work.addn_full(struct);

BEGIN -- Struct

  -- TO COMPLETE: Implementation
  -- Affectation des signaux internes
  na_s <= na_i;
  nb_s <= nb_i;

  -- And and Or operation
  and_s <= na_s AND nb_s;
  or_s <= na_s OR nb_s;

  ------------------------------------------------------------------------
  -- Add entry selection
  sub1_s <= '1' WHEN opcode_i = "010" ELSE
    '0'; --sub1 = na - nb
  sub2_s <= '1' WHEN opcode_i = "011" ELSE
    '0'; --sub2 = nb - na
  inc_s <= '1' WHEN opcode_i = "100" ELSE
    '0';

  SUB <= sub1_s XOR sub2_s;
  cin_s <= SUB XOR inc_s; --selection de Cn entrant dans l'additionneur

  WITH sub1_s SELECT -- MUX correspondant à na - nb
    n_MUX_sub1_s <= nb_s WHEN '0',
    NOT(nb_s) WHEN '1',
    (OTHERS => 'X') WHEN OTHERS;

  WITH sub2_s SELECT -- MUX correspondant à nb - na
    n_MUX_sub2_s <= na_s WHEN '0',
    NOT(na_s) WHEN '1',
    (OTHERS => 'X') WHEN OTHERS;
  WITH inc_s SELECT -- MUX correspondant à l'incrémentation
    n_MUX_inc_s <= n_MUX_sub1_s WHEN '0',
    (OTHERS => '0') WHEN '1',
    (OTHERS => 'X') WHEN OTHERS;

  --Add component

  add : addN_full
  GENERIC MAP(N => N)
  PORT MAP(
    nbr_a_i => n_MUX_sub2_s(N - 1 DOWNTO 0),
    nbr_b_i => n_MUX_inc_s(N - 1 DOWNTO 0),
    cin_i => cin_s,
    somme_o => result_add_s(N - 1 DOWNTO 0),
    cout_o => cout_s,
    ovr_o => ovr_s
  );

  ------------------------------------------------------------------------

  -- Multiplication
  mult_s <= na_s(N - 2 DOWNTO 0) & '0';
  WITH opcode_i SELECT
    result_s <=
    result_add_s WHEN "000", -- Addtion
    mult_s WHEN "001", -- Multiplication * 2
    result_add_s WHEN "010", -- na - nb
    result_add_s WHEN "011", -- nb - na
    result_add_s WHEN "100", -- Incrémentation
    na_s WHEN "101", -- na
    and_s WHEN "110", -- na and nb
    or_s WHEN "111", -- na or nb
    (OTHERS => 'X') WHEN OTHERS; --	

  -- Result is 0
  z_o <= '1' WHEN unsigned(result_s) = 0 ELSE
    '0';

  result_o <= result_s;
  WITH opcode_i SELECT
    dep_nsgn_o <=
    cout_s WHEN "000",
    na_s(N - 1) WHEN "001",
    (NOT cout_s) WHEN "010",
    (NOT cout_s) WHEN "011",
    cout_s WHEN "100",
    '0' WHEN OTHERS;

  WITH opcode_i SELECT
    dep_sgn_o <= na_s(N - 1) XOR (na_s(N - 2)) WHEN "001",
    '0' when "101",
    ovr_s WHEN OTHERS;

END struct;