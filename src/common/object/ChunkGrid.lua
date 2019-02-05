-- 3d sparse table for chunks

local ChunkGrid = {}

function ChunkGrid.new()
    local self = setmetatable({},{__index = ChunkGrid})

    self._root = {}

    return self
end

function ChunkGrid:Get(x,y,z)
    if not self._root[x] then
        self._root[x] = {}
    end

    if not self._root[x][y] then
        self._root[x][y] = {}
    end

    return self._root[x][y][z]
end

function ChunkGrid:Set(x,y,z,val)
    self:Get(x,y,z)
    self._root[x][y][z] = val
end

return ChunkGrid