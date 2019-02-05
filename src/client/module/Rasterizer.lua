-- Handles the creation of parts for chunks

local Rasterizer = {}

local ClientMine

-- fired when character enters a new chunk
function EnteredNewChunk(x,y,z)

end

function Rasterizer:RenderStep()
    
end

function Rasterizer:Init()

end

function Rasterizer:Start(modManager)
    ClientMine = modManager:GetModule("ClientMine")
end

return Rasterizer