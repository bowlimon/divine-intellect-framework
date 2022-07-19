
local bootstrapper = {}

function bootstrapper:__call()
	function shared.require(path)
		local splitPath = string.split(path, "/")
		
		local parentDirectory = nil
		
		if splitPath[1] == "" then
			if splitPath[2] == "src" then
				parentDirectory =
					game:GetService("RunService"):IsClient()
					and
					game:GetService("StarterPlayer"):WaitForChild("StarterPlayerScripts"):WaitForChild("ClientSource")
					or
					game:GetService("ServerScriptService"):WaitForChild("ServerSource")
			elseif splitPath[2] == "shared" then
				parentDirectory = game:GetService("ReplicatedStorage"):WaitForChild("SharedModules")
			elseif splitPath[2] == "modules" then
				parentDirectory = 
					game:GetService("RunService"):IsClient()
					and
					game:GetService("ReplicatedStorage"):WaitForChild("ClientModules")
					or
					game:GetService("ServerStorage"):WaitForChild("ServerModules")
			end
		else
			error("Malformed path")
		end
		
		local currentDirectory = parentDirectory
		local module = nil
		for i = 3, #splitPath do
			if splitPath[i] == "/" then continue end
			local child = currentDirectory:FindFirstChild(splitPath[i])
			if child:IsA("ModuleScript") then
				module = require(child)
				if type(module) == "table" and type(module.Init) == "function" then
					module:Init()
				end
			else
				currentDirectory = child
			end
		end
		
		return module
	end
end

return setmetatable(bootstrapper, bootstrapper)