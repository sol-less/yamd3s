.PHONY: all build run clean

all: run

build: 
	@if [ ! -d "build" ]; then \
		echo "-> Initial CMake Build Directory.."; \
		cmake -B build -S .; \
	fi
	@echo "-> Building QMLs"
	@cmake --build build

run: build
	@echo "-> Intial Quickshell Run"
	@QML_IMPORT_PATH="$(PWD)/build/imports" quickshell & disown

clean:
	@echo "-> Initial cleaning build dir.."
	@rm -rf build
