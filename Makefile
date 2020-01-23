package = mongodb-grafana-datasource
tarname = $(package)
version = $(shell git describe --abbrev=0 --tags 2>/dev/null || echo latest)
update_time = $(shell date +"%m-%d-%y")
distdir = $(tarname)-$(version)
configs = Gruntfile.js package.json src/plugin.json

all: clean grunt dist

dist: $(tarname).zip

$(tarname).zip: $(distdir)
	zip -r $@ $<
	rm -rf $<

$(distdir): ; mkdir -p $@

$(configs):
	sed \
		-e 's/@DISTDIR@/$(distdir)/g' \
		-e 's/@UPDATE_TIME@/$(update_time)/g' \
		-e 's/@VERSION@/$(version)/g' \
	$@.in > $@

grunt: $(configs) $(distdir)
	#TODO: ensure build env
	npm i 
	npm run build

clean: $(configs) $(tarname).zip $(distdir) ; rm -rf $?

.PHONY: grunt dist all
