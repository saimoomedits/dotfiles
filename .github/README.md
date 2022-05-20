<br>
    <div align="center">
        <img src="assets/header.png" width=200>
    </div>
<br>

<p align="center">
    hello there, welcome to my Awesomewm dotfiles!<br>
    this an <a href="https://awesomewm.org">awesomewm</a> rice/setup that I use as a daily driver.<br>
    <br>
    🫂 you can take anything you like from this repository. but.. please credit me too! 😄 <br>
    <br>
    :star: if you liked it, please star this repo, it really helps me ⭐
</p>

<br>

<p align="center">
    <a href="https://github.com/saimoomedits/dotfiles#info-">Info</a> - 
    <a href="https://github.com/saimoomedits/dotfiles#shots-gallery-">Gallery</a> - 
    <a href="https://github.com/saimoomedits/dotfiles#features-">Features</a> - 
    <a href="https://github.com/saimoomedits/dotfiles#setup-eyes">Setup</a> -
    <a href="https://github.com/saimoomedits/dotfiles#Keybinds">Keys</a> - 
    <a href="https://github.com/saimoomedits/dotfiles#Modules">Mods</a>
</p>

<br>


# info 📖

**setup details**

| task              | name                   |
| ----------------- | ---------------------- |
| WM                | [awesome-git](https://github.com/awesomeWM/awesome)                                      |
| terminal          | [alacritty](https://github.com/alacritty/alacritty)                                      |
| music player      | [mpd](https://www.musicpd.org/) & [ncmpcpp](https://github.com/ncmpcpp/ncmpcpp)          |
| Light GTK theme   | [Cutefish-light](https://cutefish-ubuntu.github.io/)                            |
| Dark Gtk theme    | Awesthetic-gtk
| bar               | [wibar](https://awesomewm.org/apidoc/popups_and_bars/awful.wibar.html)                   |
| compositor        | [picom-git](https://github.com/yshui/picom)                                  | 

<br>

**more info** 🕵️


<br>

* **Fonts?**
    * as for fonts, the setup uses 4 fonts in total
        - *Roboto* - main ui font
        - *Material Icons* - for icons
        - *Iosevka* - Terminal/Monospace font
        - *JetbrainsMono NF* - idk

<br>

* **gaps/border/titlebar**
    * **titlebars**
        * you can edit `layout/decorations/init.lua` to emend/modify the global titlebar.
    * **borders**
        * border size can be change in `theme/ui_vars.lua`, there is a `border_size`.
    * **gaps**
        * Gaps can also be changed in `theme/ui_vars.lua`.

<br>

* **custom theme?**
    * for dark, edit `theme/colors/dark.lua`
    * for light, edit `theme/colors/light.lua`

<br>



<br>

* **rounded corners**
    * by default, windows are rounded with awesome-wm's `client.shape` property,
    * if you want to use picom instead, do the following,

        - edit `config/others.lua`
        - scroll down to line `256` 
        - either, comment it out or remove that line
        - this will disable rounded windows with awesomeWM
<br>

# shots gallery 📸

1. <details open>
     <summary><strong>dark themed</strong></summary>

     <br>
     <img src="assets/shots/dark.png" width=500>


<br>


2. <details close>
     <summary><strong>light themed</strong></summary>

     <br>

    <img src="assets/shots/light.png" width=500>

 </details>

# features 💡

1. minimalstic vertical bar

    <br>

    <img src="assets/bar.png" height=500>

<br>

2. expandable control center

    <br>

    <img src="assets/control-center.gif" height=500>

<br>

3. Minimal notifcations with text actions

    <br>

    <img src="assets/notif.png" width=500>

<br>

4. custom ncmpcpp UI

    <br>

    <img src="assets/ncmpcpp.png" width=500>

<br>

5. exit screen

    <br>

    <img src="assets/exitscreen.png" width=500>

<br>

6. lockscreen

    <br>

    <img src="assets/lockscreen.png" width=500>

<br>

6. Minimal tasklist dock with pinned apps

    <br>

    <img src="assets/dock.png" width=300>

<br>

**and much more, obviously lol**


# setup :eyes:

**NOTE: The following instructions are for Arch/Arch-based system**


<details open>
<summary><strong>Instructions</strong></summary>

1. Install packages / dependencies
    
    ```    
    yay -S picom-git awesome-git acpid git mpd ncmpcpp wmctrl \
    firefox lxappearance gucharmap thunar alacritty neovim polkit-gnome \
    xdotool xclip scrot brightnessctl alsa-utils pulseaudio jq acpi rofi \
    inotify-tools zsh materia-gtk-theme mpdris2 bluez bluez-utils bluez-plugins \
    playerctl redshift cutefish-cursor-themes-git cutefish-icons
    ```

2. Make backup of directories that will be changed (optional)
    ```
    cd 
    mkdir .backup_config
    cp -r ~/.config/* .backup_config/
    cp -r ~/.mpd .backup_config/
    cp -r ~/.ncmpcpp .backup_config/
    cp -r ~/.themes .backup_config/
    ```

3. Clone this repo
    ```
    cd
    clear
    git clone https://github.com/saimoomedits/dotfiles
    cd dotfiles
    ```

4. Copy the dotfiles in required places
    ```
    cp -rf .config/* ~/.config/
    cp -rf extras/mpd ~/.mpd
    cp -rf extras/ncmpcpp ~/.ncmpcpp
    cp -rf extras/fonts ~/.fonts
    cp -rf extras/scripts ~/.scripts
    cp -rf extras/oh-my-zsh ~/.oh-my-zsh
    cp -rf extras/themes ~/.themes/
    ```
5. make some files executeable
    ```
    cd ~/.config/awesome/misc
    sudo chmod -R +x *
    ```
    
6. Startup services
    ```
    systemctl --user enable mpd
    sudo systemctl enable bluetooth
    ```

7. Done
    <p><b>All done, Now login to awesome-WM</b></p>

<br>




</details>    

<br>


# Keybinds

* press `super(windows key) + f1` :smile:
* the dock can be opened by hovering bottom of the screen
* the dashboard/notifcenter can be opened by hovering to the right for 0.24 seconds


# Modules

1. **[Rubato](https://github.com/andOrlando/rubato)**
    * Created by [andOrlando](https://github.com/andOrnaldo)
    * Basically, Allows you to animate a number value in AwesomeWM

2. **[Bling](https://github.com/BlingCorp/bling)**
    * Created by the BlingCorp community
    * Adds a lot more cool modules to AwesomeWM

3. **[Layout-machi](https://github.com/xinhaoyuan/layout-machi)**
    * Created by xinhaoyuan
    * Manual layout with interactive editor

4. **Awesome-Dock**
    * Created by me. the idiot
    * A tasklist dock with pinned apps
    * you can use it in your config (hopefully)
    * but there are still lots of things to improve
    
        * The dock can be used in any awesome rice.. (kinda)
    the catch is that. you need a spcific icon-theme in `/usr/share/icons` for pinned apps to work properly<br>
    but if your using the exact rice as mine, you don't have to worry about it

    <br>

    * You can customize the dock's colors, size, spacing, hide-timeout, etc in `theme/init.lua`

    <br>

    * example:
    ```lua
    theme.awesome_dock_size = 80
    theme.awesome_dock_pinned = {
        {"xterm", "terminal"},
        {"spotify", "spotify"},
        {"xterm"},
        {"thunar"}
    }
    theme.awesome_dock_color_active = theme.accent
    theme.awesome_dock_color_inactive = theme.fg_color .. "66"
    theme.awesome_dock_color_minimized = theme.accent .. "33"
    theme.awesome_dock_color_hover = theme.fg_color .. "33"
    theme.awesome_dock_color_bg = theme.bg_color
    theme.awesome_dock_disabled = false
    theme.awesome_dock_spacing = 10
    theme.awesome_dock_timeout = 1.2
    ```
    
    * to add more pinned apps you can do the following in `theme.lua`:
    ```lua
    --[[ 
        table example:
        { "app command", "app class"}
        
        * `app command` is well. the command that launches that app
        * `app class` is the class or name of the app for icons.
    ]]
    theme.awesome_dock_pinned = {
        {"spotify", "spotify"},
        {"xterm"},
        {"thunar"}
    }
    ```

# Todos

- [ ] Make dock's icon-handler identify global icon-theme
- [ ] Improve Ncmpcpp decorations
- [ ] Improve Notifications
- [ ] Polish Awesthetic-gtk-theme
   

# Credits

* special thanks to :heart:
    * [moonlight-coffee](https://github.com/Moonlight-Coffee)
    * [justleoo](https://github.com/justleoo)

<br>

* also these 🌃 awesome people!
    * [Javacafe01](https://github.com/javacafe01)
    * [manilarome](https://github.com/manilarome)
    * [elenapan](https://github.com/elenapan)
<br>

* extras :sparkles:
    * the awesome team - [awesomeWM](https://github.com/awesomewm/) contributers
    * [Cutefish](https://cutefish-ubuntu.github.io/) - Cutefishos
    * [rubato](https://github.com/andOrlando/rubato) - smooth animations
    * [Bling](https://github.com/BlingCorp/bling) - make awesome even more awesome

<br>

* contributers

<a href="https://github.com/saimoomedits/dotfiles/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=saimoomedits/dotfiles" width=160/>
</a>

