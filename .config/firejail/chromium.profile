# Works only if run chromium with --no-sandbox key.
# Also --help key doesn't work because it tries to start man. Use man chromium instead.

quiet

name chromium

caps.drop all
netfilter
nogroups
nonewprivs
noroot
protocol unix,inet,inet6,netlink
seccomp
shell none

private-bin chromium,env,perl
private-dev
private-etc resolv.conf,localtime,fonts,gtk-2.0,pulse
private-tmp

include ~/.config/firejail/mem/4G.inc

mkdir ~/.config/chromium
whitelist ~/.config/chromium
mkdir ~/.cache/chromium
whitelist ~/.cache/chromium
mkdir ~/Downloads
whitelist ~/Downloads
