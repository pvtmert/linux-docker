#!/usr/bin/env make -f

BASE  := debian:stable
IMAGE := pvtmert/linux

%: %.dockerfile

clean:
	rm -rf *.dockerfile

%.dockerfile:
	@( \
	echo '#!/usr/bin/env docker build --compress -t $(IMAGE):$* -f';\
	echo ''                                                             ;\
	echo 'FROM $(BASE)'                                           ;\
	echo ''                                                             ;\
	echo 'ENV BASEURL https://cdn.kernel.org/pub/linux/kernel'          ;\
	echo 'ENV VERSION v4.x/linux-$*'                                    ;\
	echo 'ENV TYPE tar.xz'                                              ;\
	echo ''                                                             ;\
	echo 'WORKDIR /data'                                                ;\
	echo ''                                                             ;\
	echo 'RUN apt update && apt install -y \'                           ;\
	echo '	bsdtar build-essential libssl-dev libelf-dev \'             ;\
	echo '	bison bc kmod cpio flex cpio libncurses5-dev \'             ;\
	echo '	&& apt clean'                                               ;\
	echo ''                                                             ;\
	echo 'ADD $$BASEURL/$$VERSION.$$TYPE ./'                            ;\
	echo ''                                                             ;\
	echo 'RUN test -e $$(basename $$VERSION.$$TYPE)      \'             ;\
	echo '	&& bsdtar xf $$(basename $$VERSION.$$TYPE) \'               ;\
	echo '	|| true'                                                    ;\
	echo ''                                                             ;\
	echo 'RUN make -C $$(basename $$VERSION $$TYPE) -j $$(nproc) \'     ;\
	echo '	defconfig modules vmlinux'                                  ;\
	echo ''                                                             ;\
	echo 'CMD make -C $$(basename $$VERSION $$TYPE) -j $$(nproc)'       ;\
	echo ''                                                             ;\
	) > $@
