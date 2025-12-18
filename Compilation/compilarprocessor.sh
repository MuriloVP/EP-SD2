#docker run --rm -v C:\Users\dtlco\mydata\SD-PROCESSADOR\EP-SD2 -w /workspace --name ghdl -it ghdl/ghdl:buster-mcode /bin/bash

#docker run --rm -v C:/Users/dtlco/mydata/af4/af4/onescounter-ghdl:/workspace -w /workspace --name ghdl -it ghdl/ghdl:buster-mcode /bin/bash

#opendockerapp
#./compilar<nome>.sh no terminal

ghdl -a Registrador_par.vhd
ghdl -a Mux_par.vhd
ghdl -a Mem_instr.vhd
ghdl -a Mem_dados.vhd
ghdl -a Adder_par.vhd
ghdl -a fulladder.vhd
ghdl -a Ula_bit.vhd
ghdl -a Extensor_par.vhd
ghdl -a Left_shifter.vhd
ghdl -a Regfile.vhd
ghdl -a Ula64.vhd
ghdl -a fluxoDados.vhd
ghdl -a unidadeControle.vhd
ghdl -a polilegv8.vhd
ghdl -a polilegv8_tb.vhd

ghdl -e polilegv8_tb
ghdl -r polilegv8_tb --vcd=saidapolilegv8ula64change.vcd


#ghdl -a fulladder.vhd
#ghdl -a Ula_bit.vhd
#ghdl -a Ula64.vhd
#ghdl -a Ula64_tb.vhd

#ghdl -e tb
#ghdl -r tb --vcd=saidaula64.vcd