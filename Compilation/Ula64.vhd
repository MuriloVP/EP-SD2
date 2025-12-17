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

entity ula is
    port (
        A  : in  bit_vector (63 downto 0);  -- entrada A
        B  : in  bit_vector (63 downto 0);  -- entrada B
        S  : in  bit_vector (3 downto 0);   -- seleciona operacao
        F  : out bit_vector (63 downto 0);  -- saida
        Z  : out bit;                       -- flag zero
        Ov : out bit;                       -- flag overflow
        Co : out bit                        -- flag carry out
    );
end entity ula;

architecture arch of ula is

    -- Declaração do componente ula
    component ula_bit is
        port (
            a, b             : in bit;
            ainvert, binvert : in bit;
            cin              : in bit;
            operation        : in bit_vector(1 downto 0);
            result           : out bit;
            cout             : out bit;
            overflow         : out bit
        );
    end component;

    signal ula_result : bit_vector(63 downto 0);
    signal ula_cout : bit_vector(63 downto 0);
    signal ula_overflow : bit_vector(63 downto 0);

begin

    Ula_0: ula_bit 
        port map (
            a => A(0),
            b => B(0),
            ainvert => S(3),
            binvert => S(2),
            cin => S(2),
            operation => S(1 downto 0),
            result => ula_result(0),
            cout => ula_cout(0),
            overflow => ula_overflow(0)
        );

    -- Loop de Geração para Registradores X0 a X30
    gen_ulas: for i in 1 to 63 generate
        
    begin

        -- Instanciação da Ula 'i'
        Ula_i: ula_bit 
            port map (
               a => A(i),
               b => B(i),
               ainvert => S(3),
               binvert => S(2),
               cin => ula_cout(i-1),
               operation => S(1 downto 0),
               result => ula_result(i),
               cout => ula_cout(i),
               overflow => ula_overflow(i)
            );
            
    end generate;

    F <= ula_result;

    -- Flags
    Z <= '1' when (unsigned(ula_result) = 0) else '0';
    Ov <= ula_overflow(63);
    Co <= ula_cout(63);

end architecture arch;