Entity = Class 'Entity'

function Entity:init(...)
	self.component_order = {}
	if not ... then return end
	Entity.addComponent(self,...)
end

function Entity:addComponent(...)
	for _,name in ipairs{...} do
		-- Add the component from the registry
		-- Add the entity reference to the component
		local component        = ComponentRegistry[name](self)
		component.Entity       = self
		self[component:type()] = component
		table.insert(self.component_order,component)
		
		-- Add missing dependencies to the entity and component
		if component._dependencies then 
			for name in pairs(component._dependencies) do
				local subcomponent            = self[name] or ComponentRegistry[name](self)
				subcomponent.Entity           = self
				component[subcomponent:type()]= subcomponent
				self[subcomponent:type()]     = subcomponent
				
				if not self[name] then table.insert(self.component_order,subcomponent) end
			end
		end
		
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

function Entity:callback(callback_name,...)
	for i,component in ipairs(self.component_order) do
		if component[callback_name] then component[callback_name](component,...) end
	end
end