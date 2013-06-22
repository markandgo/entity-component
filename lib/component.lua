ComponentRegistry = {}

Component = Class 'Component'

-- Reserved:
-- Component.Entity
-- Component[SubcomponentName]

function Component:init(entity)

end

function Component:destroy(entity)

end

function Component:extend(name)
	local new_component     = Class.extend(self,name)
	ComponentRegistry[name] = new_component
	return new_component
end

-- Components can depend on other components
-- This function adds dependencies to the component when adding to an entity.
function Component:require(...)
	self._require = {}
	for _,name in ipairs{...} do
		self._require[name] = true
	end
end