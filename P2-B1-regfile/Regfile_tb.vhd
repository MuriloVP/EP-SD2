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
    
    -- Sinais de Endereço (usaremos estes como constantes binárias no teste)
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

    -- Instanciação do DUT
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
        constant R_ADDR_10: bit_vector(4 downto 0) := "01010"; -- X10 (01010)
        constant R_ADDR_20: bit_vector(4 downto 0) := "10100"; -- X20 (10100)
        constant R_ADDR_31: bit_vector(4 downto 0) := "11111"; -- X31 (XZR)

    begin
        assert false report "Iniciando teste do Banco de Registradores..." severity note;

        ----------------------------------------------------
        -- 1. TESTE DE RESET ASSÍNCRONO E LEITURA INICIAL
        ----------------------------------------------------
        
        -- O rst_in já está '1'. Esperamos que q1 e q2 sejam ZERO_VAL.
        rr1_in <= R_ADDR_10; -- Ler X10
        rr2_in <= R_ADDR_20; -- Ler X20
        wait for 5 ns; -- Espera a leitura assíncrona se estabilizar

        assert q1_out = ZERO_VAL report "Erro 1A: Reset falhou em X10" severity error;
        assert q2_out = ZERO_VAL report "Erro 1B: Reset falhou em X20" severity error;

        -- Tira o reset para iniciar as operações síncronas
        rst_in <= '0';
        wait for clockPeriod; -- Espera uma borda para garantir a estabilidade

        ----------------------------------------------------
        -- 2. TESTE DE ESCRITA SÍNCRONA E LEITURA (RegWrite = 1)
        ----------------------------------------------------
        
        -- Prepara Escrita em X10: wr=10, d=D_VAL_1, regWrite=1
        wr_in <= R_ADDR_10;
        d_in <= D_VAL_1;
        regWrite_in <= '1';
        
        wait for clockPeriod; -- Ocorre a borda de subida e a escrita
        
        -- Verifica a Leitura: X10 deve ter D_VAL_1
        rr1_in <= R_ADDR_10; -- Ler X10
        wait for 5 ns;
        
        assert q1_out = D_VAL_1 report "Erro 2A: Escrita em X10 falhou" severity error;

        ----------------------------------------------------
        -- 3. TESTE DE HOLD (Escrita Desabilitada: RegWrite = 0)
        ----------------------------------------------------
        
        -- Tenta escrever um novo valor (D_VAL_2) em X10, mas com regWrite=0
        d_in <= D_VAL_2;
        regWrite_in <= '0';
        
        wait for clockPeriod; -- Ocorre a borda de subida, mas a escrita deve ser ignorada
        
        -- Verifica a Leitura: X10 deve manter D_VAL_1
        assert q1_out = D_VAL_1 report "Erro 3A: Hold (RegWrite=0) falhou" severity error;
        
        ----------------------------------------------------
        -- 4. TESTE DE ESCRITA NOVO REGISTRADOR (X20)
        ----------------------------------------------------
        
        -- Prepara Escrita em X20: wr=20, d=D_VAL_2, regWrite=1
        wr_in <= R_ADDR_20;
        d_in <= D_VAL_2;
        regWrite_in <= '1';
        
        wait for clockPeriod; -- Ocorre a borda de subida e a escrita
        
        -- Verifica a Leitura na porta q2: X20 deve ter D_VAL_2
        rr2_in <= R_ADDR_20;
        wait for 5 ns;
        
        assert q2_out = D_VAL_2 report "Erro 4A: Escrita em X20 falhou" severity error;

        ----------------------------------------------------
        -- 5. TESTE DA REGRA DO XZR (X31)
        ----------------------------------------------------
        
        -- 5a. Tentativa de Escrita em X31 (deve ser ignorada)
        wr_in <= R_ADDR_31;
        d_in <= D_VAL_1;
        regWrite_in <= '1';
        
        wait for clockPeriod; -- Tentativa de escrita síncrona em X31
        
        -- 5b. Leitura de X31 (deve ser sempre ZERO_VAL, independente da escrita)
        rr1_in <= R_ADDR_31;
        wait for 5 ns;
        
        assert q1_out = ZERO_VAL report "Erro 5A: Leitura XZR (X31) falhou (nao e zero)" severity error;

        ----------------------------------------------------
        -- FIM DO TESTE
        ----------------------------------------------------
        assert false report "Teste concluido com sucesso." severity note;
        keep_simulating <= '0';
        wait;
        
    end process;
    
end architecture tb;