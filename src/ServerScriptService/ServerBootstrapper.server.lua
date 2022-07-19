
for _, folder in next, game:GetService("ServerScriptService"):GetChildren() do
    if folder:IsA("Folder") then
        destFolder = nil

        if folder.Name == "Client" then
            destFolder = game:GetService("StarterPlayer"):WaitForChild("StarterPlayerScripts"):WaitForChild("ClientSource")
        elseif folder.Name == "Server" then
            destFolder = game:GetService("ServerStorage"):WaitForChild("ServerSource")
        elseif folder.Name == "SharedModules" then
            destFolder = game:GetService("ReplicatedStorage"):WaitForChild("SharedModules")
        end

        for _, child in next, folder:GetChildren() do
            folder:Clone().Parent = child
        end
    end
end

require(game:GetService("ReplicatedStorage"):WaitForChild("Bootstrapper"))()

shared.require("/modules/Network")