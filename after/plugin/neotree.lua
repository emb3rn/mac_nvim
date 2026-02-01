require("neo-tree").setup({
  close_if_last_window = false,
  popup_border_style = "rounded",
  enable_git_status = true,
  enable_diagnostics = true,
  window = {
      position = "left",
      width = 30,
  },
  filesystem = {
      filtered_items = {
          visible = true,
          hide_dotfiles = false,
          hide_gitignored = false,
      },
  },
})