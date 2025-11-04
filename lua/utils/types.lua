---@meta

---@class utils.Util
local M = {}

---@class utils.Serialize.Options
---@field indent string
---@field max_depth number
---@field indent_step string

------@param s string | table
------@return table
---function M.ToTable(s) end
---
------@param msg string
------@param level? snacks.notifier.level|number
------@param opts? snacks.notifier.Notif.opts
---function M.Log(msg, level, opts) end
---
------@param value any?
------@param opts utils.Serialize.Options?
------@return string
---function M.Serialize(value, opts) end
