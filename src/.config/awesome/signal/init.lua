-- Allows all signals to be connected and/or emitted
return {
    client = require(... .. ".client"),
    tag = require(... .. ".tag"), -- NOTE: The `tag` file must be loaded before `screen`
    screen = require(... .. ".screen"),
}
