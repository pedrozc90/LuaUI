local T, C, L = Tukui:unpack()

----------------------------------------------------------------
-- Commands
----------------------------------------------------------------

local function CmdSplit(cmd)
    if (cmd:find("%s")) then
        return strsplit(" ", cmd)
    end
    return cmd
end

SLASH_LUAUISLASH1 = "/lua"
SlashCmdList["LUAUISLASH"] = function(cmd)
    local arg1, arg2 = CmdSplit(cmd)

    if (arg1 == "reset") then
        LuaUIData = {}
        ReloadUI()
    end
end
