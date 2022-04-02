-- config lualine
local function arduino_status()
  local ft = vim.api.nvim_buf_get_option(0, "ft")
  if ft ~= "arduino" then
    return ""
  end
  local port = vim.fn["arduino#GetPort"]()
  local line = string.format("[%s]", vim.g.arduino_board)
  if vim.g.arduino_programmer ~= "" then
    line = line .. string.format(" [%s]", vim.g.arduino_programmer)
  end
  if port ~= 0 then
    line = line .. string.format(" (%s:%s)", port, vim.g.arduino_serial_baud)
  end
  return line
end

-- add string em uma sessao do lualine
require('lualine').setup {
  sections = {lualine_c = {arduino_status} }
}


local lsp_installer = require("nvim-lsp-installer")

lsp_installer.on_server_ready(function (server)
    local opts = {}
    if server.name == "arduino_language_server" then
        opts.on_new_config = function (config, root_dir)
            local partial_cmd = server:get_default_options().cmd
            --local MY_FQBN = "arduino:avr:nano"
            local MY_FQBN = vim.g.arduino_board
            config.cmd = vim.list_extend(partial_cmd, { "-fqbn", MY_FQBN})
        end
    end
    server:setup(opts)
end)
