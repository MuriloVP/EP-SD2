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

entity mux_tb is
end mux_tb;

architecture tb of mux_tb is

  -- Constante para definir o tamanho do teste
  constant N_BITS : natural := 4;

  -- Declara o componente do DUT
  component mux_n is
    generic (dataSize: natural);
    port (
        in0  : in  bit_vector(dataSize-1 downto 0);
        in1  : in  bit_vector(dataSize-1 downto 0);
        sel  : in  bit;
        dOut : out bit_vector(dataSize-1 downto 0)
    );
  end component;

  signal in0_in, in1_in, dOut_out: bit_vector(N_BITS -1 downto 0);
  signal sel_in: bit;

begin
  

   dut: mux_n
       generic map (dataSize => N_BITS)
       port map(in0   => in0_in,
                in1   => in1_in,
                sel   => sel_in,
                dOut  => dOut_out
      );
   
   gerador_estimulos: process is
      
      type pattern_type is record
        in0_val: bit_vector(N_BITS-1 downto 0);
        in1_val: bit_vector(N_BITS-1 downto 0);
        sel_val: bit;
        dOut_esperado: bit_vector(N_BITS-1 downto 0);
      end record;
      
      type pattern_array is array (natural range <>) of pattern_type;
      
      constant patterns: pattern_array :=
         (
          -- in0     in1     sel   esperado
          ("0000", "0000", '0', "0000"),   
          ("1000", "0001", '0', "1000"),  
          ("1010", "1000", '0', "1010"),   
          ("1110", "1111", '1', "1111"),   
          ("0000", "0111", '1', "0111"),   
          ("0111", "0011", '1', "0011")    
         ); 
   
   begin
   
      assert false report "Iniciando teste do Multiplexador..." severity note;

      
      for i in patterns'range loop
        -- Define as entradas
        in0_in      <= patterns(i).in0_val;
        in1_in      <= patterns(i).in1_val;
        sel_in      <= patterns(i).sel_val;
        
        wait for 10 ns;
         
         --  Verifica as saidas

         assert dOut_out = patterns(i).dOut_esperado 
         report "Erro no multiplexador no caso " & integer'image(i) severity error;
      
      end loop;

      -- Informa fim do teste
      assert false report "Teste concluido." severity note;      
      wait;  
   end process;
   
end tb;