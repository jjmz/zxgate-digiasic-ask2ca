----------------------------------------------------------
--  zx01xr.vhd
--		ZX01 top level with external RAM interface
--		==========================================
--
--  10/01/02	Daniel Wallner : Creation
----------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- the pads ----------------------------------------------

entity zx01xr is
  port (rst_n:    in    std_ulogic;
        clk50:    in    std_ulogic;
        kbd_clk:  in    std_ulogic;
        kbd_data: in    std_ulogic;
        v_inv:    in    std_ulogic;
        usa_uk:   in   	std_ulogic;
        video:    out   std_ulogic;
        tape_in:  in    std_ulogic;
        tape_out: out   std_ulogic;
		oe_n:     out   std_logic;
		we_n:     out   std_logic;
		ramcs_n:  out   std_logic;
		--romcs_n:  out   std_logic;
		--pgm_n:    out   std_logic;
		a:        out   std_logic_vector(14 downto 0);
		d:        inout std_logic_vector(7 downto 0);

		vgaR,vgaG,vgaB : out std_ulogic;
		
        d_lcd:    out   std_ulogic_vector(3 downto 0);
        s:        out   std_ulogic;
        cp1:      out   std_ulogic;
        cp2:      out   std_ulogic);
end;

-- the top level ------------------------------

architecture rtl of zx01xr is

  component PS2_MatrixEncoder
  port (Clk:      in std_logic;
        Reset_n:  in std_logic;
        Tick1us:  in std_logic;
        PS2_Clk:  in std_logic;
        PS2_Data: in std_logic;
        Key_Addr: in std_logic_vector(7 downto 0);
        Key_Data: out std_logic_vector(4 downto 0));
  end component;

  component T80s
  generic(
        Mode : integer := 0;
		T2Write : integer := 0);
  port (RESET_n		: in std_logic;
        CLK_n		: in std_logic;
        WAIT_n		: in std_logic;
        INT_n		: in std_logic;
        NMI_n		: in std_logic;
        BUSRQ_n		: in std_logic;
        M1_n		: out std_logic;
        MREQ_n		: out std_logic;
        IORQ_n		: out std_logic;
        RD_n		: out std_logic;
        WR_n		: out std_logic;
        RFSH_n		: out std_logic;
        HALT_n		: out std_logic;
        BUSAK_n		: out std_logic;
        A			: out std_logic_vector(15 downto 0);
        DI			: in std_logic_vector(7 downto 0);
        DO			: out std_logic_vector(7 downto 0));
  end component;

  component rom81
  port (clock: in std_logic;
        address:   in std_logic_vector(12 downto 0);
        q:   out std_logic_vector(7 downto 0));
  end component;

  component top
  generic (synchronous: boolean := false);
  port (clock:   in  std_ulogic;
        clock_2: out std_ulogic;
        phi:     in  std_ulogic;
        n_reset: out std_ulogic;
        n_modes: out std_ulogic;
        a_mem_h: out std_ulogic_vector(14 downto 13);
        a_mem_l: out std_ulogic_vector(8 downto 0);
        d_mem_i: in  std_ulogic_vector(7 downto 0);
        a_cpu:   in  std_ulogic_vector(15 downto 0);
        d_cpu_i: in  std_ulogic_vector(7 downto 0);
        d_cpu_o: out std_ulogic_vector(7 downto 0);
        oe_cpu:  out boolean;
        oe_mem:  out boolean;
        n_m1:    in  std_ulogic;
        n_mreq:  in  std_ulogic;
        n_iorq:  in  std_ulogic;
        n_wr:    in  std_ulogic;
        n_rd:    in  std_ulogic;
        n_rfsh:  in  std_ulogic;
        n_nmi:   out std_ulogic;
        n_halt:  in  std_ulogic;
        n_wait:  out std_ulogic;
        n_romcs: out std_ulogic;
        n_ramcs: out std_ulogic;
        kbd_col: in  std_ulogic_vector(4 downto 0);
        usa_uk:  in  std_ulogic;
        video:   out std_ulogic;
        n_sync:  out std_ulogic;
        o_vsync:  out std_ulogic;
        o_hsync:  out std_ulogic;
        tape_in: in  std_ulogic;
        d_lcd:   out std_ulogic_vector(3 downto 0);
        s:       out std_ulogic;
        cp1:     out std_ulogic;
        cp2:     out std_ulogic);
  end component;

component DBLSCAN
  port (I_R               : in    std_logic_vector( 2 downto 0);
	I_G               : in    std_logic_vector( 2 downto 0);
	I_B               : in    std_logic_vector( 1 downto 0);
	I_HSYNC           : in    std_logic;
	I_VSYNC           : in    std_logic;
	--
	O_R               : out   std_logic_vector( 2 downto 0);
	O_G               : out   std_logic_vector( 2 downto 0);
	O_B               : out   std_logic_vector( 1 downto 0);
	O_HSYNC           : out   std_logic;
	O_VSYNC           : out   std_logic;
	--
	ENA_6             : in    std_logic;
	ENA_12            : in    std_logic;
	CLK               : in    std_logic);
  end component;
  
  signal a_mem_h:   std_ulogic_vector(14 downto 13);
  signal a_mem_l:   std_ulogic_vector(8 downto 0);
  signal a_mem:     std_logic_vector(14 downto 0);
  signal d_rom:     std_logic_vector(7 downto 0);
  signal n_romcs:   std_ulogic;
  signal n_ramcs:   std_ulogic;
  signal a_cpu:     std_logic_vector(15 downto 0);
  signal n_m1:      std_ulogic;
  signal n_mreq:    std_ulogic;
  signal n_iorq:    std_ulogic;
  signal n_wr:      std_ulogic;
  signal n_rd:      std_ulogic;
  signal n_rfsh:    std_ulogic;
  signal n_nmi:     std_ulogic;
  signal n_halt:    std_ulogic;
  signal n_wait:    std_ulogic;
  signal clock_2:   std_ulogic;
  signal i_phi:     std_ulogic;
  signal i_n_modes: std_ulogic;
  signal d_mem_i:   std_ulogic_vector(7 downto 0);
  signal d_cpu_i:   std_logic_vector(7 downto 0);
  signal d_cpu_o:   std_ulogic_vector(7 downto 0);
  signal Tick1us:   std_logic;
  signal kbd_col:   std_logic_vector(4 downto 0);
  signal kbd_mode:  std_logic_vector(4 downto 0);
  signal i_kbd_col: std_logic_vector(4 downto 0);
  signal i_video:   std_ulogic;
  signal i_n_sync:  std_ulogic;
  signal i_n_reset: std_ulogic;
  signal s_n_reset: std_ulogic;

  signal div50: unsigned(2 downto 0);
  signal clock: std_ulogic;
  
  signal pixel: std_ulogic;

  signal ena7,ena14: std_ulogic;

  signal i_vsync: std_ulogic;
  signal i_hsync: std_ulogic;
  
begin

  oe_n <= n_rd;
  we_n <= n_wr;
  ramcs_n <= n_ramcs;
  --romcs_n <= '1';
  --pgm_n <= '1';
  --a(16 downto 15) <= "00";
  a(14 downto 0) <= a_mem;
  d <= d_cpu_i when n_wr = '0' else (others => 'Z');

  process (rst_n, i_phi)
  begin
    if rst_n = '0' then
      s_n_reset <= '0';
    elsif i_phi'event and i_phi = '1' then
      s_n_reset <= '1';
    end if;
  end process;

  process (s_n_reset, i_phi)
    variable cnt : unsigned(1 downto 0);
  begin
    if s_n_reset = '0' then
      cnt := "00";
      Tick1us <= '0';
    elsif i_phi'event and i_phi = '1' then
      if cnt = "00" then
        cnt := "10";
        Tick1us <= '1';
      else
        cnt := cnt - 1;
        Tick1us <= '0';
      end if;
    end if;
  end process;

  c_PS2_MatrixEncoder: PS2_MatrixEncoder
    port map (Clk => i_phi,
              Reset_n => i_n_reset,
              Tick1us => Tick1us,
              PS2_Clk => kbd_clk,
              PS2_Data => kbd_data,
              Key_Addr => a_cpu(15 downto 8),
              Key_Data => kbd_col);

  i_kbd_col <= kbd_mode when i_n_modes = '0' else kbd_col;
  kbd_mode(3 downto 2) <= "00"; -- PAGE
  kbd_mode(4) <= v_inv;
  kbd_mode(1 downto 0) <= "00"; -- RAM

  c_Z80: T80s
    generic map (Mode => 0, T2Write => 1)
    port map (M1_n => n_m1,
              MREQ_n => n_mreq,
              IORQ_n => n_iorq,
              RD_n => n_rd,
              WR_n => n_wr,
              RFSH_n => n_rfsh,
              HALT_n => n_halt,
              WAIT_n => n_wait,
              INT_n => a_cpu(6),
              NMI_n => n_nmi,
              RESET_n => s_n_reset,
              BUSRQ_n => '1',
              BUSAK_n => open,
              CLK_n => i_phi,
              A => a_cpu,
              DI => std_logic_vector(d_cpu_o),
              DO => d_cpu_i);

  c_ROM81: rom81
    port map (clock => i_phi,
              address => a_mem(12 downto 0),
              q => d_rom);

  c_top: top
    generic map (true)
    port map (clock,clock_2,i_phi,
              i_n_reset,i_n_modes,
              a_mem_h,a_mem_l,d_mem_i,
              std_ulogic_vector(a_cpu),std_ulogic_vector(d_cpu_i),d_cpu_o,
              open,open,
              n_m1,n_mreq,n_iorq,n_wr,n_rd,n_rfsh,
              n_nmi,n_halt,n_wait,n_romcs,n_ramcs,
              std_ulogic_vector(i_kbd_col),usa_uk,
              i_video,i_n_sync,i_vsync,i_hsync,tape_in,
              d_lcd,s,cp1,cp2);

  i_phi <= clock_2;

  a_mem(14 downto 13) <= std_logic_vector(a_mem_h);
  a_mem(12 downto 9) <= a_cpu(12 downto 9);
  a_mem(8 downto 0) <= std_logic_vector(a_mem_l);
  d_mem_i <= std_ulogic_vector(d_rom) when n_ramcs = '1'
        else std_ulogic_vector(d);

  process(clk50)
  begin
   if clk50'event and clk50 = '1' then
      if div50(2 downto 0) = "110" then
		 div50<="000";
		else
		 div50 <= div50 + 1;
		end if;
    end if;
  end process;
    
  clock <= div50(2);
  
  ena7 <= '1' when div50(2 downto 0)="000" else '0';
  ena14 <= '1' when div50(1 downto 0)="00" else '0';
  
  --tape_out <= i_n_sync;		  
  --video <= '0' when i_n_sync='0'
  --    else 'Z' when i_video='0'
  --   else '1';
  --video <= i_video;

  pixel <= '0' when i_n_sync='0' else not i_video;
  
  scan2x: DBLSCAN
  port map (
   I_R(2) => pixel, I_R(1) => pixel, I_R(0) => pixel,
   I_G(2) => pixel, I_G(1) => pixel, I_G(0) => pixel,
   I_B(1) => pixel, I_B(0) => pixel,
	I_HSYNC => i_hsync,
	I_VSYNC => i_vsync,
	O_R(0) => vgaR,
	O_G(0) => vgaG,
	O_B(0) => vgaB,
	O_HSYNC  => video,
	O_VSYNC => tape_out,
	
	ENA_6 => ena7,
	ENA_12 => ena14,
	
	CLK => clk50);
  
  -- clock => 7.14Mhz => pixclock
  -- clock_2 => 3.57Mhz => Z80
    
end;

-- end ---------------------------------------------------
