-- simple Class
-------------------------------------------------
Class          = {__type = 'Object'}
Class.__index  = Class

function Class.type(obj)
	return obj.__type
end

function Class.typeOf(obj,name)
	while obj do
		if obj.__type == name then return true end
		local meta = getmetatable(obj)
		obj = meta and meta.__index
	end
	return false
end

function Class.__call(Class,...)
	local obj = setmetatable({},Class)
	if Class.init then Class.init(obj,...)end
	return obj
end

function Class:extend(name)
	return setmetatable( Class(name),{
		__call  = Class.__call,
		__index = self,
	})
end

local reserved = {
	init   = true,
	__type = true,
	__index= true,
}

function Class:mixin(source,...)
	local recur
	recur = function(self,source)
		local meta  = getmetatable(source)
		local index = meta and meta.__index

		if index then recur(self,index) end
	
		for i,v in pairs(source) do
			if not reserved[i] then self[i] = v end
		end
	end
	recur(self,source)
	
	if source.init then source.init(self,...) end
	
	return self
end

setmetatable(Class,{__call = function(Class,name)
	local subClass  = {}
	subClass.__type = name
	subClass.__index= subClass
	return setmetatable(subClass,Class)
end})