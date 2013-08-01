%define _builddir   .
%define _sourcedir  .
%define _specdir    .
%define _rpmdir     .

Name:       bunsan_cmake
Version:    %{yandex_mail_version}
Release:    %{yandex_mail_release}
Url:        %{yandex_mail_url}

Summary:    CMake macros and functions
License:    GPLv3
Group:      System Environment/Libraries
Packager:   Aleksey Filippov <sarum9in@yandex-team.ru>
Distribution:   Red Hat Enterprise Linux

BuildArch:  noarch

BuildRoot:  %{_tmppath}/%{name}-%{version}-%{release}-root-%(%{__id_u} -n)


%description
Various CMake macros and functions for bunsan projects.


%build
cmake . -DCMAKE_INSTALL_PREFIX=/usr \
        -DCMAKE_BUILD_TYPE=Release
%{__make} %{?_smp_mflags}


%install
rm -rf %{buildroot}
%{__make} install DESTDIR="%{buildroot}"


%clean
%{__rm} -rf %{buildroot}


%files
%defattr (-,root,root,-)
%{_datadir}/cmake/Modules/BunsanCommon.cmake
%{_datadir}/cmake/Modules/BunsanCmake/*.cmake
%{_datadir}/cmake/Modules/CMakeParseArguments.cmake
%{_datadir}/cmake/Modules/FindPackageHandleStandardArgs.cmake
%{_datadir}/cmake/Modules/FindProtobuf.cmake
%{_datadir}/cmake/Modules/GNUInstallDirs.cmake

%changelog
