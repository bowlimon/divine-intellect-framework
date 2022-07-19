
local network = {
	_sendEvent = nil;
	_recvEvent = nil;
}

local callbacks = {}

function network:Bind(key, callback)
	if callbacks[key] then
		error(("NetworkError: Key %q is already bound to a callback."):format(key))
	end
	callbacks[key] = callback
end

function network:Recv(key, client, ...)
	return network._recvEvent:InvokeClient(client, key, ...)
end

function network:Send(key, client, ...)
	network._sendEvent:FireServer(client, key, ...)
end

function network:Init()
	network._sendEvent = Instance.new("RemoteEvent")
	network._recvEvent = Instance.new("RemoteFunction")
	
	network._sendEvent.OnServerEvent:Connect(function(client, key, ...)
		local callback = callbacks[key]
		if not callback then
			warn(("NetworkWarning: No callback bound to key %q."):format(key))
		else
			callback(client, ...)
		end
	end)
	
	network._recvEvent.OnServerInvoke = function(client, key, ...)
		local callback = callbacks[key]
		if not callback then
			warn(("NetworkWarning: No callback bound to key %q."):format(key))
		else
			return callback(client, ...)
		end
		return nil
	end
	
	network._sendEvent.Parent = game:GetService("ReplicatedStorage")
	network._recvEvent.Parent = game:GetService("ReplicatedStorage")
end

return network