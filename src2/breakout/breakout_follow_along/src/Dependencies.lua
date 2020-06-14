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

-- some global constants
require 'src/constants'

require 'src/Paddle'

--[[
    A simple state machine class
]]
require 'src/StateMachine'

require 'src/Util'

require 'src/states/BaseState'
require 'src/states/StartState'