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

    signal 

begin

end arch;