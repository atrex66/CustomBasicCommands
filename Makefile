KICK=kickass
TOOLS=../tools
SRC=../src

all: basicext.prg headers cartstub.prg

# Build the BASIC extension (maps at $C000)
basicext.prg: main.asm memory.asm reu.asm sprites.asm gpio.asm pwm.asm i2c.asm dma.asm \
          include/all.asm include/hw_regs.asm
	$(KICK) main.asm -o basicext.prg -vicesymbols -bytedump -debugdump

cartstub.prg: cart_start.asm
	$(KICK) cart_start.asm -o cartstub.prg -vicesymbols -bytedump -debugdump

# Regenerate C headers for the emulator from the built PRG files
headers: basicext.prg
	python3 $(TOOLS)/prgtoheader.py basicext.prg $(SRC)/basicext.h BASIC_EXTENSION BASIC_EXT

run: clean basicext.prg
	x64sc basicext.prg

clean:
	rm -f basicext.prg cartstub.prg
