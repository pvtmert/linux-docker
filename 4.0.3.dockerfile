#!/usr/bin/env docker build --compress -t pvtmert/linux:4.0.3 -f

FROM debian:stable

ENV BASEURL https://cdn.kernel.org/pub/linux/kernel
ENV VERSION v4.x/linux-4.0.3
ENV TYPE tar.xz

WORKDIR /data

RUN apt update && apt install -y \
	bsdtar build-essential libssl-dev libelf-dev \
	bison bc kmod cpio flex cpio libncurses5-dev \
	&& apt clean

ADD $BASEURL/$VERSION.$TYPE ./

RUN test -e $(basename $VERSION.$TYPE)      \
	&& bsdtar xf $(basename $VERSION.$TYPE) \
	|| true

RUN make -C $(basename $VERSION $TYPE) -j $(nproc) \
	defconfig modules vmlinux

CMD make -C $(basename $VERSION $TYPE) -j $(nproc)

