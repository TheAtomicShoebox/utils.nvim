---@class Util
-- @module utils
local M = {}

-- serialize.lua
local function is_identifier(str)
	return type(str) == "string" and str:match("^[_%a][_%w]*$") ~= nil
end

local function quote_string(s)
	return string.format("%q", s)
end

---@param s string | table
---@return table
function M.ToTable(s)
	if type(s) == "table" then
		return s
	end
	M.Log("ignore: " .. s)
	local t = {}
	s:gsub(".", function(c)
		table.insert(t, c)
	end)
	return t
end

---@param msg string
---@param level? snacks.notifier.level|number
---@param opts? snacks.notifier.Notif.opts
function M.Log(msg, level, opts)
	if vim.g.debug then
		M.Log(msg, level, opts)
	else
		M.Log(msg, "debug", opts)
	end
end

---@param value any?
---@param opts utils.Serialize.Options?
---@return string
function M.Serialize(value, opts)
	opts = opts or { indent = "\t", max_depth = 10 }
	local indent_step = opts.indent or "  "
	local max_depth = opts.max_depth or math.huge

	local seen = {} -- table -> id
	local refs = {} -- list of {id, str}
	local next_id = 1

	local function write_val(v, depth, indent)
		if type(v) == "number" then
			return tostring(v)
		elseif type(v) == "boolean" then
			return tostring(v)
		elseif type(v) == "string" then
			return quote_string(v)
		elseif type(v) == "nil" then
			return "nil"
		elseif type(v) == "table" then
			if seen[v] then
				-- already seen: emit a reference comment and a placeholder
				return ("/*ref:%d*/ {}"):format(seen[v])
			end

			if depth >= max_depth then
				seen[v] = next_id
				next_id = next_id + 1
				return ("/*maxdepth:%d*/ {}"):format(seen[v])
			end

			seen[v] = next_id
			local my_id = next_id
			next_id = next_id + 1

			-- determine if array-like (consecutive integer keys starting at 1)
			local max_index = 0
			local count = 0
			for k in pairs(v) do
				if type(k) == "number" and k > 0 and math.floor(k) == k then
					if k > max_index then
						max_index = k
					end
				end
				count = count + 1
			end

			local is_array = (count > 0) and (max_index == count)
			local parts = {}
			local new_indent = indent .. indent_step

			if is_array then
				for i = 1, max_index do
					table.insert(parts, new_indent .. write_val(v[i], depth + 1, new_indent))
				end
				local body = table.concat(parts, ",\n")
				local tblstr = "{\n" .. body .. "\n" .. indent .. "}"
				-- record to refs so cycles can be noted later (if needed)
				refs[#refs + 1] = { id = my_id, str = tblstr }
				-- return inline with id comment
				return ("/*id:%d*/ %s"):format(my_id, tblstr)
			else
				-- handle keyed table
				for k, val in pairs(v) do
					local key_repr
					if type(k) == "string" then
						if is_identifier(k) then
							key_repr = k
						else
							key_repr = "[" .. quote_string(k) .. "]"
						end
					elseif type(k) == "number" then
						key_repr = "[" .. tostring(k) .. "]"
					else
						key_repr = "[" .. quote_string(tostring(k)) .. "]"
					end
					local val_repr = write_val(val, depth + 1, new_indent)
					table.insert(parts, new_indent .. key_repr .. " = " .. val_repr)
				end
				local body = table.concat(parts, ",\n")
				local tblstr = "{\n" .. body .. "\n" .. indent .. "}"
				refs[#refs + 1] = { id = my_id, str = tblstr }
				return ("/*id:%d*/ %s"):format(my_id, tblstr)
			end
		else
			-- unsupported types: function, userdata, thread
			-- TODO: try and support functions
			return quote_string("<unsupported:" .. type(v) .. ">")
		end
	end

	local result = write_val(value, 0, "")
	return result
end

return M
