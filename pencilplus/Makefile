# Config
files = pencil.cpp
cppversion = c++2b
buildflags_dev = -Wall
buildflags_prod = -O
file := status.txt

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
