-------------------------------------------------------------------------------
-- HEIG-VD, Haute Ecole d'Ingenierie et de Gestion du canton de Vaud
-- Institut REDS, Reconfigurable & Embedded Digital Systems
--
-- Fichier      : latch_en.vhd
--
-- Description  : 
-- 
-- Auteur       : Etienne Messerli
-- Date         : 22.10.2014
-- Version      : 0.0
-- 
-- Utilise      : Exercice de description d'elements memoire
--                en VHDL synthetisable
-- 
--| Modifications |------------------------------------------------------------
-- Version   Auteur Date               Description
-- 
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity latch_en is
   port( 
      en_i   : in     std_logic;
      reset_i : in     std_logic;
      D_i     : in     std_logic;
      Q_o     : out    std_logic
   );
end latch_en ;

architecture comport of latch_en is

   signal Q_s : std_logic;

begin

  process( en_i, reset_i, D_i   )   -- a completer ...
  begin
   if reset_i = '1' then
      Q_s <= '0';
   elsif en_i = '1' then
      Q_s <= D_i;
   end if;
  
  end process;

 Q_o <= Q_s;
  
end comport;

