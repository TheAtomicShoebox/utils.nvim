local debug = require("utils.lib.debug")

local M = {}

vim.g.loaded_utils = false

---@type utils.Configuration
M.DATA = {}

---@type utils.Configuration
local _DEFAULTS = {}

-- TODO: actually add a real configuration

---@type utils.Configuration
local _EXTRA_DEFAULTS = {
	startup_logs = { "utils Started" },
}

_DEFAULTS = vim.tbl_deep_extend("force", _DEFAULTS, _EXTRA_DEFAULTS)

function M.initialize_data_if_needed()
	if vim.g.loaded_utils then
		return
	end

	M.DATA = vim.tbl_deep_extend("force", _DEFAULTS, vim.g.utils_configuration or {})

	---@type string[]?
	local startup_logs = type(M.DATA.startup_logs) == "function" and M.DATA.startup_logs() or M.DATA.startup_logs
	for log in startup_logs do
		debug.Log(log, "debug", {})
	end
end

return M
