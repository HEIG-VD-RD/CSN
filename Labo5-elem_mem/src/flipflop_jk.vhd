-------------------------------------------------------------------------------
-- HEIG-VD, Haute Ecole d'Ingenierie et de Gestion du canton de Vaud
-- Institut REDS, Reconfigurable & Embedded Digital Systems
--
-- Fichier      : flipflop_jk.vhd
-- Auteur       : Etienne Messerli,  20.04.2017
-- Description  : Flip-flop JK
-- 
-- 
-- Utilise      : Exos description d'elements memoire en VHDL synthetisable
--| Modifications |------------------------------------------------------------
-- Vers.  Qui   Date         Description
--
-------------------------------------------------------------------------------

--   Table de fonctionnement synchrone
--   du flip-flop JK
--
--    J  K |   Q+
--   ------+-------
--    0  0 |   Q
--    0  1 |   0
--    1  0 |   1
--    1  1 | not Q




library ieee;
  use ieee.std_logic_1164.all;

entity flipflop_jk is
   port(clk_i    : in     std_logic;
        reset_i  : in     std_logic;
        J_i      : in     std_logic;
        K_i      : in     std_logic;
        Q_o      : out    std_logic;
        nQ_o     : out    std_logic
   );
end flipflop_jk ;


architecture comport of flipflop_jk is

  signal Q_s, D_s : std_logic;
  signal jk_select : std_logic_vector(1 downto 0);
  signal reset_s : std_logic;
begin
  --Adaptation polarite
  reset_s <= reset_i;
  jk_select <=  J_i &  K_i;
  with jk_select select
    D_s <= Q_s when "00",
           '0' when "01",
           '1' when "10",
           not Q_s when "11",
           'X' when others;
  
  process(reset_s, clk_i)
  begin

    if reset_s = '1' then
      Q_s <= '0';
    elsif rising_edge(clk_i) then
      Q_s <= D_s;
    end if;

  
  end process;

  Q_o <= Q_s;
  nQ_o <= not Q_s;  

end comport;
