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

entity ula_bit is
    port (
        a, b             : in bit;               -- Entradas de dados
        ainvert, binvert : in bit;               -- Controles de inversão
        cin              : in bit;               -- Carry In
        operation        : in bit_vector(1 downto 0); -- Seleção da operação
        result           : out bit;              -- Resultado principal
        cout             : out bit;              -- Carry Out do somador
        overflow         : out bit               -- Detecção de estouro
    );
end entity ula_bit;

architecture arch of ula_bit is
    -- Declaração do componente Full Adder 
    component fulladder is
        port (
            a, b, cin : in bit;
            s, cout   : out bit
        );
    end component;

    signal a_sig, b_sig : bit;
    signal and_res, or_res, add_res : bit;
    signal cout_adder : bit;

begin
    -- Guardando os operandos invertidos ou não 
    a_sig <= not a when ainvert = '1' and not(operation = "11") else a;
    b_sig <= not b when binvert = '1' and not(operation = "11") else b;
    -- Operações lógicas
    and_res <= a_sig and b_sig;
    or_res  <= a_sig or b_sig;

    --Instanciando o somador
    somador: fulladder port map (
        a    => a_sig,
        b    => b_sig,
        cin  => cin,
        s    => add_res,
        cout => cout_adder
    );

    cout <= cout_adder;
 
    with operation select
        result <= and_res      when "00", -- AND
                  or_res       when "01", -- OR
                  add_res      when "10", -- ADD
                  b_sig        when "11"; -- Pass B


    overflow <= cin xor cout_adder;

end architecture arch;