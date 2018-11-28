local Settings = require(script.Parent.GameSettings.lua)
local CHUNK_SIZE = Settings.CHUNK_SIZE

local Chunk = {}

local function GetFlatIndex(x,y,z)
    return x + (y * CHUNK_SIZE.WIDTH) + (z * CHUNK_SIZE.X * CHUNK_SIZE.Z)
end

function Chunk.new()
    local self = setmetatable({},{__index = Chunk})

    self.ChunkData = {}

    return self
end

function Chunk:Fill(val) -- Fills entire chunk with val
    for i = 1, CHUNK_SIZE.X*CHUNK_SIZE.Y*CHUNK_SIZE.Z do
        self.ChunkData[i] = val
    end

    return self
end

function Chunk:SetBlock(x,y,z,val)
    self.ChunkData[GetFlatIndex(x,y,z)] = val
    return self
end

function Chunk:GetBlock(x,y,z)
    return self.ChunkData[GetFlatIndex(x,y,z)]
end

return Chunk