#!/usr/bin/env bash

apt install -y i3 chromium-browser

/usr/sbin/useradd -c "Desktop User" -m -p '$6$7dPGQfjM$nnTRTf2yvukJhpHb06DfLzawH/s1lnTvU8RHrQwHeZ0Dm15kvGrv08BTd8D3nTEoKM74TAvh5HG6ZBX3zN6kX0' desktop

# Lightdm, often used by liberals
#
#cat<<\EOF>/etc/lightdm/lightdm.conf.d/50-autologin.conf
#[SeatDefaults]
#autologin-user=desktop
#EOF

sed -i -e 's/#  AutomaticLoginEnable = true/AutomaticLoginEnable = true/g' /etc/gdm3/custom.conf
sed -i -e 's/#  AutomaticLogin = user1/AutomaticLogin = desktop/g' /etc/gdm3/custom.conf

# session fil för light-dm
#
#cat<<\EOF>/usr/share/xsessions/default.desktop
#[Desktop Entry]
#Name=Default
#Comment=This runs user session and logs you into Ubuntu
#Exec=default
#Icon=
#EOF


# sessions fil för gdm3
#
cat<<\EOF>/usr/share/xsessions/xsession.desktop
[Desktop Entry]
Name=XSession
Comment=This session uses the custom xsession file
Exec=/etc/X11/Xsession
Type=Application
DesktopNames=GNOME-Flashback;GNOME;
X-Ubuntu-Gettext-Domain=gnome-flashback
EOF

cat<<\EOF>/home/desktop/.xsession
#!/usr/bin/env bash

export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"
export LANGUAGE="en_US.UTF-8"
export LC_CTYPE="en_US.UTF-8"

gnome-settings-daemon &
gnome-volume-manager &

sed -i 's/"exited_cleanly": false/"exited_cleanly": true/' ~/.config/google-chrome/Default/Preferences
sed -i 's/"exit_type": "Crashed"/"exit_type": "None"/' ~/.config/google-chrome/Default/Preferences

/usr/bin/chromium-browser &
i3
EOF

mkdir -p /var/lib/AccountsService/users/
cat<<\EOF>/var/lib/AccountsService/users/desktop
[User]
XSession=xsession
SystemAccount=false
EOF

cat<<EOF>/home/desktop/.dmrc
[Desktop]
Session=default
EOF

mkdir /home/desktop/.config/i3
chown desktop:desktop /home/desktop/.config/i3
chown desktop:desktop /home/desktop/.config

cat<<\EOF>/home/desktop/.config/i3/config
set $mod Mod1
font pango:monospace 8
floating_modifier $mod
bindsym $mod+Return exec i3-sensible-terminal
bindsym $mod+Shift+q kill
bindsym $mod+d exec dmenu_run
bindsym $mod+j focus left
bindsym $mod+k focus down
bindsym $mod+l focus up
bindsym $mod+semicolon focus right
bindsym $mod+Left focus left
bindsym $mod+Down focus down
bindsym $mod+Up focus up
bindsym $mod+Right focus right
bindsym $mod+Shift+j move left
bindsym $mod+Shift+k move down
bindsym $mod+Shift+l move up
bindsym $mod+Shift+semicolon move right
bindsym $mod+Shift+Left move left
bindsym $mod+Shift+Down move down
bindsym $mod+Shift+Up move up
bindsym $mod+Shift+Right move right
bindsym $mod+h split h
bindsym $mod+v split v
bindsym $mod+f fullscreen toggle
bindsym $mod+s layout stacking
bindsym $mod+w layout tabbed
bindsym $mod+e layout toggle split
bindsym $mod+Shift+space floating toggle
bindsym $mod+space focus mode_toggle
bindsym $mod+a focus parent
bindsym $mod+1 workspace 1
bindsym $mod+2 workspace 2
bindsym $mod+3 workspace 3
bindsym $mod+4 workspace 4
bindsym $mod+5 workspace 5
bindsym $mod+6 workspace 6
bindsym $mod+7 workspace 7
bindsym $mod+8 workspace 8
bindsym $mod+9 workspace 9
bindsym $mod+0 workspace 10
bindsym $mod+Shift+1 move container to workspace 1
bindsym $mod+Shift+2 move container to workspace 2
bindsym $mod+Shift+3 move container to workspace 3
bindsym $mod+Shift+4 move container to workspace 4
bindsym $mod+Shift+5 move container to workspace 5
bindsym $mod+Shift+6 move container to workspace 6
bindsym $mod+Shift+7 move container to workspace 7
bindsym $mod+Shift+8 move container to workspace 8
bindsym $mod+Shift+9 move container to workspace 9
bindsym $mod+Shift+0 move container to workspace 10
bindsym $mod+Shift+c reload
bindsym $mod+Shift+r restart
bindsym $mod+Shift+e exec "i3-nagbar -t warning -m 'You pressed the exit shortcut. Do you really want to exit i3? This will end your X session.' -b 'Yes, exit i3' 'i3-msg exit'"
mode "resize" {
        # These bindings trigger as soon as you enter the resize mode
        # Pressing left will shrink the windowâs width.
        # Pressing right will grow the windowâs width.
        # Pressing up will shrink the windowâs height.
        # Pressing down will grow the windowâs height.
        bindsym j resize shrink width 10 px or 10 ppt
        bindsym k resize grow height 10 px or 10 ppt
        bindsym l resize shrink height 10 px or 10 ppt
        bindsym semicolon resize grow width 10 px or 10 ppt
        # same bindings, but for the arrow keys
        bindsym Left resize shrink width 10 px or 10 ppt
        bindsym Down resize grow height 10 px or 10 ppt
        bindsym Up resize shrink height 10 px or 10 ppt
        bindsym Right resize grow width 10 px or 10 ppt
        # back to normal: Enter or Escape
        bindsym Return mode "default"
        bindsym Escape mode "default"
}
bindsym $mod+r mode "resize"
bar {
        status_command i3status
        tray_output primary
}
EOF

cd /tmp
wget https://github.com/np422/chromeium_config/raw/master/config.tar
cd /home/desktop
tar xvpf /tmp/config.tar
chown -Rh desktop:desktop .
cd /

apt-get -f -y install
apt-get -y autoremove
apt-get clean
