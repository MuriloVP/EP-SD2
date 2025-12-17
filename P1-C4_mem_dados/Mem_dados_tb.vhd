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

entity memoriaDados_tb is
end memoriaDados_tb;

architecture tb of memoriaDados_tb is

    constant N_ADDR : natural := 4; 
    constant N_DATA : natural := 8; 
    constant N_WORD : natural := 64; -- Constante correta para 8 bytes
    constant ARQUIVO_TESTE : string := "memDados_conteudo_inicial.dat"; 

    component memoriaDados is
        generic (
            addressSize : natural;
            dataSize    : natural;
            datFileName : string
        );
        port (
            clock  : in  bit; 
            wr     : in  bit;
            addr   : in  bit_vector(addressSize-1 downto 0);
            data_i : in  bit_vector(8*dataSize-1 downto 0);
            data_o : out bit_vector(8*dataSize-1 downto 0)
        );
    end component;
    
    signal clock_in   : bit := '0';
    signal wr_in      : bit := '0';
    signal addr_in    : bit_vector(N_ADDR-1 downto 0) := (others => '0');
    signal data_i_in  : bit_vector(N_WORD-1 downto 0) := (others => '0');
    signal data_o_out : bit_vector(N_WORD-1 downto 0);
    
    signal keep_simulating: bit := '0';
    constant clockPeriod : time := 10 ns;

begin

    clock_in <= (not clock_in) and keep_simulating after clockPeriod/2;
    
    dut: memoriaDados
        generic map (
            addressSize => N_ADDR,
            dataSize    => N_DATA,
            datFileName => ARQUIVO_TESTE
        )
        port map (
            clock  => clock_in,
            wr     => wr_in,
            addr   => addr_in,
            data_i => data_i_in,
            data_o => data_o_out
        );

    gerador_estimulos: process is
        
        type pattern_type is record
            wr_val          : bit;
            addr_val        : bit_vector(N_ADDR-1 downto 0);
            data_i_val      : bit_vector(N_WORD-1 downto 0);
            data_o_esperado : bit_vector(N_WORD-1 downto 0);
        end record;

        type pattern_array is array (natural range <>) of pattern_type;
        
        constant patterns: pattern_array := (
        -- CASO 0: Leitura do arquivo (Endereço 0)
            0 => (
                wr_val => '0', 
                addr_val => "0000", 
                data_i_val => (others => '0'), 
                data_o_esperado => "1000000000000000000000000000000000000000000000000000000000000000"
            ),
        -- CASO 1: Escrita de valor novo (Endereço 0)
            1 => (
                wr_val => '1', 
                addr_val => "0000", 
                data_i_val      => "0000000000000000000000000000000011111111111111111111111111111111", 
                data_o_esperado => "0000000000000000000000000000000011111111111111111111111111111111"
            ),
        -- CASO 2: Leitura para confirmar a escrita
            2 => (
                wr_val => '0', 
                addr_val => "0000", 
                data_i_val      => (others => '0'), 
                data_o_esperado => "0000000000000000000000000000000011111111111111111111111111111111"
            )
        );

    begin
        assert false report "Iniciando teste da Memoria de Dados..." severity note;
        keep_simulating <= '1';

        wait for clockPeriod;

        for i in patterns'range loop
            wr_in     <= patterns(i).wr_val;
            addr_in   <= patterns(i).addr_val;
            data_i_in <= patterns(i).data_i_val;

            wait for clockPeriod; 

            assert data_o_out = patterns(i).data_o_esperado 
            report "Erro no Teste #" & integer'image(i) & 
                   " (Addr: " & integer'image(to_integer(unsigned(addr_in))) & ")"
            severity error;
        end loop;

        assert false report "Teste concluido." severity note;
        keep_simulating <= '0';
        wait;
    end process;

end architecture tb;