NAME :=			libcxx.a

BUILD_DIR := 	lib
SRC_DIR :=		src

CXX := 			clang++
INCLUDE :=		-I./src -I./src/include
CXXFLAGS :=		-std=c++26 -nostdinc++ -fprebuilt-module-path=$(BUILD_DIR)

OBJS := $(BUILD_DIR)/__is_posix_terminal.o $(BUILD_DIR)/std.o $(BUILD_DIR)/std.compat.o
PCMS := $(OBJS:%.o=%.pcm)
NAME := $(BUILD_DIR)/$(NAME)

all:  $(NAME) test clean

$(BUILD_DIR)/std.pcm: $(SRC_DIR)/std.cppm
	@mkdir -p $(@D)
	$(CXX) $(CXXFLAGS)  -Wno-reserved-module-identifier $(INCLUDE) --precompile $< -o $@

$(BUILD_DIR)/std.compat.pcm: $(SRC_DIR)/std.compat.cppm
	@mkdir -p $(@D)
	$(CXX) $(CXXFLAGS)  -Wno-reserved-module-identifier $(INCLUDE) --precompile $< -o $@


$(BUILD_DIR)/std.o: $(BUILD_DIR)/std.pcm
	@mkdir -p $(@D)
	$(CXX) $(CXXFLAGS) -c $< -o $@

$(BUILD_DIR)/std.compat.o: $(BUILD_DIR)/std.compat.pcm
	@mkdir -p $(@D)
	$(CXX) $(CXXFLAGS) -c $< -o $@

$(BUILD_DIR)/__is_posix_terminal.o: $(SRC_DIR)/__is_posix_terminal.cpp
	@mkdir -p $(@D)
	$(CXX) $(CXXFLAGS) $(INCLUDE) -c $< -o $@

$(NAME): $(OBJS) makefile
	@mkdir -p $(@D)
	libtool -static -o $(NAME) $(shell dirname $(shell which clang++))/../lib/c++/*.a $(OBJS)

test: $(NAME)
	$(CXX) $(CXXFLAGS)  test.cpp -o $@ $(NAME)

clean:
	rm -f $(OBJS)

fclean:
	rm -rf $(PCMS) $(NAME)

re: fclean all


