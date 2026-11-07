-- JSX lexer for Scintillua: JavaScript plus tags and attributes
local lexer = lexer
local P, S, V = lpeg.P, lpeg.S, lpeg.V

local js_lex = lexer.load('javascript')
local lex = lexer.new(..., { inherit = js_lex })

local ws = lex:tag(lexer.WHITESPACE, lexer.space^1)
local name = lexer.word * ('.' * lexer.word)^0
-- Quoted strings stop at end of line, so a stray apostrophe outside a matched element doesn't run on
local str = lex:tag(lexer.STRING, lexer.range("'", true) + lexer.range('"', true) + lexer.range('`'))
local regex = lex:tag(lexer.REGEX, lexer.after_set('+-*%^!=&|?:;,([{<>', lexer.range('/', true) * S('igm')^0))

-- JavaScript tokens inside {...}; braces are left to the `expr` rule so they nest
local js = ws + lex:get_rule('comment') + str + regex + lex:get_rule('number')
  + lex:get_rule('keyword') + lex:get_rule('type') + lex:get_rule('function')
  + lex:get_rule('constant') + lex:get_rule('identifier')
  + lex:tag(lexer.OPERATOR, S('+-/*%^!=&|?:;,.()[]<>~'))

-- A whole element: <Foo.Bar attr="..." {...spread}>children</Foo.Bar>, <br />, or <>fragment</>
-- If it doesn't match fully (e.g. `a < b`), lexing falls back to the JavaScript rules
local grammar = {'el',
  el = lex:tag(lexer.TAG, '<' * (name + #P('>'))) * (ws + V'attr' + V'expr')^0
    * (lex:tag(lexer.TAG, '/>')
      + lex:tag(lexer.TAG, '>') * V'children' * lex:tag(lexer.TAG, '</' * name^-1 * '>')),
  attr = lex:tag(lexer.ATTRIBUTE, lexer.word * (P('-') * lexer.word)^0)
    * (lex:tag(lexer.OPERATOR, '=') * (str + V'expr'))^-1,
  children = (V'el' + V'expr' + lex:tag(lexer.DEFAULT, (1 - S('<{'))^1))^0,
  expr = lex:tag(lexer.OPERATOR, '{') * (V'el' + V'expr' + js)^0 * lex:tag(lexer.OPERATOR, '}'),
}
-- keyword/type/etc. rules reference JavaScript's word lists by grammar rule name, so define them here too
for i, list in ipairs(js_lex._WORDLISTS) do grammar['javascript_wordlist' .. i] = lexer.word_match(list) end
local element = P(grammar)

lex:modify_rule('string', element + str + regex)

return lex
