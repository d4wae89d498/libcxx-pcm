NAME :=			libcxx.a

BUILD_DIR := 	lib
SRC_DIR :=		src

CXX := 			clang++
CXXFLAGS :=		-std=c++26 -I./src -I./src/include -nostdinc++ -fprebuilt-module-path=$(BUILD_DIR)

OBJS := $(BUILD_DIR)/__is_posix_terminal.o $(BUILD_DIR)/std.o $(BUILD_DIR)/std.compat.o
PCMS := $(OBJS:%.o=%.pcm)
NAME := $(BUILD_DIR)/$(NAME)

all:  $(NAME) test

$(BUILD_DIR)/std.pcm: $(SRC_DIR)/std.cppm
	$(CXX) $(CXXFLAGS) --precompile $< -o $@

$(BUILD_DIR)/std.compat.pcm: $(SRC_DIR)/std.compat.cppm
	$(CXX) $(CXXFLAGS) --precompile $< -o $@


$(BUILD_DIR)/std.o: $(BUILD_DIR)/std.pcm
	$(CXX) $(CXXFLAGS) -c $< -o $@

$(BUILD_DIR)/std.compat.o: $(BUILD_DIR)/std.compat.pcm
	$(CXX) $(CXXFLAGS) -c $< -o $@

$(BUILD_DIR)/__is_posix_terminal.o: $(SRC_DIR)/__is_posix_terminal.cpp
	$(CXX) $(CXXFLAGS) -c $< -o $@

$(NAME): $(OBJS) makefile
	libtool -static -o $(NAME) $(shell dirname $(shell which clang++))/../lib/c++/*.a $(OBJS)

test: $(NAME)
	$(CXX) $(CXXFLAGS)  test.cpp -o $@ $(NAME)

clean:
	rm -f $(OBJS)

fclean:
	rm -rf $(PCMS) $(NAME)

re: fclean all


