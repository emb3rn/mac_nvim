function Color(color)
	color = color or "github_dark_default"
	vim.cmd.colorscheme(color)
end

Color()
