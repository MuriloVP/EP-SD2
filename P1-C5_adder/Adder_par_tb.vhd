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

entity adder_tb is
end adder_tb;

architecture tb of adder_tb is

   constant N_BITS : natural := 4;
   -- Declara o componente do DUT
   component adder_n is
   	  generic (dataSize: natural);
      port(
      		in0  : in  bit_vector(dataSize-1 downto 0);
        	in1  : in  bit_vector(dataSize-1 downto 0);
        	sum  : out bit_vector(dataSize-1 downto 0);
        	cOut : out bit
     );
   end component;

   
  signal in0_in   : bit_vector(N_BITS-1 downto 0) := (others => 	'0');
  signal in1_in   : bit_vector(N_BITS-1 downto 0) := (others => 	'0');
  signal sum_out : bit_vector(N_BITS-1 downto 0) := (others => 		'0');
  signal cOut_out   : bit := '0';
begin
  
   dut: adder_n
       generic map (dataSize => N_BITS)
       port map(
           in0   => in0_in,
           in1   => in1_in,
           sum   => sum_out,
           cOut  => cOut_out
       );
   
   gerador_estimulos: process is
      
	  type pattern_type is record
        	in0_val       : bit_vector(N_BITS-1 downto 0);
        	in1_val       : bit_vector(N_BITS-1 downto 0);
        	sum_esperado  : bit_vector(N_BITS-1 downto 0);
            cOut_esperado : bit;
      end record;
	  
	  type pattern_array is array (natural range <>) of pattern_type;
	  
	  constant patterns: pattern_array :=
	     --                                op1  op2     carry_esperado  soma_esperada
		 (("0000","0000","0000",'0'),   --   0 +  0  =               0              0
		  ("0001","0001","0010",'0'),   --   1 +  1  =               0              2
		  ("1000","1000","0000",'1'),   --   8 +  8  =               1              0
		  ("1111","0001","0000",'1'),   --   F +  1  =               1              0
		  ("1110","0111","0101",'1'),   --   E +  7  =               1              5
		  ("0111","0011","1010",'0'),   --   7 +  3  =               0              A
		  ("1100","0101","0001",'1'));  --   C +  5  =               1              1
   
   begin
   
assert false report "Iniciando teste do Somador..." severity note;
      
      for i in patterns'range loop
      
        in0_in <= patterns(i).in0_val;
        in1_in <= patterns(i).in1_val;

         wait for 10 ns;
         --  Verifica as saidas
         assert sum_out = patterns(i).sum_esperado report "Erro na soma " & integer'image(to_integer(unsigned(patterns(i).in0_val))) & " + " & integer'image(to_integer(unsigned(patterns(i).in1_val))) severity error;
         assert cOut_out = patterns(i).cOut_esperado report "Erro no carry para " & integer'image(to_integer(unsigned(patterns(i).in0_val))) & " + " & integer'image(to_integer(unsigned(patterns(i).in1_val))) severity error;
      end loop;

	  -- Informa fim do teste
	  assert false report "Teste concluido." severity note;	  
	  wait; 
   end process;
   

end tb;