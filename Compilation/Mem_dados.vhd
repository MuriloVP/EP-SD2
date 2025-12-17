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
use std.textio.all;

entity memoriaDados is
  generic(
    addressSize  : natural := 8;
    dataSize     : natural := 8;
    datFileName  : string  := "memDados_conteudo_inicial.dat"
  );
  port(
    clock  : in  bit; 
    wr     : in  bit;
    addr   : in  bit_vector(addressSize-1 downto 0);
    data_i : in  bit_vector(8*dataSize-1 downto 0);
    data_o : out bit_vector(8*dataSize-1 downto 0)
  );
end memoriaDados;

architecture arch of memoriaDados is
  constant depth : natural := 2**addressSize;
  type mem_type is array (0 to depth-1) of bit_vector(dataSize-1 downto 0);
  
  impure function init_mem(file_name : in string) return mem_type is
    file     f       : text open read_mode is file_name;
    variable l       : line;
    variable tmp_bv  : bit_vector(dataSize-1 downto 0);
    variable tmp_mem : mem_type;
  begin

    for i in mem_type'range loop
        tmp_mem(i) := (others => '0');
    end loop;

    for i in mem_type'range loop
        if not endfile(f) then
             readline(f, l);
             read(l, tmp_bv);
             tmp_mem(i) := tmp_bv;
        end if;
    end loop;
    return tmp_mem;
  end;

  signal mem : mem_type := init_mem(datFileName);
  
begin
  wrt: process(clock)
    variable idx: integer; 
  begin
    if (clock='1' and clock'event) then
      if (wr='1') then
        idx := to_integer(unsigned(addr));
        if idx <= depth - 8 then
                    mem(idx)   <= data_i(63 downto 56);
                    mem(idx+1) <= data_i(55 downto 48);
                    mem(idx+2) <= data_i(47 downto 40);
                    mem(idx+3) <= data_i(39 downto 32);
                    mem(idx+4) <= data_i(31 downto 24);
                    mem(idx+5) <= data_i(23 downto 16);
                    mem(idx+6) <= data_i(15 downto 8);
                    mem(idx+7) <= data_i(7 downto 0);  
            end if;
      end if;
    end if;
  end process;

  process(addr, mem)
    variable idx: integer;
  begin
    idx := to_integer(unsigned(addr));
    if idx <= depth - 8 then
            data_o <= mem(idx)   & mem(idx+1) & mem(idx+2) & mem(idx+3) &
                      mem(idx+4) & mem(idx+5) & mem(idx+6) & mem(idx+7);
        else
            data_o <= (others => '0');
        end if;
    end process;
  
end arch;