-- simple Class
-------------------------------------------------
Class          = {__type = 'Object'}
Class.__index  = Class

function Class:new(...)
	self.__index = self
	self.__call  = Class.new
	local obj    = setmetatable({},self)
	if self.init then self.init(obj,...) end
	return obj
end

function Class:type()
	return self.__type
end

function Class:typeOf(name)
	while self do
		if self.__type == name then return true end
		local meta = getmetatable(self)
		self       = meta and meta.__index
	end
	return false
end

function Class:extend(name,...)
	local obj  = Class.new(self,...)
	obj.__type = name
	return obj
end

local reserved = {
	init   = true,
	__type = true,
	__index= true,
}

local function mixin_recursive(self,source)
	local meta  = getmetatable(source)
	local index = meta and meta.__index

	if index then mixin_recursive(self,index) end

	for i,v in pairs(source) do
		if not reserved[i] then self[i] = v end
	end
end

-- http://lua-users.org/wiki/CopyTable
local function deep_copy(t,done)
	if done[t] then return done[t]
	elseif type(t) ~= 'table' then return t end
	
	local newt = setmetatable( {}, getmetatable(t) )
	done[t]    = newt
	for i,v in pairs(t) do
		i      = deep_copy(i,done)
		v      = deep_copy(v,done)
		newt[i]= v
	end
	return newt
end

function Class:mixin(source,...)
	mixin_recursive(self,source)
	if source.init then source.init(self,...) end
	return self
end

function Class:clone()
	return deep_copy(self,{})
end

setmetatable(Class,{__call = Class.new})