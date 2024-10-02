-----------------------------------------------------------------------
-- HEIG-VD, Haute Ecole d'Ingenerie et de Gestion du Canton de Vaud
-- Institut REDS
--
-- Fichier :  exo_dec_adr_process.vhd
-- Auteur  :  E. Messerli
-- Date    :  31.03.2019, nouvelle version exercice
--
-- Utilise dans :  Exercice description système combinatoire avec process
-----------------------------------------------------------------------
-- Ver  Date       Qui  Commentaires
-- 1.0  31.03.2019 EMI  Solution
--
-----------------------------------------------------------------------

library IEEE;
use IEEE.Std_Logic_1164.all;
use IEEE.numeric_std.all;

entity exo_dec_adr_process is
port(adr_i            : in  std_logic_vector(15 downto 0);
     cs_rom_o         : out  std_logic;
     cs_ram_o         : out  std_logic;
     cs_flash_o       : out  std_logic;
     cs_io_o          : out  std_logic;
     cs_leds_o        : out  std_logic;
     cs_switch_o      : out  std_logic;
     cs_matrice_led_o : out  std_logic;
     cs_capt_analog_o : out  std_logic;
     cs_cmd_moteur_o  : out  std_logic
     );
end exo_dec_adr_process ;

architecture flot_don of exo_dec_adr_process is
  
begin
  
  process(adr_i)
    
  begin
 
     --valeur par defaut
     --   desactive tous les chips select
     cs_rom_o    <= '0';
     cs_ram_o    <= '0';
     cs_flash_o  <= '0';
     cs_io_o     <= '0';
     cs_leds_o <= '0';
     cs_switch_o <= '0';
     cs_matrice_led_o <= '0';
     cs_capt_analog_o <= '0';
     cs_cmd_moteur_o <= '0';
     --a completer .....
     
     
     
    case unsigned(adr_i(15 downto 12)) is
      when "0000"                           => cs_rom_o   <= '1';  -- ROM
      when x"1" | x"2" | x"3" | x"4"        => null;             -- libre
      when x"5" | x"6" | x"7"               => cs_ram_o   <= '1';  -- RAM 
      when x"8" | x"9"                      => cs_flash_o <= '1';  -- FLASH
      when x"a" | x"b" | x"c" | x"d" | x"e" => null;             -- libre
      when x"f"                             => cs_io_o    <= '1';  -- détails       
      
        case unsigned(adr_i(11 downto 4))  is --indentation spécifique pour le cs_io
          when  x"00"                                        => cs_leds_o         <= '1';
          when  x"01"                                        => cs_switch_o       <= '1';
          when  x"02" | x"03"                                => cs_matrice_led_o  <= '1';
          when  x"04" | x"05" | x"06" | x"07" |x"08" | x"09" => null;
          when  x"0a" | x"0b"                                => cs_capt_analog_o  <= '1';
          when  x"0c" | x"0d"                                => cs_cmd_moteur_o   <= '1';
          when  x"0e" | x"0f"                                => null;
          when others  => 
                            cs_leds_o        <= '0';
                            cs_switch_o      <= '0';
                            cs_matrice_led_o <= '0';
                            cs_capt_analog_o <= '0';
                            cs_cmd_moteur_o  <= '0';
        end case;
      when others => --cas pour simulation
                      cs_rom_o         <= 'X';
                      cs_ram_o         <= 'X';
                      cs_flash_o       <= 'X';
                      cs_io_o          <= 'X';
                      cs_leds_o        <= 'X';
                      cs_switch_o      <= 'X'; 
                      cs_matrice_led_o <= 'X';
                      cs_capt_analog_o <= 'X';
                      cs_cmd_moteur_o  <= 'X';
      end case;
  
  end process;
  
end flot_don;

