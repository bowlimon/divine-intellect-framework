
local StarterPlayerScripts = game:GetService("StarterPlayer"):WaitForChild("StarterPlayerScripts")
local ServerStorage = game:GetService("ServerStorage")
local RunService = game:GetService("RunService")

local bootstrapper = {}

function bootstrapper:__call()
	function shared.require(path)
		local splitPath = string.split(path, "/")
		
		local parentDirectory = nil
		
		if splitPath[1] == "" then
			if splitPath[2] == "src" then
				parentDirectory =
					RunService:IsClient()
					and
					StarterPlayerScripts:WaitForChild("Client"):WaitForChild("Source")
					or
					ServerStorage:WaitForChild("Server"):WaitForChild("Source")
			elseif splitPath[2] == "shared" then
				parentDirectory = game:GetService("ReplicatedStorage"):WaitForChild("Shared"):WaitForChild("Modules")
			elseif splitPath[2] == "modules" then
				parentDirectory = 
					RunService:IsClient()
					and
					StarterPlayerScripts:WaitForChild("Client"):WaitForChild("Modules")
					or
					ServerStorage:WaitForChild("Server"):WaitForChild("Modules")
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