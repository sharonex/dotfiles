---@type MappingsTable
local M = {}

local function get_last_line(myString)
	local lastLine = nil

	for line in myString:gmatch("[^\n]+") do
		lastLine = line
	end

	if lastLine then
		return lastLine
	else
		return myString
	end
end

M.general = {
    i = {
        ["<C-a>"] = { "<ESC>I" },
        ["<C-c>"] = { "<ESC>" }
    },
	n = {
        ["<C-o>"] = {"<C-o>zz"},
        ["<C-i>"] = {"<C-i>zz"},
        ["u"] = {"uzz"},
        ["<C-r>"] = {"<C-r>zz"},
        ["<A-S-Left>"] = {"4<C-W>>"},
        ["<A-S-Right>"] = {"4<C-W><"},
        ["<A-S-Up>"] = {"4<C-W>+"},
        ["<A-S-Down>"] = {"4<C-W>-"},
        ["<C-w>kh"] = {"<C-w>h<C-w>q", "Kill window to the left"},
        ["<C-w>kj"] = {"<C-w>j<C-w>q", "Kill window below"},
        ["<C-w>kk"] = {"<C-w>k<C-w>q", "Kill window above"},
        ["<C-w>kl"] = {"<C-w>l<C-w>q", "Kill window to the right"},
        ["{"] = {"[{"},
        ["}"] = {"}]"},
        ["[{"] = {"{"},
        ["}]"] = {"}"},
        ["=="] = {"mb10k=20j`b", "Indent in 10 line chunk(up and down)"},

        ["<M-,>"] = { "<cmd> lua require('sibling-swap').swap_with_left_with_opp()<CR>", "swaps arguments to the left"},
        ["<M-.>"] = { "<cmd> lua require('sibling-swap').swap_with_right_with_opp()<CR>", "swaps arguments to the right"},
		["<C-h>"] = { "<cmd> TmuxNavigateLeft<CR>", "window left" },
		["<C-l>"] = { "<cmd> TmuxNavigateRight<CR>", "window right" },
		["<C-j>"] = { "<cmd> TmuxNavigateDown<CR>", "window down" },
        ["<C-k>"] = { "<cmd> TmuxNavigateUp<CR>", "window up" },
		["L"] = { "$", "End of line" },
		["H"] = { "^", "Start of line" },
		["<C-d>"] = { "<C-d>zz", "Page Down" },
		["<C-u>"] = { "<C-u>zz", "Page Up" },
        ["cgw"] = {"*Ncgn", "Repeatably change current word"},

        ["<leader>tl"] = { "<cmd> TSJToggle<CR>", "Toggle line split"};
        ["]e"] = {": cnext<CR>", "next quickfix error"},
        ["[e"] = {": cprev<CR>", "prev quickfix error"},
        ["]g"] = {": Gitsigns next_hunk<CR>", "next git hunk"},
        ["[g"] = {": Gitsigns prev_hunk<CR>", "prev git hunk"},

		["<leader>u"] = { "<cmd>UndotreeToggle<CR><cmd>UndotreeFocus<CR>", "Toggle UndoTree" },
        ["<C-c>"] = { ":noh <CR>", "Clear highlights" },
        ["<leader>dd"] = {":lua vim.diagnostic.disable()<CR>", "Disable lsp diagnostics"},
        ["<leader>de"] = {":lua vim.diagnostic.enable()<CR>", "enable lsp diagnostics"},
        ["<A-t>"] = {
            function()
                require("nvterm.terminal").toggle "horizontal"
            end,
            "Toggle horizontal term",
        },
        ["<leader>xx"] = {"<cmd>source % <CR>", "execute current file"},
        ["<C-m>"] = {"<cmd>:w<CR>", "Save file"},

        ["<leader>ca"] ={"<cmd>CodeActionMenu<cr>", "Open code actions"},

        -- Substitute, exchange
        ["gp"] ={"<cmd>lua require('substitute').operator()<cr>"},
        ["gpp"] ={"<cmd>lua require('substitute').line()<cr>"},
        ["gP"] ={"<cmd>lua require('substitute').eol()<cr>"},
        ["gx"] ={"<cmd>lua require('substitute.exchange').operator()<cr>"},
        ["gxx"] ={"<cmd>lua require('substitute.exchange').line()<cr>"},
        ["gxc"] = { "<cmd>lua require('substitute.exchange').cancel()<cr>"},

        -- Rust
        ["<leader>re"] = {"<cmd>RustExpandMacro<CR>", "Rust expand macro"},
        ["<leader>rc"] = {"<cmd>RustOpenCargo<CR>", "Rust open cargo"},
	},
	v = {
        ["gs"] ={"<cmd>lua require('substitute').visual()<cr>"},
        ["gx"] ={"<cmd>lua require('substitute.exchange').visual()<cr>"},
		["L"] = { "$h", "End of line" },
		["H"] = { "^", "Start of line" },
        ["J"] = {":m '>+1<CR>gv=gv", "Move line down"},
        ["K"] = {":m '<-2<CR>gv=gv", "Move line up"},
        ["<"] = { "<gv" },
        [">"] = { ">gv" },
        ["="] = { "=gv" },
		["<leader>sp"] = {
			function()
				-- yank the highlighted text into register z
				vim.cmd('normal! "zy')

				-- get the content of register z
				local search_term = vim.fn.getreg("z")

				-- start the live grep with the content of register z as the default text
				require("telescope.builtin").live_grep({ default_text = get_last_line(search_term) })
			end,
			"Find highlighted text in files",
		},
	},
}

M.extraGit = {
	plugin = false,
	n = {
		["<leader>gg"] = { ":LazyGit<CR>", "Opens LazyGit" },
		["<leader>gB"] = { "<cmd> Git blame<CR>", "Run git blame on file" },
		["<leader>gaf"] = { ":AdvancedGitSearch diff_commit_file<CR>", "Show last commits that changed current file" },
		["<leader>gas"] = { ":AdvancedGitSearch search_log_content<CR>", "Search git log for something" },
		["<leader>gs"] = { ":Gitsigns stage_hunk<CR>", "Stage git hunk" },
		["<leader>gr"] = { ":Gitsigns reset_hunk<CR>", "Reset git hunk" },
		["<leader>gp"] = { ":Gitsigns preview_hunk<CR>", "Pop up of git hunk diff" },
		["<leader>g["] = { ":GitMediate<CR>", "Run git mediate conflict resolver" },
		["<leader>gf"] = { ":Git<CR>/taged<CR>:noh<CR>j", "Run git fugitive" },
		["<leader>gl"] = { ":Git log<CR>", "Open fugitive log" },

	},
	v = {
		["<leader>gs"] = { ":Gitsigns stage_hunk<CR>", "Stage git hunk" },
		["<leader>gal"] = {
			":'<,'>AdvancedGitSearch diff_commit_line<CR>",
			"Show last commits that changed highlighted lines",
		},
	},
}
M.telescope = {
	plugin = true,
	n = {
		["<leader>sp"] = {
            "<cmd> Telescope egrepify<CR>",
            "Find in files",
        },
		["<leader>sP"] = { "<cmd> Telescope grep_string <CR>", "Find current word in files" },
		["<leader>ss"] = { "<cmd> Telescope current_buffer_fuzzy_find <CR>", "Find in current file" },
		["<leader>sl"] = { "<cmd> Telescope resume <CR>", "Continue last search" },
        ["<leader>fc"] = { "<cmd> Telescope commands <CR>", "Find vim commands" },
        ["<leader>fk"] = { "<cmd> Telescope keymaps <CR>", "Look up key mappings"},
        ["<leader>fs"] = { "<cmd> Telescope lsp_dynamic_workspace_symbols <CR>", "Search workspace symbols"},
        ["<leader>fb"] = {
            function ()
                require('telescope.builtin').buffers({ sort_lastused = true, ignore_current_buffer = true, sort_mru = true })
            end,
            "Show recent buffers"
        },
	},
}

M.harpoon = {
  n = {
    ["<leader>ma"] = {
      function()
        require("harpoon.mark").add_file()
      end,
      "󱡁 Harpoon Add file",
    },
    ["<leader>ta"] = { "<CMD>Telescope harpoon marks<CR>", "󱡀 Toggle quick menu" },
    ["<leader>mm"] = {
      function()
        require("harpoon.ui").toggle_quick_menu()
      end,
      "󱠿 Harpoon Menu",
    },
    ["<leader>1"] = {
      function()
        require("harpoon.ui").nav_file(1)
      end,
      "󱪼 Navigate to file 1",
    },
    ["<leader>2"] = {
      function()
        require("harpoon.ui").nav_file(2)
      end,
      "󱪽 Navigate to file 2",
    },
    ["<leader>3"] = {
      function()
        require("harpoon.ui").nav_file(3)
      end,
      "󱪾 Navigate to file 3",
    },
    ["<leader>4"] = {
      function()
        require("harpoon.ui").nav_file(4)
      end,
      "󱪿 Navigate to file 4",
    },
  },
}

M.trouble = {
    n = {
        ["<leader>ll"] = { "<cmd> lua vim.diagnostic.open_float({scope=\"line\"}) <cr>", "Show line diagnostics" },
        ["<leader>lc"] = { "<cmd> lua vim.diagnostic.open_float({scope=\"cursor\"}) <cr>", "Show line diagnostics" },
        ["<leader>ld"] = { "<cmd>TroubleToggle document_diagnostics<cr>", "Document diagnostics" },
        ["<leader>lw"] = { "<cmd>TroubleToggle workspace_diagnostics<cr>", "Workspace diagnostics" },
        ["<leader>qf"] = { "<cmd>TroubleToggle quickfix<cr>", "Quickfix" },
    }
}

M.ChatGPT = {
   n = {
       ["<leader>ac"] = { "<cmd>ChatGPT<CR>", "ChatGPT" },
       ["<leader>ae"] = { "<cmd>ChatGPTEditWithInstruction<CR>", "Edit with instruction" },
       ["<leader>ag"] = { "<cmd>ChatGPTRun grammar_correction<CR>", "Grammar Correction" },
       ["<leader>at"] = { "<cmd>ChatGPTRun translate<CR>", "Translate" },
       ["<leader>ak"] = { "<cmd>ChatGPTRun keywords<CR>", "Keywords" },
       ["<leader>ad"] = { "<cmd>ChatGPTRun docstring<CR>", "Docstring" },
       ["<leader>aa"] = { "<cmd>ChatGPTRun add_tests<CR>", "Add Tests" },
       ["<leader>ao"] = { "<cmd>ChatGPTRun optimize_code<CR>", "Optimize Code" },
       ["<leader>as"] = { "<cmd>ChatGPTRun summarize<CR>", "Summarize" },
       ["<leader>af"] = { "<cmd>ChatGPTRun fix_bugs<CR>", "Fix Bugs" },
       ["<leader>ax"] = { "<cmd>ChatGPTRun explain_code<CR>", "Explain Code" },
       ["<leader>ar"] = { "<cmd>ChatGPTRun roxygen_edit<CR>", "Roxygen Edit" },
       ["<leader>al"] = { "<cmd>ChatGPTRun code_readability_analysis<CR>", "Code Readability Analysis" },
   },
}
M.ChatGPT.v = M.ChatGPT.n

M.disabled = {
    n = {
        ["<leader>h"] = "",
        ["<leader>v"] = "",
    }
}

M.Neotest = {
    plugin = false,
    n = {
        ["<leader>tr"] = {"<cmd>Neotest run<CR>", "Run current test"},
        ["<leader>to"] = {"<cmd>Neotest output-panel<CR>", "Open test output"},
        ["<leader>ts"] = {"<cmd>Neotest summary<CR>", "Open test output"},
        ["<leader>tg"] = {
            function()
                local neotest = require("neotest")
                neotest.run.get_last_run()
                neotest.run.run()
            end,
            "Run last test",
        },
    }

}

return M
