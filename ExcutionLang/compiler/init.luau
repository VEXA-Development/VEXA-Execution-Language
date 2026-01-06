local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TemporaryCageMeshProvider = game:GetService("TemporaryCageMeshProvider")
local SpecialValue = require(ReplicatedStorage.Shared.Util.SpecialValue).compiler
local Config = require(script.Parent.constances.Config)
local types = require(script.Parent.constances.Types)

local functions = script.Parent.constances.functions


local OgPrint = print
local OgError = error

local function print(...)
  OgPrint(`[{script.Name}]` , ...)
end

local function error(Text:any , level)
  level = level or 1
  OgError(`[{script.Name}] {Text}`  , level)
end





local function RemoveWhiteSpace(Code:string)
  local newString = ""

  local last = ""

  for _ , V in Code:split("") do
    if V == " " or V == "\t" then
      if last == "" then
        continue
      elseif last ~= " " and last ~= "\t" and last ~= ";" and last ~= ":" then
        newString ..= ":"
        last = ":"
        continue
      elseif last == ";" or last == ":" then
        continue
      end
    elseif V == "\n" then
      continue
    else
      newString ..= V
    end
    last = V
  end




  return newString
end


local function MakeInstruction(Line:string , LineNumber:number , TempCache: {[string]:boolean})
  if Line == "" then
    return nil
  end

  local split = Line:split(":")
  local instruction: types.Instruction = {instruction = split[1] , value = ""}






  local isTable = if Line:match("{") then true else false

  if isTable then
    instruction.value = split[2]:split("{")[2]:split("}")[1]:split(",")
  else
    instruction.value = split[2]
  end




  if Config.CompilerFunctionCheck then
    if functions:FindFirstChild(instruction.instruction) == nil then
      error(`"{instruction.instruction}" Not found in functions folder. Line {LineNumber}`)
    end
  end

  if Config.CompilerCacheCheck then
    local value = instruction.value


    if typeof(value) == "string" and tonumber(value) == nil then
      local temp , Passed , returnedValue = SpecialValue(TempCache, value)

      if Passed ~= true then
        error(Passed)
      end

      if returnedValue then
        value = returnedValue
      end

      TempCache = temp

    elseif typeof(value) == "table" then

      for m , V in value do 
        if typeof(V) == "string" and (tonumber(V) == nil) then
          local temp , Passed , returnedValue = SpecialValue(TempCache, V)
          print(temp . passed , 109)
          if Passed ~= true then
            error(Passed)
          end

          if returnedValue then
            value = returnedValue
          end

          TempCache = temp
        end
        print(V , 120 , type(V) , tonumber(V))
      end
    end

    print(value , 124 , type(value) , tonumber(value))

    if functions:FindFirstChild(instruction.instruction) then
      local Info = require(functions:FindFirstChild(instruction.instruction))

      if Info.CompilerCheckCallback then
        local temp, e = Info.CompilerCheckCallback(TempCache , value)

        if e ~= true then
          error(e)
        end
        TempCache = temp
      end
    end
  end

  return instruction,TempCache
end



return function(Code: string ) : types.compiledCode
  local template: types.compiledCode = {instructions = {} , cache = {}, ActiveValue = 0}

  Code = RemoveWhiteSpace(Code)

  local tempCache = {}

  print(Code)
  for i , V in Code:split(";") do
    local instruction = nil
    instruction , tempCache = MakeInstruction(V , i ,tempCache)

    table.insert(template.instructions , instruction)
  end

  print(template)


  return template
end