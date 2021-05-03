local _, ns = ...
local RaidCooldowns = ns.RaidCooldowns

local Split = function(cmd)
	if cmd:find("%s") then
		return strsplit(" ", cmd)
	else
		return cmd
	end
end

function RaidCooldowns:RunCommand(cmd)
    local arg1, arg2 = Split(cmd)
    if (arg1 == "queue") then
        print("not implemented")
    end
end

SLASH_RAIDCD1 = "/raidcd"
SlashCmdList["RAIDCD"] = function(cmd)
    RaidCooldowns:RunCommand(cmd)
end
