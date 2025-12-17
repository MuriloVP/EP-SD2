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
use ieee.numeric_bit.ALL;
use std.textio.all;

entity memoriaInstrucoes is
    generic (
        addressSize : natural := 8;    
        dataSize    : natural := 8;    
        datFileName : string  := "memInstr_conteudo.dat" 
    );
    port (
        addr : in  bit_vector(addressSize-1 downto 0);
        data : out bit_vector(4*dataSize-1 downto 0)
    );
end entity memoriaInstrucoes;

architecture arch of memoriaInstrucoes is
  constant depth : natural := 2**addressSize;
  type mem_type is array (0 to depth-1) of bit_vector(dataSize-1 downto 0);
  --! Initial values filling function
  impure function init_mem(file_name : in string) return mem_type is
    file     f       : text open read_mode is file_name;
    variable l       : line;
    variable tmp_bv  : bit_vector(dataSize-1 downto 0);
    variable tmp_mem : mem_type;
  begin
    for i in mem_type'range loop
    	if not endfile(f) then
      		readline(f, l);
      		read(l, tmp_bv);
      		tmp_mem(i) := tmp_bv;
        end if;
    end loop;
    return tmp_mem;
  end;
  --! Memory matrix
  constant mem : mem_type := init_mem(datFileName);
begin
  process(addr)
    variable idx : integer;
  begin
    idx := to_integer(unsigned(addr));
    if idx <= depth - 4 then
      data <= mem(idx) & mem(idx+1) & mem(idx+2) & mem(idx+3);
    else
      data <= (others => '0');
    end if;
  end process; 
end arch;