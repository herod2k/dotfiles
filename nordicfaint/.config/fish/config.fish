export QT_QPA_PLATFORMTHEME=gtk3
export BROWSER=firefox
export EDITOR=vim
export PATH="$PATH:$HOME/.scripts:$HOME/.local/bin:$HOME/.config/scripts"
export GNOME_KEYRING_CONTROL=1
if test -n "$DESKTOP_SESSION"
    set (gnome-keyring-daemon --start | string split "=")
end
