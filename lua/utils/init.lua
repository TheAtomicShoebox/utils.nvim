local debug = require("utils.lib.debug")

---@class utils
local M = {}

M.reload = function(module)
	package.loaded[module] = nil
	return require(module)
end

M.Serialize = debug.Serialize

M.Log = debug.Log

M.ToTable = debug.ToTable

return M
