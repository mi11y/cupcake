#!/usr/bin/zsh
meson build --prefix=/usr
cd build
ninja
sudo ninja install
cd ..
sudo update-icon-caches /usr/share/icons/*
