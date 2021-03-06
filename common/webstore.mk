PROJECT ?= $(shell basename `pwd`)

build/Assets/resources :
	mkdir -p build/Assets/resources || true

build/Assets/resources/promo-440x280.png : build/Assets/resources/promo-440x280.jpg
	convert $< $@

build/Assets/resources/promo-440x280.jpg : build/Assets/resources
	convert -size 440x280 xc:lightblue -font Helvetica -pointsize 72 -gravity center -undercolor white -stroke none -strokewidth 3 -annotate +0+0 ' $(PROJECT) ' +repage $@

build/Assets/resources/screenshot-640x400.png : build/Assets/resources/screenshot-640x400.jpg
	convert $< $@

build/Assets/resources/screenshot-640x400.jpg : build/Assets/resources
	convert -size 640x400 xc:lightblue -font Helvetica -pointsize 72 -gravity center -undercolor white -stroke none -strokewidth 3 -annotate +0+0 ' $(PROJECT) ' +repage $@

dummyimages : build/Assets/resources/promo-440x280.png build/Assets/resources/screenshot-640x400.png

.PHONY : dummyimages
