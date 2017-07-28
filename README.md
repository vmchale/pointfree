# pointfree

## Installation

Using [vim-plug](https://github.com/junegunn/vim-plug):

```vimscript
Plug 'vmchale/pointfree'
```

Note that the `pointfree` binary must be on your path. You can install it with:

```bash
 $ stack install pointfree
```

## Usage

To use this plugin, either type `:PointfreeLine` on the current line or
`:Pointfree` along with an expression, e.g.

```vimcsript
:Pointfree \x -> x * 2
```

## Configuration

This plugin provides one keybinding, but you have to pick the keys yourself.
This is what I use in my `.vimrc`:

```vimscript
au BufNewFile,BufRead *.hs nmap pf <Plug>Pointfree
```

If you get stuck at any time:

```vimscript
:help pointfree
```
