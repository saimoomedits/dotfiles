-- ui vars
-- ~~~~~~~
-- ui variables that help theme/init.lua define its properties
-- line 10-16, will probably be overwritten by scripts
-- its better not to add/remove lines above line 16


return {

font                = "Roboto",
titlebar_position   = "bottom",
gaps                = 10,
border_width        = 0,
round_corners       = 15,
bar_size            = 54,
color_scheme        = "dark",

}


--[[

* Explaination of
* what each thing is

>> font
* font which which will be used by this setup
* spaces, font size, font-properties are not required

>> gaps
* window gaps, the padding of the opened client(window)

>> border_width
* window border width

>> round_corners
* rounded_corner radius for everything!
* set to 0 for sharp edges

>> color_scheme
* variable used to define the current accent/color.
* posibble strings: "grey", "blue", "pink", "green"
* "pink" and "green" are light-themes
* whereas, "blue" and "grey" are dark.

]]

