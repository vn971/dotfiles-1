quiet

name firefox

caps.drop all
netfilter
nogroups
nonewprivs
noroot
protocol unix,inet,inet6
seccomp
shell none

private-bin firefox,sh
private-dev
private-etc resolv.conf,localtime,fonts,gtk-2.0,gtk-3.0,pulse
private-tmp

mkdir ~/.mozilla
whitelist ~/.mozilla
mkdir ~/.cache/mozilla/firefox
whitelist ~/.cache/mozilla/firefox
mkdir ~/Downloads
whitelist ~/Downloads
