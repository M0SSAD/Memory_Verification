vlib work
vlog -cover bcesst Class_Based_Verification_Env/mem_pkg.sv Class_Based_Verification_Env/package.sv Class_Based_Verification_Env/interface.sv Design/memory.sv Class_Based_Verification_Env/top.sv
vsim -c -voptargs=+acc -coverage top
add wave *
run -all
coverage report -output coverage_report.txt -detail
exit