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

entity two_left_shifts is
    generic (
        dataSize: natural := 64
    );
    port(
        input  : in  bit_vector(dataSize-1 downto 0);
        output : out bit_vector(dataSize-1 downto 0)
    );
end entity two_left_shifts;

architecture arch of two_left_shifts is
begin
    output <= input(dataSize-3 downto 0) & "00";
    
end architecture arch;