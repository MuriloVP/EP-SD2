library ieee;
use ieee.numeric_bit.all;

entity memoriaDados_tb is
end memoriaDados_tb;

architecture tb of memoriaDados_tb is

    constant N_ADDR : natural := 4; 
    constant N_DATA : natural := 8; 
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
            data_i : in  bit_vector(dataSize-1 downto 0);
            data_o : out bit_vector(dataSize-1 downto 0)
        );
    end component;
    
    signal clock_in   : bit := '0';
    signal wr_in      : bit := '0';
    signal addr_in    : bit_vector(N_ADDR-1 downto 0) := (others => '0');
    signal data_i_in  : bit_vector(N_DATA-1 downto 0) := (others => '0');
    signal data_o_out : bit_vector(N_DATA-1 downto 0);
    
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
            data_i_val      : bit_vector(N_DATA-1 downto 0);
            data_o_esperado : bit_vector(N_DATA-1 downto 0);
        end record;

        type pattern_array is array (natural range <>) of pattern_type;
        
        constant patterns: pattern_array := (
            --  wr,  addr,   data_i,  data_o esperado
            -- CASO 0: Leitura do arquivo
            ('0',"0000","00011001", "10000000"), 
            -- CASO 1: Leitura do arquivo 
            ('0',"1111","10011000", "00001001"),
            -- CASO 2: Escrita 
            ('1',"0010","10000001", "10000001"),
            -- CASO 3: Escrita 
            ('1',"0011","00000000", "00000000"),
            -- CASO 4: Escrita 
            ('1',"0100","10101010", "10101010") 
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
            report "Erro no endereco " & integer'image(to_integer(unsigned(addr_in))) &
                   ". Esperado: " & integer'image(to_integer(unsigned(patterns(i).data_o_esperado))) &
                   ", Lido: " & integer'image(to_integer(unsigned(data_o_out)))
            severity error;
        end loop;

        assert false report "Teste concluido." severity note;
        keep_simulating <= '0';
        wait;
    end process;

end architecture tb;