#!/bin/sed -nf
##
##             DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
##                     Version 2, December 2004
##
##  Copyright (C) 2004 Sam Hocevar <sam@hocevar.net>
##
##  Everyone is permitted to copy and distribute verbatim or modified
##  copies of this license document, and changing it is allowed as long
##  as the name is changed.
##
##             DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
##    TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
##
##   0. You just DO WHAT THE FUCK YOU WANT TO.
##
##
## Project Home Page: http://github.com/Anvil/bash-doxygen/
## Project Author: Damien Nadé <github@livna.org>
##

# Delete non doxygen-related lines content, but not the line
# themselves.
/^\(\s*\)#-d\( \|$\)/!{
     s/^.*$//p
}
# Make all #- lines doxygen-able.
s/^\s*#-d\( \|$\)//p

