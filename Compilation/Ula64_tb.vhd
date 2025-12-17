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

entity ula_tb is
end entity;

architecture tb of ula_tb is

    -- Declaração do Componente a ser Testado (DUT)
    component ula is
        port (
            A  : in  bit_vector (63 downto 0);
            B  : in  bit_vector (63 downto 0);
            S  : in  bit_vector (3 downto 0);
            F  : out bit_vector (63 downto 0);
            Z  : out bit;
            Ov : out bit;
            Co : out bit
        );
    end component;

    -- Sinais de Estímulo
    signal A_in  : bit_vector (63 downto 0) := (others => '0');
    signal B_in  : bit_vector (63 downto 0) := (others => '0');
    signal S_in  : bit_vector (3 downto 0)  := (others => '0');
    
    -- Sinais de Saída
    signal F_out : bit_vector (63 downto 0);
    signal Z_out : bit;
    signal Ov_out: bit;
    signal Co_out: bit;
    
    -- Constante de tempo para propagação combinacional
    constant DELAY : time := 5 ns; 

begin

    -- Instanciação do DUT
    dut: ula
        port map(
            A  => A_in,
            B  => B_in,
            S  => S_in,
            F  => F_out,
            Z  => Z_out,
            Ov => Ov_out,
            Co => Co_out
        );

    -- Processo de Estímulos e Verificação
    stimulus_process: process is
        
        -- Constante
        constant ALL_ONES   : bit_vector(63 downto 0) := x"FFFFFFFFFFFFFFFF";
        constant HIGH_BIT_M1: bit_vector(63 downto 0) := x"7FFFFFFFFFFFFFFF"; -- Maior Positivo
        constant HIGH_BIT_P1: bit_vector(63 downto 0) := x"8000000000000000"; -- Mais Negativo
        constant VAL_A      : bit_vector(63 downto 0) := x"1111111100000000";
        constant VAL_B      : bit_vector(63 downto 0) := x"00000000AAAAAAAA";
        

    begin
        assert false report "Iniciando teste da ULA de 64 bits:" severity note;

        -- Teste 1 - AND Padrão
        A_in <= ALL_ONES;
        B_in <= x"000000000000FFFF";
        S_in <= "0000";
        wait for DELAY;
        assert F_out = x"000000000000FFFF" and Z_out = '0' report "Erro 1: AND falhou" severity error;

        -- Teste 2 - OR Padrão
        A_in <= VAL_A;
        B_in <= VAL_B;
        S_in <= "0001";
        wait for DELAY;
        assert F_out = x"11111111AAAAAAAA" and Z_out = '0' report "Erro 2: OR falhou" severity error;

        -- Teste 3 - Soma Padrão
        A_in <= x"0000000000000001";
        B_in <= x"0000000000000001";
        S_in <= "0010";
        wait for DELAY;
        assert F_out = x"0000000000000002" and Z_out = '0' and Ov_out = '0' and Co_out = '0' report "Erro 3: SOMA padrão falhou" severity error;

        --Teste 4 - Subtração Padrão
        A_in <= x"0000000000000005";
        B_in <= x"0000000000000002";
        S_in <= "0110";
        wait for DELAY;
        assert F_out = x"0000000000000003" and Z_out = '0' and Ov_out = '0' and Co_out = '1' report "Erro 4: SUBTRAÇÃO padrão falhou" severity error;

        -- Teste 5 - Soma com Overflow
        A_in <= HIGH_BIT_M1;
        B_in <= x"0000000000000001";
        S_in <= "0010";
        wait for DELAY;
        assert F_out = HIGH_BIT_P1 and Z_out = '0' and Ov_out = '1' and Co_out = '0' report "Erro 5: SOMA Overflow falhou" severity error;

        -- Teste 6 - Subtração com overflow
        A_in <= HIGH_BIT_P1;
        B_in <= x"0000000000000001";
        S_in <= "0110";
        wait for DELAY;
        assert F_out = HIGH_BIT_M1 and Z_out = '0' and Ov_out = '1' and Co_out = '1' report "Erro 6: SUBTRAÇÃO Overflow falhou" severity error;
        
        -- Teste 7 - Soma com flag Zero
        A_in <= x"0000000000000005";
        B_in <= x"FFFFFFFFFFFFFFFB";
        S_in <= "0010";
        wait for DELAY;
        assert F_out = (others => '0') and Z_out = '1' and Ov_out = '0' and Co_out = '1' report "Erro 7: SOMA Zero Flag (5 + (-5)) falhou" severity error;

        -- Teste 8 - Subtração com flag Zero
        A_in <= x"0000000000000005";
        B_in <= x"0000000000000005";
        S_in <= "0110";
        wait for DELAY;
        assert F_out = (others => '0') and Z_out = '1' and Ov_out = '0' and Co_out = '1' report "Erro 8: SUBTRAÇÃO Zero Flag (5 - 5) falhou" severity error;

        -- Teste 9 - Pass B 
        A_in <= x"FFFFFFFFFFFFFFFF";
        B_in <= VAL_B;
        S_in <= "0111";
        wait for DELAY;
        assert F_out = VAL_B and Z_out = '0' report "Erro 9: PASS B falhou" severity error;

        -- Teste 10 - NOR 
        A_in <= x"0000000000000000";
        B_in <= x"0000000000000001";
        S_in <= "1100";
        wait for DELAY;
        assert F_out = x"FFFFFFFFFFFFFFFE" and Z_out = '0' report "Erro 10: NOR falhou" severity error;

        -- FIM DO TESTE
        assert false report "Teste da ULA 64 concluído com sucesso." severity note;
        wait;
        
    end process;
    
end architecture tb;