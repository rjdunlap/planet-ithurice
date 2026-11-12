local resource_autoplace = require("resource-autoplace")
local sounds = require("__base__.prototypes.entity.sounds")
local simulations = require("__space-age__.prototypes.factoriopedia-simulations")
local item_sounds = require("__base__.prototypes.item_sounds")


local merge = require("lib").merge

-- Custom Scrap

data:extend({
	merge(data.raw.resource["scrap"], {
		name = "xithurice-scrap",
		icon_size = 64,
		order = "w-a[xithurice-scrap]",
		minable = merge(data.raw.resource["scrap"].minable, {
			mining_time = 0.50,
			result = "xithurice-scrap",
		}),
		map_color = { 0.77, 0.55, 0.55 },
		map_grid = true,
		factoriopedia_simulation = "nil",
	}),})

data:extend{{
    type = "item",
    name = "xithurice-scrap",
    icon = "__space-age__/graphics/icons/scrap.png",
    pictures =
    {
      { size = 64, filename = "__space-age__/graphics/icons/scrap.png",   scale = 0.5, mipmap_count = 4 },
      { size = 64, filename = "__space-age__/graphics/icons/scrap-1.png", scale = 0.5, mipmap_count = 4 },
      { size = 64, filename = "__space-age__/graphics/icons/scrap-2.png", scale = 0.5, mipmap_count = 4 },
      { size = 64, filename = "__space-age__/graphics/icons/scrap-3.png", scale = 0.5, mipmap_count = 4 },
      { size = 64, filename = "__space-age__/graphics/icons/scrap-4.png", scale = 0.5, mipmap_count = 4 },
      { size = 64, filename = "__space-age__/graphics/icons/scrap-5.png", scale = 0.5, mipmap_count = 4 }
    },
    subgroup = "fulgora-processes",
    order = "a[xithurice-scrap]-a[xithurice-scrap]",
    inventory_move_sound = item_sounds.resource_inventory_move,
    pick_sound = item_sounds.resource_inventory_pickup,
    drop_sound = item_sounds.resource_inventory_move,
    stack_size = 25,
    default_import_location = "ithurice",
    weight = 2*kg
  }
}

-- barrel
for _,fluid in pairs (data.raw.fluid) do 
  if fluid.name == "fluorine" or  
     fluid.name == "lithium-brine"  then
    fluid.auto_barrel = true
  end
end

data:extend{
{
    type = "recipe",
    name = "xithurice-scrap-recycling",
    icons = {
      {
        icon = "__recycler__/graphics/icons/recycling.png"
      },
      {
        icon = "__space-age__/graphics/icons/scrap.png",
        scale = 0.4
      },
      {
        icon = "__recycler__/graphics/icons/recycling-top.png"
      }
    },
    categories = {"recycling", "hand-crafting"},
    subgroup = "fulgora-processes",
    order = "a[trash]-a[trash-recycling]",
    enabled = false,
    auto_recycle = false,
    energy_required = 0.6,
    ingredients = {{type = "item", name = "xithurice-scrap", amount = 1}},
    results =
    {
      {type = "item", name = "ice",                       amount = 1, independent_probability = 0.30, show_details_in_recipe_tooltip = false},
      {type = "item", name = "scrap",                     amount = 1, independent_probability = 0.20, show_details_in_recipe_tooltip = false},
      {type = "item", name = "crude-oil-barrel",          amount = 1, independent_probability = 0.05, show_details_in_recipe_tooltip = false},
      {type = "item", name = "coal",                      amount = 1, independent_probability = 0.03, show_details_in_recipe_tooltip = false},
      {type = "item", name = "fluorine-barrel",           amount = 1, independent_probability = 0.02, show_details_in_recipe_tooltip = false},
      {type = "item", name = "lithium-brine-barrel",      amount = 1, independent_probability = 0.02, show_details_in_recipe_tooltip = false},
      {type = "item", name = "ice-platform",              amount = 1, independent_probability = 0.02, show_details_in_recipe_tooltip = false},
      {type = "item", name = "holmium-ore",               amount = 1, independent_probability = 0.02, show_details_in_recipe_tooltip = false},
      {type = "item", name = "burner-mining-drill",       amount = 1, independent_probability = 0.02, show_details_in_recipe_tooltip = false},
      {type = "item", name = "copper-cable",              amount = 1, independent_probability = 0.02, show_details_in_recipe_tooltip = false},
      {type = "item", name = "lithium",                   amount = 1, independent_probability = 0.01, show_details_in_recipe_tooltip = false},
      {type = "item", name = "wood",                      amount = 1, independent_probability = 0.01, show_details_in_recipe_tooltip = false},
    }
  }
}

-- Let the vanilla "Scrap recycling productivity" research apply to this scrap recipe as well.
do
  local tech = data.raw.technology["scrap-recycling-productivity"]
  if tech and data.raw.recipe["xithurice-scrap-recycling"] then
    tech.effects = tech.effects or {}
    table.insert(tech.effects, {type = "change-recipe-productivity", recipe = "xithurice-scrap-recycling", change = 0.1})
  end
end
