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

entity unidadeControle is
    port(
        opcode : in bit_vector (10 downto 0); -- sinal de condição código da instrução
        extendMSB : out bit_vector (4 downto 0); -- sinal de controle sign-extend
        extendLSB : out bit_vector (4 downto 0); -- sinal de controle sign-extend
        reg2Loc : out bit; -- sinal de controle MUX Read Register 2
        regWrite : out bit; -- sinal de controle Write Register
        aluSrc : out bit; -- sinal de controle MUX entrada B ULA
        alu_control : out bit_vector (3 downto 0); -- sinal de controle da ULA
        branch : out bit; -- sinal de controle desvio condicional
        uncondBranch : out bit; -- sinal de controle desvio incondicional
        memRead : out bit; -- sinal de controle leitura RAM dados
        memWrite : out bit; -- sinal de controle escrita RAM dados
        memToReg : out bit -- sinal de controle MUX Write Data
    );
end entity unidadeControle;

architecture arch of unidadeControle is

    signal isR, isLDUR, isSTUR, isCBZ, isB : bit;

begin

    --Identificacao do tipo de instrucao

    with opcode select
        isR <= '1' when "10001011000" | "11001011000" | "10001010000" | "10101010000",
               '0' when others;

    with opcode select
        isLDUR <= '1' when "11111000010",
                  '0' when others;

    with opcode select
        isSTUR <= '1' when "11111000000",
                  '0' when others;

    isCBZ <= '1' when (opcode(10 downto 3) = "10110100") else
             '0';
    isB <= '1' when (opcode(10 downto 5) = "000101") else
           '0';

    -- Determinacao dos sinais de controle

    reg2Loc <= '1' when (isSTUR or isCBZ) else '0';
    aluSrc <= '1' when (isLDUR or isSTUR) else '0';
    memToReg <= '1' when (isLDUR) else '0';
    regWrite <= '1' when (isR or isLDUR) else '0';
    memRead <= '1' when (isLDUR) else '0';
    memWrite <= '1' when (isSTUR) else '0';
    branch <= '1' when (isCBZ) else '0';
    uncondBranch <= '1' when (isB) else '0';

    alu_control <= "0010" when (opcode = "10001011000" or isLDUR or isSTUR ) else
                   "0110" when (opcode = "11001011000") else
                   "0000" when (opcode = "10001010000") else
                   "0001" when (opcode = "10101010000") else
                   "0011" when (isCBZ) else
                   "0000";

    extendMSB <= "10100" when (isLDUR or isSTUR) else
                 "10111" when (isCBZ) else
                 "11001" when (isB) else
                 "00000";
    
    extendLSB <= "01100" when (isLDUR or isSTUR) else
                 "00101" when (isCBZ) else
                 "00000";

end arch;