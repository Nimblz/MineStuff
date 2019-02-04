local PRINT_DEBUG = true

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Common = ReplicatedStorage:WaitForChild("common")
local CommonModules = Common:WaitForChild("module")

local Lib = ReplicatedStorage:WaitForChild("lib")
local PizzaAlpaca = Lib:WaitForChild("pizzaalpaca")

local PizzaAlpacaModules = PizzaAlpaca:WaitForChild("module")
local SidedModules = script.Parent:WaitForChild("module")

local ModuleManager = require(PizzaAlpaca.object.ModuleManager).new(PRINT_DEBUG)

ModuleManager:AddModuleDirectory(PizzaAlpacaModules)
ModuleManager:AddModuleDirectory(CommonModules)
ModuleManager:AddModuleDirectory(SidedModules)

ModuleManager:LoadAllModules()
ModuleManager:InitAllModules()
ModuleManager:StartAllModules()