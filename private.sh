#!/usr/bin/env bash

arg=$1

if [ -z "$arg" ]; then
        read -sp "Passphrase: " passphrase
        sig=$(printf "%s" "${passphrase}" | ecryptfs-add-passphrase - | sed 's/\(.*\)\[\(.*\)\]\(.*\)/\2/g')
        # Old mount options
        #sudo mount -t ecryptfs -o rw,relatime,ecryptfs_fnek_sig="${sig}",ecryptfs_sig="${sig}",ecryptfs_cipher=aes,sig_bytes=32,ecryptfs_unlink_sigs,verbosity=0,key=passphrase:passphrase_passwd="$passphrase" ~/.e ~/.private
        sudo mount -t ecryptfs -o rw,relatime,ecryptfs_fnek_sig="${sig}",ecryptfs_sig="${sig}",ecryptfs_cipher=aes,ecryptfs_key_bytes=32,ecryptfs_unlink_sigs,verbosity=0,key=passphrase:passphrase_passwd="$passphrase" .e .private
else
        if [ "$arg" == "-u" ]; then
                sudo umount .private
                keyctl list @u
                keyctl clear @u
        else
                echo "Error: Bad argument"
        fi
fi
