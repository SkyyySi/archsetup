packages=(grml-zsh-config pkgfile zsh zsh-autosuggestions zsh-completions zsh-history-substring-search zsh-syntax-highlighting zsh-theme-powerlevel10k)

postinstall() {
	# Update the pkgfile database (for the command-not-found handler)
	pkgfile -u

	# Create a config to properly load and set up everything
	cat <<EOF > /etc/skel/.zshrc.local
#!/usr/bin/env zsh
# Load plugins
plug() { if [[ -r ${@} ]]; then source ${@}; fi; }
plug /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
plug /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
plug /usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh
zle -N history-substring-search-up
zle -N history-substring-search-down
[[ -n "${terminfo[kcuu1]}" ]] && bindkey "${terminfo[kcuu1]}" history-substring-search-up
[[ -n "${terminfo[kcud1]}" ]] && bindkey "${terminfo[kcud1]}" history-substring-search-down

# Load powerlevel10k (the theme)
plug /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme
EOF
}
