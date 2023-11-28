local overrides = require("custom.configs.overrides")

-- Update this path
---@type NvPluginSpec[]
local plugins = {

    -- Override plugin definition options
    --
    {
        "nvim-telescope/telescope.nvim",
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
        "tpope/vim-surround",
        lazy = false,
    },
    {
        "kdheepak/lazygit.nvim",
        lazy = false,
    },
    {
        'tpope/vim-fugitive',
        lazy = false,
        -- doesn't work :(
        config = function ()
            local fugitiveMappings = vim.api.nvim_create_augroup('FugitiveMappings', { clear = true })

            -- Create an autocommand within that group
            vim.api.nvim_create_autocmd('FileType', {
                group = fugitiveMappings,
                pattern = 'fugitive',
                callback = function()
                    -- Your mappings or commands go here
                    vim.api.nvim_buf_set_keymap(0, 'n', 'o', '<CR>:Gedit', { noremap = true, silent = true })
                end,
            })
        end
    },
    {
        "aaronhallaert/advanced-git-search.nvim",
        lazy = false,
        config = function()
            -- optional: setup telescope before loading the extension
            require("telescope").load_extension("advanced_git_search")
        end,
        dependencies = {
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
        config = function(_, opts)
            require("rust-tools").setup(opts)
        end,
    },
    {
        "rust-lang/rust.vim",
        ft = "rust",
        config = function()
            vim.g.rustfmt_command = 'rustfmt +nightly-2023-11-18'
            vim.g.rustfmt_autosave = 1
        end,
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
            -- require('leap').add_repeat_mappings(';', ',', {
            --     relative_directions = true,
            -- })
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
        'lewis6991/spaceless.nvim',
        config = function()
            require'spaceless'.setup()
        end,
        lazy = false
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
                        args = {"--failure-output=immediate",
                                -- "--nocapture",
                        }
                    }
                }
            })
        end,
    },
    {
        "jackMort/ChatGPT.nvim",
        lazy = false,
        config = function()
            require("chatgpt").setup()
        end,
        dependencies = {
            "MunifTanjim/nui.nvim",
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope.nvim"
        }
    },
    {
        'Wansmer/sibling-swap.nvim',
        requires = { 'nvim-treesitter' },
        lazy = false,
        config = function()
            require('sibling-swap').setup({
                enable_default_keymaps = false,
            })
        end,
    },
    {
        'akinsho/git-conflict.nvim',
        config = true,
        lazy = false,
    },
    {
        "kevinhwang91/nvim-bqf",
        lazy = false,
    },
    {
        'lewis6991/gitsigns.nvim',
        lazy = false,
    },
    {
        'weilbith/nvim-code-action-menu',
        lazy = false,
        config = function()
            vim.g.code_action_menu_show_action_kind = false
            vim.g.code_action_menu_show_details = false
        end
    },
    {
        'unblevable/quick-scope',
        lazy = false,
        config = function()
            vim.cmd [[
              highlight QuickScopePrimary guifg='#af0f5f' gui=underline ctermfg=155 cterm=underline
              highlight QuickScopeSecondary guifg='#5000ff' gui=underline ctermfg=81 cterm=underline
            ]]

        end
    },
}

return plugins
