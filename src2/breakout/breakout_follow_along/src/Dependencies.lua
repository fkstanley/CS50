--[[
    A library allowing us to draw at a virtual resolution
    https://github.com/Ulydev/push
]]
push = require 'lib/push'

--[[
    A library allowing us to represent anything in the game
    as code
    https://github.com/vrld/hump/blob/master/class.lua
]]
Class = require 'lib/class'

require 'src/constants'

require 'src/StateMachine'

require 'src/states/BaseState'
require 'src/states/StartState'