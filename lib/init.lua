path = ...
-- Generic module name
lib  = {}

require(path..'.class')
require(path..'.component')
require(path..'.entity')

require(path..'.event')
require(path..'.state')

return lib