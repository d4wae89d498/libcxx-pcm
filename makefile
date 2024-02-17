CXX := 			clang++
CXXFLAGS :=		-std=c++26 -I. -I./include -nostdinc++ -fprebuilt-module-path=.

all:  test

std.pcm: std.cppm
	$(CXX) $(CXXFLAGS) --precompile $< -o $@

std.compat.pcm: std.compat.cppm
	$(CXX) $(CXXFLAGS) --precompile $< -o $@

__is_posix_terminal.o: __is_posix_terminal.cpp
	$(CXX) $(CXXFLAGS) -c $< -o $@

test: std.pcm std.compat.pcm __is_posix_terminal.o
	$(CXX) $(CXXFLAGS)  test.cpp std.pcm __is_posix_terminal.o -o $@ $(shell dirname $(shell which clang++))/../lib/c++/*.a

clean:
	rm -f *.pcm *.o

re: clean all


