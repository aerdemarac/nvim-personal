vim.g.c_syntax_for_h = 1                    -- Treat .h files as C
vim.g.c_ansi_typedefs = 1                   -- Highlight size_t, atomic_int, etc.
vim.g.c_ansi_constants = 1                  -- Highlight NULL, EXIT_SUCCESS, etc.
vim.g.c_gnu = 1                             -- GNU extension highlighting
vim.g.c_no_curly_error = 1                  -- Stop annoying bracket errors
vim.g.cpp_class_scope_highlight = 1         -- Highlight Namespaces and Classes
vim.g.cpp_member_variable_highlight = 1     -- Highlights p->member variables
vim.g.cpp_class_decl_highlight = 1          -- Highlight class names in declarations
vim.g.cpp_posix_standard = 1                -- Highlight POSIX types
vim.g.cpp_experimental_template_highlight = 1 -- Better template highlighting
vim.g.cpp_concepts_highlight = 1            -- C++20 concepts support

vim.g.mapleader = " "

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.opt.number = true
vim.opt.relativenumber = false
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.termguicolors = true
vim.opt.cursorline = true
vim.opt.showmode = false
vim.opt.wrap = false
vim.opt.compatible = false
vim.opt.splitright = true
vim.o.autoindent = true
vim.o.smartindent = true

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  -- Packer replacement not needed
  {
    "neovim/nvim-lspconfig"
  },
  {
    "hrsh7th/nvim-cmp"
  },
  {
    "hrsh7th/cmp-nvim-lsp"
  },
  {
    "L3MON4D3/LuaSnip"
  },
  {
    "saadparwaiz1/cmp_luasnip"
  },
  {
    "windwp/nvim-autopairs"
  },
  {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    require("lualine").setup({
      options = {
        theme = "auto",
      },
      sections = {
        lualine_c = {
          {
            "diagnostics",
            sources = { "nvim_diagnostic" },
            symbols = {
              error = "E:",
              warn  = "W:",
              info  = "I:",
              hint  = "H:",
            },
          },
        },
      },
    })
  end,
  },
  { 
      "sheerun/vim-polyglot", 
      lazy = false,
      init = function()
        -- Tell polyglot to handle C/C++ specifically
        vim.g.polyglot_disabled = { "sensible" } 
      end,
  },
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
  },
  {
  "ghillb/cybu.nvim",
  branch = "main", -- timely updates
  -- branch = "v1.x", -- won't receive breaking changes
  dependencies = { "nvim-tree/nvim-web-devicons", "nvim-lua/plenary.nvim" }, -- optional for icon support
  keys = {
    { "K", "<Plug>(CybuPrev)", mode = "n", desc = "Cybu Prev" },
    { "J", "<Plug>(CybuNext)", mode = "n", desc = "Cybu Next" },
  },
  opts = {}, -- automatically calls require("cybu").setup()
  },
   {
    "catppuccin/nvim",
    name = "catppuccin",
    config = function()
      require("catppuccin").setup({
        flavour = "mocha",
        transparent_background = false,
        term_colors = true,
        styles = {
          comments = { "italic" },
          conditionals = { "bold" },
          functions = { "bold" },
          keywords = { "italic" },
        },
      })
      vim.cmd([[colorscheme catppuccin]])
    end,
  },
  })
local lspconfig = require("lspconfig")
local capabilities = require("cmp_nvim_lsp").default_capabilities()

lspconfig.clangd.setup({
  capabilities = capabilities,
  cmd = {
    "clangd",
    "--background-index",
    "--clang-tidy",
    "--header-insertion=never",
    "--limit-results=100",
    "--completion-style=detailed",
  },
  root_dir = lspconfig.util.root_pattern("compile_commands.json", ".git", "Makefile"),
})

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "*.h",
  command = "setfiletype c",
})

local telescope = require("telescope")
local builtin = require("telescope.builtin")

telescope.setup({
  defaults = {
    layout_strategy = "horizontal",
    layout_config = { width = 0.95, height = 0.95, preview_width = 0.6 },
    file_ignore_patterns = { "/usr/include", "bits/", "c%+%+/", "v1/", "boost/" },
  },
})

vim.keymap.set("n", "<leader>fa", function()
  builtin.lsp_dynamic_workspace_symbols({
    symbols = { "Class", "Struct", "Function", "Method", "Variable", "Field" },
  })
end)
vim.keymap.set("n", "<leader>fd", builtin.lsp_document_symbols)
vim.keymap.set("n", "<leader>ff", builtin.find_files)
vim.keymap.set("n", "<leader>fg", builtin.live_grep)
vim.keymap.set("n", "<leader>fb", builtin.buffers)
vim.keymap.set("n", "gd", builtin.lsp_definitions)
vim.keymap.set("n", "gr", builtin.lsp_references)
vim.keymap.set("n", "gi", builtin.lsp_implementations)

local cmp = require("cmp")
local luasnip = require("luasnip")

cmp.setup({
  preselect = cmp.PreselectMode.None,
  completion = { keyword_length = 3 },
  snippet = { expand = function(args) luasnip.lsp_expand(args.body) end },
  mapping = {
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<Tab>"] = cmp.mapping.confirm({ select = true }),
    ["<Esc>"] = cmp.mapping.abort(),
  },
  sources = {
    {
      name = "nvim_lsp",
      max_item_count = 15,
      entry_filter = function(entry)
        return entry.kind ~= cmp.lsp.CompletionItemKind.Text
      end,
    },
    { name = "luasnip", max_item_count = 5 },
  },
})

require("nvim-autopairs").setup({ map_cr = true, map_bs = true, enable_check_bracket_line = false })
require("cmp").event:on("confirm_done", require("nvim-autopairs.completion.cmp").on_confirm_done())

require("nvim-tree").setup({
  filters = {
    git_ignored = false,
  },
  on_attach = function(bufnr)
    local api = require("nvim-tree.api")
    api.config.mappings.default_on_attach(bufnr)
    vim.keymap.set("n", "<leader>v", api.node.open.vertical, { buffer = bufnr, silent = true })
    vim.keymap.set("n", "<leader>s", api.node.open.horizontal, { buffer = bufnr, silent = true })
  end,
})
vim.keymap.set("n", "<leader>t", ":NvimTreeToggle<CR>", { silent = true })

vim.keymap.set("n", "S", function()
  vim.diagnostic.open_float(0, { focus = false })
end)

vim.keymap.set("n", "<F8>", ":w<CR>:!g++ % -o test<CR>", { silent = true })
vim.keymap.set(
  "n",
  "<F5>",
  ":w<CR>:!gcc -fsanitize=address,undefined,leak -fno-omit-frame-pointer -g3 -std=c99 -Wall -Wextra -Wconversion -Wshadow -pedantic % -o test && exit || read<CR>",
  { silent = false }
)
vim.keymap.set("n", "L", vim.lsp.buf.hover, { noremap = true, silent = true })

local function lsp_hover_silent()
    vim.diagnostic.open_float(nil, { focus = false })  -- optional diagnostics
    vim.lsp.buf.hover()                                -- show hover info
end

vim.keymap.set("n", "L", lsp_hover_silent, { noremap = true, silent = true })
vim.cmd([[autocmd VimEnter * :silent! redraw!]])
vim.keymap.set("n", "<leader>xx", function()
  local qf_open = false

  for _, win in ipairs(vim.fn.getwininfo()) do
    if win.quickfix == 1 then
      qf_open = true
      break
    end
  end

  if qf_open then
    vim.cmd("cclose")
  else
    vim.diagnostic.setqflist()
    vim.cmd("copen")
  end
end)
vim.keymap.set("n", "<leader>gi", function()
  require("nvim-tree.api").tree.toggle_gitignore_filter()
end, { desc = "Toggle GitIgnore Files in NvimTree", silent = true })

vim.api.nvim_set_keymap('t', '<Esc>', '<C-\\><C-n>', { noremap = true, silent = true })
vim.cmd('cnoreabbrev term vsplit \\| term')

vim.keymap.set("n", "$", "g_", { desc = "Last non-blank char" })
vim.keymap.set("n", "v$", "vg_", { desc = "Last non-blank char" })
vim.keymap.set("n", "g$", "$", { desc = "Real end of line" })
