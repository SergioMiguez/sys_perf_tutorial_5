all: program

program: program.cpp barrier.cpp barrier.hpp
	$(CXX) -g -O2 -pthread -o program program.cpp barrier.cpp

parsec-prepare:
	wget -qO- https://www.doc.ic.ac.uk/~lvilanov/teaching/comp60017/parsec-3.0-core.tar.gz | tar xvz
	wget -qO- https://www.doc.ic.ac.uk/~lvilanov/teaching/comp60017/parsec-3.0-input-sim.tar.gz | tar xvz
	grep -rl "HUGE" parsec-3.0/pkgs/apps/ferret | xargs sed -i "s/HUGE/DBL_MAX/g"
	sed -i -e 's/CFLAGS += -I$$(INCDIR)/CFLAGS += -I$$(INCDIR) -fno-omit-frame-pointer/g'  parsec-3.0/pkgs/apps/ferret/src/Makefile
	#chmod a+x cd parsec-3.0/pkgs/libs/*/src/configure
	bash -c '(cd parsec-3.0 && . env.sh && parsecmgmt -a build -p ferret)'
	bash -c '(cd parsec-3.0 && . env.sh && parsecmgmt -a run -p ferret -i simlarge -s echo)'

parsec-rebuild:
	bash -c '(cd parsec-3.0 && . env.sh && parsecmgmt -a fulluninstall -p ferret)'
	bash -c '(cd parsec-3.0 && . env.sh && parsecmgmt -a build -p ferret)'

parsec-run:
	bash -c '(cd parsec-3.0 && . env.sh && parsecmgmt -a run -p ferret -i simlarge -k -n 1 | grep -E real\|user)'
	bash -c '(cd parsec-3.0 && . env.sh && parsecmgmt -a run -p ferret -i simlarge -k -n 2 | grep -E real\|user)'
	bash -c '(cd parsec-3.0 && . env.sh && parsecmgmt -a run -p ferret -i simlarge -k -n 3 | grep -E real\|user)'
	bash -c '(cd parsec-3.0 && . env.sh && parsecmgmt -a run -p ferret -i simlarge -k -n 4 | grep -E real\|user)'
	bash -c '(cd parsec-3.0 && . env.sh && parsecmgmt -a run -p ferret -i simlarge -k -n 5 | grep -E real\|user)'

parsec-profile:
	bash -c '(cd parsec-3.0 && . env.sh && parsecmgmt -a run -p ferret -i simlarge -k -n 1 -s "perf stat" | tail -28)'
	bash -c '(cd parsec-3.0 && . env.sh && parsecmgmt -a run -p ferret -i simlarge -k -n 2 -s "perf stat" | tail -28)'
	bash -c '(cd parsec-3.0 && . env.sh && parsecmgmt -a run -p ferret -i simlarge -k -n 3 -s "perf stat" | tail -28)'
	bash -c '(cd parsec-3.0 && . env.sh && parsecmgmt -a run -p ferret -i simlarge -k -n 4 -s "perf stat" | tail -28)'
	bash -c '(cd parsec-3.0 && . env.sh && parsecmgmt -a run -p ferret -i simlarge -k -n 5 -s "perf stat" | tail -28)'

parsec-profile2:
	(cd parsec-3.0/pkgs/apps/ferret/run && \
	perf record -g ../inst/amd64-linux.gcc/bin/ferret corel lsh queries 10 20 1 output.txt && \
	perf report)
