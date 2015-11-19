transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vcom -93 -work work {/ssd/altera/projects/zxgate/zx01/zx01xr.vhd}
vcom -93 -work work {/ssd/altera/projects/zxgate/zx97/video81.vhd}
vcom -93 -work work {/ssd/altera/projects/zxgate/zx97/top.vhd}
vcom -93 -work work {/ssd/altera/projects/zxgate/zx97/res_clk.vhd}
vcom -93 -work work {/ssd/altera/projects/zxgate/zx97/modes97.vhd}
vcom -93 -work work {/ssd/altera/projects/zxgate/zx97/lcd97.vhd}
vcom -93 -work work {/ssd/altera/projects/zxgate/zx97/io81.vhd}
vcom -93 -work work {/ssd/altera/projects/zxgate/zx97/busses.vhd}
vcom -93 -work work {/ssd/altera/projects/zxgate/ext/ps2me.vhd}
vcom -93 -work work {/ssd/altera/projects/zxgate/Z80/T80_Reg.vhd}
vcom -93 -work work {/ssd/altera/projects/zxgate/Z80/T80_Pack.vhd}
vcom -93 -work work {/ssd/altera/projects/zxgate/Z80/T80_MCode.vhd}
vcom -93 -work work {/ssd/altera/projects/zxgate/Z80/T80_ALU.vhd}
vcom -93 -work work {/ssd/altera/projects/zxgate/rom81.vhd}
vcom -93 -work work {/ssd/altera/projects/zxgate/Z80/T80.vhd}
vcom -93 -work work {/ssd/altera/projects/zxgate/Z80/T80s.vhd}

