--data.lua
local asteroid_util = require("__space-age__.prototypes.planet.asteroid-spawn-definitions")
local planet_catalogue_vulcanus = require("__space-age__.prototypes.planet.procession-catalogue-vulcanus")

require("ithurice")

data:extend{
  {
    type = "noise-expression",
    name = "ithurice_elevation",
    expression = "lerp(blended, maxed, 0.4)",
    local_expressions = {
      maxed = "max(formation_clumped, formation_broken)",
      blended = "lerp(formation_clumped, formation_broken, 0.4)",
      formation_clumped = "-25\z
                          + 12 * max(ithurice_island_peaks, random_island_peaks)\z
                          + 15 * tri_crack",
      formation_broken  = "-20\z
                          + 8 * max(ithurice_island_peaks * 1.1, min(0., random_island_peaks - 0.2))\z
                          + 13 * (pow(voronoi_large * max(0, voronoi_large_cell * 1.2 - 0.2) + 0.5 * voronoi_small * max(0, aux + 0.1), 0.5))",
      random_island_peaks = "abs(amplitude_corrected_multioctave_noise{x = x,\z
                                                                  y = y,\z
                                                                  seed0 = map_seed,\z
                                                                  seed1 = 1000,\z
                                                                  input_scale = segmentation_mult / 1.2,\z
                                                                  offset_x = -10000,\z
                                                                  octaves = 6,\z
                                                                  persistence = 0.8,\z
                                                                  amplitude = 1})",
      voronoi_large = "voronoi_facet_noise{   x = x + aquilo_wobble_x * 2,\z
                                              y = y + aquilo_wobble_y * 2,\z
                                              seed0 = map_seed,\z
                                              seed1 = 'aquilo-cracks',\z
                                              grid_size = 24,\z
                                              distance_type = 'euclidean',\z
                                              jitter = 1}",
      voronoi_large_cell = "voronoi_cell_id{  x = x + aquilo_wobble_x * 2,\z
                                              y = y + aquilo_wobble_y * 2,\z
                                              seed0 = map_seed,\z
                                              seed1 = 'aquilo-cracks',\z
                                              grid_size = 24,\z
                                              distance_type = 'euclidean',\z
                                              jitter = 1}",
      voronoi_small  = "voronoi_facet_noise{   x = x + aquilo_wobble_x * 2,\z
                                              y = y + aquilo_wobble_y * 2,\z
                                              seed0 = map_seed,\z
                                              seed1 = 'aquilo-cracks',\z
                                              grid_size = 10,\z
                                              distance_type = 'euclidean',\z
                                              jitter = 1}",
      tri_crack = "min(aquilo_simple_billows{seed1 = 2000, octaves = 3, input_scale = segmentation_mult / 1.5},\z
                       aquilo_simple_billows{seed1 = 3000, octaves = 3, input_scale = segmentation_mult / 1.2},\z
                       aquilo_simple_billows{seed1 = 4000, octaves = 3, input_scale = segmentation_mult})",
      segmentation_mult = "aquilo_segmentation_multiplier / 25",
    }
  },
  {
    type = "noise-expression",
    name = "ithurice_starting_island",
    expression = "1 - distance * (aquilo_segmentation_multiplier / 225)"
  },
  {
    type = "noise-expression",
    name = "ithurice_island_peaks",
    -- before this point all spots should be in the -1 to 1 range
    expression = "max(1.6 * (0.25 + ithurice_starting_island),\z
                      1.1 * (0.15 + fulgora_vaults_and_starting_vault))"
  },
  
}

--START MAP GEN
function MapGen_Ithurice()
    local map_gen_setting = table.deepcopy(data.raw.planet.fulgora.map_gen_settings)
    map_gen_setting.property_expression_names =
    {
      elevation = "ithurice_elevation",
      temperature = "aquilo_temperature",
      moisture = "moisture_basic",
      aux = "aquilo_aux",
      cliffiness = "fulgora_cliffiness",
      cliff_elevation = "cliff_elevation_from_elevation",
    }
    
    map_gen_setting.autoplace_controls = {

    }
    
    map_gen_setting.cliff_settings ={
      name = "cliff-fulgora",
      control = "fulgora_cliff",
      cliff_elevation_0 = 80,
      -- Ideally the first cliff would be at elevation 0 on the coastline, but that doesn't work,
      -- so instead the coastline is moved to elevation 80.
      -- Also there needs to be a large cliff drop at the coast to avoid the janky cliff smoothing
      -- but it also fails if a corner goes below zero, so we need an extra buffer of 40.
      -- So the first cliff is at 80, and terrain near the cliff shouln't go close to 0 (usually above 40).
      cliff_elevation_interval = 40,
      cliff_smoothing = 0, -- This is critical for correct cliff placement on the coast.
      richness = 0.95
    }

    map_gen_setting.autoplace_settings["tile"] =
    {
        settings =
        {
          ["snow-flat"] = {},
          ["snow-crests"] = {},
          ["snow-lumpy"] = {},
          ["snow-patchy"] = {},
          ["ice-rough"] = {},
          ["ice-smooth"] = {},
          ["brash-ice"] = {},
          ["ammoniacal-ocean"] = {},
          ["ammoniacal-ocean-2"] = {}
        }
    }

    map_gen_setting.autoplace_settings["decorative"] =
    {
      settings =
      {
        ["lithium-iceberg-medium"] = {},
        ["lithium-iceberg-small"] = {},
        ["lithium-iceberg-tiny"] = {},
        ["floating-iceberg-large"] = {},
        ["floating-iceberg-small"] = {},
        ["aqulio-ice-decal-blue"] = {},
        ["aqulio-snowy-decal"] = {},
        ["snow-drift-decal"] = {},

        ["fulgoran-ruin-tiny"] = {},
        ["fulgoran-gravewort"] = {},
        ["urchin-cactus"] = {},
        ["medium-fulgora-rock"] = {},
        ["small-fulgora-rock"] = {},
        ["tiny-fulgora-rock"] = {},
      }
    }

    map_gen_setting.autoplace_settings["entity"] =  { 
        settings = {

        ["lithium-iceberg-huge"] = {},
        ["lithium-iceberg-big"] = {},
        ["ithurice-scrap"] = {},
        ["fulgoran-ruin-vault"] = { },
        ["fulgoran-ruin-attractor"] = { },
        ["fulgoran-ruin-colossal"] = { },
        ["fulgoran-ruin-huge"] = { },
        ["fulgoran-ruin-big"] = { },
        ["fulgoran-ruin-stonehenge"] = { },
        ["fulgoran-ruin-medium"] = { },
        ["fulgoran-ruin-small"] = {},
        ["fulgurite"] = {},
        }
    }
     

    return map_gen_setting
end



--END MAP GEN

local nauvis = data.raw["planet"]["nauvis"]
local aquilo = data.raw["planet"]["aquilo"]
local planet_lib = require("__PlanetsLib__.lib.planet")

local start_astroid_spawn_rate =
{
  probability_on_range_chunk =
  {
    {position = 0.1, probability = asteroid_util.nauvis_chunks, angle_when_stopped = asteroid_util.chunk_angle},
    {position = 0.9, probability = asteroid_util.nauvis_chunks, angle_when_stopped = asteroid_util.chunk_angle}
  },
  type_ratios =
  {
    {position = 0.1, ratios = asteroid_util.nauvis_ratio},
    {position = 0.9, ratios = asteroid_util.nauvis_ratio},
  }
}
local start_astroid_spawn = asteroid_util.spawn_definitions(start_astroid_spawn_rate, 0.1)


local ithurice = 
{
    type = "planet",
    name = "ithurice", 
    solar_power_in_space = aquilo.solar_power_in_space,
    icon = "__planet-ithurice__/graphics/planet-ithurice.png",
    icon_size = 512,
    label_orientation = aquilo.label_orientation,
    starmap_icon = "__planet-ithurice__/graphics/planet-ithurice.png",
    starmap_icon_size = 512,
    magnitude = aquilo.magnitude,
    platform_procession_set =
    {
      arrival = {"planet-to-platform-b"},
      departure = {"platform-to-planet-a"}
    },
    planet_procession_set =
    {
      arrival = {"platform-to-planet-b"},
      departure = {"planet-to-platform-a"}
    },
    procession_graphic_catalogue = planet_catalogue_vulcanus,
    surface_properties = {
        ["day-night-cycle"] = aquilo.surface_properties["day-night-cycle"],
        ["magnetic-field"] = 99,
        ["solar-power"] = aquilo.surface_properties["solar-power"],
        pressure = aquilo.surface_properties["pressure"],
        gravity = aquilo.surface_properties["gravity"]
    },
    map_gen_settings = MapGen_Ithurice(),
    asteroid_spawn_influence = 1,
    asteroid_spawn_definitions = start_astroid_spawn,
    pollutant_type = "pollution",
    entities_require_heating = true,
    persistent_ambient_sounds =
    {
      base_ambience = {filename = "__space-age__/sound/wind/base-wind-vulcanus.ogg", volume = 0.8},
      wind = {filename = "__space-age__/sound/wind/wind-vulcanus.ogg", volume = 0.8},
      crossfade =
      {
        order = {"wind", "base_ambience"},
        curve_type = "cosine",
        from = {control = 0.35, volume_percentage = 0.0},
        to = {control = 2, volume_percentage = 100.0}
      },
      semi_persistent =
      {
        {
          sound = {variations = sound_variations("__space-age__/sound/world/semi-persistent/distant-rumble", 3, 0.5)},
          delay_mean_seconds = 10,
          delay_variance_seconds = 5
        },
        {
          sound = {variations = sound_variations("__space-age__/sound/world/semi-persistent/distant-flames", 5, 0.6)},
          delay_mean_seconds = 15,
          delay_variance_seconds = 7.0
        }
      }
    },
    lightning_properties =
    {
      lightnings_per_chunk_per_tick = 1 / (60 * 10), --cca once per chunk every 10 seconds (600 ticks)
      search_radius = 10.0,
      lightning_types = {"lightning"},
      priority_rules =
      {
        {
          type = "id",
          string = "lightning-collector",
          priority_bonus = 10000
        },
        {
          type = "prototype",
          string = "lightning-attractor",
          priority_bonus = 1000
        },
        {
          type = "id",
          string = "fulgoran-ruin-vault",
          priority_bonus = 95
        },
        {
          type = "id",
          string = "fulgoran-ruin-colossal",
          priority_bonus = 94
        },
        {
          type = "id",
          string = "fulgoran-ruin-huge",
          priority_bonus = 93
        },
        {
          type = "id",
          string = "fulgoran-ruin-big",
          priority_bonus = 92
        },
        {
          type = "id",
          string = "fulgoran-ruin-medium",
          priority_bonus = 91
        },
        {
          type = "prototype",
          string = "pipe",
          priority_bonus = 1
        },
        {
          type = "prototype",
          string = "pump",
          priority_bonus = 1
        },
        {
          type = "prototype",
          string = "offshore-pump",
          priority_bonus = 1
        },
        {
          type = "prototype",
          string = "electric-pole",
          priority_bonus = 10
        },
        {
          type = "prototype",
          string = "power-switch",
          priority_bonus = 10
        },
        {
          type = "prototype",
          string = "logistic-robot",
          priority_bonus = 100
        },
        {
          type = "prototype",
          string = "construction-robot",
          priority_bonus = 100
        },
        {
          type = "impact-soundset",
          string = "metal",
          priority_bonus = 1
        }
      },
      exemption_rules =
      {
        {
          type = "prototype",
          string = "rail-support",
        },
        {
          type = "prototype",
          string = "legacy-straight-rail",
        },
        {
          type = "prototype",
          string = "legacy-curved-rail",
        },
        {
          type = "prototype",
          string = "straight-rail",
        },
        {
          type = "prototype",
          string = "curved-rail-a",
        },
        {
          type = "prototype",
          string = "curved-rail-b",
        },
        {
          type = "prototype",
          string = "half-diagonal-rail",
        },
        {
          type = "prototype",
          string = "rail-ramp",
        },
        {
          type = "prototype",
          string = "elevated-straight-rail",
        },
        {
          type = "prototype",
          string = "elevated-curved-rail-a",
        },
        {
          type = "prototype",
          string = "elevated-curved-rail-b",
        },
        {
          type = "prototype",
          string = "elevated-half-diagonal-rail",
        },
        {
          type = "prototype",
          string = "rail-signal",
        },
        {
          type = "prototype",
          string = "rail-chain-signal",
        },
        {
          type = "prototype",
          string = "locomotive",
        },
        {
          type = "prototype",
          string = "artillery-wagon",
        },
        {
          type = "prototype",
          string = "cargo-wagon",
        },
        {
          type = "prototype",
          string = "fluid-wagon",
        },
        {
          type = "prototype",
          string = "land-mine",
        },
        {
          type = "prototype",
          string = "wall",
        },
        {
          type = "prototype",
          string = "tree",
        },
        {
          type = "countAsRockForFilteredDeconstruction",
          string = "true",
        },
      }
    }
}

ithurice.orbit = {
    parent = {
        type = "space-location",
        name = "star",
    },
    distance = 32,
    orientation = 0.24
}

local ithurice_connection = {
    type = "space-connection",
    name = "vulcanus-ithurice",
    from = "nauvis",
    to = "ithurice",
    subgroup = data.raw["space-connection"]["nauvis-vulcanus"].subgroup,
    length = 45000,
    asteroid_spawn_definitions = asteroid_util.spawn_definitions(asteroid_util.nauvis_vulcanus),
}
data:extend{ithurice_connection}

PlanetsLib:extend({ithurice})

PlanetsLib.borrow_music(data.raw["planet"]["aquilo"], ithurice)

data:extend {{
    type = "technology",
    name = "planet-discovery-ithurice",
    icons = util.technology_icon_constant_planet("__planet-ithurice__/graphics/planet-ithurice.png"),
    icon_size = 512,
    essential = true,
    localised_description = {"space-location-description.ithurice"},
    effects = {
        {
            type = "unlock-space-location",
            space_location = "ithurice",
            use_icon_overlay_constant = true
        },
        {
            type = "unlock-recipe",
            recipe = "lightning-rod",
        },
        {
            type = "unlock-recipe",
            recipe = "ithurice-scrap-recycling",
        },
        {
          type = "unlock-recipe",
          recipe = "heating-tower"
        },
        {
          type = "unlock-recipe",
          recipe = "heat-pipe"
        },
        {
          type = "unlock-recipe",
          recipe = "heat-exchanger"
        },
        {
          type = "unlock-recipe",
          recipe = "steam-turbine"
        }
    },
    prerequisites = {
        "space-science-pack",
    },
    unit = {
        count = 200,
        ingredients = {
            {"automation-science-pack",      1},
            {"logistic-science-pack",        1},
            {"chemical-science-pack",        1},
            {"space-science-pack",           1}
        },
        time = 60,
    },
    order = "ea[ithurice]",
}}


APS.add_planet{name = "ithurice", filename = "__planet-ithurice__/ithurice.lua", technology = "planet-discovery-ithurice"}