onerror {quit -f}
vlib work
vlog -work work Incubator.vo
vlog -work work Incubator.vt
vsim -novopt -c -t 1ps -L cycloneii_ver -L altera_ver -L altera_mf_ver -L 220model_ver -L sgate work.TemperatureControl_vlg_vec_tst
vcd file -direction Incubator.msim.vcd
vcd add -internal TemperatureControl_vlg_vec_tst/*
vcd add -internal TemperatureControl_vlg_vec_tst/i1/*
add wave /*
run -all
