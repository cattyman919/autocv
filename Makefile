.PHONY: watch clean all

# Directory for output files
OUT_DIR = out

all: run

.PHONY: all run

run:
	go run ./cmd/autocv/

clean:
	rm -rf $(OUT_DIR) || rmdir /s /q $(OUT_DIR)
