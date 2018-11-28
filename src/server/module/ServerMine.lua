local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Lib = ReplicatedStorage:WaitForChild("lib")
local PizzaAlpaca = Lib:WaitForChild("pizzaalpaca")

local nTable = require(PizzaAlpaca.object.nTable)
local Settings = require(script.Parent.GameSettings.lua)

local Blocks

local CHUNK_SIZE = Settings.CHUNK_SIZE

local ServerMine = {}

local function TruncateCoords(x,y,z)
    return x%CHUNK_SIZE.x,y%CHUNK_SIZE.y,z%CHUNK_SIZE.z
end

function ServerMine:Init()
    self.ChunkData = nTable.new() -- Sparse chunk data
end

function ServerMine:Start(moduleManager)
    Blocks = moduleManager:GetModule("BlockDictionary"):GetBlocks()
end

function ServerMine:GetChunkAt(x,y,z)
    return self.ChunkData
        [math.ceil(x/CHUNK_SIZE.x)]
        [math.ceil(y/CHUNK_SIZE.y)]
        [math.ceil(z/CHUNK_SIZE.z)]
end

function ServerMine:TryToMine(player,x,y,z)
    if player == "server" then -- Server is allowed to mine with no restriction
        self:Mine(player,x,y,z)
    else
        -- check if player can mine
        local CanMine = true -- true always for now

        if CanMine then
            self:Mine(player,x,y,z)
        end
    end
end
function ServerMine:Mine(player,x,y,z) -- Mine in global coords
    local Chunk = self:GetChunkAt(x,y,z)
    local Mined = Chunk:GetBlock(TruncateCoords(x,y,z))
    Chunk:SetBlock(TruncateCoords(x,y,z),Blocks.AIR)
    -- TODO: Give credit

end

return ServerMine