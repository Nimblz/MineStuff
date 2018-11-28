local BlockDictionary = {}

local Blocks

local function CompileBlocks()
    local CompilingBlocks = {}
    for _,child in pairs(script:GetDescendants()) do
        if child:IsA("ModulesScript") then
            local Module = require(child)

            for classname,block in pairs(Module) do
                if CompilingBlocks[classname] then
                    warn("Block conflict!: "..classname)
                else
                    CompilingBlocks[classname] = block
                end
            end
        end
    end

    return CompilingBlocks
end

function BlockDictionary:Init()
    Blocks = CompileBlocks()
end

function BlockDictionary:Start()
end

function BlockDictionary:GetBlocks()
    return Blocks
end

return BlockDictionary