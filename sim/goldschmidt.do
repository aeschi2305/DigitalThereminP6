onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /goldschmidt_tb/clk
add wave -noupdate /goldschmidt_tb/done
add wave -noupdate /goldschmidt_tb/init
add wave -noupdate /goldschmidt_tb/start
add wave -noupdate /goldschmidt_tb/den
add wave -noupdate /goldschmidt_tb/num
add wave -noupdate /goldschmidt_tb/quo
add wave -noupdate /goldschmidt_tb/goldschmidt_pm/den_reg
add wave -noupdate /goldschmidt_tb/goldschmidt_pm/num_reg
add wave -noupdate /goldschmidt_tb/goldschmidt_pm/count_reg
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ns} 0}
quietly wave cursor active 0
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
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
WaveRestoreZoom {250 ns} {1250 ns}
