PROG   = Test_main
OBJ    = Test_main.o
MAINFN = julia_Main_Test_main
PORT   = /dev/tty.usbmodem1101
MCU_TARGET = atmega328p

CC      = avr-gcc
OBJCOPY = avr-objcopy
OBJDUMP = avr-objdump
AVRDUDE = avrdude

elf: $(PROG).elf

$(PROG).elf: $(OBJ)
	$(CC) -Os -DMAINFN=$(MAINFN) -mmcu=$(MCU_TARGET) -o $@ main.c $^

hex: $(PROG).hex

$(PROG).hex: $(PROG).elf
	$(OBJCOPY) -j .text -j .data -O ihex $< $@

flash: $(PROG).hex
	$(AVRDUDE) -v -C ../avrdude.conf -c arduino -p $(MCU_TARGET) -P $(PORT) -D -U flash:w:$(PROG).hex:i
