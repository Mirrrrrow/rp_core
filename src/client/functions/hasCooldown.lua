local cooldowns = {}

---@param key string
---@param duration number
---@return boolean
local function hasCooldown(key, duration)
    local now = GetGameTimer()

    if not cooldowns[key] or cooldowns[key] < now then
        cooldowns[key] = now + duration
        return false
    end

    return true
end

return hasCooldown
