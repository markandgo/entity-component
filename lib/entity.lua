local Class = lib.Class
Entity      = Class 'Entity'

function Entity:init(...)
	self.component_order = {}
	if not ... then return end
	Entity.addComponent(self,...)
end

function Entity:addComponent(...)
	for _,name in ipairs{...} do
		-- Add the component from the registry
		-- Add the entity reference to the component
		if not lib.ComponentRegistry[name] then error('Component does not exist: '..name) end
		local component  = lib.ComponentRegistry[name](self)
		component.Entity = self
		self[name]       = component
		table.insert(self.component_order,component)
	end
end

function Entity:removeComponent(...)
	for _,name in ipairs{...} do
		local the_component
		for i,component in ipairs(self.component_order) do
			if component:type() == name then 
				the_component = table.remove(self.component_order,i) 
				break 
			end
		end
		self[name] = nil
		
		if the_component.destroy then the_component:destroy(self) end
	end
end

function Entity:trigger(callback_name,...)
	for i,component in ipairs(self.component_order) do
		if component[callback_name] then component[callback_name](component,...) end
	end
end

lib.Entity = Entity