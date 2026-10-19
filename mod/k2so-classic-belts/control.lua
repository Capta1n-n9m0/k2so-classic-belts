-- A recipe unlock added to an already researched technology is not applied to existing saves, so enable the
-- restored recipes directly for every force that has kr-logistic-4. (Not reset_technology_effects(): that would
-- also recompute bonuses other mods set by script.)
local recipes = {
	"kr-advanced-transport-belt",
	"kr-advanced-underground-belt",
	"kr-advanced-splitter",
	"kr-advanced-loader",
}

local function refresh()
	for _, force in pairs(game.forces) do
		local tech = force.technologies["kr-logistic-4"]
		if tech and tech.researched then
			for _, name in pairs(recipes) do
				local recipe = force.recipes[name]
				if recipe then
					recipe.enabled = true
				end
			end
		end
	end
end

script.on_init(refresh)
script.on_configuration_changed(refresh)

if script.active_mods["factorio-test"] then
	require("__factorio-test__/init")({ "tests/classic-belts" })
end
