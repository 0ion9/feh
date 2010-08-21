include config.mk

all: build-src build-man

build-src:
	@${MAKE} -C src

build-man:
	@${MAKE} -C man

test: all
	@PACKAGE=${PACKAGE} VERSION=${VERSION} prove test

test-x11: all
	@test/run-interactive

install: install-man install-doc install-bin install-font install-img

install-man:
	@echo installing manuals to ${man_dir}
	@mkdir -p ${man_dir}/man1
	@cp man/*.1 ${man_dir}/man1
	@chmod 644 ${man_dir}/man1/feh.1 ${man_dir}/man1/feh-cam.1 \
		${man_dir}/man1/gen-cam-menu.1

install-doc:
	@echo installing docs to ${doc_dir}
	@mkdir -p ${doc_dir}
	@cp AUTHORS ChangeLog README TODO ${doc_dir}
	@chmod 644 ${doc_dir}/*

install-bin:
	@echo installing executables to ${bin_dir}
	@mkdir -p ${bin_dir}
	@cp src/feh cam/feh-cam cam/gen-cam-menu ${bin_dir}
	@chmod 755 ${bin_dir}/feh ${bin_dir}/feh-cam \
		${bin_dir}/gen-cam-menu

install-font:
	@echo installing fonts to ${font_dir}
	@mkdir -p ${font_dir}
	@cp data/fonts/* ${font_dir}
	@chmod 644 ${font_dir}/*

install-img:
	@echo installing images to ${image_dir}
	@mkdir -p ${image_dir}
	@cp data/images/* ${image_dir}
	@chmod 644 ${image_dir}/*


uninstall:
	rm -f ${man_dir}/man1/feh.1 ${man_dir}/man1/feh-cam.1
	rm -f ${man_dir}/man1/gen-cam-menu.1
	rm -rf ${doc_dir}
	rm -f ${bin_dir}/feh ${bin_dir}/feh-cam ${bin_dir}/gen-cam-menu
	rm -rf ${font_dir}
	rm -rf ${image_dir}

dist:
	mkdir /tmp/feh-${VERSION}
	git --work-tree=/tmp/feh-${VERSION} checkout -f
	sed -i 's/^VERSION ?= .*$$/VERSION ?= ${VERSION}/' \
		/tmp/feh-${VERSION}/config.mk
	tar -C /tmp -cjf ../feh-${VERSION}.tar.bz2 feh-${VERSION}
	rm -r /tmp/feh-${VERSION}

clean:
	@${MAKE} -C src clean
	@${MAKE} -C man clean

.PHONY: all test test-x11 install uninstall clean install-man install-doc \
	install-bin install-font install-img dist
