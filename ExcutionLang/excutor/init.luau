local ReplicatedStorage = game:GetService("ReplicatedStorage")
local functions = script.Parent.constances.functions


local SpecialValue = require(ReplicatedStorage.Shared.Util.SpecialValue).excutor
local Config = require(ReplicatedStorage.Shared.constances.Config)
local Types = require(script.Parent.constances.Types)



local function ExcuteInstruction(compiledCode:Types.compiledCode , func: string , value: number | {number} | string , LineNumber: number)
  if functions:FindFirstChild(func) then
    local funcInfo: Types.func = require(functions:FindFirstChild(func))
    --print(compiledCode)

    return funcInfo.callback(compiledCode, value)
  else
    if Config.OnErrorStop == false then
      warn(`{func} Not found. Line {LineNumber}`)
    else
      warn(`{func} Not found. Line {LineNumber}`)
      return false
    end
  end
  return compiledCode
end

return function(compiledCode: Types.compiledCode)
  for i , V in compiledCode.instructions do
    local value = V.value

    if typeof(value) == "string" and tonumber(value) == nil then

      value = SpecialValue(compiledCode, value)

    elseif typeof(value) == "table" then

      for m , V in value do 
        if typeof(V) == "string" and tonumber(V) == nil then
          value[m] = SpecialValue(compiledCode, V)
        else
          value[m] = tonumber(V)
        end
      end
    end
    local newCompiledCode = ExcuteInstruction(compiledCode , V.instruction , value , i)

    if newCompiledCode == false then
      return  nil
    end


    compiledCode = ExcuteInstruction(compiledCode , V.instruction , value , i)
  end

  --print(compiledCode.ActiveValue)
  return compiledCode.ActiveValue
end