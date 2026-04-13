# External Dependencies (Pre-Lua-Setup)

- [x] Neovim ≥ 0.9
- [x] Git
- [x] clangd
- [x] gcc / g++ (build-essential)
- [x] clang-tidy
- [x] ripgrep (rg)
- [x] fd
- [x] make / cmake
- [x] bat
- [x] lsd

# Neovim Custom Keybindings

Leader key: `Space`

---

## Telescope / LSP Navigation

| Key | Mode | Action |
|-----|------|--------|
| `<leader>fa` | Normal | Search workspace symbols (Class, Struct, Function, Method, Variable, Field) |
| `<leader>fd` | Normal | Search document symbols |
| `<leader>ff` | Normal | Find files |
| `<leader>fg` | Normal | Live grep |
| `<leader>fb` | Normal | List open buffers |
| `gd` | Normal | Go to LSP definitions |
| `gr` | Normal | Go to LSP references |
| `gi` | Normal | Go to LSP implementations |

---

## Nvim-Tree

| Key | Mode | Action |
|-----|------|--------|
| `<leader>t` | Normal | Toggle NvimTree |
| `<leader>v` | Normal | Open node in vertical split (buffer-local) |
| `<leader>s` | Normal | Open node in horizontal split (buffer-local) |
| `<leader>gi` | Normal | Toggle GitIgnore files filter |

---

## Diagnostics

| Key | Mode | Action |
|-----|------|--------|
| `L` | Normal | Show diagnostics float (no focus) || Info about variable or method| 
| `<leader>xx` | Normal | Populate quickfix list with diagnostics and open `:copen` |

---

## Compilation / Build

| Key | Mode | Action |
|-----|------|--------|
| `<F8>` | Normal | Save and compile with `g++ % -o test` |
| `<F5>` | Normal | Save and compile with GCC + sanitizers |

---

## Line Navigation

| Key | Mode | Action |
|-----|------|--------|
| `$` | Normal | Jump to last non-blank character (`g_`) |
| `g$` | Normal | Jump to real end of line (`$`) |

---

## Buffer Navigation

| Key | Mode | Action |
|-----|------|--------|
| `K` | Normal | Jump to previous buffer like alt+tab |
| `J` | Normal | Jump to next buffer like alt+tab |

---

## Terminal Mode

| Key | Mode | Action |
|-----|------|--------|
| `<Esc>` | Terminal | Exit terminal to Normal mode |

---

## Hover / Info

| Key | Mode | Action |
|-----|------|--------|
| `L` | Normal | LSP hover/info + optional diagnostics (silent) |
