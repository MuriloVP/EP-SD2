library ieee;
use ieee.numeric_bit.all;

entity ula_bit_tb is
end entity;

architecture tb of ula_bit_tb is

    component ula_bit is
        port (
            a, b             : in bit;
            ainvert, binvert : in bit;
            cin              : in bit;
            operation        : in bit_vector(1 downto 0);
            result           : out bit;
            cout             : out bit;
            overflow         : out bit
        );
    end component;

    -- Sinais
    signal a_in, b_in, ainvert_in, binvert_in, cin_in : bit := '0';
    signal op_in : bit_vector(1 downto 0) := "00";
    signal result_out, cout_out, overflow_out : bit :='0';

begin

    dut: ula_bit port map (
        a => a_in, 
        b => b_in, 
        ainvert => ainvert_in, 
        binvert => binvert_in, 
        cin => cin_in, 
        operation => op_in,
        result => result_out, 
        cout => cout_out, 
        overflow => overflow_out
    );

    gerador_estimulos: process is
        
        type pattern_type is record
            a_val, b_val     : bit;
            ainvert_val      : bit;
            binvert_val      : bit;
            cin_val          : bit;
            op_val           : bit_vector(1 downto 0);
            result_esp       : bit;
            cout_esp         : bit;
            overflow_esp     : bit;
    end record;

    type pattern_array is array (natural range <>) of pattern_type;
      
    constant patterns: pattern_array := (
        --A,   B, Ainv, Binv,Cin,  Op,   Res, Cout, Ovf   | Descrição
        
        -- TESTE 1: AND
        ('0', '1', '0', '0', '0', "00",  '0', '0', '0'),  -- 0 AND 1 = 0
        -- TESTE 2: AND
        ('1', '1', '0', '0', '0', "00",  '1', '1', '1'),  -- 1 AND 1 = 1 
        -- TESTE 3: OR 
        ('0', '1', '0', '0', '0', "01",  '1', '0', '0'),  -- 0 OR 1 = 1
        -- TESTE 4: OR 
        ('0', '0', '0', '0', '0', "01",  '0', '0', '0'),  -- 0 OR 0 = 0
        -- TESTE 5: ADD
        ('0', '1', '0', '0', '0', "10",  '1', '0', '0'),  -- 0 + 1 + 0 = 1 
        -- TESTE 6: ADD
        ('1', '1', '0', '0', '0', "10",  '0', '1', '1'),  -- 1 + 1 + 0 = 0 
        -- TESTE 7: ADD
        ('1', '1', '0', '0', '1', "10",  '1', '1', '0'),  -- 1 + 1 + 1 = 1 
        -- TESTE 8: Pass B
        ('1', '0', '0', '0', '0', "11",  '0', '0', '0'),  -- Passa B (0)
        -- TESTE 9: ADD
        ('0', '1', '0', '0', '0', "11",  '1', '0', '0'),  -- Passa B (1)
        -- TESTE 10: AND Inversores 
        ('0', '0', '1', '1', '0', "00",  '1', '1', '1'),       
        -- TESTE 11: Subtração Implícita (A + not B + 1)
        ('1', '1', '0', '1', '1', "10",  '0', '1', '0')
    );

    begin
      assert false report "Iniciando simulacao da Ula de 1 bit..." severity note;
      
      for i in patterns'range loop
        a_in          <= patterns(i).a_val;
        b_in          <= patterns(i).b_val;
        ainvert_in    <= patterns(i).ainvert_val;
        binvert_in   <= patterns(i).binvert_val;
        cin_in        <= patterns(i).cin_val;
        op_in         <= patterns(i).op_val;
          
        wait for 10 ns;
        --Verifica as sídas
        assert result_out = patterns(i).result_esp 
        report "Erro no resultado do caso " & integer'image(i) 
        severity error;
        assert cout_out = patterns(i).cout_esp 
        report "Erro no Carry out do caso " & integer'image(i) 
        severity error;
        assert overflow_out = patterns(i).overflow_esp 
        report "Erro no resultado do caso " & integer'image(i) 
        severity error;
          
      end loop;
	  --Informa fim do teste	
      assert false report "Teste concluido." severity note;
      wait;
  end process;

end architecture tb;