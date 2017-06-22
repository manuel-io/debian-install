
clean:
	rm -rf auto binary .build chroot local
	rm -f live-image-amd64.* chroot.*
	rm -f config/binary config/bootstrap config/build config/chroot
	rm -f config/source config/common
	rm -f config/includes.chroot/installer/chroot/free.img
	rm -rf config/packages* config/includes config/includes.bootstrap
	rm -rf config/includes.installer config/includes.source
	rm -rf config/apt config/archives config/debian-installer config/package-lists  config/preseed config/rootfs

.PHONY: clean
