require 'lib'

-- ##############################################
-- BOX COMPONENT
-- ##############################################

Box = lib.Component:extend 'Box'

function Box:init(entity)
	self:require(entity,'Position')
	self.w = 100
	self.h = 100
end

-- ##############################################
-- POSITION COMPONENT
-- ##############################################

Position = lib.Component:extend 'Position'

function Position:init(entity)
	self.x,self.y = 0,0
end

-- ##############################################
-- COLOR COMPONENT
-- ##############################################

Color = lib.Component:extend 'Color'

function Color:init(entity)
	self[1] = 255
	self[2] = 0
	self[3] = 0
end

-- ##############################################
-- RENDER BOX COMPONENT
-- ##############################################

RenderBox = lib.Component:extend 'RenderBox'

function RenderBox:draw()
	local e      = self.Entity
	local color  = e.Color
	local x,y,w,h= e.Position.x,e.Position.y,e.Box.w,e.Box.w
	love.graphics.setColor(color)
	love.graphics.rectangle('fill',x,y,w,h)
	love.graphics.setColor(255,255,255)
end

-- ##############################################
-- TESTING ENTITY AND CLONING
-- ##############################################

MyEntity = lib.Entity('Color','Box','RenderBox')

MyEntity2  = MyEntity:clone()
local pos  = MyEntity2.Position
pos.x,pos.y= 100,0
local color= MyEntity2.Color
color[2]   = 255
	
function love.draw()
	MyEntity:trigger 'draw'
	MyEntity2:trigger 'draw'
end