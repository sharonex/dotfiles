local overrides = require("custom.configs.overrides")

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
        dir="/Users/sharonavni/projects/nvim/git-mediate.nvim",
        config = function()
            require("git-mediate").setup()
        end,
        lazy=false
    },
    {
        "Sharonex/edit-list.nvim",
        config = function()
            require("edit-list").setup()
        end,
        lazy=false
    },
    -- {
    --     "github/copilot.vim",
    --     lazy = false,
    --     config = function()  -- Mapping tab is already used by NvChad
    --         vim.g.copilot_no_tab_map = true;
    --         vim.g.copilot_assume_mapped = true;
    --         vim.g.copilot_tab_fallback = "";
    --         -- The mapping is set to other key, see custom/lua/mappings
    --         -- or run <leader>ch to see copilot mapping section
    --     end
    -- },
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
        "Sharonex/grape.nvim",
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
    }
}

return plugins
