-------------------------------------------------------------------------------
-- HEIG-VD, Haute Ecole d'Ingenierie et de Gestion du canton de Vaud
-- Institut REDS, Reconfigurable & Embedded Digital Systems
--
-- Fichier      : flipflop_t.vhd
-- Description  : Flip-flop T (toggle) soit 
--                  si T_i actif alors Q+ = not Q sinon Q+ = Q
-- 
-- Auteur       : Etienne Messerli,  2.10.2014
-- 
-- Utilise      : Exos description d'elements memoire en VHDL synthetisable
--| Modifications |------------------------------------------------------------
-- Vers.  Qui   Date         Description
-- 1.0    EMI  03.04.2019    Change nom entite/fichier => flipflop_t
--
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity flipflop_t is
   port(clk_i    : in     std_logic;
        reset_i  : in     std_logic;
        T_i      : in     std_logic;
        Q_o      : out    std_logic
   );
end flipflop_t ;


architecture comport of flipflop_t is
  signal reset_s : std_logic;
  signal Q_s     : std_logic;
  signal D_s     : std_logic;
begin
  --Adaptation polarite
  reset_s <= reset_i;
  
  D_s <= not Q_s when T_i = '1' else Q_s;

  
  process(reset_s, clk_i)
  begin
    if reset_s = '1' then
      Q_s <= '0';
    elsif rising_edge(clk_i) then
      Q_s <= D_s;
    end if;
  
  end process;


  Q_o <= Q_s;

end comport;
