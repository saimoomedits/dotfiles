# i3_resize for bspwm
## BSPWM's resizing suckssss
To use i3 like resize in bspwm in linux, proceed with these commands :

    git clone https://github.com/zim0369/bspwm_i3size.git $HOME/.config/bspwm/resize/
    
    chmod +rwx $HOME/.config/bspwm/resize/*
In your sxhkdrc( remove these default lines ) :

    # contract a window by moving one of its side inward
    alt + {h,j,k,l}
    	bspc node -z {right -20 0,top 0 20,bottom 0 -20,left 20 0}
    
    # expand a window by moving one of its side outward
    alt + shift + {h,j,k,l}
    	bspc node -z {left -20 0,bottom 0 20,top 0 -20,right 20 0}
Replace the above lines with these :

    # i3 like resizing
    alt + h
        /bin/sh $HOME/.config/bspwm/resize/shrinkx.sh
    alt + l
        /bin/sh $HOME/.config/bspwm/resize/expandx.sh
    alt + k
        /bin/sh $HOME/.config/bspwm/resize/shrinky.sh
    alt + j
        /bin/sh $HOME/.config/bspwm/resize/expandy.sh

NOTE : Make sure you reload your sxhkd & you don't have to toggle any resize mode in bspwm like i3's. Just start resizing the windows with alt+{h,j,k,l}

### USAGE :
alt + h -> Shrink windows horizontally.

alt + l -> Expand windows horizontally.

alt + k -> Shrink windows vertically.

alt + j -> Expand windows vertically.
