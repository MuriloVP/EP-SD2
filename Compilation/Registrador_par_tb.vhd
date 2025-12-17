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

entity reg_tb is
end entity;

architecture tb of reg_tb is
  
  -- Constante para definir o tamanho do teste
  constant N_BITS : natural := 4;

  -- Componente a ser testado (Device Under Test -- DUT)
  component reg is

    generic (dataSize: natural);
    port (
      clock:  in bit;
      reset:  in bit;
      enable: in bit;
      d:      in bit_vector(dataSize-1 downto 0);
      q:      out bit_vector(dataSize-1 downto 0)
    );
  end component;
  
  -- Declaração de sinais para conectar ao componente
  signal clk_in: bit := '0';
  signal rst_in, enable_in: bit := '0';
  signal d_in: bit_vector(N_BITS-1 downto 0);
  signal q_out: bit_vector(N_BITS-1 downto 0);

  -- Configurações do clock
  signal keep_simulating: bit := '0'; -- delimita o tempo de geração do clock
  constant clockPeriod : time := 10 ns;
  
begin
  -- Gerador de clock: executa enquanto 'keep_simulating = 1'
  clk_in <= (not clk_in) and keep_simulating after clockPeriod/2;
  
  -- Conecta DUT (Device Under Test)
  dut: reg

       generic map (dataSize => N_BITS)
       port map(Clock  => clk_in,
                Reset  => rst_in,
                Enable => enable_in,
                d      => d_in,
                q      => q_out
      );


gerador_estimulos: process is

    type pattern_type is record
        d_val: bit_vector(N_BITS-1 downto 0);
        enable_val: bit;
        reset_val: bit;
        q_esperado: bit_vector(N_BITS-1 downto 0);
    end record;

    type pattern_array is array (natural range <>) of pattern_type;

    constant patterns: pattern_array :=
    (
     ("0000", '0', '1', "0000"), -- 1. Reset
     ("1010", '1', '0', "1010"), -- 2. Escrita (Grava 1010)
     ("1111", '0', '0', "1010"), -- 3. Hold (Mantém 1010, ignora 1111)
     ("0101", '1', '0', "0101")  -- 4. Nova Escrita (Grava 0101)
    );

begin

    assert false report "Iniciando teste do Registrador ..." severity note;
    keep_simulating <= '1';

    for i in patterns'range loop
        -- Define as entradas
        d_in      <= patterns(i).d_val;
        enable_in <= patterns(i).enable_val;
        rst_in    <= patterns(i).reset_val;

        wait for clockPeriod;
            
        assert q_out = patterns(i).q_esperado report "Erro no registrador no caso " & integer'image(i) severity error;

    end loop;
    
    assert false report "Teste concluido." severity note;
    keep_simulating <= '0';
    wait;
    end process;

end tb;