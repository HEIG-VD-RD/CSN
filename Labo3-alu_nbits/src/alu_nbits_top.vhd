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
-- Ver   Auteur      Date            Description
-- 1.0   RDE & EBO   14.03.2024      Implémentation de l'ALU
--
-------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY alu_nbits_top IS
  GENERIC (N : POSITIVE RANGE 1 TO 16 := 4);
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

  SIGNAL na_s : STD_LOGIC_VECTOR(N - 1 DOWNTO 0); --  
  SIGNAL nb_s : STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
  SIGNAL mult_s : STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
  SIGNAL result_s : STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
  SIGNAL Pin_s : STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
  SIGNAL Qin_s : STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
  SIGNAL Qin_int_s : STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
  SIGNAL result_add_s : STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
  SIGNAL porte_s : STD_LOGIC_VECTOR(N - 1 DOWNTO 0);

  SIGNAL ovr_s : STD_LOGIC;
  SIGNAL cout_s : STD_LOGIC;
  SIGNAL cin_s : STD_LOGIC;

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

  -- Sélection de l'entrée 'P' de l'additioneur
  WITH NOT (opcode_i(1) AND opcode_i(0)) SELECT
  Pin_s <= nb_i WHEN '0',
           na_i WHEN '1',
           (OTHERS => 'X') WHEN OTHERS;

  -- Sélection de l'entrée 'Q' de l'additioneur
  -- Sélection intermédiaire 
  Qin_int_s <= nb_i WHEN opcode_i(0) = '0' ELSE
               na_i;
  Qin_s <= (OTHERS => '0') WHEN opcode_i(2) = '1' ELSE
            Qin_int_s      WHEN opcode_i(1) = '0' ELSE
            NOT Qin_int_s;

  -- Sélection du carry d'entré de l'additionneur
  cin_s <= opcode_i(1) OR (opcode_i(2) AND NOT opcode_i(0));

  -- Instanciation de l'élément additionneur
  add : addN_full
  GENERIC MAP(N => N)
  PORT MAP(
    nbr_a_i => Pin_s,
    nbr_b_i => Qin_s,
    cin_i => cin_s,
    somme_o => result_add_s(N - 1 DOWNTO 0),
    cout_o => cout_s,
    ovr_o => ovr_s
  );

  -- Résultat final des opérations effectué dans l'additionneur 
  result_s <= porte_s WHEN (opcode_i(2) AND opcode_i(1)) = '1' ELSE
              result_add_s;
  result_o <= result_s;

  -- Résultat des opérations logique OR et AND 
  porte_s <= (na_i OR nb_i) WHEN opcode_i(0) = '1' ELSE
             (na_i AND nb_i);

  -- Le résultat vaut 0
  z_o <= '1' WHEN unsigned(result_s) = 0 ELSE
    '0';

  -- Dépassement pour les signés  
  dep_sgn_o <= ovr_s;

  -- Dépassement pour les non signés
  dep_nsgn_o <= (NOT cout_s) WHEN opcode_i(1) = '1' ELSE
                cout_s;

END struct;