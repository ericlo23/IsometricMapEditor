local composer = require("composer")
local Sprite = require("Sprite")

Sprite.setDefaultSrpite("sprites/characters.png", "sprites.characters")
--How to use sprite
--Sprite.new("1/3")

Sprite.addSheet("isotiles", "sprites/isotiles.png", "sprites.isotiles")

composer.gotoScene("scenes.Editor.Editor")
--composer.gotoScene("scenes.Demo")
--composer.gotoScene("scenes.characterdemo")
