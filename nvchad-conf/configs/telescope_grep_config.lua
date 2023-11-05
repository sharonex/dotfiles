return {
    winblend = 10,
    extensions = {
        file_browser = { layout_strategy = "horizontal", sorting_strategy = "ascending" },
        heading = { treesitter = true },
        ["ui-select"] = { require("telescope.themes").get_dropdown({}) },
    },
    cache_picker = { num_pickers = 10 },
    dynamic_preview_title = true,
    layout_strategy = "vertical",
    layout_config = {
        vertical = {
            width = 0.9,
            height = 0.9,
            preview_height = 0.6,
            preview_cutoff = 0,
        },
    },
    path_display = { "smart", shorten = { len = 3 } },
    wrap_results = true,
}
