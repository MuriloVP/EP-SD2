library IEEE;
use ieee.numeric_bit.all;

entity mux_n is
    generic (
        dataSize: natural := 64
    );
    port (
        in0  : in  bit_vector(dataSize-1 downto 0);
        in1  : in  bit_vector(dataSize-1 downto 0);
        sel  : in  bit;
        dOut : out bit_vector(dataSize-1 downto 0)
    );
end entity mux_n;

architecture arch_mux of mux_n is
begin
	with sel select
    dOut <= in0 when '0',
    	 	in1 when '1';
            
end architecture arch_mux;