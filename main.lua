local composer = require("composer")
local Sprite = require("sprites.Sprite")

--local performance = require("util.performance")
--performance:newPerformanceMeter()

Sprite.addSheet("isotiles", "sprites/isotiles.png", "sprites.isotiles")

--composer.gotoScene("tool.AutoOutliner")

composer.gotoScene("scenes.Editor")
--composer.gotoScene("scenes.Demo")

--Sprite.setDefaultSrpite("sprites/characters.png", "sprites.characters")
--composer.gotoScene("scenes.characterdemo")
