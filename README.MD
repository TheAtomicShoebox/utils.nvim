I noticed a dearth of plugins that purely help debug neovim configuration with lua, so I decided to create this plugin.
It's very unsophisticated, and is hardcoded to my current setup [here](https://www.github.com/TheAtomicShoebox/nvim), but I might improve it with time.

It's currently written to work directly with [LazyVim](https://www.github.com/LazyVim/LazyVim), using the Snacks.nvim and noice, but that could be swapped out
for whatever logging setup someone has.

I am new to lua and to plugin writing, so this may take some time.

For now, there are very few utilities:

 * Serialize: a function to turn tables into strings, so you can dump data into logging
 * ToTable: a function to turn a string into a table, so you can manipulate the table in lua more simply (this may not be needed, but who knows)
 * Log: a function that will log as debug (and thus not be seen) when a global debug flag is turned off

I created this code by first just copypasta-ing from an AI, so I warrant nothing about the quality of the code.

I welcome issues, criticism, and contribution, in the very unlikely scenario someone actually finds this repo and wants to use it.
Hopefully I'll get around to updating this enough that it will be something interesting.
