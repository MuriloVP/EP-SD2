------------------------------------------------------
--- PROJETO POLILEGV8 - TURMA 1 - GRUPO 1 - T1G01 ----
------------------------------------------------------
--- INTEGRANTES --------------------------------------
------------------------------------------------------
--- DANIEL TRIERWEILER LEAL CORRÊA - 15446990 --------
--- GUILHERME GADIOLI MARCELINO MARTINS - 15507545 ---
--- JOÃO VICTOR DE ALCÂNTARA FREDO - 15638419 --------
--- MAURÍLIO MIRANDA LAGO - 15513111 -----------------
--- MURILO VITOR PIERETTI - 15481030 -----------------
------------------------------------------------------

library ieee;
use ieee.numeric_bit.all;


entity polilegv8_tb is
end entity;

architecture arch of polilegv8_tb is

    -- Declaração do DUT
    component polilegv8 is
        port (
            clock : in bit;
            reset : in bit
        );
    end component;

    -- Sinais de estímulo
    signal clock_in : bit := '0';
    signal reset_in : bit := '0';

    constant DELAY : time := 5 ns;

begin

    dut: polilegv8
        port map (
            clock => clock_in,
            reset => reset_in
        );

    clock_process: process is
        
    begin

        clock_in <= '0';
        wait for DELAY/2;
        clock_in <= '1';
        wait for DELAY/2;

    end process;

    reset_process: process is
        
    begin

        reset_in <= '1';
        wait for 2*DELAY;
        reset_in <= '0';
        wait for 100*delay;
        
        assert false report "Teste concluído" severity failure;
        wait;

    end process;

end arch;