library ieee;
use ieee.numeric_bit.all;

entity ula is
    port (
        A  : in  bit_vector (63 downto 0);  -- entrada A
        B  : in  bit_vector (63 downto 0);  -- entrada B
        S  : in  bit_vector (3 downto 0);   -- seleciona operacao
        F  : out bit_vector (63 downto 0);  -- saida
        Z  : out bit;                       -- flag zero
        Ov : out bit;                       -- flag overflow
        Co : out bit                        -- flag carry out
    );
end entity ula;

architecture arch of ula is

    -- Declaração do componente ula
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

    type ula_array_type is array (63 downto 0) of bit_vector(63 downto 0);
    signal ula_cout : ula_array_type;
    signal ula_result : ula_array_type;

    signal A_invert : bit_vector (63 downto 0);
    signal B_invert : bit_vector (63 downto 0);
    signal A_unsigned : unsigned (63 downto 0);
    signal A_unsigned_invert : unsigned (63 downto 0);
    signal B_unsigned : unsigned (63 downto 0);
    signal B_unsigned_invert : bit_vector(63 downto 0);
    signal Cin_init : bit;
    signal Or_64bits : bit;
    signal Or_result : bit_vector (63 downto 0);
    signal Op_dec


begin

    A_unsigned <= unsigned(A);
    B_unsigned <= unsigned(B);
    A_unsigned_invert <= (NOT A_unsigned) + 1;
    B_unsigned_invert <= (NOT B_unsigned) + 1;
    A_invert <= bit_vector(A_unsigned_invert);
    B_invert <= bit_vector(B_unsigned_invert);

    with S select
    Op_dec <= "00" when "0000",
            "01" when "0001",
            "10" when "0010"


    Ula_0: component ula_bit 
            port map (
               a => A(0),
               b => B(0),
               ainvert => A_invert(0),
               binvert => B_invert(0),
               cin => ,
               operation => ,
               result => ula_result(0),
               cout => ula_cout(0),
               overflow =>
            );
    -- Loop de Geração para Registradores X0 a X30
    gen_ulas: for i in 1 to 63 generate
        
    begin

        -- Instanciação do Registrador 'i'
        Ula_i: component ula_bit 
            port map (
               a => A(i),
               b => B(i),
               ainvert => A_invert(i),
               binvert => B_invert(i),
               cin => ula_cout(i-1);
               operation => ,
               result => ula_result(i),
               cout => ula_cout(i),
               overflow => 
            );
            
    end generate gen_ulas;

    
    Or_result <= ula_result(0);

    Or_camparador : for i in 1 to 63 loop

        Or_result(i) <= ula_result(i) or Or_result(i-1);
        
    end loop ; -- Or_camparador
    Or_64bits <= or_result(63);
    Z <= not (Or_64bits);
    
   Ov<= u63_cout(63);
   F <= ula_cout;

end architecture arch;