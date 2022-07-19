
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

function network:Recv(key, ...)
	return network._recvEvent:InvokeServer(key, ...)
end

function network:Send(key, ...)
	network._sendEvent:FireServer(key, ...)
end

function network:Init()
	network._sendEvent = game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvent")
	network._recvEvent = game:GetService("ReplicatedStorage"):WaitForChild("RemoteFunction")
	
	network._sendEvent.OnClientEvent:Connect(function(key, ...)
		local callback = callbacks[key]
		if not callback then
			warn(("NetworkWarning: No callback bound to key %q."):format(key))
		else
			callback(...)
		end
	end)
	
	network._recvEvent.OnClientInvoke = function(key, ...)
		local callback = callbacks[key]
		if not callback then
			warn(("NetworkWarning: No callback bound to key %q."):format(key))
		else
			return callback(...)
		end
		return nil
	end
end

return network