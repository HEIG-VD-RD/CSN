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
-- Ver   Auteur  Date        Description
-- 2.0    EMI    16.10.2020  Additionneur 4 bits avec carry in/out
--
------------------------------------------------------------------------------

library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity add4 is
  port (nbr_a_i   : in  std_logic_Vector(3 downto 0);
        nbr_b_i   : in  std_logic_Vector(3 downto 0);
        cin_i     : in  std_logic;
        somme_o   : out std_logic_Vector(3 downto 0);
        cout_o     : out std_Logic
        );
end add4;

architecture flot_don of add4 is

  -- signaux internes
   	
   signal nbr_a_s, nbr_b_s : unsigned(4 downto 0);
   signal somme_s : unsigned(4 downto 0); 
   signal cin_s : unsigned(0 downto 0); -- Car vecteur 1
begin

  --Nous souhaitons réaliser l'operation suivante:
  
  nbr_a_s <=  '0' & unsigned(nbr_a_i);
  nbr_b_s <=  '0' & unsigned(nbr_b_i);
  -- cin_s <= to_unsigned(cin_i, 1); Ne va pas marcher
  -- cin_s = unsigned(cin_i); ne va pas marcher
  cin_s(0) <= cin_i;

  somme_s <=  nbr_a_s +  nbr_b_s + cin_s ; 
  
  --A modifier ...
  
  somme_o <= std_logic_vector(somme_s(3 downto 0));
  cout_o <= somme_s(4);

end flot_don;
