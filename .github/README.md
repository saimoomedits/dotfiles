<div align="center">
    <img src="assets/Header.png" width=300>
</div>


<br>

    

# Welcome!! 👋

<div align="right">
    <img src="assets/preview.gif" width=450 align="right">
</div>

<p>
    <h3><b><- Awesome-WM rice 🍚 -></b></h3><br>
    Hey there, welcome to my dotfiles! you can find config files for awesome, alacritty, etc here<br>
    I use the Material theme as a theme and color scheme for this setup!<br>
    went for a "android-like" look here while also keeping it simple!<br>
    I have recently switched to Awesome-WM and I gotta say This WM is Amazing!<br>
    <br>
    You can find everything used in this setup in this repo<br>
    if you have any questions/fix. feel free to open an issue/pull-request<br>
     <br>
        <b>Fyi, I am pretty new to awesome, so pls no hate</b>
    <br>
    <h2><b>Enjoy!</b></h2>
        
    
</p>

<br>


# Shots 📷

<details close>
<summary><strong>Light mode</strong></summary>
    <img src="assets/light.png" width=700 align="center">

</details>

<details open>
<summary><strong>Dark mode</strong></summary>
    <img src="assets/dark.png" width=700 align="center">

</details>

<br>

# Setup 🤖


<details open>
<summary><strong>Arch/ Arch Based</strong></summary>

1. Install packages / dependencies

        ```shell
        yay -S picom-ibhagwan-git awesome-git acpid git mpd ncmpcpp wmctrl \
        firefox lxappearance gucharmap thunar Alacritty neovim polkit-gnome \
        xdotool xclip scrot brightnessctl alsa-utils pulseaudio jq acpi rofi 
        ```

2. Make backup of directories that will be changed (optional)
    ```shell
    cd 
    mkdir .backup_config
    cp -r ~/.config/* .backup_config/
    cp -r ~/.mpd .backup_config/
    cp -r ~/.ncmpcpp .backup_config/

    ```

3. Clone this repo
    ```shell
    cd
    clear
    git clone https://github.com/saimoomedits/dotfiles
    cd dotfiles
    ````

4. Copy the dotfiles in required places
    ```shell
    cp -rf .config/* ~/.config/
    cp -rf .mpd ~/.mpd
    cp -rf .ncmpcpp ~/.ncmpcpp
    cp -rf .fonts/* ~/.fonts/
    cp -rf .themes/* ~/.themes/
    ```
5. make some files executeable
    ```shell
    cd ~/.config/awesome/misc
    sudo chmod -R +x *
    ```
6. Done
    <p><b>All done, Now login to awesome-WM</b></p>

<br>




</details>    

<br>

# basic Keybinds ⌨️

| Task              | Keybind               |
| ----------------- | --------------------- |
| terminal          | super + Enter         |
| restart awesome   | super + ctrl + r      |
| exit awesome      | super + shft + e      |
| toggle theme      | super + f             |
| toggle sidebar    | super + z             |
| switch Workspace  | super + 1-6           |

<br>

**For all keybindings, check ```keys.lua``` file**


<br>

# Credits 🙏

**this rice was made possible by the following geniuses:**

* [JavaCafe01](https://github.com/JavaCafe01/dotfiles)
* [Elenapan](https://github.com/elenapan/dotfiles)

<br>

**wallpaper**
* [Moonlight-coffee](https://github.com/moonlight-coffeee)

**modules**
* [Rubato](https://github.com/andOrlando/rubato)
* [Bling](https://github.com/BlingCorp/bling)
