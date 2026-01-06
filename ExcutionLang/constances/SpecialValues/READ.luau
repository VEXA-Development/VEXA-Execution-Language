local Types = require(script.Parent.Parent.Types)



return {
  callback = function (compiledCode: Types.compiledCode , value)
    if compiledCode.ActiveValue then -- to shut up the linter
      return compiledCode.cache[value]
    end
    return nil
  end,
  CompilerCheckCallback = function(TempCache , Value)
    if TempCache[Value] == nil then
      return TempCache , `{Value} Not Found In cache.`
    end
    return TempCache , true
  end,
}