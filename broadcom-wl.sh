#!/bin/bash
#
# After upgrading the kernel, you need to rebuild the broadcom-wl package 
# with the new kernel installed to update the module.
#
# This script will download the latest package tarball and driver
# So should be run BEFORE rebooting while you still have a network connection
#
# Then again after rebooting to install the package and load the module

[ $# -eq 0 ] && { echo "Usage: $0 1 (Before boot), 2 (After boot)"; exit 1; }

case "$1" in 
	1)
		cd ~/Downloads
		git clone https://aur.archlinux.org/broadcom-wl.git
		cd broadcom-wl

		pkgver="$(awk '/pkgver=/' PKGBUILD | awk '{print substr($0,8)}')"

		if [ $(uname -m) = "x86_64" ]; then
			_arch="_64"
		else
			_arch=""
		fi

		drURL="http://www.broadcom.com/docs/linux_sta/hybrid-v35${_arch}-nodebug-pcoem-${pkgver//./_}.tar.gz"
		drFILE="${drURL:39}"

		curl -sO $drURL

		sed -i 's,http://www.broadcom.com/docs/linux_sta/hybrid-v35${_arch}-nodebug-pcoem-${pkgver//./_}.tar.gz,drTEMP,g' PKGBUILD
		sed -i "s,drTEMP,$drFILE,g" PKGBUILD
		;;

	2)
		cd ~/Downloads/broadcom-wl
		makepkg

		pkgFILE="$(find . -name "*.pkg.*")"
		sudo pacman -U "$pkgFILE"

		sudo modprobe wl
esac
