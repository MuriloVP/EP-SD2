library ieee;
use ieee.numeric_bit.all;

entity tb_sign_extend is
end entity;

architecture tb of tb_sign_extend is

  constant IN_SIZE  : natural := 8;  
  constant OUT_SIZE : natural := 12; 
  constant POS_BITS : natural := 3;  

  component sign_extend is
    generic (
        dataISize       : natural;
        dataOSize       : natural;
        dataMaxPosition : natural
    );
    port(
        inData      : in  bit_vector(dataISize-1 downto 0);
        inDataStart : in  bit_vector(dataMaxPosition-1 downto 0);
        inDataEnd   : in  bit_vector(dataMaxPosition-1 downto 0);
        outData     : out bit_vector(dataOSize-1 downto 0)
    );
  end component;

  -- Sinais
  signal s_inData      : bit_vector(IN_SIZE-1 downto 0) := (others => '0');
  signal s_inDataStart : bit_vector(POS_BITS-1 downto 0) := (others => '0');
  signal s_inDataEnd   : bit_vector(POS_BITS-1 downto 0) := (others => '0');
  signal s_outData     : bit_vector(OUT_SIZE-1 downto 0);

begin

  -- Instanciação do DUT
  dut: sign_extend
       generic map (
           dataISize       => IN_SIZE,
           dataOSize       => OUT_SIZE,
           dataMaxPosition => POS_BITS
       )
       port map (
           inData      => s_inData,
           inDataStart => s_inDataStart,
           inDataEnd   => s_inDataEnd,
           outData     => s_outData
       );

  gerador_estimulos: process is
      
      type pattern_type is record
          val_in    : bit_vector(IN_SIZE-1 downto 0);
          pos_start : bit_vector(POS_BITS-1 downto 0); -- Bit de sinal (fim superior)
          pos_end   : bit_vector(POS_BITS-1 downto 0); -- Bit inferior
          esperado  : bit_vector(OUT_SIZE-1 downto 0);
      end record;
      
      type pattern_array is array (natural range <>) of pattern_type;
      
      constant patterns: pattern_array := (

          ("00010001", "100", "001", "111111111000"),

          ("11100111", "011", "000", "000000000111"),
          
          ("00100000", "101", "101", "111111111111"),

          ("10000000", "111", "000", "111110000000")
      );

  begin
      assert false report "Iniciando teste do Extensor de Sinal..." severity note;
      
      for i in patterns'range loop
          s_inData      <= patterns(i).val_in;
          s_inDataStart <= patterns(i).pos_start;
          s_inDataEnd   <= patterns(i).pos_end;
          
          wait for 10 ns;
          --Verifica as sídas
          assert s_outData = patterns(i).esperado
          report "Erro no caso " & integer'image(i) 
          severity error;
      end loop;
	  --Informa fim do teste	
      assert false report "Teste concluido." severity note;
      wait;
  end process;

end architecture tb;