# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools xdg

DESCRIPTION="Communication program for Texas Instruments calculators"
HOMEPAGE="http://lpg.ticalc.org/prj_tilp"
SRC_URI="https://downloads.sourceforge.net/tilp/tilp2-linux/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="nls"

RDEPEND="
	dev-libs/glib:2
	gnome-base/libglade:2.0
	>=sci-libs/libticalcs2-1.1.9
	>=sci-libs/libticables2-1.3.5
	>=sci-libs/libtifiles2-1.1.7
	>=sci-libs/libticonv-1.1.5
	x11-libs/gtk+:2
	nls? ( virtual/libintl )"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	nls? ( sys-devel/gettext )"

PATCHES=( "${FILESDIR}"/${PN}-1.18-nonbash.patch )

src_prepare() {
	default
	# The ac macro AC_PATH_KDE was provided by "acinclude.m4" in 1.17.
	# This file is missing in the current version which will cause an autoconf error.
	# But since we don't build with kde support, we may safely remove all its reverse dependencies.
	sed -i -e '/AC_PATH_KDE/d' configure.ac || die
	sed -i \
		-e 's/@[^@]*\(KDE\|QT\|KIO\)[^@]*@//g' \
		-e 's/@X_LDFLAGS@//g' \
		src/Makefile.am || die
	eautoreconf
}

src_configure() {
	# kde seems to be kde3 only
	econf \
		--without-kde \
		$(use_enable nls)
}
