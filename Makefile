.PHONY: watch clean all

# Directory for output files
OUT_DIR = out

.PHONY: all
all: run

.PHONY: run
run:
	go run ./cmd/autocv/

.PHONY: clean
clean:
	rm -rf $(OUT_DIR) || rmdir /s /q $(OUT_DIR)
