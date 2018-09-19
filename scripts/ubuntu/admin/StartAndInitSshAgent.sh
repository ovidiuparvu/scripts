#!/usr/bin/env bash


# =============================================================================
# Constants
# =============================================================================

SSH_AUTH_SOCK_FILE_PATH="${HOME}/.ssh/ssh_auth_sock";


# =============================================================================
# Main
# =============================================================================

# Start SSH agent on the first login only
if [[ ! -S "${SSH_AUTH_SOCK_FILE_PATH}" ]]; then
    eval "$(ssh-agent -s)";

    ln -sf "${SSH_AUTH_SOCK}" "${SSH_AUTH_SOCK_FILE_PATH}";

    export SSH_AUTH_SOCK;
    
    SSH_AUTH_SOCK="${SSH_AUTH_SOCK_FILE_PATH}";

    # Add SSH keys to the SSH agent
    ssh-add ~/.ssh/id_rsa;
fi
