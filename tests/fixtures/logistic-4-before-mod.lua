-- AutoTest fixture: a save from before k2so-classic-belts was installed, where kr-logistic-4 is researched
-- but the restored recipes are off (what an existing K2SO save looks like). Built without the mod.
return function()
	local force = game.forces.player
	force.technologies["kr-logistic-4"].researched = true
	for _, name in pairs({ "kr-advanced-transport-belt", "kr-advanced-underground-belt", "kr-advanced-splitter", "kr-advanced-loader" }) do
		local recipe = force.recipes[name]
		if recipe then
			recipe.enabled = false
		end
	end
end
