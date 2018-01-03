#!/bin/sh

# vault_setup.sh
#
# This script will automatically create an Ansible vault file for the vagrant
# user to be used with playbooks.
# By default, the files will be recreated at each login to avoid a changed
# password from breaking the playbook.  The user may opt out of this behavior.
# In that case, delete the vault file and then re-run this script to recreate
# them.
# ----------------------------------------------------------------------------


VAULTDIR=~/.vault
VAULTFILE=$VAULTDIR/vault.yml
VAULTPASS=$VAULTDIR/.pass
NOVAULT=$VAULTDIR/no_vault
NOCLEANUP=$VAULTDIR/no_cleanup


# Do nothing if the user has opted to not set up the vault file
# -------------------------------------------------------------
if [ -e $NOVAULT ]; then exit 0; fi

# Exit if the user has opted out of automatic file recreation upon each login
# ---------------------------------------------------------------------------
if [ -e $NOCLEANUP -a -e $VAULTFILE -a -e $VAULTPASS ]; then

  exit 0

else

  if [ ! -d $VAULTDIR ]; then mkdir $VAULTDIR; fi

  # Allow the user to opt out of vault file setup
  # ---------------------------------------------
  printf "\nPerform Ansible setup? [Y,n] "
  read choice
  choice=`echo "$choice" | tr '[:upper:]' '[:lower:]'`
  case "$choice" in
    n|no)
      touch $NOVAULT
      exit 0
      ;;
    *)
      printf "\nCreating Ansible vault file...\n"
      ;;
  esac

  # Prompt for credentials
  # ----------------------
  printf "Enter IDIR username: "
  read username
  printf "Enter IDIR password: "
  read -s password
  printf "\nEnter Windows username (e.g., wgretzky_a): "
  read windows_username
  printf "Enter Windows password: "
  read -s windows_password

  # Create vault and password files
  # -------------------------------
  printf "\n\nCreating ANSIBLE_VAULT_PASSWORD_FILE...\n"
  printf "ansible_username: $username@bcgov\nansible_password: $password\nssh_user: $username\nssh_pass: $password\nansible_become_pass: $password\nwindows_username: $windows_username\nwindows_password: $windows_password\n" > $VAULTFILE

  # Generate a random vault password and save it to a file
  # ------------------------------------------------------
  cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w ${1:-12} | head -n 1 > $VAULTPASS
  chmod 600 $VAULTPASS
  printf "\nSetting environment variable ANSIBLE_VAULT_PASSWORD_FILE...\n\n"
  export ANSIBLE_VAULT_PASSWORD_FILE=$VAULTPASS

  # Encrypt the vault file
  # ----------------------
  ansible-vault encrypt $VAULTFILE

  # Give the user the option to override file recreation on each login
  # ------------------------------------------------------------------
  printf "\nRecreate vault files at each login? [Y,n] "
  read choice
  choice=`echo "$choice" | tr '[:upper:]' '[:lower:]'`
  case "$choice" in
    n|no) touch $NOCLEANUP;;
    *) ;;
  esac

  printf "\nDone\n"
fi
