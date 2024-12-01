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
        -- Autocompletion
        'hrsh7th/nvim-cmp',
        dependencies = {
            -- Snippet Engine & its associated nvim-cmp source
            'L3MON4D3/LuaSnip',
            'saadparwaiz1/cmp_luasnip',

            -- Adds LSP completion capabilities
            'hrsh7th/cmp-nvim-lsp',

            -- Adds a number of user-friendly snippets
            'rafamadriz/friendly-snippets',
            'onsails/lspkind.nvim',
            'mlaursen/vim-react-snippets',
        },
        config = require('configs.cmp_config'),
    },

    -- Useful plugin to show you pending keybinds.
    { 'folke/which-key.nvim',  opts = {} },
    {
        -- Adds git related signs to the gutter, as well as utilities for managing changes
        'lewis6991/gitsigns.nvim',
        opts = {
            -- See `:help gitsigns.txt`
            signs = {
                add = { text = '+' },
                change = { text = '~' },
                delete = { text = '_' },
                topdelete = { text = '‾' },
                changedelete = { text = '~' },
            },
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
            end,
        },
    },
    {
        -- Set lualine as statusline
        'nvim-lualine/lualine.nvim',
        -- See `:help lualine.txt`
        config = function()
            require('lualine').setup({
                sections = {
                    lualine_c = { { 'filename', path = 1 } }
                },
            })
        end,
    },
    {
        -- Add indentation guides even on blank lines
        'lukas-reineke/indent-blankline.nvim',
        -- Enable `lukas-reineke/indent-blankline.nvim`
        -- See `:help ibl`
        main = 'ibl',
        opts = {},
    },

    -- "gc" to comment visual regions/lines
    { 'numToStr/Comment.nvim', opts = {} },

    -- Fuzzy Finder (files, lsp, etc)
    -- {
    --     'nvim-telescope/telescope.nvim',
    --     branch = '0.1.x',
    --     dependencies = {
    --         'nvim-lua/plenary.nvim',
    --         -- Fuzzy Finder Algorithm which requires local dependencies to be built.
    --         -- Only load if `make` is available. Make sure you have the system
    --         -- requirements installed.
    --         {
    --             'nvim-telescope/telescope-fzf-native.nvim',
    --             -- NOTE: If you are having trouble with this installation,
    --             --       refer to the README for telescope-fzf-native for more instructions.
    --             build = 'make',
    --             cond = function()
    --                 return vim.fn.executable 'make' == 1
    --             end,
    --         },
    --     },
    --     config = function()
    --         -- Enable telescope fzf native, if installed
    --         pcall(require('telescope').load_extension, 'fzf')
    --         require('telescope').setup {
    --             defaults = {
    --                 path_display = { "full" }
    --             },
    --         }
    --     end
    -- },
    {
        'nvim-tree/nvim-tree.lua',
        lazy = false,
        config = function()
            require("nvim-tree").setup({
                view = {
                    width = 50,
                },
            })
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
        "kdheepak/lazygit.nvim",
        lazy = false,
    },
    {
        'tpope/vim-fugitive',
        lazy = false,
        config = function()
            -- doesn't work :(
            -- TODO: This is meant to be a fugitive mapping region. But it doesn't work.
            -- I think ThePrimeagen's config has a working example of this.
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
    },
    -- Rustacenvim config from appelgriebsch/Nv
    {
        "mrcjkb/rustaceanvim",
        ft = { "rust" },
        config = function()
            local codelldb = require('mason-registry').get_package('codelldb')
            local extension_path = codelldb:get_install_path() .. '/extension/'
            local codelldb_path = extension_path .. 'adapter/codelldb'
            local liblldb_path = extension_path .. 'lldb/lib/liblldb.dylib'

            local cfg = require('rustaceanvim.config')
            vim.g.rustaceanvim = {
                server = {
                    on_attach = function(_, _)
                        vim.lsp.inlay_hint.enable()
                    end,
                    default_settings = {
                        -- rust-analyzer language server configuration
                        ['rust-analyzer'] = {
                            checkOnSave = {
                                command = "clippy",
                                -- command = "check",
                                -- extraArgs = { "--no-deps" },
                            },
                            check = {
                                workspace = false
                            },
                        },
                    },
                },
                dap = {
                    adapter = cfg.get_codelldb_adapter(codelldb_path, liblldb_path),
                },
            }
        end
    },
    {
        'ibhagwan/fzf-lua',
        lazy = false,
        config = function()
            require('fzf-lua').setup({
                lsp              = {
                    jump_to_single_result = true,
                    async_or_timeout      = 2000,
                    formatter             = "path.filename_first",
                },
                winopts          = {
                    split = 'botright new',
                    row = 1.0,
                    height = 0.3,
                    width = 1.0,
                    preview = {
                        vertical = 'up:70%',
                        horizontal = 'right:50%',
                    },
                },
                lsp_code_actions = {
                    winopts = {
                        -- Set the window to float
                        relative = "editor",
                        -- Position it at the center of the screen
                        row = 0.5,
                        col = 0.5,
                        -- Set the size (adjust as needed)
                        width = 0.6,
                        height = 0.8,
                        -- Add a border
                        border = "rounded",
                    },
                },
                git              = {
                    files = {
                        file_icons   = true,
                        color_icons  = true,
                        path_shorten = false,
                    }
                },
                grep             = {
                    formatter = "path.filename_first",
                }
            })
        end
    },
    {
        'stevearc/conform.nvim',
        opts = {},
        config = function()
            return {
                "stevearc/conform.nvim",
                event = { "BufReadPre", "BufNewFile" },
                config = function()
                    local conf = require("conform")

                    conf.setup({
                        log_level = vim.log.levels.DEBUG,
                        formatters_by_ft = {
                            lua = { "stylua" },
                            rust = { "rustfmt" },
                            typescript = { { "prettierd", "prettier", stop_after_first = true } },
                            typescriptreact = { { "prettierd", "prettier", stop_after_first = true } },
                            javascript = { { "prettierd", "prettier", stop_after_first = true } },
                            javascriptreact = { { "prettierd", "prettier", stop_after_first = true } },

                            ["*"] = { "codespell", "trim_whitespace" },
                            -- Use the "_" filetype to run formatters on filetypes that don't
                            -- have other formatters configured.
                            ["_"] = { "trim_whitespace" },
                        },
                    })

                    vim.api.nvim_create_autocmd('FileType', {
                        pattern = vim.tbl_keys(require('conform').formatters_by_ft),
                        group = vim.api.nvim_create_augroup('conform_formatexpr', { clear = true }),
                        callback = function() vim.opt_local.formatexpr = 'v:lua.require("conform").formatexpr()' end,
                    })
                    vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
                    vim.g.auto_conform_on_save = true
                    vim.api.nvim_create_autocmd('BufWritePre', {
                        pattern = '*',
                        callback = function(args)
                            if vim.g.auto_conform_on_save then require('conform').format({ bufnr = args.buf, timeout_ms = nil }) end
                        end,
                    })
                    vim.api.nvim_create_user_command('ConformToggleOnSave', function()
                        vim.g.auto_conform_on_save = not vim.g.auto_conform_on_save
                        vim.notify('Auto-Conform on save: ' .. (vim.g.auto_conform_on_save and 'Enabled' or 'Disabled'))
                    end, {})
                end,
            }
        end,
    },
    {
        'mrjones2014/smart-splits.nvim',
        config = function()
            require('smart-splits').setup()
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
        lazy = false,
    },
    {
        'ThePrimeagen/harpoon',
        branch = "master",
        dependencies = {
            'nvim-lua/plenary.nvim',
        },
        -- config = function()
        --     require("harpoon"):setup({})
        -- end
    },
    {
        dir = "/Users/sharonavni/personal/git-mediate.nvim",
        dependencies = { "skywind3000/asyncrun.vim" },
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
    -- {
    --     "ggandor/leap-spooky.nvim",
    --     lazy = false,
    --     config = function()
    --         require('leap-spooky').setup {
    --         }
    --     end
    -- },
    {
        "ggandor/flit.nvim",
        lazy = false,
        config = function()
            require('flit').setup {
                keys = { f = 'f', F = 'F', t = 't', T = 'T' },
                -- A string like "nv", "nvo", "o", etc.
                labeled_modes = "v",
                -- Repeat with the trigger key itself.
                clever_repeat = true,
                multiline = true,
                -- Like `leap`s similar argument (call-specific overrides).
                -- E.g.: opts = { equivalence_classes = {} }
                opts = {}
            }
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
        "nvim-tree/nvim-web-devicons",
        lazy = false,
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
        end
    },
    {
        "tpope/vim-rsi",
        lazy = false,
    },
    {
        'AndrewRadev/linediff.vim',
        lazy = false,
        config = function()
            vim.cmd [[
                let g:linediff_first_buffer_command  = 'rightbelow new'
                let g:linediff_further_buffer_command = 'rightbelow horizontal new'
            ]]
        end
    },
    -- {
    --     "fdschmidt93/telescope-egrepify.nvim",
    --     lazy = false,
    --     config = function()
    --         local egrep_actions = require "telescope._extensions.egrepify.actions"
    --         require("telescope").setup {
    --             extensions = {
    --                 egrepify = {
    --                     attach_mappings = false,
    --                     -- default mappings
    --                     mappings = {
    --                         i = {
    --                             -- toggle prefixes, prefixes is default
    --                             ["<C-z>"] = egrep_actions.toggle_prefixes,
    --                             -- toggle AND, AND is default, AND matches tokens and any chars in between
    --                             ["<C-&>"] = egrep_actions.toggle_and,
    --                             -- toggle permutations, permutations of tokens is opt-in
    --                             ["<C-r>"] = egrep_actions.toggle_permutations,
    --                         },
    --                     },
    --                 },
    --             },
    --         }
    --
    --         require "telescope".load_extension("egrepify")
    --     end
    -- },
    -- {
    --     'jinh0/eyeliner.nvim',
    --     lazy = false,
    --     config = function()
    --         -- vim.api.nvim_set_hl(0, 'EyelinerPrimary', { fg = '#FF4500', bold = true, underline = true })
    --         -- vim.api.nvim_set_hl(0, 'EyelinerSecondary', { fg = '#00FF00', underline = true })
    --         require 'eyeliner'.setup {
    --             highlight_on_key = false, -- show highlights only after keypress
    --             dim = false               -- dim all other characters if set to true (recommended!)
    --         }
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
    {
        "mg979/vim-visual-multi",
        branch = "master",
        config = function()
            vim.cmd [[
                VMTheme codedark
            ]]
        end,
    },
    -- {
    --     'nvimtools/none-ls.nvim',
    --     event = "VeryLazy",
    --     opts = function()
    --         return require("configs.null-ls")
    --     end,
    -- },
    {
        "utilyre/sentiment.nvim",
        version = "*",
        event = "VeryLazy", -- keep for lazy loading
        opts = {
            -- config
        },
        init = function()
            -- `matchparen.vim` needs to be disabled manually in case of lazy loading
            vim.g.loaded_matchparen = 1
        end,
    },
    {
        'windwp/nvim-ts-autotag',
        ft = { "html", "javascript", "javascriptreact", "typescript", "typescriptreact", "svelte", "vue" },
        config = function()
            require('nvim-ts-autotag').setup()
        end
    },
    -- {
    --     "ErichDonGubler/lsp_lines.nvim",
    --     config = function()
    --         require("lsp_lines").setup()
    --     end,
    --
    -- },
    {
        "stevearc/oil.nvim",
        lazy = false,
        config = function()
            require("oil").setup()
        end,
    },
    {
        'sindrets/diffview.nvim',
        event = "VeryLazy",
    },
    -- {
    --     "catppuccin/nvim",
    --     lazy = false,
    --     config = function()
    --         vim.cmd("colorscheme catppuccin-mocha")
    --     end
    -- },
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
    -- {
    --     'akinsho/toggleterm.nvim',
    --     version = "*",
    --     config = function()
    --         require 'toggleterm'.setup {
    --         }
    --         function _G.set_terminal_keymaps()
    --             local opts = { buffer = 0 }
    --             vim.keymap.set('t', '<C-x>', [[<C-\><C-n>]], opts)
    --             vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
    --             vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
    --             vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
    --             vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
    --         end
    --
    --         -- if you only want these mappings for toggle term use term://*toggleterm#* instead
    --         vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')
    --     end
    -- },
    {
        'rcarriga/nvim-dap-ui',
        lazy = false,
        dependencies = { 'mfussenegger/nvim-dap', 'nvim-neotest/nvim-nio' },
        config = function()
            require('dapui').setup()
            local dap, dapui = require("dap"), require("dapui")
            dap.listeners.before.attach.dapui_config = function()
                dapui.open()
            end
            dap.listeners.before.launch.dapui_config = function()
                dapui.open()
            end
            dap.listeners.before.event_terminated.dapui_config = function()
                dapui.close()
            end
            dap.listeners.before.event_exited.dapui_config = function()
                dapui.close()
            end
        end
    },
    -- {
    --     'b0o/incline.nvim',
    --     config = function()
    --         require('configs.incline')
    --     end,
    --     -- Optional: Lazy load Incline
    --     event = 'VeryLazy',
    -- },
    -- {
    --     "NeogitOrg/neogit",
    --     dependencies = {
    --         "nvim-lua/plenary.nvim",  -- required
    --         "sindrets/diffview.nvim", -- optional - Diff integration
    --
    --         -- Only one of these is needed, not both.
    --         "nvim-telescope/telescope.nvim", -- optional
    --     },
    --     config = true
    -- },
    {
        "johmsalas/text-case.nvim",
        lazy = false,
        config = function()
            require('textcase').setup {}
        end
    }
})
