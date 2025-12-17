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

entity memoriaInstrucoes_tb is
end memoriaInstrucoes_tb;

architecture tb of memoriaInstrucoes_tb is

    constant N_ADDR : natural := 4; 
    constant N_DATA : natural := 8;
    constant N_INSTR: natural :=32; 
    constant ARQUIVO_TESTE : string := "memInstr_conteudo.dat";

    component memoriaInstrucoes is
        generic (
            addressSize : natural;
            dataSize    : natural;
            datFileName : string
        );
        port (
            addr : in  bit_vector(addressSize-1 downto 0);
            data : out bit_vector(4*dataSize-1 downto 0)
        );
    end component;

    signal addr_in : bit_vector(N_ADDR-1 downto 0) := (others => '0');
    signal data_out : bit_vector(N_INSTR-1 downto 0);

begin

    dut: memoriaInstrucoes
        generic map (
            addressSize => N_ADDR,
            dataSize    => N_DATA,
            datFileName => ARQUIVO_TESTE
        )
        port map (
            addr => addr_in,
            data => data_out
        );

    gerador_estimulos: process is
        
        type pattern_type is record
            addr_val     : bit_vector(N_ADDR-1 downto 0);
            data_esperado: bit_vector(N_INSTR-1 downto 0);
        end record;

        type pattern_array is array (natural range <>) of pattern_type;
        
        constant patterns: pattern_array := (
            0 => (
                addr_val      => "0000", 
                data_esperado => "11111000010000000000001111100001"
            )
        );

    begin
        assert false report "Iniciando teste da Memoria de Instrucoes..." severity note;

        wait for 10 ns;

        for i in patterns'range loop
            addr_in <= patterns(i).addr_val;
            
            wait for 10 ns; 

            assert data_out = patterns(i).data_esperado 
            report "Erro no endereco " & integer'image(to_integer(unsigned(addr_in))) &
                   ". Esperado: " & integer'image(to_integer(unsigned(patterns(i).data_esperado))) &
                   ", Lido: " & integer'image(to_integer(unsigned(data_out)))
            severity error;
        end loop;

        assert false report "Teste concluido." severity note;
        wait;
    end process;

end architecture tb;