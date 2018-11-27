#!/usr/bin/env docker build --compress -t pvtmert/linux -f

FROM debian:stable

ENV TYPE tar.gz
ENV BASEURL https://git.kernel.org/torvalds
ENV VERSION t/linux-4.20-rc4

WORKDIR /data

RUN apt update && apt install -y time \
	bsdtar build-essential libssl-dev libelf-dev \
	bison bc kmod cpio flex cpio libncurses5-dev \
	&& apt clean

ADD $BASEURL/$VERSION.$TYPE ./

RUN test -e $(basename $VERSION.$TYPE)      \
	&& bsdtar xf $(basename $VERSION.$TYPE) \
	|| true

RUN time make -C $(basename $VERSION $TYPE) -j $(nproc) defconfig modules vmlinux

CMD time make -C $(basename $VERSION $TYPE) -j $(nproc)
