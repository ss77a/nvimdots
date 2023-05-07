
EOABORT
	)"
fi

# Always use HTTPS when this script is run non-interactively (e.g. CI)
if [[ -n "${NONINTERACTIVE-}" ]]; then
	USE_SSH=0
fi

info "This script will install ss77a/nvimdots to:"
echo "${DEST_DIR}"

if [[ -d "${DEST_DIR}" ]]; then
	warn "The destination folder: \"${DEST_DIR}\" already exists."
	warn_ext "We will make a backup for you at \"${BACKUP_DIR}\"."
fi

if [[ -z "${NONINTERACTIVE-}" ]]; then
	ring_bell
	wait_for_user

	if check_ssh; then
		USE_SSH=0
	fi
	clone_pref
fi

if [[ -d "${DEST_DIR}" ]]; then
	execute "mv" "-f" "${DEST_DIR}" "${BACKUP_DIR}"
fi

info "Fetching in progress..."
if [[ "${USE_SSH}" -eq "1" ]]; then
	if check_nvim_version "${REQUIRED_NVIM_VERSION}"; then
		execute "git" "clone" "-b" "main" "${CLONE_ATTR[@]}" "git@github.com:ayamir/nvimdots.git" "${DEST_DIR}"
	elif check_nvim_version "${REQUIRED_NVIM_VERSION_LEGACY}"; then
		warn "You have outdated Nvim installed (< ${REQUIRED_NVIM_VERSION})."
		info "Automatically redirecting you to the latest compatible version..."
		execute "git" "clone" "-b" "0.8" "${CLONE_ATTR[@]}" "git@github.com:ayamir/nvimdots.git" "${DEST_DIR}"
	else
		warn "You have outdated Nvim installed (< ${REQUIRED_NVIM_VERSION_LEGACY})."
		abort "$(
			cat <<EOABORT
You have a legacy Neovim distribution installed.
Please make sure you have nvim v${REQUIRED_NVIM_VERSION_LEGACY} installed at the very least.
EOABORT
		)"
	fi
else
	if check_nvim_version "${REQUIRED_NVIM_VERSION}"; then
		execute "git" "clone" "-b" "main" "${CLONE_ATTR[@]}" "https://github.com/ayamir/nvimdots.git" "${DEST_DIR}"
	elif check_nvim_version "${REQUIRED_NVIM_VERSION_LEGACY}"; then
		warn "You have outdated Nvim installed (< ${REQUIRED_NVIM_VERSION})."
		info "Automatically redirecting you to the latest compatible version..."
		execute "git" "clone" "-b" "0.8" "${CLONE_ATTR[@]}" "https://github.com/ayamir/nvimdots.git" "${DEST_DIR}"
	else
		warn "You have outdated Nvim installed (< ${REQUIRED_NVIM_VERSION_LEGACY})."
		abort "$(
			cat <<EOABORT
You have a legacy Neovim distribution installed.
Please make sure you have nvim v${REQUIRED_NVIM_VERSION_LEGACY} installed at the very least.
EOABORT
		)"
	fi
fi

cd "${DEST_DIR}" || return

if [[ "${USE_SSH}" -eq "0" ]]; then
	info "Changing default fetching method to HTTPS..."
	execute "perl" "-pi" "-e" "s/\[\"use_ssh\"\] \= true/\[\"use_ssh\"\] \= false/g" "${DEST_DIR}/lua/core/settings.lua"
fi

info "Spawning Neovim and fetching plugins... (You'll be redirected shortly)"
info "If lazy.nvim failed to fetch any plugin(s), maunally execute \`:Lazy sync\` until everything is up-to-date."
cat <<EOS

Thank you for using this set of configuration!
- Project Homepage:
    ${tty_underline}https://github.com/ss77a/nvimdots${tty_reset}
- Further documentation (including executables you ${tty_bold}must${tty_reset} install for full functionality):
    ${tty_underline}https://github.com/ss77a/nvimdots/wiki/Prerequisites${tty_reset}
EOS

if [[ -z "${NONINTERACTIVE-}" ]]; then
	ring_bell
	wait_for_user
	nvim
fi
