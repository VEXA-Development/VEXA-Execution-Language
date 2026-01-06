local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SpecialValues = script.Parent.Parent.constances.SpecialValues


local Types = require(script.Parent.Parent.constances.Types)

local function SpecialValueExcutor(compiledCode , line:string)
  local split = line:split(`(`)

  if SpecialValues:FindFirstChild(split[1]) then
    local Special:Types.SpecialValue = require(SpecialValues:FindFirstChild(split[1]))
    local value = ""

    if split[2] then
      if split[2]:split(")")[1]:split(`"`)[2] then
        value = split[2]:split(")")[1]:split(`"`)[2]
      end
    end


    return Special.callback(compiledCode, value)
  else
    return line:split(`"`)[2]
  end
end


local function SpecialValueCompilerCheck(TempCache , line:string)
  local split = line:split(`(`)

  if SpecialValues:FindFirstChild(split[1]) then
    local Special:Types.SpecialValue = require(SpecialValues:FindFirstChild(split[1]))
    local value = ""

    if split[2] then
      if split[2]:split(")")[1]:split(`"`)[2] then
        value = split[2]:split(")")[1]:split(`"`)[2]
      end
    end
    if Special.CompilerCheckCallback then
      return Special.CompilerCheckCallback(TempCache, value)
    end

    return TempCache , true
  else
    return TempCache , true , line:split(`"`)[2]
  end
end


return {excutor = SpecialValueExcutor, compiler = SpecialValueCompilerCheck}