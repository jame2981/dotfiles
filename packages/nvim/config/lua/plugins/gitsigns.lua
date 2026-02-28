return {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
        signs = {
            add          = { text = "▎" },
            change       = { text = "▎" },
            delete       = { text = "" },
            topdelete    = { text = "" },
            changedelete = { text = "▎" },
            untracked    = { text = "▎" },
        },
        on_attach = function(bufnr)
            local gs = package.loaded.gitsigns
            local map = function(keys, cmd, desc)
                vim.keymap.set("n", keys, cmd, { buffer = bufnr, silent = true, desc = desc })
            end
            -- hunk navigation
            map("]h", gs.next_hunk, "Next Hunk")
            map("[h", gs.prev_hunk, "Prev Hunk")
            -- hunk actions
            map("<leader>ghs", gs.stage_hunk, "Stage Hunk")
            map("<leader>ghr", gs.reset_hunk, "Reset Hunk")
            map("<leader>ghS", gs.stage_buffer, "Stage Buffer")
            map("<leader>ghu", gs.undo_stage_hunk, "Undo Stage Hunk")
            map("<leader>ghp", gs.preview_hunk, "Preview Hunk")
            map("<leader>ghb", function() gs.blame_line({ full = true }) end, "Blame Line")
            map("<leader>gtb", gs.toggle_current_line_blame, "Toggle Blame")
            map("<leader>gtd", gs.toggle_deleted, "Toggle Deleted")
        end,
    },
}

