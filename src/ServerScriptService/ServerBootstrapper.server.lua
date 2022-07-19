
for _, folder in next, game:GetService("ServerScriptService"):GetChildren() do
    if folder:IsA("Folder") then
        dest = nil

        if folder.Name == "Client" then
            dest = game:GetService("StarterPlayer"):WaitForChild("StarterPlayerScripts")
        elseif folder.Name == "Server" then
            dest = game:GetService("ServerStorage")
        elseif folder.Name == "SharedModules" then
            dest = game:GetService("ReplicatedStorage")
        end

        folder:Clone().Parent = dest
    end
end

require(game:GetService("ReplicatedStorage"):WaitForChild("Bootstrapper"))()

shared.require("/modules/Network")