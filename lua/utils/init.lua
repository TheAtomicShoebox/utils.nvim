local M = {}

M.reload = function(module)
	package.loaded[module] = nil
	return require(module)
end

return M
