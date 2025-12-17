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

entity regfile is
    port (
        clock       : in bit ; -- entrada de clock
        reset       : in bit ; -- entrada de reset
        regWrite    : in bit ; -- entrada de carga do registrador wr
        rr1         : in bit_vector (4 downto 0 ) ;     -- entrada define registrador 1
        rr2         : in bit_vector (4 downto 0 ) ;     -- entrada define registrador 2
        wr          : in bit_vector (4 downto 0 ) ;     -- entrada define registrador de escrita
        d           : in bit_vector (63 downto 0 ) ;    -- entrada de dado para carga paralela
        q1          : out bit_vector (63 downto 0 ) ;   -- saida do registrador rr1
        q2          : out bit_vector (63 downto 0)      -- saida do registrador rr2
) ;
end entity regfile ;

architecture arch of regfile is

    -- Declaração do componente reg
  component reg is
    generic (dataSize: natural := 64);
    port (
      clock:  in bit;
      reset:  in bit;
      enable: in bit;
      d:      in bit_vector(dataSize-1 downto 0);
      q:      out bit_vector(dataSize-1 downto 0)
    );
  end component;

-- Tipo para armazenar as 32 saídas dos registradores
    type reg_array_type is array (0 to 31) of bit_vector(63 downto 0);
    signal reg_data_out : reg_array_type;

-- Sinal para armazenar o valor inteiro do endereço de escrita
    signal wr_integer : integer range 0 to 31;

-- Sinal para as conversões inteiras dos endereços de leitura
    signal rr1_integer : integer range 0 to 31;
    signal rr2_integer : integer range 0 to 31;

-- Sinal de clock corrigido
    signal clock_att : bit;

begin


    -- Definição do clock_att
    with wr select
    clock_att <= clock when '0';
            <= not clock when '1';

    -- Conversão para integer
    wr_integer <= to_integer(unsigned(wr));
    rr1_integer <= to_integer(unsigned(rr1));
    rr2_integer <= to_integer(unsigned(rr2));

    -- Loop de Geração para Registradores X0 a X30
    gen_registers: for i in 0 to 30 generate

        -- O registrador i é habilitado se regWrite=1 E o endereço wr aponta para i
        signal reg_enable : bit; 
        
    begin
        -- Lógica de Geração do Sinal Enable
        reg_enable <= regWrite when wr_integer = i else '0';

        -- Instanciação do Registrador 'i'
        R_i: reg 
            generic map (dataSize => 64)
            port map (
                clock => clock_att,
                reset => reset,
                enable => reg_enable,
                d => d,
                q => reg_data_out(i)
            );
            
    end generate;
    
    -- (Para XZR(X31): a saída é sempre 0)
    reg_data_out(31) <= (others => '0');

    -- Leitura do registrador 1
    q1 <= reg_data_out(rr1_integer);

    --Leitura do registrador 2
    q2 <= reg_data_out(rr2_integer);

end architecture arch;