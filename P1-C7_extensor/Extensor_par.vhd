library ieee;
use ieee.numeric_bit.all;

entity sign_extend is
    generic (
        dataISize       : natural := 32; -- Tamanho da entrada
        dataOSize       : natural := 64; -- Tamanho da saída
        dataMaxPosition : natural := 5   -- (log2(dataISize)=5)
    );
    port(
        inData      : in  bit_vector(dataISize-1 downto 0);
        inDataStart : in  bit_vector(dataMaxPosition-1 downto 0); -- Bit mais significativo (Sinal)
        inDataEnd   : in  bit_vector(dataMaxPosition-1 downto 0); -- Bit menos significativo
        outData     : out bit_vector(dataOSize-1 downto 0)
    );
end entity sign_extend;

architecture arch of sign_extend is
begin
    process(inData, inDataStart, inDataEnd)

        variable i_start : integer;
        variable i_end   : integer;
        variable data : integer; -- Tamanho do dado útil extraído
        variable sign_bit : bit;
    begin

        i_start := to_integer(unsigned(inDataStart));
        i_end   := to_integer(unsigned(inDataEnd));
        

        data := i_start - i_end + 1;
        
        sign_bit := inData(i_start);

        for k in 0 to dataOSize-1 loop
            if k < data then
                outData(k) <= inData(i_end + k);
            else
                outData(k) <= sign_bit;
            end if;     
        end loop;
        
    end process;
end architecture arch;
