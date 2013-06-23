local handlerMap = function(Event,handlers,callback)
	for i = 1,#handlers do
		local handler = handlers[i]
		callback(Event,handler)
	end
end

local delHandler = function(Event,handler) 
	Event[handler] = nil 
end

local addHandler = function(Event,handler) Event[handler] = handler end

local Class = lib.Class
local Event = Class 'Event' 

function Event:init()
	self.Events = {}
end

function Event.register(name,...)
	local handlers  = {...}
	local Events    = Event.Events
	Events[name]    = Events[name] or {}
	handlerMap(Events[name],handlers,addHandler)
end

function Event.remove(name,...)
	local Event    = Event.Events[name]
	if not Event then error 'Event is empty!' end
	local handlers = {...}
	handlerMap(Event,handlers,delHandler)
	if not next(Event) then Event.Events[name] = nil end
end

function Event.clear(name)
	Event.Events[name] = nil
end

function Event.trigger(name,...)
	local Event = Event.Events[name]
	if not Event then return end
	for handler in pairs(Event) do
		handler(...)
	end
end

lib.Event = Event