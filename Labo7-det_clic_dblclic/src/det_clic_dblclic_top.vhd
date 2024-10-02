-------------------------------------------------------------------------------
-- HEIG-VD, Haute Ecole d'Ingenierie et de Gestion du canton de Vaud
-- Institut REDS, Reconfigurable & Embedded Digital Systems
--
-- Fichier      : det_clic_dblclic_top.vhd
-- Auteur       : Etienne Messerli, le 05.05.2016
-- 
-- Description  : Detection d'un clic et double clic
--                Projet repris du labo Det_Clic_DblClic 2012
-- 
-- Utilise      : Labo SysLog2 2016
--| Modifications |------------------------------------------------------------
-- Ver   Date        Qui         Description
-- 1.0   20.11.2020  EMI   Ajout generique pour timer et maintien
-- 
-------------------------------------------------------------------------------

library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;

use work.det_clic_dblclic_pkg.all;

entity det_clic_dblclic_top is

    
    generic (T1_g      : natural range 1 to 1023 := 4;
             T2_g      : natural range 1 to 1023 := 6;
             T_HOLD    : natural range 1 to 1023 := 2
             );
    port(clock_i       : in  std_logic;  --horloge systeme 1MHz
         nReset_i      : in  std_logic;  --reset asynchrone
         button_i      : in  std_logic;
         top_ms_i      : in  std_logic;
         clic_o        : out std_logic;
         dbl_clic_o    : out std_logic;
         clic_lg_o     : out std_logic;
         dbl_clic_lg_o : out std_logic
         );
end det_clic_dblclic_top;

architecture struct of det_clic_dblclic_top is

  -- Internal signal declarations
  signal reset_s       : std_logic;

    ----------
    -- TODO --
    ----------
    -- Enum pour les états
    type state_type is 
    (ATTENTE,
     APPUYER, 
     CLIC, 
     ATTENTE_DBLCLCK,
     CONFIRMATION_CLIC,
     APPUYER_DBLCLCK,
     DBL_CLIC,
     CONFIRMATION_DBLCLCK);

    -- Signaux pour les états
    signal current_state, next_state : state_type;
    -- Signaux pour les triggers
    signal trigger1_s, trigger2_s : STD_LOGIC;
    -- Signal pour le clic simple
    signal clic_s, dbl_clic_s : std_logic;
    -- Signal sortie clics long
    signal clic_lg_s, dbl_clic_lg_s : std_logic;
    -- Signal pour le timer
    signal start_delai_s : std_logic;

    signal reset_hold : std_logic;


   -- Component declarations
   
   
    ----------
    -- TODO --
    ----------
   
    component timer is
        generic (T1_g : natural range 1 to 1023 := 4;
                 T2_g : natural range 1 to 1023 := 6
                );
        Port ( clock_i    : in  std_logic;
               reset_i    : in  std_logic;
               start_i    : in  std_logic;
               top_ms_i   : in  std_logic;
               trigger1_o : out std_logic;
               trigger2_o : out std_logic
        );
    end component;
   
   

    component maintien
        generic (T_HOLD : natural range 1 to 1023 := 2
                );
        port (clock_i    : in  std_logic;
              reset_i    : in  std_logic;
              pulse_i    : in  std_logic;
              top_ms_i   : in  std_logic;
              p_hold_o   : out std_logic
              );
    end component;
    for all : maintien use entity work.maintien;

    

begin


    ----------
    -- TODO --
    ----------
    -- TODO changer les noms de current et next state en etat futur et etat présent

    -- Reset
    reset_s <= nReset_i;
    reset_hold <= not nReset_i;

    -- Timer
    Timer1 : timer
    generic map (T1_g => T1_c, T2_g => T2_c)
    Port map (
        clock_i => clock_i,
        reset_i => nReset_i,
        start_i => start_delai_s,
        top_ms_i => top_ms_i,
        trigger1_o => trigger1_s,
        trigger2_o => trigger2_s
    );
    -- Maintient pour le clic simple
    Maintient1 : maintien
    generic map (T_HOLD => T_HOLD_C)
    Port map (
        clock_i => clock_i,
        reset_i => reset_hold,
        pulse_i => clic_s,
        top_ms_i => top_ms_i,
        p_hold_o => clic_lg_s
    );
    -- Maintient pour le double clic
    Maintient2 : maintien
    generic map (T_HOLD => T_HOLD_C)
    Port map (
        clock_i => clock_i,
        reset_i => reset_hold,
        pulse_i => dbl_clic_s,
        top_ms_i => top_ms_i,
        p_hold_o => dbl_clic_lg_s
    );
    
   

    -- Gestion des états
    process(current_state, button_i, trigger1_s, trigger2_s, top_ms_i)
    begin
        -- Initialisations des sorties a 0
        clic_s <= '0';
        dbl_clic_s <= '0';
        start_delai_s <= '0';

        -- Cas de la machine à états
        case current_state is
            when ATTENTE =>
                start_delai_s <= '1';
                if button_i = '1' and top_ms_i = '1' and trigger1_s = '0' and trigger2_s = '0' then
                    next_state <= APPUYER;                    
                else
                    next_state <= ATTENTE;
                end if;

            when APPUYER =>
                if trigger1_s = '1' then
                    next_state <= ATTENTE;
                elsif button_i = '0'and top_ms_i ='1'then
                    next_state <= CLIC;
                    
                else
                    next_state <= APPUYER;
                end if;

            when CLIC =>
                start_delai_s <= '1';
                next_state <= ATTENTE_DBLCLCK;

            when ATTENTE_DBLCLCK =>
                if trigger2_s = '1' then
                    next_state <= CONFIRMATION_CLIC;
                elsif button_i = '1' then
                    next_state <= APPUYER_DBLCLCK;
                else 
                    next_state <= ATTENTE_DBLCLCK;
                end if;

            when CONFIRMATION_CLIC =>
                clic_s <= '1';
                next_state <= ATTENTE;

            when APPUYER_DBLCLCK =>
            if trigger2_s = '1' then
                next_state <= ATTENTE;
                elsif button_i = '1'  then
                    start_delai_s <= '1';
                    next_state <= DBL_CLIC;
                end if;
                
            when DBL_CLIC =>
                if trigger1_s = '1' then
                    next_state <= ATTENTE;
                elsif button_i = '0' and top_ms_i = '1' then
                    next_state <= CONFIRMATION_DBLCLCK;
                else
                    next_state <= DBL_CLIC;
                end if;

            when CONFIRMATION_DBLCLCK =>
                dbl_clic_s <= '1';
                next_state <= ATTENTE;      

            when others =>
                next_state <= ATTENTE;
        end case;
    end process;


    -- Machine à états pour gérer les transitions
    process(clock_i, reset_s)
    begin
        if reset_s = '0' then
            current_state <= ATTENTE;
        elsif rising_edge(clock_i) then
            current_state <= next_state;
        end if;
    end process;

    clic_lg_o <= clic_lg_s;
    dbl_clic_lg_o <= dbl_clic_lg_s;
    clic_o <= clic_s;
    dbl_clic_o <= dbl_clic_s;
    

end struct;
