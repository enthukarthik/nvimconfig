return {
  -- various colorschemes

  { "tanvirtin/monokai.nvim",  priority = 1000,},
  -- { "Shatur/neovim-ayu",       priority = 1000,},
  -- { "tiagovla/tokyodark.nvim", priority = 1000,},
  -- { "folke/tokyonight.nvim",   priority = 1000,},
  --
  -- { "ellisonleao/gruvbox.nvim", name = "gruvbox",    priority = 1000,},
  -- { "catppuccin/nvim",          name = "catppuccin", priority = 1000,},
  -- { "decaycs/decay.nvim",       name = "decay",      priority = 1000,},
  -- { "Everblush/nvim",           name = "everblush",  priority = 1000,},
  -- { "rebelot/kanagawa.nvim",    name = "kanagawa",   priority = 1000,},
  -- { "navarasu/onedark.nvim",    name = "onedark",    priority = 1000,},

  -- which-key plugin to notify keymappings configured
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {},
  },
  -- tree-sitter using nvim-treesitter

  {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "nvim-treesitter/nvim-treesitter-context",
    },
    build = ":TSUpdate",
    config = function()
      local configs = require("nvim-treesitter.configs")
      configs.setup({
        ensure_installed = {
          "awk",
          "bash",
          "bicep",
          "c",
          "c_sharp",
          "clojure",
          "cmake",
          "commonlisp",
          "cpp",
          "css",
          "csv",
          "cuda",
          "dockerfile",
          "erlang",
          "glsl",
          "haskell",
          "haskell_persistent",
          "hlsl",
          "html",
          "ini",
          "java",
          "javascript",
          "json",
          "json5",
          "jsonnet",
          "latex",
          "lua",
          "make",
          "markdown",
          "markdown_inline",
          "nasm",
          "ocaml",
          "python",
          "query",
          "racket",
          "regex",
          "rust",
          "scala",
          "scheme",
          "toml",
          "tsx",
          "typescript",
          "vim",
          "vimdoc",
          "xml",
          "yaml",
        },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "<C-Space>",
            node_incremental = "<C-Space>",
            node_decremental = "<bs>",
            scope_incremental = false,
          },
        },
        auto_install = true,
        highlight = {
          enable = true,
        },
        indent = {
          enable = true,
        },
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    event = "VeryLazy",
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
    },
    config = function()
        local ts_repeat_move = require("nvim-treesitter.textobjects.repeatable_move")

        -- Repeat movement with ; and ,
        -- ensure ; goes forward and , goes backward regardless of the last direction
        Map({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move_next, {})
        Map({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_previous, {})

        -- Optionally, make builtin f, F, t, T also repeatable with ; and ,
        Map({ "n", "x", "o" }, "f", ts_repeat_move.builtin_f_expr, { expr = true })
        Map({ "n", "x", "o" }, "F", ts_repeat_move.builtin_F_expr, { expr = true })
        Map({ "n", "x", "o" }, "t", ts_repeat_move.builtin_t_expr, { expr = true })
        Map({ "n", "x", "o" }, "T", ts_repeat_move.builtin_T_expr, { expr = true })
    end,
  },

  -- telescope

  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
      },
      "MunifTanjim/nui.nvim",
      "nvim-telescope/telescope-frecency.nvim",
      "nvim-telescope/telescope-file-browser.nvim",
      "xiyaowong/telescope-emoji.nvim",
      "ghassan0/telescope-glyph.nvim",
    },

    config = function()
      local telescope = require("telescope")
      local builtins = require("telescope.builtin")
      local actions = require("telescope.actions")

      Map("n", "<leader>ff", builtins.find_files, { desc = "Fuzzy find files in pwd" })
      Map("n", "<leader>fr", builtins.oldfiles, { desc = "Fuzzy find recent files" })
      Map("n", "<leader>fb", builtins.buffers, { desc = "Fuzzy find from buffers" })
      Map("n", "<leader>fs", builtins.live_grep, { desc = "Find string in pwd" })
      Map("n", "<leader>f*", builtins.grep_string, { desc = "Find string under cursor in pwd" })
      Map("n", "<leader>tf", ":Telescope file_browser<CR>", { desc = "Open telescope file browser extension" })
      Map("n", "<leader>te", ":Telescope emoji<CR>", { desc = "Open telescope emoji extension" })
      Map("n", "<leader>tg", ":Telescope glyph<CR>", { desc = "Open telescope glyph extension" })
      Map("n", "<leader>tq", ":Telescope frecency<CR>", { desc = "Open telescope frecency extension" })

      telescope.setup({
        defaults = {
          path_display = { "smart" },
          mappings = {
            i = {
              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,
              ["<C-h>"] = actions.which_key,
              ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
              ["<leader><leader>"] = actions.close,
            },
          },
        },
      })

      telescope.load_extension("fzf")
      telescope.load_extension("frecency")
      telescope.load_extension("file_browser")
      telescope.load_extension("emoji")
      telescope.load_extension("glyph")
    end,
  },
  -- Commenting code using Comment.nvim
  {
    -- gcc - to add a linewise comment
    -- gbc - to add blockwise comment
    -- gc - same as gcc in visual mode
    -- gb - same as gbc in visual mode
    -- gcO - add line comment above and enter Insert mode
    -- gco - add line comment below and enter Insert mode
    "numToStr/Comment.nvim",
    event = {"BufReadPre", "BufNewFile"},
    opts = {},
  },
  -- Surrounding something with a specific character using nvim-surround
  {
    -- Usage :
    -- ys{motion}{char} - add
    -- ds{char} - delete
    -- cs{target}{replacement} - change
    --     Old text                    Command         New text
    -- --------------------------------------------------------------------------------
    --     surr*ound_words             ysw)           (surround_words)
    --     *make strings               ys$"            "make strings"
    --     [delete ar*ound me!]        ds]             delete around me!
    --     remove <b>HTML t*ags</b>    dst             remove HTML tags
    --     delete(functi*on calls)     dsf             function calls
    --     'change quot*es'            cs'"            "change quotes"
    --     <b>or tag* types</b>        csth1<CR>       <h1>or tag types</h1>
    --     Detailed information on how to use this plugin can be found in :h nvim-surround.usage
    "kylechui/nvim-surround",
    version = "*",
    event = "InsertEnter",
    opts = {},
  },
  -- Improved status line using lualine
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup({
        options = {
          icons_enabled = true,
          theme = "molokai", -- check lualine github page for available themes
          section_separators = { left = "", right = "" },
          component_separators = { left = "", right = "" },
          disabled_filetypes = {
            statusline = {},
            winbar = {},
          },
          ignore_focus = {},
          always_divide_middle = true,
          globalstatus = true,
          refresh = {
            statusline = 1000,
            tabline = 1000,
            winbar = 1000,
          },
        },
        sections = {
          lualine_a = { "mode", "searchcount" },
          lualine_b = { "branch", "diff", "diagnostics" },
          lualine_c = { { "filename", path = 2 } },
          lualine_x = { "encoding", "fileformat", "filetype" },
          lualine_y = { "progress" },
          lualine_z = { "location", "%b %B", "%h%m%r", "os.date()" },
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = { "filename" },
          lualine_x = { "location" },
          lualine_y = {},
          lualine_z = {},
        },
        tabline = {
          lualine_a = { { "buffers", mode = 2 } },
          lualine_b = {},
          lualine_c = {},
          lualine_x = {},
          lualine_y = {},
          lualine_z = {},
        },
        winbar = {},
        inactive_winbar = {},
        extensions = {},
      })
    end,
  },
  -- Bring in terminal whenever required using toggleterm.nvim
  {
    "akinsho/toggleterm.nvim",
    keys = {
      { "<C-\\>", "<cmd>ToggleTerm<CR>" },
      { "<leader>tr", "<cmd>ToggleTerm direction=vertical size=120<CR>" },
    },
    version = "*",
    config = function()
      require("toggleterm").setup({
        open_mapping = [[<C-\>]],
        hide_number = false,
        direction = "float",
        float_opts = {
          border = "curved",
        },
      })
    end,
  },
  -- vim.ui.select and vim.input changed to telescope
  {
    "stevearc/dressing.nvim",
    event = "VeryLazy",
  },
  -- show indentation using a vertical line
  {
    "lukas-reineke/indent-blankline.nvim",
    event = { "BufReadPre", "BufNewFile" },
    main = "ibl",
    opts = {},
  },
  -- show filesystem using neo-tree
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    keys = {
      { "<C-n>", "<cmd>Neotree float toggle<CR>" },
      { "<leader>fr", "<cmd>Neotree float reveal<CR>" },
      { "<leader>nt", "<cmd>Neotree left toggle<CR>" },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    config = function()
      require("neo-tree").setup({
        close_if_last_window = true,
        filesystem = {
          filtered_items = {
            visible = true,
            hide_dotfiles = false,
          },
          follow_current_file = {
            enabled = true,
          },
          use_libuv_file_watcher = true,
        },
      })
    end,
  },
  -- LSP Setup
  {
    "williamboman/mason.nvim",
    cmd = { "Mason", "MasonInstall", "MasonInstallAll", "MasonUpdate" },
    config = function()
      require("mason").setup({
        ui = {
          icons = {
            package_pending = " ",
            package_installed = "󰄳 ",
            package_uninstalled = "󰚌 ",
          },
        },

        max_concurrent_installers = 10,
      })

      local srv_options = {
        ensure_installed = {
          "lua-language-server",
          "stylua",
          "clangd",
          "clang-format",
          "haskell-language-server",
          "prettierd",
          "rust-analyzer",
          "taplo",
          "pyright",
          "black",
          "ruff",
        },
      }

      vim.api.nvim_create_user_command("MasonInstallAll", function()
        if srv_options.ensure_installed and #srv_options.ensure_installed > 0 then
          vim.cmd("MasonInstall " .. table.concat(srv_options.ensure_installed, " "))
        end
      end, {})

      vim.g.mason_binaries_list = srv_options.ensure_installed
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    config = true,
  },
  {
    "hrsh7th/cmp-nvim-lsp",
  },
  {
    "L3MON4D3/LuaSnip",
    version = "v2.*",
    -- build = "make install_jsregexp",
    dependencies = {
      "saadparwaiz1/cmp_luasnip", -- for autocompletion
      "rafamadriz/friendly-snippets", -- useful snippets
    },
  },
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-buffer", -- source for text in buffer
      "hrsh7th/cmp-path", -- source for file system paths
      "onsails/lspkind.nvim", -- vs-code like pictograms
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      local lspkind = require("lspkind")

      -- loads vscode style snippets from installed plugins (e.g. friendly-snippets)
      require("luasnip.loaders.from_vscode").lazy_load()

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-j>"] = cmp.mapping.select_next_item(), -- next suggestion
          ["<C-k>"] = cmp.mapping.select_prev_item(), -- previous suggestion
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" }, -- snippets
          { name = "buffer" }, -- text within the current buffer
          { name = "path" }, -- file system paths
        }),
        -- configure lspking for vs-code like pictograms in completion menu
        formatting = {
          format = lspkind.cmp_format({
            maxwidth = 50,
            ellipsis_char = "...",
          }),
        },
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    cmd = { "LspInfo", "LspInstall", "LspUninstall" },
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim"
    },
    config = function()
      local lspconfig = require("lspconfig")
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      lspconfig.lua_ls.setup({
        capabilities = capabilities,
        settings = {
          Lua = {
            workspace = {
              library = {
                [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
                ["${3rd}/luv/library"] = true,
                [vim.fn.stdpath("data") .. "/lazy/lazy.nvim/lua/lazy"] = true,
              },
              maxPreload = 100000,
              preloadFileSize = 10000,
            },
          },
        },
      })

      lspconfig.clangd.setup({
        capabilities = capabilities,
      })

      lspconfig.pyright.setup({
        capabilities = capabilities,
      })

      Map("n", "<leader>e", vim.diagnostic.open_float, { desc = "Open lsp diagnostics windows" })
      Map("n", "[d", vim.diagnostic.goto_prev, { desc = "Goto the previous lsp diagnostics" })
      Map("n", "]d", vim.diagnostic.goto_next, { desc = "Goto the next lsp diagnostics" })
      Map("n", "<leader>q", vim.diagnostic.setloclist, { desc = "LSP setloclist" })

      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = function(args)
          -- Enable completion triggered by <c-x><c-o> in Insert mode
          vim.bo[args.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

          -- Buffer local mappings.
          -- See `:help vim.lsp.*` for documentation on any of the below functions
          Map("n", "gD", vim.lsp.buf.declaration, { desc = "Goto lsp declaration", buffer = args.buf } )
          Map("n", "gd", vim.lsp.buf.definition, { desc = "Goto lsp definition", buffer = args.buf } )
          Map("n", "K", vim.lsp.buf.hover, { desc = "Display lsp info about the symbol", buffer = args.buf } )
          Map("n", "gi", vim.lsp.buf.implementation, { desc = "Goto lsp implementation of the symbol", buffer = args.buf } )
          Map("n", "gr", vim.lsp.buf.references, { desc = "Goto lsp references of the symbol", buffer = args.buf } )
          Map("n", "<C-k>", vim.lsp.buf.signature_help, { desc = "Show lsp help about the symbol", buffer = args.buf } )
          Map("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, { desc = "Add lsp workspace folder", buffer = args.buf } )
          Map("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, { desc = "Remove lsp workspace folder", buffer = args.buf } )
          Map("n", "<leader>wl", function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
          end, { desc = "List lsp workspace folders", buffer = args.buf } )
          Map("n", "<leader>D", vim.lsp.buf.type_definition, { desc = "Goto lsp type definition", buffer = args.buf } )
          Map("n", "<leader>rn", vim.lsp.buf.rename, { desc = "LSP Rename of the symbol", buffer = args.buf } )
          Map("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Display lsp code action", buffer = args.buf } )
          -- nnoremap('<leader>f', function()
          --   vim.lsp.buf.format { async = true }
          -- end, opts)
        end,
      })

      vim.fn.sign_define("DiagnosticSignError", { text = " ", texthl = "DiagnosticSignError" })
      vim.fn.sign_define("DiagnosticSignWarn",  { text = " ", texthl = "DiagnosticSignWarn"  })
      vim.fn.sign_define("DiagnosticSignInfo",  { text = " ", texthl = "DiagnosticSignInfo"  })
      vim.fn.sign_define("DiagnosticSignHint",  { text = "󰌵 ", texthl = "DiagnosticSignHint"  })
    end,
  },
  -- add autopairs to add automatic brackets, quotes, etc
  {
    "windwp/nvim-autopairs",
    event = { "InsertEnter" },
    dependencies = {
      "hrsh7th/nvim-cmp",
    },
    config = function()
      local autopairs = require("nvim-autopairs")
      autopairs.setup({
        check_ts = true, -- enable treesitter
        ts_config = {
          lua = { "string" }, -- don't add pairs in lua string treesitter nodes
          javascript = { "template_string" }, -- don't add pairs in javascript template_string treesiter nodes
          java = false, -- don't check treesitter on java
        },
      })

      local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      local cmp = require("cmp")

      cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
    end,
  },
}
