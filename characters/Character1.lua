local Character = require("Character")
local Sprite = require("sprites.Sprite")
local Ch ={}

Ch.new = function()
    local character = Character.new()

    local sprite = Sprite.newAnimation({
        {
            name = "run",
            frames = {
                "1/6",
                "1/7"
            },
            time = 300
        }
    })
    character:insert(sprite)
    character.sprite = sprite

    function character:run()
        character.sprite:setSequence("run")
        character.sprite:play()
    end

    return character
end

return Ch