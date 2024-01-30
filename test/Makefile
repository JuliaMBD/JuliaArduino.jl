PROG   = Test_main
OBJS    = Test_main.o
MAINFN = julia_main
PORT   = /dev/tty.usbmodem101
MCU_TARGET = atmega2560

CC      = avr-gcc
OBJCOPY = avr-objcopy
OBJDUMP = avr-objdump
AVRDUDE = avrdude

elf: $(PROG).elf

$(PROG).elf: $(OBJS)
	$(CC) -Os -DMAINFN=$(MAINFN) -mmcu=$(MCU_TARGET) -o $@ main.c $^

hex: $(PROG).hex

$(PROG).hex: $(PROG).elf
	$(OBJCOPY) -j .text -j .data -O ihex $< $@

flash: $(PROG).hex
	$(AVRDUDE) -v -C ../avrdude.conf -c arduino -p $(MCU_TARGET) -P $(PORT) -D -U flash:w:$(PROG).hex:i
