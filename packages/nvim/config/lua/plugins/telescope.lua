return {
    "nvim-telescope/telescope.nvim",
    branch = "master",
    dependencies = {
        "nvim-lua/plenary.nvim",
        { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    keys = {
        { "<leader>ff", "<cmd>Telescope find_files<cr>",                desc = "Find Files" },
        { "<leader>fg", "<cmd>Telescope live_grep<cr>",                 desc = "Live Grep" },
        { "<leader>fb", "<cmd>Telescope buffers<cr>",                   desc = "Buffers" },
        { "<leader>fr", "<cmd>Telescope oldfiles<cr>",                  desc = "Recent Files" },
        { "<leader>fs", "<cmd>Telescope lsp_document_symbols<cr>",      desc = "Document Symbols" },
        { "<leader>fS", "<cmd>Telescope lsp_workspace_symbols<cr>",     desc = "Workspace Symbols" },
        { "<leader>fd", "<cmd>Telescope diagnostics<cr>",               desc = "Diagnostics" },
        { "<leader>fh", "<cmd>Telescope help_tags<cr>",                 desc = "Help Tags" },
        { "<leader>fc", "<cmd>Telescope commands<cr>",                  desc = "Commands" },
        { "<leader>/",  "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Search in Buffer" },
    },
    config = function()
        local telescope = require("telescope")
        telescope.setup({
            defaults = {
                prompt_prefix = "  ",
                selection_caret = " ",
                layout_strategy = "horizontal",
                layout_config = { prompt_position = "top" },
                sorting_strategy = "ascending",
                file_ignore_patterns = { "node_modules", ".git/", "dist/", "build/" },
            },
            extensions = {
                fzf = {
                    fuzzy = true,
                    override_generic_sorter = true,
                    override_file_sorter = true,
                    case_mode = "smart_case",
                },
            },
        })
        telescope.load_extension("fzf")
    end,
}
