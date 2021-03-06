-- Object used to hold chunk data, kept track of by servermine, passed to rasterizer.

local Settings = require(script.Parent.Parent.GameSettings)
local CHUNK_SIZE = Settings.CHUNK_SIZE

local Chunk = {}

local function GetFlatIndex(x,y,z)
    return x + (y * CHUNK_SIZE.X) + (z * CHUNK_SIZE.X * CHUNK_SIZE.Z)
end

function Chunk.new(cx,cy,cz)
    local self = setmetatable({},{__index = Chunk})

    self.ChunkPos = Vector3.new(cx,cy,cz)
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