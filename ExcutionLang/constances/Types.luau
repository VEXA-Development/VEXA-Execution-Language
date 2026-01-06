type valuesWstring = string | {string | number} | number
type values = {string | number} | number

export type Instruction = {
  instruction: string ,
  value: valuesWstring,
}


export type compiledCode = {
  instructions: {[number]:Instruction},
  cache: {[string]:number | {number}?},
  ActiveValue: number | {number}
}


export type func = {
  callback: (compiledCode , valuesWstring) -> compiledCode,
  CompilerCheckCallback: ({[string]:boolean} , string) -> {[string]:boolean} | boolean?,
}


export type SpecialValue = {
  callback: (compiledCode , valuesWstring) -> values,
  CompilerCheckCallback: ({[string]:boolean} , string) -> {[string]:boolean} | boolean?,
}









return nil