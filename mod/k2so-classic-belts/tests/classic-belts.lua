-- Tests for k2so-classic-belts, run with FactorioTest (see AutoTest/README.md in the author's workspace).
-- Loaded only when the factorio-test mod is active; never runs in a normal game.

local function assert_equal(actual, expected, what)
	assert(actual == expected, string.format("%s: expected %s, got %s", what, tostring(expected), tostring(actual)))
end

local function has_fluid(recipe)
	for _, ingredient in pairs(recipe.ingredients) do
		if ingredient.type == "fluid" then
			return true
		end
	end
	return false
end

describe("express underground belt", function()
	test("max distance is 20 again", function()
		assert_equal(prototypes.entity["express-underground-belt"].max_underground_distance, 20, "max_underground_distance")
	end)

	-- Own lab-tile surface, so the test runs the same on FactorioTest's empty save and on a real base.
	local surface
	before_all(function()
		surface = game.create_surface("classic-belts-test")
		surface.generate_with_lab_tiles = true
		surface.request_to_generate_chunks({ 0, 0 }, 2)
		surface.force_generate_chunk_requests()
	end)
	after_all(function()
		game.delete_surface(surface)
	end)

	-- The entrance faces east, the exit is placed `gap` tiles further east.
	local function place_pair(gap)
		local y = 10 + gap
		local input = surface.create_entity({
			name = "express-underground-belt", position = { 0.5, y + 0.5 }, direction = defines.direction.east,
			type = "input", force = "player",
		})
		local output = surface.create_entity({
			name = "express-underground-belt", position = { gap + 0.5, y + 0.5 }, direction = defines.direction.east,
			type = "output", force = "player",
		})
		after_test(function()
			input.destroy()
			output.destroy()
		end)
		return input, output
	end

	test("connects at 20 tiles", function()
		local input, output = place_pair(20)
		assert(input.underground_belt_neighbour == output, "entrance and exit 20 tiles apart are not connected")
	end)

	test("does not connect at 21 tiles", function()
		local input = place_pair(21)
		assert(input.underground_belt_neighbour == nil, "entrance and exit 21 tiles apart are connected")
	end)
end)

describe("K2 advanced belts are back", function()
	local names = { "kr-advanced-transport-belt", "kr-advanced-underground-belt", "kr-advanced-splitter" }

	test.each(names)("%s: entity, item and recipe not hidden", function(name)
		assert(prototypes.entity[name], "entity missing")
		assert(not prototypes.entity[name].hidden, "entity hidden")
		assert(prototypes.item[name], "item missing")
		assert(not prototypes.item[name].hidden, "item hidden")
		assert(prototypes.recipe[name], "recipe missing")
		assert(not prototypes.recipe[name].hidden, "recipe hidden")
	end)

	test("kr-logistic-4 technology not hidden", function()
		assert(not prototypes.technology["kr-logistic-4"].hidden, "technology hidden")
	end)

	test("researching kr-logistic-4 enables the restored recipes", function()
		local force = game.forces.player
		local tech = force.technologies["kr-logistic-4"]
		local was_researched = tech.researched
		after_test(function()
			tech.researched = was_researched
		end)
		tech.researched = true
		for _, name in pairs({ "kr-advanced-transport-belt", "kr-advanced-underground-belt", "kr-advanced-splitter", "kr-advanced-loader" }) do
			assert(force.recipes[name].enabled, name .. " not enabled")
		end
	end)
end)

-- Save made without this mod, kr-logistic-4 researched and the restored recipes off
-- (ClassicBelts/tests/fixtures/logistic-4-before-mod.lua). Loading it with the mod must turn them on.
tags("fixture", "fixture:logistic-4-before-mod")
describe("added to a save that already researched kr-logistic-4", function()
	test.each({ "kr-advanced-transport-belt", "kr-advanced-underground-belt", "kr-advanced-splitter", "kr-advanced-loader" })(
		"%s is enabled",
		function(name)
			local force = game.forces.player
			assert(force.technologies["kr-logistic-4"].researched, "fixture: kr-logistic-4 not researched")
			assert(force.recipes[name].enabled, name .. " not enabled")
		end
	)
end)

describe("express logistics are hand-craftable without lubricant", function()
	test.each({ "express-splitter", "express-underground-belt", "kr-express-loader" })("%s", function(name)
		local recipe = prototypes.recipe[name]
		assert(not has_fluid(recipe), "has a fluid ingredient")
		assert(recipe.has_category("crafting"), "not in the crafting category")
	end)
end)

describe("K2 advanced loader recipe", function()
	test("ingredients are K2's original ones", function()
		local expected = { ["kr-advanced-transport-belt"] = 1, ["kr-express-loader"] = 2, ["kr-rare-metals"] = 10 }
		local recipe = prototypes.recipe["kr-advanced-loader"]
		local count = 0
		for _, ingredient in pairs(recipe.ingredients) do
			assert_equal(ingredient.amount, expected[ingredient.name], ingredient.name)
			count = count + 1
		end
		assert_equal(count, 3, "ingredient count")
	end)

	test("hand-craftable anywhere", function()
		local recipe = prototypes.recipe["kr-advanced-loader"]
		assert(recipe.has_category("crafting"), "not in the crafting category")
		assert(recipe.surface_conditions == nil or #recipe.surface_conditions == 0, "has surface conditions")
	end)

	test("unlocked by kr-logistic-4", function()
		for _, effect in pairs(prototypes.technology["kr-logistic-4"].effects) do
			if effect.type == "unlock-recipe" and effect.recipe == "kr-advanced-loader" then
				return
			end
		end
		error("kr-logistic-4 does not unlock kr-advanced-loader")
	end)
end)
