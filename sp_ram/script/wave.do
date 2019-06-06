onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate :tb_sp_ram:dut:clk
add wave -noupdate :tb_sp_ram:dut:rst_n
add wave -noupdate :tb_sp_ram:dut:port_req_i
add wave -noupdate -radix hexadecimal :tb_sp_ram:dut:port_addr_i
add wave -noupdate :tb_sp_ram:dut:port_we_i
add wave -noupdate -radix hexadecimal :tb_sp_ram:dut:port_wdata_i
add wave -noupdate :tb_sp_ram:dut:en_i
add wave -noupdate :tb_sp_ram:dut:be_i
add wave -noupdate :tb_sp_ram:dut:port_gnt_o
add wave -noupdate :tb_sp_ram:dut:port_rvalid_o
add wave -noupdate -radix hexadecimal :tb_sp_ram:dut:port_rdata_o
add wave -noupdate :tb_sp_ram:dut:mem_flag
add wave -noupdate :tb_sp_ram:dut:mem_result
add wave -noupdate -radix hexadecimal :tb_sp_ram:dut:wdata
add wave -noupdate -radix hexadecimal :tb_sp_ram:dut:addr
add wave -noupdate :tb_sp_ram:dut:i
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {665 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 263
configure wave -valuecolwidth 82
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {613 ps} {901 ps}
