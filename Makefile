# makefile for Vectoroids

# (Based on Agendaroids)

# by Bill Kendrick
# bill@newbreedsoftware.com
# http://www.newbreedsoftware.com/vectoroids/

# November 30, 2001 - April 13, 2002


PREFIX=/usr/local
MAN_PREFIX=$(PREFIX)
BIN_PREFIX=$(PREFIX)/bin
DATA_PREFIX=$(PREFIX)/share/vectoroids/
JOY=YES
TARGET_DEF=LINUX

CC         = mipsel-linux-gcc
LD         = mipsel-linux-gcc
STRIP      = mipsel-linux-strip

SYSROOT:=$(shell mipsel-gcw0-linux-uclibc-gcc --print-sysroot)
SDL_CFLAGS:=$(shell $(SYSROOT)/usr/bin/sdl-config --cflags)
SDL_LIB:=$(shell $(SYSROOT)/usr/bin/sdl-config --libs) -lSDL_mixer -lSDL_image

NOSOUNDFLAG=__SOUND
CFLAGS    = $(SDL_CFLAGS) -Winline -mabi=32 -mips32 -mtune=mips32 -O3 -fstrength-reduce -fthread-jumps -fexpensive-optimizations -fomit-frame-pointer -frename-registers -pipe -G 0 -ffast-math #-fprofile-use -D$(NOSOUNDFLAG) \
	-DDATA_PREFIX=\"$(DATA_PREFIX)\" -DJOY_$(JOY) -D$(TARGET_DEF)


all:	vectoroids

embedded:
	make vectoroids TARGET_DEF=EMBEDDED MIXER= JOY=NO \
		DATA_PREFIX=/opt/QtPalmtop/share/vectoroids/ \
		SDL_LIB="/usr/local/arm/lib/libSDL_mixer.a /usr/local/arm/lib/libSDL.a -L/usr/local/arm/lib/ -lpthread -L/opt/Qtopia/sharp/lib -lqpe -lqte" \
		CC=/usr/local/arm/bin/arm-linux-gcc
	/usr/local/arm/bin/arm-linux-strip vectoroids


emtest:
	make vectoroids TARGET_DEF=EMBEDDED

nosound:
	make vectoroids MIXER= NOSOUNDFLAG=NOSOUND

install:
	install -d $(DATA_PREFIX)
	cp -R data/* $(DATA_PREFIX)
	chmod -R a+rX,g-w,o-w $(DATA_PREFIX)
	cp vectoroids $(BIN_PREFIX)
	chmod a+rx,g-w,o-w $(BIN_PREFIX)/vectoroids
	install -d $(MAN_PREFIX)/man/man6/
	cp vectoroids.6 $(MAN_PREFIX)/man/man6/
	chmod a+rx,g-w,o-w $(MAN_PREFIX)/man/man6/vectoroids.6


clean:
	-rm vectoroids
	-rm *.o


vectoroids:	vectoroids.o
	$(CC) $(CFLAGS) vectoroids.o -o vectoroids $(SDL_LIB)


vectoroids.o:	vectoroids.c
