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

entity fluxoDados is
    port(
        clock : in bit; -- entrada de clock
        reset : in bit; -- clear assincrono
        extendMSB : in bit_vector (4 downto 0); -- sinal de controle sign-extend
        extendLSB : in bit_vector (4 downto 0); -- sinal de controle sign-extend
        reg2Loc : in bit; -- sinal de controle MUX Read Register 2
        regWrite : in bit; -- sinal de controle Write Register
        aluSrc : in bit; -- sinal de controle MUX entrada B ULA
        alu_control : in bit_vector (3 downto 0); -- sinal de controle da ULA
        branch : in bit; -- sinal de controle desvio condicional
        uncondBranch : in bit; -- sinal de controle desvio incondicional
        memRead : in bit; -- sinal de controle leitura RAM dados
        memWrite : in bit; -- sinal de controle escrita RAM dados
        memToReg : in bit; -- sinal de controle MUX Write Data
        opcode : out bit_vector (10 downto 0) -- sinal de condição código da instrução
    );
end entity fluxoDados;

architecture arch of fluxoDados is

    -- Declaracao de componentes ja projetados

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

    component memoriaInstrucoes is
        generic (
            addressSize : natural := 8;    
            dataSize    : natural := 8;    
            datFileName : string  := "memInstr_conteudo.dat" 
        );
        port (
            addr : in  bit_vector(addressSize-1 downto 0);
            data : out bit_vector(4*dataSize-1 downto 0)
        );
    end component;

    component regfile is
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
        );
    end component;

    component sign_extend is
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
    end component;

    component ula is
        port (
            A  : in  bit_vector (63 downto 0);  -- entrada A
            B  : in  bit_vector (63 downto 0);  -- entrada B
            S  : in  bit_vector (3 downto 0);   -- seleciona operacao
            F  : out bit_vector (63 downto 0);  -- saida
            Z  : out bit;                       -- flag zero
            Ov : out bit;                       -- flag overflow
            Co : out bit                        -- flag carry out
        );
    end component;

    component mux_n is
        generic (
            dataSize: natural := 64
        );
        port (
            in0  : in  bit_vector(dataSize-1 downto 0);
            in1  : in  bit_vector(dataSize-1 downto 0);
            sel  : in  bit;
            dOut : out bit_vector(dataSize-1 downto 0)
        );
    end component;

    component memoriaDados is
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
    end component;

    component adder_n is
        generic (
            dataSize: natural := 64 
        );
        port(
            in0  : in  bit_vector(dataSize-1 downto 0);
            in1  : in  bit_vector(dataSize-1 downto 0);
            sum  : out bit_vector(dataSize-1 downto 0);
            cOut : out bit
        );
    end component;

    component two_left_shifts is
        generic (
            dataSize: natural := 64
        );
        port(
            input  : in  bit_vector(dataSize-1 downto 0);
            output : out bit_vector(dataSize-1 downto 0)
        );
    end component;

    signal pc_in : bit_vector(63 downto 0);
    signal pc_out : bit_vector(6 downto 0);
    signal instruction : bit_vector(31 downto 0);
    signal reg2Loc_out : bit_vector(63 downto 0);
    signal qr1, qr2, sign_ext_out : bit_vector(63 downto 0);
    signal branch_adder_out, common_adder_out : bit_vector(63 downto 0);
    signal twoshifts_out, ula_inb, ula_result : bit_vector(63 downto 0);
    signal memDadostoMux, muxtoRegwrite : bit_vector(63 downto 0);
    signal z_flag, ov_flag, co_flag, co_common, co_branch, Selpc : bit;

begin

    pc: reg
        generic map (dataSize => 7)
        port map (
            clock => clock,
            reset => reset,
            enable => '1',
            d => pc_in(6 downto 0),
            q => pc_out
        );
    
    memInstr: memoriaInstrucoes
        generic map (
            addressSize => 7,    
            dataSize    => 8,    
            datFileName => "memInstrPolilegv8.dat" 
        )
        port map (
            addr => pc_out,
            data => instruction
        );

    mux_reg2Loc: mux_n
        generic map (
            dataSize => 64
        )
        port map (
            in0 => (63 downto 5 => '0') & instruction(20 downto 16),
            in1 => (63 downto 5 => '0') & instruction(4 downto 0),
            sel => reg2Loc,
            dOut => reg2Loc_out
        );

    regBanco: regfile
        port map (
            clock => clock,       
            reset => reset,       
            regWrite => regWrite,   
            rr1 => instruction(9 downto 5),         
            rr2 => reg2Loc_out(4 downto 0),              
            wr => instruction(4 downto 0),     
            d => muxtoRegwrite,    
            q1 => qr1,    
            q2 => qr2         
        );

    sign_ext: sign_extend
        generic map (
            dataISize => 32,       
            dataOSize => 64,       
            dataMaxPosition => 5
        )
        port map (
            inData => instruction,
            inDataStart => extendMSB,
            inDataEnd => extendLSB,
            outData => sign_ext_out
        );

    mux_ula_inb: mux_n
        generic map (
            dataSize => 64
        )
        port map (
            in0 => qr2,
            in1 => sign_ext_out,
            sel => aluSrc,
            dOut => ula_inb
        );

    ula64: ula
        port map (
            A => qr1,
            B => ula_inb,
            S => alu_control,
            F => ula_result,
            Z => z_flag,
            Ov => ov_flag,
            Co => co_flag
        );

    memDados: memoriaDados
        generic map (
            addressSize => 7,
            dataSize => 8,
            datFileName => "memDadosInicialPolilegv8.dat"
        )
        port map (
            clock => clock, 
            wr => memWrite,     
            addr => ula_result(6 downto 0),  
            data_i => qr2,
            data_o => memDadostoMux
        );

    mux_memtoReg: mux_n
        generic map (
            dataSize => 64
        )
        port map (
            in0 => ula_result,
            in1 => memDadostoMux,
            sel => memToReg,
            dOut => muxtoRegwrite
        ); 
        
    shift2: two_left_shifts
        generic map (
            dataSize => 64
        )
        port map (
            input => sign_ext_out,
            output => twoshifts_out
        );

    common_adder: adder_n
        generic map (
            dataSize => 64
        )
        port map (
            in0 => (63 downto 7 => '0') & pc_out,
            in1 => (63 downto 3 => '0') & "100",
            sum => common_adder_out,
            cOut => co_common
        );

    branch_adder: adder_n
        generic map (
            dataSize => 64
        )
        port map (
            in0 => (63 downto 7 => '0') & pc_out,
            in1 =>  twoshifts_out,
            sum => branch_adder_out,
            cOut => co_branch
        );

    Selpc <= uncondBranch or (branch and z_flag);

    mux_pc: mux_n
        generic map (
            dataSize => 64
        )
        port map (
            in0 => common_adder_out,
            in1 => branch_adder_out,
            sel => Selpc,
            dOut => pc_in
        );

    opcode <= instruction(31 downto 21);

end arch;