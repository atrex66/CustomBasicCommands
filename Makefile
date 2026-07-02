KICK=kickass
TOOLS=../tools
SRC=../src

all: main.prg cart_header.prg headers

# Build the BASIC extension (maps at $C000)
main.prg: main.asm memory.asm reu.asm sprites.asm gpio.asm pwm.asm i2c.asm dma.asm \
          include/all.asm include/hw_regs.asm
	$(KICK) main.asm -vicesymbols -bytedump -debugdump

# Build the cartridge autostart stub (maps at $8000)
cart_header.prg: cart_header.asm
	$(KICK) cart_header.asm -vicesymbols

# Regenerate C headers for the emulator from the built PRG files
headers: main.prg cart_header.prg
	python3 $(TOOLS)/prgtoheader.py main.prg $(SRC)/basicext.h BASIC_EXTENSION BASIC_EXT
	python3 $(TOOLS)/prgtoheader.py cart_header.prg $(SRC)/cartstub.h CART_STUB CART_STUB

run: clean main.prg
	x64sc main.prg

clean:
	rm -f main.prg cart_header.prg
