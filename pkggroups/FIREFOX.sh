packages=(firefox firefox-dark-reader firefox-decentraleyes firefox-extension-https-everywhere
          firefox-extension-privacybadger firefox-ublock-origin)

if [[ -n $(pacman -Ss ^firefox-i18n-${LOCALE_APPLANG}$) ]]; then
	packages+=(firefox-i18n-${LOCALE_APPLANG})
fi
