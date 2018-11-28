local ReplicatedStorage = game:GetService("ReplicatedStorage")
local t = require(ReplicatedStorage.lib.t.t)

return {
    FromClient = {
        RequestWorld = {
            Arguments = t.tuple(),
        },
    },
    FromServer = {
        ChunkUpdated = {
            Arguments = t.tuple(t.number,t.number,t.number,t.table)
        }
    }
}