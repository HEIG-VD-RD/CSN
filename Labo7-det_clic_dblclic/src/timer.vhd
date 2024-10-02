-------------------------------------------------------------------------------
-- HEIG-VD, Haute Ecole d'Ingenierie et de Gestion du canton de Vaud
-- Institut REDS, Reconfigurable & Embedded Digital Systems
--
-- Fichier      : timer.vhd
-- Auteur       : Etienne Messerli, le 05.05.2016
-- 
-- Description  : Detection d'un clic et double clic
--                Projet repris du labo Det_Clic_DblClic 2012
-- 
-- Utilise      : Labo SysLog2 2016
--| Modifications |------------------------------------------------------------
-- Ver   Date      Qui         Description
-- 1.0   05.05.16  EMI         version initiale
-- 1.1   19.11.20  SMS         remplacement des constantes par des génériques
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity timer is
    generic (
        T1_g : natural range 1 to 1023 := 2;
        T2_g : natural range 1 to 1023 := 3 );
    port (
        clock_i    : in  std_logic;
        reset_i    : in  std_logic;
        start_i    : in  std_logic;
        top_ms_i   : in  std_logic;
        trigger1_o : out std_logic;
        trigger2_o : out std_logic
        );
end timer;

architecture comport of timer is

  ----------
  -- TODO --
  ----------
  
  -- Declaration des signaux internes
  signal etat_fut : unsigned(10 downto 0);
  signal etat_pres : unsigned(10 downto 0);
  signal Q_incr : unsigned(10 downto 0);


begin


  ----------
  -- TODO --
  ----------
  
  
  -- Multiplexeur pour etat_fut 

    etat_fut <= (others => '0' ) when start_i = '1' else 
    Q_incr when top_ms_i = '1'  else
    etat_pres;

  process(clock_i, reset_i)
    begin
      if reset_i = '0' then
        etat_pres <= (others => '0');
      elsif rising_edge(clock_i) then
        etat_pres <= etat_fut;
      end if;
  end process;

  -- Incrémentation de l'état
  Q_incr <= etat_pres + 1;


  -- Detection des triggers 
  -- trigger1 pour le simple clic donc est actif quand T1 = T1_g est atteint
  trigger1_o <= '1' when etat_pres =  to_unsigned(T1_g, etat_pres'length)  else '0';
  -- trigger2 pour le double clic donc est actif quand T2 = T2_g est atteint
  trigger2_o <= '1' when etat_pres = to_unsigned(T2_g, etat_pres'length) else '0';


end comport;
