# related-files.nvim

An extension for [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim)
to jump between related files, as specified in code comments.

## Installation

Packer

```lua
use "synchronal/related-files.nvim", { requires = { { 'nvim-telescope/telescope.nvim' } } }
```

```lua
require'telescope'.load_extension('related_files')
```

## Adding related files

Related files are added to a file as a code comment:

```bash
# @related [a related file](path/to/file.txt)
# @related [another file](path/to/file.lua)
```

```typescript
// @related [file name](path/to/file)
```

## Usage

```lua
:Telescope related_files
```

## Development

```shell
nvim --cmd "set rtp+=$(pwd)" fixtures/first.sh
```

```vim
:lua require("telescope").load_extension('related_files')
:Telescope related_files
```
