local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local Remote = ReplicatedStorage:WaitForChild("remote")

local Settings = require(ReplicatedStorage.common.GameSettings)
local Chunk = require(ReplicatedStorage.common.object.Chunk)
local ChunkGrid = require(ReplicatedStorage.common.object.ChunkGrid)

local Blocks

local CHUNK_SIZE = Settings.CHUNK_SIZE

local ServerMine = {}

local function OverflowCoords(x,y,z)
    return Vector3.new(x%CHUNK_SIZE.x,y%CHUNK_SIZE.y,z%CHUNK_SIZE.z)
end

function ServerMine:Init()
    self.NumChunks = 0
    self.ChunkData = ChunkGrid.new() -- Sparse chunk data
end

function ServerMine:Start(moduleManager)
    Blocks = moduleManager:GetModule("BlockDictionary"):GetBlocks()

    for x = -4,4 do
        for z = -4,4 do
            self:SetBlockAt(x,-1,z, Blocks.UNBREAKIUM)
        end
    end

    -- Mine out a square for players to start in
    for y = 0,4 do
        for x = -4,4 do
            for z = -4,4 do
                self:Mine("server",x,y,z)

                local BlockPart = Instance.new("Part")
                BlockPart.Size = Settings.BLOCK_SIZE
                BlockPart.CFrame = CFrame.new(Settings.BLOCK_SIZE * Vector3.new(x,y,z))
                BlockPart.Anchored = true
                BlockPart.CanCollide = false
                BlockPart.Transparency = 1
                BlockPart.Color = Color3.new(0,1,0)
                BlockPart.Parent = Workspace

                local Outline = Instance.new("SelectionBox",BlockPart)

                Outline.LineThickness = 0.1
                Outline.SurfaceTransparency = 1
                Outline.Color3 = BlockPart.Color
                Outline.SurfaceColor3 = BlockPart.Color
                Outline.Adornee = BlockPart
            end
        end
    end

    Remote:WaitForChild("GetChunk").OnServerInvoke = function(player,x,z,y)
        assert(type(x) == "number")
        assert(type(y) == "number")
        assert(type(z) == "number")

        return self:GetChunkAt(x,y,z)
    end
end

function ServerMine:GetChunkData()
    return self.ChunkData
end

function ServerMine:NewChunkAt(x,y,z)
    if not self.ChunkData:Get(x,y,z) then
        self.ChunkData:Set(x,y,z,Chunk.new())
        self.ChunkData:Get(x,y,z):Fill(Blocks.STONE)

        self.NumChunks = self.NumChunks + 1

        local ChunkPart = Instance.new("Part")
        ChunkPart.Name = x.." "..y.." "..z
        ChunkPart.Size = Settings.CHUNK_SIZE * Settings.BLOCK_SIZE
        ChunkPart.CFrame = CFrame.new(
            (Settings.CHUNK_SIZE * Settings.BLOCK_SIZE * (Vector3.new(x,y,z))) + -- Chunk position scaled to world
            (Settings.CHUNK_SIZE * Settings.BLOCK_SIZE * 0.5) -- Half chunk offset to align part center
        )
        ChunkPart.Anchored = true
        ChunkPart.CanCollide = false
        ChunkPart.Transparency = 1
        ChunkPart.Color = Color3.new(1,0,0)
        ChunkPart.Parent = Workspace

        local Outline = Instance.new("SelectionBox",ChunkPart)

        Outline.LineThickness = 0
        Outline.SurfaceTransparency = 1
        Outline.Color3 = ChunkPart.Color
        Outline.Adornee = ChunkPart
    end
end

function ServerMine:MakeChunksAt(x,y,z)
    -- Make chunk in this pos
    self:NewChunkAt(x,y,z)

    for dx = -1,1,2 do
        self:NewChunkAt(x+dx,y,z)
    end
    for dy = -1,1,2 do
        self:NewChunkAt(x,y+dy,z)
    end
    for dz = -1,1,2 do
        self:NewChunkAt(x,y,z+dz)
    end
end

function ServerMine:GetChunkAt(x,y,z)
    local ChunkPosX, ChunkPosY, ChunkPosZ =
        math.floor(x/CHUNK_SIZE.x),
        math.floor(y/CHUNK_SIZE.y),
        math.floor(z/CHUNK_SIZE.z)

    return self.ChunkData:Get(ChunkPosX,ChunkPosY,ChunkPosZ)
end

function ServerMine:GetOrGenChunkAt(x,y,z)
    local ChunkPosX, ChunkPosY, ChunkPosZ =
        math.floor(x/CHUNK_SIZE.x),
        math.floor(y/CHUNK_SIZE.y),
        math.floor(z/CHUNK_SIZE.z)

    self:MakeChunksAt(ChunkPosX,ChunkPosY,ChunkPosZ);

    return self.ChunkData:Get(ChunkPosX,ChunkPosY,ChunkPosZ)
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
    local WorldChunk = self:GetOrGenChunkAt(x,y,z)
    local LocalBlock = OverflowCoords(x,y,z)
    local Mined = WorldChunk:GetBlock(LocalBlock.x,LocalBlock.y,LocalBlock.z)
    WorldChunk:SetBlock(LocalBlock.x,LocalBlock.y,LocalBlock.z,Blocks.AIR)

    -- TODO: Give credit.

    return Mined
end

function ServerMine:SetBlockAt(x,y,z,blocktype)
    local WorldChunk = self:GetOrGenChunkAt(x,y,z)
    local LocalBlock = OverflowCoords(x,y,z)
    WorldChunk:SetBlock(LocalBlock.x,LocalBlock.y,LocalBlock.z,blocktype)
end

return ServerMine