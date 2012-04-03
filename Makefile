PICAXE_COMPILER = picaxe08m2
PICAXE_PORT = /dev/tty.usbserial-00001004
#PICAXE_PORT = /dev/tty.usbserial
PICAXE_DEBUG = -dh
PICAXE_SERTXD = -t

SRC = PICAXE_SerialLCD.bas

MSG_ERRORS_NONE = Errors: none
MSG_BEGIN = -------- begin --------
MSG_END = --------  end  --------
MSG_CLEANING = Cleaning project:

REMOVE = rm -f

TARGET = $(basename $(SRC)).bas
ERROR = $(basename $(TARGET)).err

all: begin download finished end

debug: $(TARGET)
	$(PICAXE_COMPILER) $(PICAXE_DEBUG) -c$(PICAXE_PORT) $(TARGET)

sertxd: $(TARGET)
	$(PICAXE_COMPILER) $(PICAXE_SERTXD) -c$(PICAXE_PORT) $(TARGET)

download: $(TARGET)
	$(PICAXE_COMPILER) -c$(PICAXE_PORT) $(TARGET)

check: begin syntax_check finished end

syntax: check

syntax_check: $(TARGET)
	$(PICAXE_COMPILER) -s $(TARGET)

begin:
	@echo
	@echo $(MSG_BEGIN)

finished:
	@echo $(MSG_ERRORS_NONE)
			
end:
	@echo $(MSG_END)
	@echo

clean: begin clean_list finished end

clean_list :
	@echo
	@echo $(MSG_CLEANING)
	$(REMOVE) $(ERROR) 

.PHONY: all begin finish end clean

