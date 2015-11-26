# zxgate-digiasic-ask2ca

Based on zxgate (zx01)
- Added Scan doubler for VGA output
- Z80 clocked at ~3.57Mhz (50Mhz/7/2) for 56Hz output
- VGA output 600x800 @ 56Hz

Not fully tested...

Download via RS232:
- tape_in connected to the FPGA board's RX
- 'digital' filtering to use RS232 regular signal at 38400bps
- use 'ptors' program to convert .P files to RS232 signal you can pipe to RS

(ex. : ./ptors FILE.P >/dev/ttyS0)

- use 'setbr' to set baudrate (./setbr /dev/ttyS0 38400)

38400 seems to be fine, although exact bitrate should be around 36000.

