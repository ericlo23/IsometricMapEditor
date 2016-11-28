local composer = require("composer")
local Sprite = require("sprites.Sprite")

Sprite.addSheet("isotiles", "sprites/isotiles.png", "sprites.isotiles")

--composer.gotoScene("tool.AutoOutliner")

composer.gotoScene("scenes.Editor.Editor")
--composer.gotoScene("scenes.Demo")

--Sprite.setDefaultSrpite("sprites/characters.png", "sprites.characters")
--composer.gotoScene("scenes.characterdemo")
