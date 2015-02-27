FLEX_SDK ?= C:/flexsdk

APP=edutainment
APP_XML=$(APP).xml
ADL=$(FLEX_SDK)/bin/adl
AMXMLC=$(FLEX_SDK)/bin/amxmlc
SOURCES=src/Startup.hx

all: $(APP).swf
$(APP).swf: $(SOURCES)
	haxe \
	-cp src \
	-cp vendor \
	-swf-version 11.8 \
	-swf-header 512:512:60:ffffff \
	-main Startup \
	-swf $(APP).swf \
	-swf-lib vendor/starling.swc --macro "patchTypes('vendor/starling.patch')"

clean:
	rm $(APP).swf
	
test: $(APP).swf
	$(ADL) -profile tv -screensize 512x512:640x640 $(APP_XML)