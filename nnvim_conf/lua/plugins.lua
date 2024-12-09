-- [[ Install `lazy.nvim` plugin manager ]]
--    https://github.com/folke/lazy.nvim
--    `:help lazy.nvim.txt` for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system {
        'git',
        'clone',
        '--filter=blob:none',
        'https://github.com/folke/lazy.nvim.git',
        '--branch=stable', -- latest stable release
        lazypath,
    }
end
vim.opt.rtp:prepend(lazypath)

-- [[ Configure plugins ]]
-- NOTE: Here is where you install your plugins.
--  You can configure plugins using the `config` key.
--
--  You can also configure plugins after the setup call,
--    as they will be available in your neovim runtime.
require('lazy').setup({
    -- NOTE: First, some plugins that don't require any configuration

    -- Detect tabstop and shiftwidth automatically
    'tpope/vim-sleuth',

    {
        'williamboman/mason.nvim',
        dependencies = { 'williamboman/mason-lspconfig.nvim' },
        opts = {
            ensure_installed = {
                'typescript-language-server',
                'tailwindcss-language-server',
                'eslint-lsp',
                'prettierd',
            }
        },
        config = function()
            require('mason').setup()
            require('mason-lspconfig').setup()
            -- Never format with tsserver
            vim.lsp.buf.format {
                filter = function(client)
                    print(client.name)
                    return client.name ~= "tsserver" or client.name ~= "ts_ls"
                end
            }
        end
    },

    -- NOTE: This is where your plugins related to LSP can be installed.
    --  The configuration is done below. Search for lspconfig to find it below.
    {
        -- LSP Configuration & Plugins
        'neovim/nvim-lspconfig',
        dependencies = {
            -- Automatically install LSPs to stdpath for neovim
            'williamboman/mason.nvim',
            'williamboman/mason-lspconfig.nvim',
            'saghen/blink.cmp',

            -- Useful status updates for LSP
            -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
            { 'j-hui/fidget.nvim', opts = {} },

            -- Additional lua configuration, makes nvim stuff amazing!
            'folke/neodev.nvim',
        },
        config = function()
            require("configs.lspconfig")
        end,
    },
    {
        'saghen/blink.cmp',
        lazy = false, -- lazy loading handled internally
        -- optional: provides snippets for the snippet source
        -- dependencies = 'rafamadriz/friendly-snippets',

        -- use a release tag to download pre-built binaries
        version = 'v0.*',
        -- OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
        -- build = 'cargo build --release',
        -- If you use nix, you can build from source using latest nightly rust with:
        -- build = 'nix run .#build-plugin',

        ---@module 'blink.cmp'
        ---@type blink.cmp.Config
        opts = {
            -- 'default' for mappings similar to built-in completion
            -- 'super-tab' for mappings similar to vscode (tab to accept, arrow keys to navigate)
            -- 'enter' for mappings similar to 'super-tab' but with 'enter' to accept
            -- see the "default configuration" section below for full documentation on how to define
            -- your own keymap.
            keymap = { preset = 'enter' },

            appearance = {
                -- Sets the fallback highlight groups to nvim-cmp's highlight groups
                -- Useful for when your theme doesn't support blink.cmp
                -- will be removed in a future release
                use_nvim_cmp_as_default = true,
                -- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
                -- Adjusts spacing to ensure icons are aligned
                nerd_font_variant = 'mono'
            },

            -- default list of enabled providers defined so that you can extend it
            -- elsewhere in your config, without redefining it, via `opts_extend`
            sources = {
                completion = {
                    enabled_providers = { 'lsp', 'path', 'snippets', 'buffer' },
                },
            },

            -- experimental auto-brackets support
            -- completion = { accept = { auto_brackets = { enabled = true } } }

            -- experimental signature help support
            -- signature = { enabled = true }
        },
        -- allows extending the enabled_providers array elsewhere in your config
        -- without having to redefine it
        opts_extend = { "sources.completion.enabled_providers" }
    },

    -- Useful plugin to show you pending keybinds.
    { 'folke/which-key.nvim', opts = {} },
    {
        -- Adds git related signs to the gutter, as well as utilities for managing changes
        'lewis6991/gitsigns.nvim',
        opts = {
            -- See `:help gitsigns.txt`
            -- signs = {
            --     add = { text = '+' },
            --     change = { text = '~' },
            --     delete = { text = '_' },
            --     topdelete = { text = '‾' },
            --     changedelete = { text = '~' },
            -- },
            sign_priority = 100,
            on_attach = function(bufnr)
                -- don't override the built-in and fugitive keymaps
                local gs = package.loaded.gitsigns
                vim.keymap.set({ 'n', 'v' }, ']c', function()
                    if vim.wo.diff then
                        return ']c'
                    end
                    vim.schedule(function()
                        gs.next_hunk()
                    end)
                    return '<Ignore>'
                end, { expr = true, buffer = bufnr, desc = 'Jump to next hunk' })
                vim.keymap.set({ 'n', 'v' }, '[c', function()
                    if vim.wo.diff then
                        return '[c'
                    end
                    vim.schedule(function()
                        gs.prev_hunk()
                    end)
                    return '<Ignore>'
                end, { expr = true, buffer = bufnr, desc = 'Jump to previous hunk' })

                vim.keymap.set({ "n", "v" }, "<leader>gs", ":Gitsigns stage_hunk<CR>", { desc = "[G]it [S]tage hunk" })
                vim.keymap.set({ "n", "v" }, "<leader>gu", ":Gitsigns reset_hunk<CR>", { desc = "[G]it [U]ndo hunk" })
                vim.keymap.set("n", "<leader>gp", ":Gitsigns preview_hunk<CR>", { desc = "[G]it [p]op hunk diff" })
                vim.keymap.set("n", "]g", ": Gitsigns next_hunk<CR>", { desc = "next git hunk" })
                vim.keymap.set("n", "[g", ": Gitsigns prev_hunk<CR>", { desc = "prev git hunk" })
            end,
        },
    },
    {
        -- Add indentation guides even on blank lines
        'lukas-reineke/indent-blankline.nvim',
        -- Enable `lukas-reineke/indent-blankline.nvim`
        -- See `:help ibl`
        main = 'ibl',
        opts = {},
    },
    -- Fuzzy Finder (files, lsp, etc)
    {
        'nvim-telescope/telescope.nvim',
        branch = '0.1.x',
        dependencies = {
            'nvim-lua/plenary.nvim',
            -- Fuzzy Finder Algorithm which requires local dependencies to be built.
            -- Only load if `make` is available. Make sure you have the system
            -- requirements installed.
            {
                'nvim-telescope/telescope-fzf-native.nvim',
                -- NOTE: If you are having trouble with this installation,
                --       refer to the README for telescope-fzf-native for more instructions.
                build = 'make',
                cond = function()
                    return vim.fn.executable 'make' == 1
                end,
            },
        },
        config = function()
            -- Enable telescope fzf native, if installed
            pcall(require('telescope').load_extension, 'fzf')
            require('telescope').setup {
                defaults = {
                    path_display = { "full" }
                },
            }

            local egrepify_with_text = function()
                -- if in visual mode
                if vim.fn.mode() == "v" then
                    -- yank the highlighted text into register z
                    vim.cmd('normal! "zy')

                    -- get the content of register z
                    local search_term = vim.fn.getreg("z")
                    require("telescope").extensions.egrepify.egrepify({ default_text = search_term })
                else
                    -- yank current word under cursor
                    local current_word =
                        require("telescope").extensions.egrepify.egrepify({ default_text = vim.fn.expand("<cword>") })
                end
            end

            vim.keymap.set(
                "n",
                "<leader>/",
                function()
                    -- You can pass additional configuration to telescope to change theme, layout, etc.
                    require("telescope.builtin").current_buffer_fuzzy_find(
                        require("telescope.themes").get_dropdown {
                            winblend = 10,
                            previewer = false
                        }
                    )
                end,
                { desc = "[/] Fuzzily search in current buffer" }
            )
            vim.keymap.set("n", "<leader>?", require("telescope.builtin").oldfiles,
                { desc = "[?] Find recently opened files" })
            vim.keymap.set("n", "<leader>f", require("telescope.builtin").git_files, { desc = "[F]ind (Git) Files" })
            vim.keymap.set("n", "<leader>sf", require("telescope.builtin").find_files, { desc = "[S]earch [F]iles" })
            vim.keymap.set("n", "<leader>sh", require("telescope.builtin").help_tags, { desc = "[S]earch [H]elp" })
            -- vim.keymap.set("n", "<leader>sr", require("telescope").extensions.project.project, { desc = "[S]earch [R]epo" })
            vim.keymap.set("n", "<leader>sl", require("telescope.builtin").resume, { desc = "[S]earch [L]ast again" })
            vim.keymap.set("n", "<leader>sp", "<cmd> Telescope egrepify<CR>", { desc = "Find in files" })
            vim.keymap.set({ "n", "v" }, "<leader>sP", egrepify_with_text, { desc = "Find current word in files" })
            vim.keymap.set("v", "<leader>sp", egrepify_with_text, { desc = "Find selection in files" })
            vim.keymap.set({ "n", "v" }, "<leader>sT", require("telescope.builtin").live_grep,
                { desc = "Find current word in files" })
            vim.keymap.set("v", "<leader>sp", egrepify_with_text, { desc = "Find selection in files" })
            -- vim.keymap.set("n", "<leader>ss", "<cmd> Telescope current_buffer_fuzzy_find <CR>", { desc = "Find in current file" })
            vim.keymap.set("n", "<leader>sc", "<cmd> Telescope commands <CR>", { desc = "Find vim commands" })
            vim.keymap.set("n", "<leader>sk", "<cmd> Telescope keymaps <CR>", { desc = "Look up key mappings" })
            vim.keymap.set("n", "<leader>b", function()
                require("telescope.builtin").buffers(
                    require('telescope.themes').get_dropdown({
                        sort_mru = true,
                        ignore_current_buffer = true,
                        sort_lastused = true,
                        only_cwd = true, -- Only show buffers in the current working directory
                        show_all_buffers = false,
                        winblend = 10,
                    })
                )
            end, { desc = "Open buffers" })
        end
    },
    {
        'nvim-tree/nvim-tree.lua',
        lazy = false,
        config = function()
            require("nvim-tree").setup({
                view = {
                    width = 50,
                },
            })

            vim.keymap.set("n", "<C-q>", ":NvimTreeFindFileToggle<CR>", { desc = "Toggle nvim tree" })
        end
    },
    {
        "chrisgrieser/nvim-lsp-endhints",
        event = "LspAttach",
        opts = {}, -- required, even if empty
        config = function()
            require("lsp-endhints").setup()
        end
    },
    {
        -- Highlight, edit, and navigate code
        'nvim-treesitter/nvim-treesitter',
        dependencies = {
            'nvim-treesitter/nvim-treesitter-textobjects',
        },
        build = ':TSUpdate',
        config = function()
            require('nvim-treesitter.configs').setup {
                -- Add languages to be installed here that you want installed for treesitter
                ensure_installed = { 'c', 'cpp', 'go', 'lua', 'python', 'rust', 'tsx', 'javascript', 'typescript', 'vimdoc', 'vim', 'bash' },

                -- Autoinstall languages that are not installed. Defaults to false (but you can change for yourself!)
                auto_install = false,

                highlight = { enable = true },
                indent = { enable = true },
                incremental_selection = {
                    enable = true,
                    keymaps = {
                        init_selection = '<s-space>',
                        scope_incremental = '<CR>',
                        node_incremental = '<TAB>',
                        node_decremental = '<S-TAB>',
                    },
                },
                textobjects = {
                    select = {
                        enable = true,
                        lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
                        keymaps = {
                            -- You can use the capture groups defined in textobjects.scm
                            ['aa'] = '@parameter.outer',
                            ['ia'] = '@parameter.inner',
                            ['af'] = '@function.outer',
                            ['if'] = '@function.inner',
                            ['ac'] = '@class.outer',
                            ['ic'] = '@class.inner',
                            ['al'] = '@statement.outer',
                            ['il'] = '@statement.outer',
                        },
                    },
                    move = {
                        enable = true,
                        set_jumps = true, -- whether to set jumps in the jumplist
                        goto_next_start = {
                            [']m'] = '@function.outer',
                            [']]'] = '@class.outer',
                            [']l'] = '@statement.outer',
                        },
                        goto_next_end = {
                            [']M'] = '@function.outer',
                            [']['] = '@class.outer',
                        },
                        goto_previous_start = {
                            ['[m'] = '@function.outer',
                            ['[l'] = '@statement.outer',
                            ['[['] = '@class.outer',
                        },
                        goto_previous_end = {
                            ['[M'] = '@function.outer',
                            ['[]'] = '@class.outer',
                        },
                    },
                    swap = {
                        enable = true,
                        swap_next = {
                            ['<leader>a'] = '@parameter.inner',
                        },
                        swap_previous = {
                            ['<leader>A'] = '@parameter.inner',
                        },
                    },
                },
            }
        end
    },

    -- sharon configs
    {
        "kylechui/nvim-surround",
        version = "*", -- Use for stability; omit to use `main` branch for the latest features
        event = "VeryLazy",
        config = function()
            local build_common_surround = function(object_name, opener, closer)
                return {
                    add = function()
                        return { { object_name .. opener }, { closer } }
                    end,
                    find = function()
                        local config = require("nvim-surround.config")
                        return config.get_selection({ node = "generic_type" })
                    end,
                    delete = "^(" .. object_name .. opener .. ")().-(" .. closer .. ")()$",
                    change = {
                        target = "^(" .. object_name .. opener .. ")().-(" .. closer .. ")()$"
                        -- replacement = function()
                        --     local config = require("nvim-surround.config")
                        --     local result = config.get_input("Enter the new type: ")
                        --     if result then
                        --         return { { result .. opener }, { closer } }
                        --     end
                        -- end,
                    }
                }
            end
            require("nvim-surround").setup({
                surrounds = {
                    ["R"] = build_common_surround("anyhow::Result", "<", ">"),
                    ["V"] = build_common_surround("Vec", "<", ">"),
                    ["O"] = build_common_surround("Option", "<", ">"),
                    ["S"] = build_common_surround("Some", "(", ")"),
                    -- ["S"] = {
                    --     add = function()
                    --         return { { "Some(" }, { ")" } }
                    --     end,
                    -- },
                    ["K"] = {
                        add = function()
                            return { { "Ok(" }, { ")" } }
                        end,
                    },
                    -- "generic"
                    ["g"] = {
                        add = function()
                            local config = require("nvim-surround.config")
                            local result = config.get_input("Enter the generic name: ")
                            if result then
                                return { { result .. "<" }, { ">" } }
                            end
                        end,
                        find = function()
                            local config = require("nvim-surround.config")
                            return config.get_selection({ node = "generic_type" })
                        end,
                        delete = "^(.-<)().-(>)()$",
                        change = {
                            target = "^(.-<)().-(>)()$",
                            replacement = function()
                                local config = require("nvim-surround.config")
                                local result = config.get_input("Enter the generic name: ")
                                if result then
                                    return { { result .. "<" }, { ">" } }
                                end
                            end,
                        }
                    }
                }
            })
        end
    },
    {
        'tpope/vim-fugitive',
        lazy = false,
        config = function()
            vim.keymap.set("n", "<leader>gB", "<cmd> Git blame<CR>", { desc = "Run [G]it [B]lame on file" })
            vim.keymap.set("n", "<leader>gf", ":Git<CR>/taged<CR>:noh<CR>j", { desc = "[G]it [F]ugitive" })
        end
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
        "mbbill/undotree",
        lazy = false,
        config = function()
            vim.keymap.set("n", "<leader>u", "<cmd>UndotreeToggle<CR><cmd>UndotreeFocus<CR>",
                { desc = "Toggle UndoTree" })
        end
    },
    {
        'mrjones2014/smart-splits.nvim',
        config = function()
            require('smart-splits').setup()
            -- Tmux window navigation
            vim.keymap.set('n', '<A-h>', require('smart-splits').resize_left)
            vim.keymap.set('n', '<A-j>', require('smart-splits').resize_down)
            vim.keymap.set('n', '<A-k>', require('smart-splits').resize_up)
            vim.keymap.set('n', '<A-l>', require('smart-splits').resize_right)
            -- moving between splits
            vim.keymap.set('n', '<C-h>', require('smart-splits').move_cursor_left)
            vim.keymap.set('n', '<C-j>', require('smart-splits').move_cursor_down)
            vim.keymap.set('n', '<C-k>', require('smart-splits').move_cursor_up)
            vim.keymap.set('n', '<C-l>', require('smart-splits').move_cursor_right)
            -- swapping buffers between windows
            vim.keymap.set('n', '<leader><leader>h', require('smart-splits').swap_buf_left)
            vim.keymap.set('n', '<leader><leader>j', require('smart-splits').swap_buf_down)
            vim.keymap.set('n', '<leader><leader>k', require('smart-splits').swap_buf_up)
            vim.keymap.set('n', '<leader><leader>l', require('smart-splits').swap_buf_right)
        end,
    },
    {
        "gbprod/yanky.nvim",
        dependencies = {
            { "kkharji/sqlite.lua" }
        },
        opts = {
            ring = { storage = "sqlite" },
        },
        config = function()
            vim.keymap.set({ "n", "x" }, "<leader>y",
                function() require("telescope").extensions.yank_history.yank_history({}) end,
                { desc = "Open Yank History" })
        end,
        lazy = false,
    },
    {
        'ThePrimeagen/harpoon',
        branch = "master",
        dependencies = {
            'nvim-lua/plenary.nvim',
        },
        config = function()
            -- Harpoon 2
            -- local harpoon = require("harpoon")
            -- vim.keymap.set("n", "<leader>ha", function() harpoon:list():append() end)
            -- vim.keymap.set("n", "<leader>hm", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)
            --
            -- vim.keymap.set("n", "<leader>1", function() harpoon:list():select(1) end)
            -- vim.keymap.set("n", "<leader>2", function() harpoon:list():select(2) end)
            -- vim.keymap.set("n", "<leader>3", function() harpoon:list():select(3) end)
            -- vim.keymap.set("n", "<leader>4", function() harpoon:list():select(4) end)

            vim.keymap.set("n", "<leader>ha", function() require("harpoon.mark").add_file() end)
            vim.keymap.set("n", "<leader>hm", function() require("harpoon.ui").toggle_quick_menu() end)

            vim.keymap.set("n", "<leader>1", function() require("harpoon.ui").nav_file(1) end)
            vim.keymap.set("n", "<leader>2", function() require("harpoon.ui").nav_file(2) end)
            vim.keymap.set("n", "<leader>3", function() require("harpoon.ui").nav_file(3) end)
            vim.keymap.set("n", "<leader>4", function() require("harpoon.ui").nav_file(4) end)
            vim.keymap.set("n", "<leader>5", function() require("harpoon.ui").nav_file(5) end)
            vim.keymap.set("n", "<leader>6", function() require("harpoon.ui").nav_file(6) end)
        end
    },
    {
        dir = "/Users/sharonavni/personal/git-mediate.nvim",
        dependencies = { "skywind3000/asyncrun.vim" },
        config = function()
            require("git-mediate").setup()
            vim.keymap.set("n", "<leader>g[", ":GitMediate<CR>", { desc = "Run git mediate conflict resolver" })
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
            use_diagnostic_signs = false -- enabling this will use the signs defined in your lsp client
        },
        keys = {
            {
                "<leader>ld",
                "<cmd>Trouble diagnostics toggle pinned=false filter.buf=0<cr>",
                desc = "Document diagnostics"
            },
            {
                "<leader>lw",
                "<cmd>Trouble diagnostics toggle pinned=false<cr>",
                desc = "Workspace diagnostics"
            },
            {
                "<leader>ls",
                "<cmd>Trouble symbols toggle<cr>",
                desc = "Document [S]ymbols"
            },
            {
                "<leader>qf",
                "<cmd>Trouble qflist toggle<cr>",
                desc = "Open [Q]uick[f]ix"
            }
        },
    },
    {
        "windwp/nvim-autopairs",
        opts = {
            fast_wrap = {},
            disable_filetype = { "TelescopePrompt", "vim" },
        },
        config = function(_, opts)
            require("nvim-autopairs").setup(opts)
            --
            -- -- setup cmp for autopairs
            -- local cmp_autopairs = require "nvim-autopairs.completion.cmp"
            -- require("cmp").event:on("confirm_done", cmp_autopairs.on_confirm_done())
        end,
    },
    {
        'lewis6991/spaceless.nvim',
        config = function()
            require 'spaceless'.setup()
        end,
        lazy = false
    },
    {
        "gbprod/substitute.nvim",
        config = function()
            require("substitute").setup({
                range = {
                    prefix = "g",
                }
            })
            -- Exchange
            vim.keymap.set("n", "gx", "<cmd>lua require('substitute.exchange').operator()<cr>", { desc = "" })
            vim.keymap.set("v", "gx", "<cmd>lua require('substitute.exchange').visual()<cr>", { desc = "" })
            vim.keymap.set("n", "gp", "<cmd>lua require('substitute').operator()<cr>", { desc = "" })
            vim.keymap.set("n", "gP", "<cmd>lua require('substitute').eol()<cr>", { desc = "" })
        end
    },
    {
        "tpope/vim-rsi",
        lazy = false,
    },
    {
        "fdschmidt93/telescope-egrepify.nvim",
        lazy = false,
        config = function()
            local egrep_actions = require "telescope._extensions.egrepify.actions"
            require("telescope").setup {
                extensions = {
                    egrepify = {
                        attach_mappings = false,
                        -- default mappings
                        mappings = {
                            i = {
                                -- toggle prefixes, prefixes is default
                                ["<C-z>"] = egrep_actions.toggle_prefixes,
                                -- toggle AND, AND is default, AND matches tokens and any chars in between
                                ["<C-&>"] = egrep_actions.toggle_and,
                                -- toggle permutations, permutations of tokens is opt-in
                                ["<C-r>"] = egrep_actions.toggle_permutations,
                                ["<C-a>"] = false,
                            },
                        },
                    },
                },
            }

            require "telescope".load_extension("egrepify")
        end
    },
    {
        'aznhe21/actions-preview.nvim',
        lazy = false,
    },
    {
        'windwp/nvim-ts-autotag',
        ft = { "html", "javascript", "javascriptreact", "typescript", "typescriptreact", "svelte", "vue" },
        config = function()
            require('nvim-ts-autotag').setup()
        end
    },
    {
        "stevearc/oil.nvim",
        lazy = false,
        config = function()
            require("oil").setup()
            vim.keymap.set("n", "|", "<CMD>Oil<CR>", { desc = "Open parent directory" })
        end,
    },
    {
        'sindrets/diffview.nvim',
        event = "VeryLazy",
        config = function()
            vim.keymap.set("n", "<leader>gd", ":DiffviewOpen<CR>", { desc = "[G]it [D]iff" })
        end
    },
    {
        'navarasu/onedark.nvim',
        lazy = false,
        config = function()
            require('onedark').setup {
                -- Main options --
                style = 'deep',               -- Default theme style. Choose between 'dark', 'darker', 'cool', 'deep', 'warm', 'warmer' and 'light'
                transparent = false,          -- Show/hide background
                term_colors = true,           -- Change terminal color as per the selected theme style
                ending_tildes = false,        -- Show the end-of-buffer tildes. By default they are hidden
                cmp_itemkind_reverse = false, -- reverse item kind highlights in cmp menu

                -- toggle theme style ---
                toggle_style_key = "<leader>tx",
            }
            vim.cmd("colorscheme onedark")
        end
    },
    {
        "folke/snacks.nvim",
        priority = 1000,
        lazy = false,
        opts = require("configs.snacks"),
        keys = {
            -- { "<leader>.",  function() Snacks.scratch() end,          desc = "Toggle Scratch Buffer" },
            -- { "<leader>S",  function() Snacks.scratch.select() end,   desc = "Select Scratch Buffer" },
            -- { "<leader>n",  function() Snacks.notifier.show_history() end, desc = "Notification History" },
            { "<leader>Bd", function() Snacks.bufdelete() end,        desc = "Delete Buffer" },
            { "<leader>gh", function() Snacks.lazygit.log_file() end, desc = "Lazygit Current File History" },
            { "<leader>gg", function() Snacks.lazygit() end,          desc = "Lazygit" },
            { "<leader>gl", function() Snacks.lazygit.log() end,      desc = "Lazygit Log (cwd)" },
            { "<leader>un", function() Snacks.notifier.hide() end,    desc = "Dismiss All Notifications" },
        },
    },
    {
        "mg979/vim-visual-multi",
        branch = "master",
        config = function()
            vim.cmd [[
                VMTheme codedark
            ]]
        end,
    },
    {
        "nvim-neorg/neorg",
        lazy = false,  -- Disable lazy loading as some `lazy.nvim` distributions set `lazy = true` by default
        version = "*", -- Pin Neorg to the latest stable release
        -- config = {
        --     vim.keymap.set("n", "<leader>n", ":Neorg<CR>", { desc = "Open Neorg" })
        -- }
        -- config = true,
        config = function()
            require("neorg").setup {
                load = {
                    ["core.defaults"] = {},
                    ["core.concealer"] = {},
                    ["core.syntax"] = {},
                    ["core.summary"] = {},
                    ["core.dirman"] = {
                        config = {
                            workspaces = {
                                notes = "~/notes",
                            },
                            default_workspace = "notes",
                        },
                    },
                },
            }

            vim.wo.foldlevel = 99
            vim.wo.conceallevel = 2

            vim.keymap.set("n", "<leader>njt", ":Neorg journal today<CR>", { desc = "Neorg Journal Today" })
            vim.keymap.set("n", "<leader>njy", ":Neorg journal yesterday<CR>", { desc = "Neorg Journal Yesterday" })
            vim.keymap.set("n", "<leader><CR>", "<Plug>(neorg.esupports.hop.hop-link)", { desc = "Follow link" })
        end,
    },
    -- {
    --     "ggandor/flit.nvim",
    --     lazy = false,
    --     config = function()
    --         require('flit').setup {
    --             keys = { f = 'f', F = 'F', t = 't', T = 'T' },
    --             -- A string like "nv", "nvo", "o", etc.
    --             labeled_modes = "v",
    --             -- Repeat with the trigger key itself.
    --             clever_repeat = true,
    --             multiline = true,
    --             -- Like `leap`s similar argument (call-specific overrides).
    --             -- E.g.: opts = { equivalence_classes = {} }
    --             opts = {}
    --         }
    --     end
    -- },
    -- {
    --     -- Set lualine as statusline
    --     'nvim-lualine/lualine.nvim',
    --     -- See `:help lualine.txt`
    --     config = function()
    --         require('lualine').setup({
    --             sections = {
    --                 lualine_c = { { 'filename', path = 1 } }
    --             },
    --         })
    --     end,
    -- },
    -- {
    --     'rcarriga/nvim-dap-ui',
    --     lazy = false,
    --     dependencies = { 'mfussenegger/nvim-dap', 'nvim-neotest/nvim-nio' },
    --     config = function()
    --         require('dapui').setup()
    --         local dap, dapui = require("dap"), require("dapui")
    --         dap.listeners.before.attach.dapui_config = function()
    --             dapui.open()
    --         end
    --         dap.listeners.before.launch.dapui_config = function()
    --             dapui.open()
    --         end
    --         dap.listeners.before.event_terminated.dapui_config = function()
    --             dapui.close()
    --         end
    --         dap.listeners.before.event_exited.dapui_config = function()
    --             dapui.close()
    --         end
    --
    --         vim.keymap.set("n", "<leader>dt", "<cmd>DapToggleBreakpoint<CR>", { desc = "[D]ebug [T]oggle Breakpoint" })
    --         vim.keymap.set("n", "<leader>do", "<cmd>DapStepOver<CR>", { desc = "[D]ebug [O]ver" })
    --         vim.keymap.set("n", "<leader>di", "<cmd>DapStepInto<CR>", { desc = "[D]ebug [I]nto" })
    --         vim.keymap.set("n", "<leader>dc", "<cmd>DapContinue<CR>", { desc = "[D]ebug [C]ontinue" })
    --         vim.keymap.set("n", "<leader>dx", "<cmd>DapTerminate<CR>", { desc = "[D]ebug [X]it" })
    --         vim.keymap.set("n", "<leader>dx", "<cmd>DapTerminate<CR>", { desc = "[D]ebug [X]it" })
    --     end
    -- },
    -- {
    --     "johmsalas/text-case.nvim",
    --     lazy = false,
    --     config = function()
    --         require('textcase').setup {}
    --     end
    -- },
    -- {
    --     'unblevable/quick-scope',
    --     config = function()
    --         vim.cmd [[
    --           highlight QuickScopePrimary guifg='#af0f5f' gui=underline ctermfg=155 cterm=underline
    --           highlight QuickScopeSecondary guifg='#5000ff' gui=underline ctermfg=81 cterm=underline
    --           ]]
    --     end,
    -- },
    {
        "kevinhwang91/nvim-bqf",
        lazy = false,
    },
    -- {
    --     "ggandor/leap-spooky.nvim",
    --     lazy = false,
    --     config = function()
    --         require('leap-spooky').setup {
    --         }
    --     end
    -- },
    -- Rustacenvim config from appelgriebsch/Nv
    -- {
    --     "mrcjkb/rustaceanvim",
    --     ft = { "rust" },
    --     config = function()
    --         local codelldb = require('mason-registry').get_package('codelldb')
    --         local extension_path = codelldb:get_install_path() .. '/extension/'
    --         local codelldb_path = extension_path .. 'adapter/codelldb'
    --         local liblldb_path = extension_path .. 'lldb/lib/liblldb.dylib'
    --
    --         local cfg = require('rustaceanvim.config')
    --         vim.g.rustaceanvim = {
    --             server = {
    --                 on_attach = function(_, _)
    --                     vim.lsp.inlay_hint.enable()
    --                 end,
    --                 default_settings = {
    --                     -- rust-analyzer language server configuration
    --                     ['rust-analyzer'] = {
    --                         checkOnSave = {
    --                             enable = true,
    --                             command = "check",
    --                             -- Disable running tests automatically
    --                             allTargets = false,
    --
    --                             -- extraArgs = { "--no-deps" },
    --                         },
    --                         check = {
    --                             workspace = false
    --                         },
    --                         -- Disable automatic running of tests
    --                         cargo = {
    --                             autoreload = false,
    --                             runBuildScripts = false,
    --                         },
    --                     },
    --                 },
    --             },
    --             dap = {
    --                 adapter = cfg.get_codelldb_adapter(codelldb_path, liblldb_path),
    --             },
    --         }
    --         vim.keymap.set("n", "<leader>re", "<cmd>RustLsp expandMacro<CR>", { desc = "[R]ust expand macro" })
    --         vim.keymap.set("n", "<leader>rc", "<cmd>RustLsp openCargo<CR>", { desc = "[R]ust open cargo" })
    --         vim.keymap.set("n", "<leader>rp", "<cmd>RustLsp parentModule<CR>", { desc = "[R]ust open parent module" })
    --         vim.keymap.set("n", "<leader>rr", "<cmd>RustLsp reloadWorkspace<CR>", { desc = "[R]ust [R]estart" })
    --         vim.keymap.set("n", "<leader>rd", "<cmd>RustLsp renderDiagnostic <CR>", { desc = "[R]ust [D]iagnostics" })
    --     end
    -- },
    -- {
    --     'ibhagwan/fzf-lua',
    --     lazy = false,
    --     config = function()
    --         -- require 'fzf-lua'.setup {
    --         --     winopts = {
    --         --         split = "belowright new",
    --         --         height = 0.4
    --         --     }
    --         -- }
    --     end
    --
    -- },
    -- {
    --     'stevearc/conform.nvim',
    --     opts = {},
    --     config = function()
    --         return {
    --             "stevearc/conform.nvim",
    --             event = { "BufReadPre", "BufNewFile" },
    --             config = function()
    --                 local conf = require("conform")
    --
    --                 conf.setup({
    --                     log_level = vim.log.levels.DEBUG,
    --                     formatters_by_ft = {
    --                         lua = { "stylua" },
    --                         rust = { "rustfmt" },
    --                         typescript = { { "prettierd", "prettier", stop_after_first = true } },
    --                         typescriptreact = { { "prettierd", "prettier", stop_after_first = true } },
    --                         javascript = { { "prettierd", "prettier", stop_after_first = true } },
    --                         javascriptreact = { { "prettierd", "prettier", stop_after_first = true } },
    --
    --                         ["*"] = { "codespell", "trim_whitespace" },
    --                         -- Use the "_" filetype to run formatters on filetypes that don't
    --                         -- have other formatters configured.
    --                         ["_"] = { "trim_whitespace" },
    --                     },
    --                 })
    --
    --                 vim.api.nvim_create_autocmd('FileType', {
    --                     pattern = vim.tbl_keys(require('conform').formatters_by_ft),
    --                     group = vim.api.nvim_create_augroup('conform_formatexpr', { clear = true }),
    --                     callback = function() vim.opt_local.formatexpr = 'v:lua.require("conform").formatexpr()' end,
    --                 })
    --                 vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
    --                 vim.g.auto_conform_on_save = true
    --                 vim.api.nvim_create_autocmd('BufWritePre', {
    --                     pattern = '*',
    --                     callback = function(args)
    --                         if vim.g.auto_conform_on_save then require('conform').format({ bufnr = args.buf, timeout_ms = nil }) end
    --                     end,
    --                 })
    --                 vim.api.nvim_create_user_command('ConformToggleOnSave', function()
    --                     vim.g.auto_conform_on_save = not vim.g.auto_conform_on_save
    --                     vim.notify('Auto-Conform on save: ' .. (vim.g.auto_conform_on_save and 'Enabled' or 'Disabled'))
    --                 end, {})
    --             end,
    --         }
    --     end,
    -- },
    -- {
    --     -- Autocompletion
    --     'hrsh7th/nvim-cmp',
    --     dependencies = {
    --         -- Snippet Engine & its associated nvim-cmp source
    --         'L3MON4D3/LuaSnip',
    --         'saadparwaiz1/cmp_luasnip',
    --
    --         -- Adds LSP completion capabilities
    --         'hrsh7th/cmp-nvim-lsp',
    --
    --         -- Adds a number of user-friendly snippets
    --         'rafamadriz/friendly-snippets',
    --         'onsails/lspkind.nvim',
    --         'mlaursen/vim-react-snippets',
    --     },
    --     config = require('configs.cmp_config'),
    -- },
})
