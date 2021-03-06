#!/bin/sh
# Auto-generated uninstallation file

PATH=$PATH:/bin:/sbin:/usr/sbin
LOGFILE="/var/log/vboxadd-uninstall.log"

# Read routines.sh
if ! test -r "/opt/VBoxGuestAdditions-5.2.6/routines.sh"; then
    echo 1>&2 "Required file routines.sh not found.  Aborting..."
    return 1
fi
. "/opt/VBoxGuestAdditions-5.2.6/routines.sh"

# We need to be run as root
check_root

create_log "$LOGFILE"

echo 1>&2 "Removing installed version 5.2.6 of VirtualBox Guest Additions..."

NO_CLEANUP=""
if test "$1" = "no_cleanup"; then
    shift
    NO_CLEANUP="no_cleanup"
fi

test -r "/var/lib/VBoxGuestAdditions/filelist" || abort "Required file filelist not found.  Aborting..."

# Stop and clean up all services
for i in "/opt/VBoxGuestAdditions-5.2.6/init/vboxadd-service" "/opt/VBoxGuestAdditions-5.2.6/init/vboxadd"; do
    if test -r "$i"; then
        stop_init_script "`basename "$i"`" 2>> "/var/log/vboxadd-install.log"
        test -z "${NO_CLEANUP}" && grep -q '^# *cleanup_script *$' "${i}" && "${i}" cleanup 2>> "$LOGFILE"
        delrunlevel "`basename "$i"`" 2>> "/var/log/vboxadd-install.log"
        remove_init_script "`basename "$i"`" 2>> "/var/log/vboxadd-install.log"
    fi
done

# Load all modules
# Important: This needs to be done before loading the configuration
#            value below to not override values which are set to a default
#            value in the modules itself.
for CUR_MODULE in /opt/VBoxGuestAdditions-5.2.6/installer/module-autologon
    do
        . "$CUR_MODULE"
    done

# Load configuration values
test -r "/var/lib/VBoxGuestAdditions/config" && . "/var/lib/VBoxGuestAdditions/config"

# Call uninstallation initialization of all modules
for CUR_MODULE in ""
    do
        if test -z "$CUR_MODULE"; then
            continue
        fi
        mod_${CUR_MODULE}_pre_uninstall
        if [ 0 -ne 0 ]; then
            echo 1>&2 "Module \"$CUR_MODULE\" failed to initialize uninstallation"
            # Continue initialization.
        fi
    done

# Call uninstallation of all modules
for CUR_MODULE in ""
    do
        if test -z "$CUR_MODULE"; then
            continue
        fi
        mod_${CUR_MODULE}_uninstall
        if [ 0 -ne 0 ]; then
            echo 1>&2 "Module \"$CUR_MODULE\" failed to uninstall"
            # Continue uninstallation.
        fi
    done

# And remove all files and empty installation directories
# Remove any non-directory entries
cat "/var/lib/VBoxGuestAdditions/filelist" | xargs rm 2>/dev/null
# Remove any empty (of files) directories in the file list
cat "/var/lib/VBoxGuestAdditions/filelist" |
    while read file; do
        case "$file" in
            */)
            test -d "$file" &&
                find "$file" -depth -type d -exec rmdir '{}' ';' 2>/dev/null
            ;;
        esac
    done

# Remove configuration files
rm "/var/lib/VBoxGuestAdditions/filelist" 2>/dev/null
rm "/var/lib/VBoxGuestAdditions/config" 2>/dev/null
rmdir "/var/lib/VBoxGuestAdditions" 2>/dev/null
exit 0
