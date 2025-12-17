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

entity polilegv8 is
    port (
        clock : in bit;
        reset : in bit
    );
end entity polilegv8;

architecture arch of polilegv8 is

    -- Declaracao dos componentes fluxoDados e unidadeControle

    component fluxoDados is
        port(
            clock : in bit; -- entrada de clock
            reset : in bit; -- clear assincrono
            extendMSB : in bit_vector (4 downto 0); -- sinal de controle sign-extend
            extendLSB : in bit_vector (4 downto 0); -- sinal de controle sign-extend
            reg2Loc : in bit; -- sinal de controle MUX Read Register 2
            regWrite : in bit; -- sinal de controle Write Register
            aluSrc : in bit; -- sinal de controle MUX entrada B ULA
            alu_control : in bit_vector (3 downto 0); -- sinal de controle da ULA
            branch : in bit; -- sinal de controle desvio condicional
            uncondBranch : in bit; -- sinal de controle desvio incondicional
            memRead : in bit; -- sinal de controle leitura RAM dados
            memWrite : in bit; -- sinal de controle escrita RAM dados
            memToReg : in bit; -- sinal de controle MUX Write Data
            opcode : out bit_vector (10 downto 0) -- sinal de condição código da instrução
        );
    end component;

    component unidadeControle is
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
    end component;

    signal opcode : bit_vector(10 downto 0);
    signal extendMSB, extendLSB : bit_vector(4 downto 0);
    signal alu_control : bit_vector(3 downto 0);
    signal reg2Loc, regWrite, aluSrc, branch, uncondBranch, memRead, memWrite, memToReg : bit;

begin

    fd: fluxoDados
        port map (
            clock => clock,
            reset => reset,
            extendMSB => extendMSB,
            extendLSB => extendLSB,
            reg2Loc => reg2Loc,
            regWrite => regWrite,
            aluSrc => aluSrc,
            alu_control => alu_control,
            branch => branch,
            uncondBranch => uncondBranch,
            memRead => memRead,
            memWrite => memWrite,
            memToReg => memToReg,
            opcode => opcode
        );

    uc: unidadeControle
        port map (
            opcode => opcode,
            extendMSB => extendMSB,
            extendLSB => extendLSB,
            reg2Loc => reg2Loc,
            regWrite => regWrite,
            aluSrc => aluSrc,
            alu_control => alu_control,
            branch => branch,
            uncondBranch => uncondBranch,
            memRead => memRead,
            memWrite => memWrite,
            memToReg => memToReg
        );

            

end arch;