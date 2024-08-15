vim.loader.enable()

-------------------
-- global settings
-------------------
vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0

-------------------
-- local options
-------------------
local options = {
  number = true,
  relativenumber = true,
  numberwidth = 2,

  -- display white spaces
  list = true,
  listchars = { tab = "→ ", trail = "·", extends = "»", precedes = "«", eol = "¬" },

  termguicolors = true,
  background = "dark",
  signcolumn = "yes",

  cursorline = true,
  wrap = false,

  inccommand = "split",

  -- tab settings
  expandtab = true,
  tabstop = 2,
  softtabstop = 2,
  shiftwidth = 2,
  shiftround = true,

  -- indentation settings
  autoindent = true,
  smartindent = true,
  breakindent = true,

  -- search settings
  ignorecase = true,
  smartcase = true,
  hlsearch = true,
  grepprg = "rg --vimgrep",
  grepformat = "%f:%l:%c:%m", -- :h errorformat

  scrolloff = 15,
  sidescrolloff = 5,

  clipboard = "unnamed,unnamedplus",
  completeopt = "menu,menuone,noselect,preview,noinsert",
  wildmode = "longest:full,full",

  -- splint windows setting
  splitright = true,
  splitbelow = true,

  swapfile = false,
  undofile = true,
  virtualedit = "block",

  updatetime = 250,
  timeout = true,
  timeoutlen = 300,
  mouse = "a",
  mousemoveevent = true,
  autowrite = true,
  formatoptions = "tqnlj", -- :h fo-table
  fileencoding = "utf-8",
  guifont = "Hack Nerd Font:h13",
}

vim.opt.shortmess:append("IsF") -- :h shortmvim.opt
vim.opt.whichwrap:append("<>[]hl") -- :h whichwrap
vim.opt.iskeyword:append("-")

for option, value in pairs(options) do
  vim.opt[option] = value
end

-------------------
-- keymap settings
-------------------
function Map(mode, lhs, rhs, opts)
  -- set default value if nothing has been specified
  if opts.noremap == nil then
    opts.noremap = true
  end

  if opts.silent == nil then
    opts.silent = true
  end

  vim.keymap.set(mode, lhs, rhs, opts)
end

Map({ "i", "v" }, "jk", "<Esc>", { desc = "Escape to normal mode" })
Map({ "i", "v" }, "kj", "<Esc>", { desc = "Escape to normal mode" })

-- Movement between panes
Map("n", "<C-h>", "<C-w>h", { desc = "Move the cursor to the left pane" })
Map("n", "<C-j>", "<C-w>j", { desc = "Move the cursor to the below pane" })
Map("n", "<C-k>", "<C-w>k", { desc = "Move the cursor to the above pane" })
Map("n", "<C-l>", "<C-w>l", { desc = "Move the cursor to the right pane" })

-- spliting windows
Map("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" })
Map("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" })
Map("n", "<leader>se", "<C-w>=", { desc = "Make split window panes equal in size" })
Map("n", "<leader>sx", ":close<CR>", { desc = "Close the current split window" })

-- Movement between buffers
Map("n", "<S-l>", ":bnext<CR>", { desc = "Move to the next buffer" })
Map("n", "<S-h>", ":bprevious<CR>", { desc = "Move to the previous buffer" })
Map("n", "<S-d>", ":bdelete<CR>", { desc = "Close the buffer" })

-- move text in visual mode
Map("v", "<A-j>", ":m .+1<CR>==", { desc = "Move the visual selected line down" })
Map("v", "<A-k>", ":m .-2<CR>==", { desc = "Move the visual selected line up" })

-- move text in visual block mode
Map("x", "J", ":move '>+1<CR>gv-gv", { desc = "Move the visual selected block down" })
Map("x", "K", ":move '<-2<CR>gv-gv", { desc = "Move the visual selected block up" })

-- Better terminal navigation
Map("t", "<C-h>", "<C-\\><C-n><C-w>h", { desc = "Move from terminal to the left pane" })
Map("t", "<C-j>", "<C-\\><C-n><C-w>j", { desc = "Move from terminal to the below pane" })
Map("t", "<C-k>", "<C-\\><C-n><C-w>k", { desc = "Move from terminal to the above pane" })
Map("t", "<C-l>", "<C-\\><C-n><C-w>l", { desc = "Move from terminal to the right pane" })

-- Resize window panes with arrow keys
Map("n", "<C-Up>", ":resize +2<CR>", { desc = "Increase the pane window size horizontally" })
Map("n", "<C-Down>", ":resize -2<CR>", { desc = "Decrease the pane window size horizontally" })
Map("n", "<C-Right>", ":vertical resize +2<CR>", { desc = "Increase the pane window size vertically" })
Map("n", "<C-Left>", ":vertical resize -2<CR>", { desc = "Decrease the pane window size vertically" })

Map("v", "<", "<gv", { desc = "Decrease the indentation" })
Map("v", ">", ">gv", { desc = "Increase the indentation" })

Map("n", "j", [[v:count? "j" : "gj"]], {noremap = true, expr = true})
Map("n", "k", [[v:count? "k" : "gk"]], {noremap = true, expr = true})

-- Misc bindings
Map("n", "<leader>a", "ggVG", { desc = "Select all..." })
Map("n", "<leader>nh", ":nohl<CR>", { desc = "Disable highlight of text from hlsearch" })
Map("n", "<leader>p", '"*p', { desc = "Paste contents from clipboard" })
Map("n", "<leader>+", "<C-a>", { desc = "Increment the numeral under the cursor" })
Map("n", "<leader>-", "<C-x>", { desc = "Decrement the numeral under the cursor" })

-----------------------------------------
-- install and start lazy plugin manager
-----------------------------------------

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end

vim.opt.rtp:prepend(lazypath)

local plugins_directory = {
  { import = "plugins" }
}

local lazy_opts = {
  defaults = {
    lazy = false,
  },
  install = {
    missing = true,
  },
  ui = {
    icons = {
      cmd = " ",
      config = "",
      event = " ",
      favorite = " ",
      -- ft = " ",
      ft = "",
      init = " ",
      import = " ",
      keys = " ",
      -- lazy = "󰒲 ",
      lazy = "󰂠 ",
      -- loaded = "●",
      loaded = "",
      not_loaded = "○",
      plugin = " ",
      runtime = " ",
      require = "󰢱 ",
      source = " ",
      start = " ",
      task = "✔ ",
      list = {
        "●",
        "➜",
        "★",
        "‒",
      },
    },
  },
  performance = {
    cache = {
      enabled = true,
    },
    reset_packpath = true,
    rtp = {
      reset = true,
      disabled_plugins = {
        "2html_plugin",
        "tohtml",
        "getscript",
        "getscriptPlugin",
        "gzip",
        "logipat",
        "netrw",
        "netrwPlugin",
        "netrwSettings",
        "netrwFileHandlers",
        "matchit",
        "matchparen",
        "tar",
        "tarPlugin",
        "rrhelper",
        "spellfile_plugin",
        "vimball",
        "vimballPlugin",
        "zip",
        "zipPlugin",
        "tutor",
        "rplugin",
        "syntax",
        "synmenu",
        "optwin",
        "compiler",
        "bugreport",
        "ftplugin",
      },
    },
  },
  checker = {
    enabled = true,
    notify = false,
  },
  change_detection = {
    enabled = true,
    notify = false,
  },
}

require("lazy").setup(plugins_directory, lazy_opts)

-- Set colorscheme
local colorscheme = "monokai_pro"

local function setcolorscheme(scheme)
  return vim.cmd.colorscheme(scheme)
end

local status_ok, _ = pcall(setcolorscheme, colorscheme)
if not status_ok then
  vim.notify("colorscheme " .. colorscheme .. " not found")
  return
end
