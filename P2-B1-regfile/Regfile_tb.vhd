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

entity regfile_tb is
end entity;

architecture tb of regfile_tb is

    -- Constantes de Tempo
    constant clockPeriod : time := 10 ns;

    -- Declaração do Componente a ser Testado (DUT)
    component regfile is
        port (
            clock   : in bit;
            reset   : in bit;
            regWrite: in bit;
            rr1     : in bit_vector (4 downto 0);
            rr2     : in bit_vector (4 downto 0);
            wr      : in bit_vector (4 downto 0);
            d       : in bit_vector (63 downto 0);
            q1      : out bit_vector (63 downto 0);
            q2      : out bit_vector (63 downto 0)
        );
    end component;

    -- Sinais de Controle e Dados
    signal clk_in   : bit := '0';
    signal rst_in   : bit := '1'; -- Começa em '1' para garantir o Reset Assíncrono
    signal regWrite_in : bit := '0';
    
    -- Sinais de teste
    signal rr1_in   : bit_vector (4 downto 0) := (others => '0');
    signal rr2_in   : bit_vector (4 downto 0) := (others => '0');
    signal wr_in    : bit_vector (4 downto 0) := (others => '0');
    
    -- Sinais de Dados
    signal d_in     : bit_vector (63 downto 0) := (others => '0');
    signal q1_out   : bit_vector (63 downto 0);
    signal q2_out   : bit_vector (63 downto 0);
    
    signal keep_simulating : bit := '1'; 

begin

    -- Gerador de Clock
    clk_in <= (not clk_in) and keep_simulating after clockPeriod/2;

    -- Instanciação
    dut: regfile
        port map(
            clock   => clk_in,
            reset   => rst_in,
            regWrite=> regWrite_in,
            rr1     => rr1_in,
            rr2     => rr2_in,
            wr      => wr_in,
            d       => d_in,
            q1      => q1_out,
            q2      => q2_out
        );
        
    -- Processo de Estímulos e Verificação
    stimulus_process: process is
        
        -- Constantes de Teste
        constant D_VAL_1 : bit_vector(63 downto 0) := x"AABBCCDD11223344"; -- Dado 1
        constant D_VAL_2 : bit_vector(63 downto 0) := x"FFFFFFFFEEEEEEEE"; -- Dado 2
        constant ZERO_VAL: bit_vector(63 downto 0) := (others => '0');     -- Zero 64 bits

        -- Endereços importantes
        constant R_VAL_1: bit_vector(4 downto 0) := "01010"; -- X10 (01010)
        constant R_VAL_2: bit_vector(4 downto 0) := "10100"; -- X20 (10100)
        constant R_VAL_31: bit_vector(4 downto 0) := "11111"; -- X31 (XZR)

    begin
        assert false report "Iniciando teste do Banco de Registradores..." severity note;

        -- TESTE 1 (Teste do reset)
        
        rr1_in <= R_VAL_1; 
        rr2_in <= R_VAL_2; 
        wait for 5 ns; 

        assert q1_out = ZERO_VAL report "Erro 1A: Reset falhou em X1" severity error;
        assert q2_out = ZERO_VAL report "Erro 1B: Reset falhou em X2" severity error;

        -- Tira o reset para iniciar as operações síncronas
        rst_in <= '0';
        wait for clockPeriod; 

       -- TESTE 2 (Teste de escrita)
        
        -- Prepara Escrita
        wr_in <= R_VAL_1;
        d_in <= D_VAL_1;
        regWrite_in <= '1';
        
        wait for clockPeriod; 
        
        -- Verifica a Leitura
        rr1_in <= R_VAL_1;
        wait for 5 ns;
        
        assert q1_out = D_VAL_1 report "Erro 2A: Escrita em X1 falhou" severity error;

        -- TESTE 3 (Teste do regWrite = '0')
        
        d_in <= D_VAL_2;
        regWrite_in <= '0';
        
        wait for clockPeriod; -- Ocorre a borda de subida, mas a escrita deve ser ignorada
        
        -- Verifica a Leitura
        assert q1_out = D_VAL_1 report "Erro 3A: Hold (RegWrite=0) falhou" severity error;
        
        -- TESTE 4 (Teste de escrita em outro registrador)
        
        -- Prepara Escrita
        wr_in <= R_VAL_2;
        d_in <= D_VAL_2;
        regWrite_in <= '1';
        
        wait for clockPeriod;
        
        -- Verifica a Leitura
        rr2_in <= R_VAL_2;
        wait for 5 ns;
        
        assert q2_out = D_VAL_2 report "Erro 4A: Escrita em X20 falhou" severity error;

        -- TESTE 5 (Teste do XZR)
        
        -- Tentativa de Escrita em X31 
        wr_in <= R_VAL_31;
        d_in <= D_VAL_1;
        regWrite_in <= '1';
        
        wait for clockPeriod;
        
        -- Leitura de X31
        rr1_in <= R_VAL_31;
        wait for 5 ns;
        
        assert q1_out = ZERO_VAL report "Erro 5A: Leitura XZR (X31) falhou (nao e zero)" severity error;

        -- Fim do teste
        
        assert false report "Teste concluido com sucesso." severity note;
        keep_simulating <= '0';
        wait;
        
    end process;
    
end architecture tb;