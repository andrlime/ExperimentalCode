# Config
files = pencil.cpp
cppversion = c++2b
buildflags_dev = -Wall -g
buildflags_prod = -O3

all: dev run

dev:
	@echo "Building program..."
	@rm -f ./build.out
	@g++ -std=$(cppversion) $(buildflags_dev) -I. $(files) -lpthread -o build.out
	
run:
	@echo "Running program..."
	@./build.out sample.csv 3

build:
	@echo "Building program..."
	@rm -f ./build.out
	@g++ -std=$(cppversion) $(buildflags_prod) -I. $(files) -lpthread -o pencil
	@chmod 755 pencil

install: build # This is written to work on my computer, not a generic computer
	@mv pencil ~/bin