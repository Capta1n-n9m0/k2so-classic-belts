-- Runs after Krastorio2-spaced-out's data-updates (hard dependency), so every value set here wins over K2SO,
-- and other mods' data-final-fixes (recycling, down-binning, stacking) see the restored prototypes.

-- 1. Express underground belt reach: K2SO cuts it 20 -> 15.
data.raw["underground-belt"]["express-underground-belt"].max_distance = 20

-- 2. K2 advanced belt, underground belt and splitter: K2SO hides the items, recipes and entities
--    and hides their technology (kr-logistic-4). Unhide them; the recipes are still K2's own.
local hidden_types = { "recipe", "item", "transport-belt", "underground-belt", "splitter" }
for _, name in pairs({ "kr-advanced-transport-belt", "kr-advanced-underground-belt", "kr-advanced-splitter" }) do
	for _, type in pairs(hidden_types) do
		local prototype = data.raw[type][name]
		if prototype then
			prototype.hidden = nil
			prototype.hidden_in_factoriopedia = nil
		end
	end
end
local logistic_4 = data.raw.technology["kr-logistic-4"]
if logistic_4 then
	logistic_4.hidden = nil
	logistic_4.hidden_in_factoriopedia = nil
end

-- 3. Hand-craftable express logistics: K2SO adds lubricant and moves these recipes to
--    crafting-with-fluid/metallurgy. Drop the fluid ingredients and put them back in plain crafting.
local function without_fluids(recipe_name)
	local recipe = data.raw.recipe[recipe_name]
	if not recipe then
		return
	end
	local ingredients = {}
	for _, ingredient in pairs(recipe.ingredients or {}) do
		if ingredient.type ~= "fluid" then
			ingredients[#ingredients + 1] = ingredient
		end
	end
	recipe.ingredients = ingredients
	recipe.categories = { "crafting" }
end
without_fluids("express-splitter")
without_fluids("express-underground-belt")
without_fluids("kr-express-loader")

-- K2SO rebuilt the advanced loader around Vulcanus (turbo belt, tungsten, lubricant, 4000 pressure).
-- Restore the K2 recipe, which uses the advanced belt again, and K2's unlock on kr-logistic-4.
local advanced_loader = data.raw.recipe["kr-advanced-loader"]
if advanced_loader then
	advanced_loader.categories = { "crafting" }
	advanced_loader.surface_conditions = nil
	advanced_loader.ingredients = {
		{ type = "item", name = "kr-advanced-transport-belt", amount = 1 },
		{ type = "item", name = "kr-express-loader", amount = 2 },
		{ type = "item", name = "kr-rare-metals", amount = 10 },
	}
	if logistic_4 then
		local unlocked = false
		for _, effect in pairs(logistic_4.effects or {}) do
			if effect.type == "unlock-recipe" and effect.recipe == "kr-advanced-loader" then
				unlocked = true
			end
		end
		if not unlocked then
			logistic_4.effects = logistic_4.effects or {}
			table.insert(logistic_4.effects, { type = "unlock-recipe", recipe = "kr-advanced-loader" })
		end
	end
end
