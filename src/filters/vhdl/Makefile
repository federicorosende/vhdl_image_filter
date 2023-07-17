all: analyze elaborate run runui

analyze:
	ghdl -a divider.vhd filter.vhd filter_test_bench.vhd

elaborate:
	ghdl -e pixel_filter_test_bench_entity

run:
	ghdl -r pixel_filter_test_bench_entity --vcd=filter.vcd

runui:
	gtkwave --rcvar 'fontname_signals Monospace 13' --rcvar 'fontname_waves Monospace 12' filter.vcd		

clean:
	rm -f *.cf filter.vcd