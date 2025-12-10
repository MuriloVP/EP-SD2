library ieee;
use ieee.numeric_bit.all;

entity adder_n is
    generic (
        dataSize: natural := 64 
    );
    port(
        in0  : in  bit_vector(dataSize-1 downto 0);
        in1  : in  bit_vector(dataSize-1 downto 0);
        sum  : out bit_vector(dataSize-1 downto 0);
        cOut : out bit
    );
end entity adder_n;

architecture adder_n_arch of adder_n is
   signal sum_c: bit_vector(dataSize downto 0);  
begin
   sum_c <= bit_vector(unsigned('0' & in0) + unsigned('0' & in1));  
   sum   <= sum_c(dataSize-1 downto 0);      
   cOut <= sum_c(dataSize);           
end adder_n_arch;