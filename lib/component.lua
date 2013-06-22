ComponentRegistry = {}

Component = Class 'Component'

-- Reserved:
-- Component.Entity
-- Component[SubcomponentName]

function Component:init(Entity)

end

function Component:destroy(Entity)

end

function Component:extend(name)
	local new_component     = Class.extend(self,name)
	ComponentRegistry[name] = new_component
	return new_component
end

-- This function automatically adds dependencies to the component and entity.
-- This function is not required as other components can be manually added.
function Component:require(Entity,...)
	for _,name in ipairs{...} do
		
		-- Check for existence and circular dependencies
		if not ComponentRegistry[name] then error('Component does not exist: '..name) end
		
		local Entity_comp = Entity[name]
		if Entity_comp == true then error('Loop in loading component: '..name) end
		
		if not Entity_comp then 
			Entity[name]  = true
			Entity_comp   = ComponentRegistry[name](Entity) 
		end
		self[name]          = Entity_comp
		Entity[name]        = Entity_comp
	end
end