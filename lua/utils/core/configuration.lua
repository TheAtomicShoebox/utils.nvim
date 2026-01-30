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

	vim.g.loaded_utils = true

	---@type string[]?
	---@diagnostic disable-next-line: assign-type-mismatch
	local startup_logs = type(M.DATA.startup_logs) == "function" and M.DATA.startup_logs() or M.DATA.startup_logs
	for log in startup_logs do
		debug.Log(log, "debug", {})
	end
end

---@param data utils.Configuration? All configuration for this plugin
---@return utils.Configuration # The configuration with 100% filled out values
function M.resolve_data(data)
	M.initialize_data_if_needed()
	return vim.tbl_deep_extend("force", M.DATA, data or {})
end

return M
