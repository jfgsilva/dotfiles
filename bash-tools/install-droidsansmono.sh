#!/bin/bash
curl -o /tmp/dsm.zip -L https://github.com/ryanoasis/nerd-fonts/releases/download/v3.3.0/DroidSansMono.zip
yes A | unzip /tmp/dsm.zip -d ~/.local/share/fonts
fc-cache -fv ~/.local/share/fonts
