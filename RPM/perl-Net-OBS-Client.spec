#
# Copyright (c) 2015 SUSE LINUX GmbH, Nuernberg, Germany.
#
# All modifications and additions to the file contributed by third parties
# remain the property of their copyright owners, unless otherwise agreed
# upon. The license for this file, and modifications and additions to the
# file, is the same license as for the pristine package itself (unless the
# license for the pristine package is not an Open Source License, in which
# case the license is the MIT License). An "Open Source License" is a
# license that conforms to the Open Source Definition (Version 1.9)
# published by the Open Source Initiative.

# Please submit bugfixes or comments via http://bugs.opensuse.org/
#
%global debug_package %{nil}

%define cpan_name Net-OBS-Client

Name:           perl-%{cpan_name}
Version:        0.0.1
Release:        1
Summary:        Simplify usage of open build service API calls in perl
License:        GPL-1.0+ or Artistic-1.0
Group:          Development/Libraries/Perl
Url:            http://github.com/M0ses/%{cpan_name}
Source:         %{cpan_name}-%{version}.tar.gz
BuildRoot:      %{_tmppath}/%{name}-%{version}-build

BuildRequires: perl
BuildRequires: perl-macros

BuildRequires: perl(Moose)
BuildRequires: perl(Moose::Role)
BuildRequires: perl(LWP::UserAgent)
BuildRequires: perl(XML::Structured)
BuildRequires: perl(Config::INI::Reader)
BuildRequires: perl(Config::Tiny)
BuildRequires: perl(HTTP::Request)
BuildRequires: perl(HTTP::Cookies)
BuildRequires: perl(URI::URL)
BuildRequires: perl(Path::Class)

Requires: perl(Moose)
Requires: perl(Moose::Role)
Requires: perl(LWP::UserAgent)
Requires: perl(XML::Structured)
Requires: perl(Config::INI::Reader)
Requires: perl(Config::Tiny)
Requires: perl(HTTP::Request)
Requires: perl(HTTP::Cookies)
Requires: perl(URI::URL)
Requires: perl(Path::Class)

Provides: perl(Net::OBS::Client)
%{perl_requires}

%description
Net::OBS::Client aims to simplify usage of OBS (https://openbuildservice.org) API calls in perl.

%prep
%setup -q -n %{cpan_name}-%{version}

%build
%{__perl} Makefile.PL INSTALLDIRS=vendor OPTIMIZE="%{optflags}"
%{__make} %{?_smp_mflags}

%check
%{__make} test

%install
%perl_make_install
%perl_process_packlist
%perl_gen_filelist

%files -f %{name}.files
%defattr(-,root,root,755)
%doc Changes README

%changelog
* Fri Mar 11 2016 Frank Schreiner - 0.0.1-1
- intial version

