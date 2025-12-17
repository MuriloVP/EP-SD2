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

library IEEE;
use ieee.numeric_bit.all;

entity reg is
    generic (
        dataSize: natural := 64 
    );
    port (
        clock  : in bit;
        reset  : in bit;
        enable : in bit; 
        d      : in  bit_vector(dataSize-1 downto 0);
        q      : out bit_vector(dataSize-1 downto 0)
    );
end entity reg;

architecture comportamento of reg is
begin
    process(clock, reset)
    begin
        -- Reset Assíncrono
        if reset = '1' then
            q <= (others => '0'); 
            
        elsif (clock'event and clock = '1') then
            if enable = '1' then
                q <= d;
            end if;
        end if;
    end process;
end architecture comportamento;