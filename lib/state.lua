State = {}

function State.init(self)
	self.__States = self.__States or {}
	local oldmeta = getmetatable(self)
	setmetatable(self.__States,oldmeta)
end

function State:addState(name)
	local States  = self.__States
	local newState= {}
	States[name]  = newState	
	return newState
end

function State:gotoState(name,...)
	local meta     = getmetatable(self) or {}
	local oldState = meta and meta.__index
	if oldState and oldState.leave then oldState.leave(self,...) end
	
	local State = self.__States[name]
	
	if not State then
		local originalmeta = getmetatable(self.__States)
		setmetatable(self,originalmeta)
		return
	end
	
	if State.enter then State.enter(self,oldState,...) end
	meta.__index     = State
	meta.__Statename = name
	setmetatable(self,meta)
end

function State.getState(self)
	local meta = getmetatable(self)
	if meta then return meta.__Statename, meta.__index end
end