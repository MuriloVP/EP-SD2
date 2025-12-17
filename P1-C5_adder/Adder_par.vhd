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

entity adder_n is
    generic (
        dataSize: natural := 64 
    );
    port(
        in0  : in  bit_vector(dataSize-1 downto 0);
        in1  : in  bit_vector(dataSize-1 downto 0);
        sum  : out bit_vector(dataSize-1 downto 0);
        cOut : out bit
    );
end entity adder_n;

architecture adder_n_arch of adder_n is
   signal sum_c: bit_vector(dataSize downto 0);  
begin
   sum_c <= bit_vector(unsigned('0' & in0) + unsigned('0' & in1));  
   sum   <= sum_c(dataSize-1 downto 0);      
   cOut <= sum_c(dataSize);           
end adder_n_arch;