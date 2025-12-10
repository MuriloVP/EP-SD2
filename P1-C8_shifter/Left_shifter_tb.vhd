library ieee;
use ieee.numeric_bit.all;

entity left_shift_tb is
end left_shift_tb;

architecture tb of left_shift_tb is

    constant N_BITS : natural := 6;

    component two_left_shifts is
        generic (dataSize: natural);
        port(
            input  : in  bit_vector(dataSize-1 downto 0);
            output : out bit_vector(dataSize-1 downto 0)
        );
    end component;

    signal input_in   : bit_vector(N_BITS-1 downto 0) := (others => '0');
    signal output_out : bit_vector(N_BITS-1 downto 0) := (others => '0');

begin
  
    dut: two_left_shifts
        generic map (dataSize => N_BITS)
        port map(
            input  => input_in,
            output => output_out
        );
   
    gerador_estimulos: process is
      
        type pattern_type is record
            input_val       : bit_vector(N_BITS-1 downto 0);
            output_esperado : bit_vector(N_BITS-1 downto 0);
        end record;
      
        type pattern_array is array (natural range <>) of pattern_type;
      
        constant patterns: pattern_array :=
           (
            ("000000", "000000"),   
            ("110000", "000000"),   
            ("100001", "000100"),   
            ("111111", "111100"),   
            ("001111", "111100"),   
            ("101010", "101000"),   
            ("000011", "001100")    
           ); 
   
    begin
   
        assert false report "Iniciando teste do Deslocador Assíncrono..." severity note;
      
        for i in patterns'range loop
      
            input_in <= patterns(i).input_val;

            wait for 10 ns;
         
            assert output_out = patterns(i).output_esperado 
            report "Erro no caso " & integer'image(i)  
            severity error;

        end loop;

        -- Informa fim do teste
        assert false report "Teste concluido com sucesso." severity note;      
        wait; 
    end process;
   
end tb;