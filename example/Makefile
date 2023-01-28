PROG   = RGB3
OBJ    = RGB3.o
MAINFN = julia_Main_RGB_RGB3
PORT   = /dev/ttyACM0

MCU_TARGET = atmega2560

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
	$(AVRDUDE) -V -c arduino -p $(MCU_TARGET) -P $(PORT) -U flash:w:$(PROG).hex