-- Tech-tree changes that only apply when this planet is the start planet.
-- Any Planet Start loads this file (see APS.add_planet in data.lua) only in that case.
local utils = require("__any-planet-start__.utils")

utils.remove_tech("recycling", true, true)
utils.set_prerequisites("holmium-processing", nil)
utils.set_prerequisites("lithium-processing", nil)
