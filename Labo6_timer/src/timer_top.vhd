-------------------------------------------------------------------------------
-- HEIG-VD, Haute Ecole d'Ingenierie et de Gestion du canton de Vaud
-- Institut REDS, Reconfigurable & Embedded Digital Systems
--
-- Fichier      : timer_top.vhd
--
-- Description  : 
-- 
-- Auteur       : Etienne Messerli
-- Date         : 28.10.2015
-- Version      : 0.0
-- 
-- Utilise      : Manipulation Timer pour cours CSN
-- 
--| Modifications |------------------------------------------------------------
-- Ver   Auteur      Date               Description
-- 0.0    EMI        29.09.2014   version intiale, entite du timer_top
-- 1.0    RDE & GGN  30.04.2024   Version entière faite en laboratoire   
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;

entity timer_top is
   port( 
      clock_i      : in   std_logic; -- Clock for the system
      nReset_i     : in   std_logic; -- Reset to 0 of the system
      Mono_nDiv_i  : in   std_logic; -- Input signal to choose between monostable and divider mode
      en_div_i     : in   std_logic; -- Enable for divider
      run_mono_i   : in   std_logic; -- Enable for monostable 
      val_i        : in   std_logic_vector(6 downto 0); -- Value for the timer
      done_o       : out  std_logic -- Signal when the value has reached it's value count
   );
end timer_top ;

architecture timer of timer_top is

   -- Signals declaration
   signal done_s : std_logic;  
   signal mono_s : std_logic_vector( 6 downto 0);
   signal div_s  : std_logic_vector( 6 downto 0);
   signal Q_fut  : std_logic_vector( 6 downto 0);
   signal Q_decr : unsigned(6 downto 0);
   signal Q_pres    : unsigned(6 downto 0); -- Anciennement Q_s
   
   
begin

   -- Logic for the divider mode
   div_s <= std_logic_vector(Q_decr) when ((en_div_i = '1') and (done_s = '0')) else 
            "0000001" when en_div_i = '0' else
            val_i; 
   -- Logic for the monostable mode
   mono_s <= val_i when run_mono_i = '0' else
             std_logic_vector(Q_pres) when done_s = '1' else
             std_logic_vector(Q_decr);
   -- Value to process for the next clock tic
   Q_fut <= mono_s when Mono_nDiv_i = '1' else div_s;

  process(nReset_i, clock_i)
  begin

   if (nReset_i = '0') then
      Q_pres <= (OTHERS => '0'); --Reset to 0
   elsif rising_edge(clock_i) then
        Q_pres <= unsigned(Q_fut); -- Assigns of the Q_fut value on the clock
   end if;

 end process;

 Q_decr <= Q_pres - 1; -- Counter that decrements

 done_s <= '1' when Q_pres = 1 and Mono_nDiv_i = '0' else 
           '1' when Q_pres = 0 and Mono_nDiv_i = '1' else 
           '0

 done_o <= done_s;
end timer;

