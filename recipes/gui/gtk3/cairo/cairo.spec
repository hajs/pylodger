
%define pixman_version 0.26.2
%define freetype_version 2.1.9
%define fontconfig_version 2.0

Name:		cairo
Version:	1.12.2
Release:	1%{?dist}
Summary:	A 2D graphics library

Vendor:		Continuum Analytics, Inc.
Packager:	build@continuum.io

Group:		System Environment/Libraries
License:	LGPLv2 or MPLv1.1
URL:		http://cairographics.org

Source0:	http://cairographics.org/releases/%{name}-%{version}.tar.xz

BuildRoot:	%{_tmppath}/%{name}-%{version}-%{release}-root-%(%{__id_u} -n)
BuildRequires:	pkgconfig
BuildRequires:	libpng-devel
BuildRequires:	libxml2-devel
BuildRequires:	pixman-devel >= %{pixman_version}
BuildRequires:	freetype-devel >= %{freetype_version}
BuildRequires:	fontconfig-devel >= %{fontconfig_version}


%description
Cairo is a 2D graphics library designed to provide high-quality display
and print output. Currently supported output targets include the X Window
System, OpenGL (via glitz), in-memory image buffers, and image files (PDF,
PostScript, and SVG).

Cairo is designed to produce consistent output on all output media while
taking advantage of display hardware acceleration when available (e.g.
through the X Render Extension or OpenGL).


%package devel
Summary:	Development files for cairo
Group:		Development/Libraries
Requires:	%{name} = %{version}-%{release}
Requires:	libpng-devel
Requires:	pixman-devel >= %{pixman_version}
Requires:	freetype-devel >= %{freetype_version}
Requires:	fontconfig-devel >= %{fontconfig_version}
Requires:	pkgconfig

%description devel
Cairo is a 2D graphics library designed to provide high-quality display
and print output.

This package contains libraries, header files and developer documentation
needed for developing software which uses the cairo graphics library.


%prep
%setup -q


%build
%configure \
	--disable-static 	\
	--enable-warnings 	\
	--enable-freetype 	\
	--enable-ps 		\
	--enable-pdf 		\
	--enable-svg 		\
	--disable-gtk-doc
make


%install
rm -rf $RPM_BUILD_ROOT

make install DESTDIR=$RPM_BUILD_ROOT
rm $RPM_BUILD_ROOT%{_libdir}/*.la


%clean
rm -rf $RPM_BUILD_ROOT


%post -p /sbin/ldconfig


%postun -p /sbin/ldconfig


%files
%defattr(-,root,root,-)
%doc AUTHORS BIBLIOGRAPHY BUGS COPYING COPYING-LGPL-2.1 COPYING-MPL-1.1 NEWS README
%{_libdir}/libcairo*.so.*


%files devel
%defattr(-,root,root,-)
%doc ChangeLog PORTING_GUIDE
%{_bindir}/cairo-trace
%{_includedir}/*
%{_libdir}/libcairo*.so
%{_libdir}/cairo/libcairo*.so*
%{_libdir}/cairo/libcairo*.la
%{_libdir}/pkgconfig/*
%{_datadir}/gtk-doc/html/cairo


%changelog
