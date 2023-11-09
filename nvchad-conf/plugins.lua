local overrides = require("custom.configs.overrides")

-- Update this path
local extension_path = vim.env.HOME .. '/.vscode/extensions/vadimcn.vscode-lldb-1.10.0/'
local codelldb_path = extension_path .. 'adapter/codelldb'
local liblldb_path = extension_path .. 'lldb/lib/liblldb'
local this_os = vim.loop.os_uname().sysname;

-- The path in windows is different
if this_os:find "Windows" then
  codelldb_path = extension_path .. "adapter\\codelldb.exe"
  liblldb_path = extension_path .. "lldb\\bin\\liblldb.dll"
else
  -- The liblldb extension is .so for linux and .dylib for macOS
  liblldb_path = liblldb_path .. (this_os == "Linux" and ".so" or ".dylib")
end

---@type NvPluginSpec[]
local plugins = {

    -- Override plugin definition options
    --
    {
        "nvim-telescope/telescope.nvim",
        -- config = function()
        --     require("telescope").setup(require("custom.configs.telescope_grep_config"))
        -- end
    },
    {
        "neovim/nvim-lspconfig",
        config = function()
            require("plugins.configs.lspconfig")
            require("custom.configs.lspconfig")
        end, -- Override to setup mason-lspconfig
    },
    {
        "jose-elias-alvarez/null-ls.nvim",
        ft = {"go", "python"},
        config = function()
            require("custom.configs.null-ls")
        end,
    },
    -- override plugin configs
    {
        "williamboman/mason.nvim",
        opts = overrides.mason,
    },

    {
        "nvim-treesitter/nvim-treesitter",
        opts = overrides.treesitter,
    },

    {
        "nvim-tree/nvim-tree.lua",
        opts = overrides.nvimtree,
    },
    -- Install a plugin
    {
        "max397574/better-escape.nvim",
        event = "InsertEnter",
        config = function()
            require("better_escape").setup()
        end,
    },
    {
        "junegunn/fzf",
        lazy = false,
    },
    {
        "rbgrouleff/bclose.vim",
        lazy = false,
    },
    {
        "francoiscabrol/ranger.vim",
        lazy = false,
    },
    {
        "tpope/vim-surround",
        lazy = false,
    },
    {
        "kdheepak/lazygit.nvim",
        lazy = false,
    },
    {
        "aaronhallaert/advanced-git-search.nvim",
        lazy = false,
        config = function()
            -- optional: setup telescope before loading the extension
            require("telescope").setup({
                -- move this to the place where you call the telescope setup function
                extensions = {
                    advanced_git_search = {
                        -- fugitive or diffview
                        diff_plugin = "diffview",
                    },
                },
            })

            require("telescope").load_extension("advanced_git_search")
        end,
        dependencies = {
            { "sindrets/diffview.nvim", },
            { "tpope/vim-fugitive", },
            { "tpope/vim-rhubarb", },
        },
    },
    {
        "rmagatti/auto-session",
        lazy = false,
        config = function()
            require("auto-session").setup({
                log_level = "error",
                auto_session_suppress_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
            })
        end,
    },
    {
        "wellle/targets.vim",
        lazy = false,
    },
    {
        "mbbill/undotree",
        lazy = false,
    },
    {
        "mfussenegger/nvim-dap",
    },
    {
        "rcarriga/nvim-dap-ui",
        lazy = false,
    },
    {
        "simrat39/rust-tools.nvim",
        ft = "rust",
        dependencies = "neovim/nvim-lspconfig",
        opts = function()
            return require("custom.configs.rust-tools")
        end,
        config = function(_)
            require("rust-tools").setup({
                dap = {
                    adapter = require('rust-tools.dap').get_codelldb_adapter(
                        codelldb_path, liblldb_path)
                },
                tools = {
                    hover_actions = {
                        auto_focus = true,
                    },
                }
            })
        end,
    },
    {
        "rust-lang/rust.vim",
        ft = "rust",
        config = function()
            vim.g.rustfmt_autosave = 1
        end,
    },
    {
        "ThePrimeagen/refactoring.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
        },
        config = function()
            require("refactoring").setup()
        end,
        lazy = false,
    },
    {
        "christoomey/vim-tmux-navigator",
        lazy = false,
    },
    {
        'ThePrimeagen/harpoon',
        lazy = false
    },
    {
        "hrsh7th/nvim-cmp",
        opts = {
            sources = {
                { name = "nvim_lsp", group_index = 2 },
                { name = "luasnip",  group_index = 2 },
                { name = "buffer",   group_index = 2 },
                { name = "nvim_lua", group_index = 1 },
                { name = "path",     group_index = 2 },
            },
        },
    },
    {
        'skywind3000/asyncrun.vim',
        lazy = false,
    },
    {
        "mkotha/conflict3",
        lazy = false,
    },
    {
        "Sharonex/git-mediate.nvim",
        dependencies={"mkotha/conflict3", "skywind3000/asyncrun.vim"},
        config = function()
            require("git-mediate").setup()
        end,
        lazy = false,
    },
    {
        "zbirenbaum/copilot.lua",
        cmd = "Copilot",
        event = "InsertEnter",
        config = function()
            require("copilot").setup({
                panel = {
                    enabled = true,
                    auto_refresh = true,
                },
                suggestion = {
                    enabled = true,
                    auto_trigger = true,
                    accept = false, -- disable built-in keymapping
                },
            })
        end
    },
    {
        "ggandor/leap.nvim",
        lazy = false,
        config = function()
            require("leap").add_default_mappings()
            require('leap').add_repeat_mappings(';', ',', {
                relative_directions = true,
            })
        end
    },
    {
        "folke/trouble.nvim",
        lazy = false,
        dependencies = { "nvim-tree/nvim-web-devicons" },
        opts = {
            -- your configuration comes here
            -- or leave it empty to use the default settings
            -- refer to the configuration section below
        },
    },
    {
        'Wansmer/treesj',
        dependencies = { 'nvim-treesitter/nvim-treesitter' },
        config = function()
            require('treesj').setup({
                use_default_keymaps = true,
            })
        end,
        lazy = false,
    },
    {
        'lewis6991/spaceless.nvim',
        config = function()
            require'spaceless'.setup()
        end,
        lazy = false
    },
    {
        "nvim-telescope/telescope-frecency.nvim",
        config = function()
            require("telescope").load_extension "frecency"
        end,
    },
    {
        'windwp/nvim-autopairs',
        event = "InsertEnter",
        opts = {} -- this is equalent to setup({}) function
    },
    {
        'nvim-tree/nvim-web-devicons',
        lazy = false,
    },
    {
        'nvim-telescope/telescope-ui-select.nvim',
        lazy = false,
    },
    {
        "gbprod/substitute.nvim",
        config = function()
            require("substitute").setup({
                range = {
                    prefix = "g",
                }
            })
        end
    },
    {
        "f-person/git-blame.nvim",
        lazy = false,
    },
    {
        "fdschmidt93/telescope-egrepify.nvim",
        lazy = false,
        config = function()
            require "telescope".load_extension("egrepify")
        end
    },
    {
        "hashivim/vim-terraform",
        ft = "tf",
        lazy = false,
    },
    {
        "rouge8/neotest-rust",
        ft = "rust",
        dependencies = {
            "nvim-neotest/neotest",
            "nvim-lua/plenary.nvim",
        },
        config = function()
            require("neotest").setup({
                adapters = {
                    require("neotest-rust") {
                        args = {"--failure-output=immediate"}
                    }
                }
            })
        end,
    },
    {
        'nvimdev/lspsaga.nvim',
        config = function()
            require('lspsaga').setup({})
        end,
        lazy = false,
        dependencies = {
            'nvim-treesitter/nvim-treesitter',
            'nvim-tree/nvim-web-devicons',
        },
    }
}

return plugins
