local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Common = ReplicatedStorage:WaitForChild("common")

local Module = require(Common:WaitForChild("Module"))

Module.HelloWorld()