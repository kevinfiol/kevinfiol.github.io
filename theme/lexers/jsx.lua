-- JSX lexer for Scintillua: JavaScript plus tags and attributes
local lexer = lexer
local P, S = lpeg.P, lpeg.S

local lex = lexer.new(..., { inherit = lexer.load('javascript') })

-- Tags: <Foo.Bar, </div, fragments (<> and </>), and self-closing />
local name = lexer.word * ('.' * lexer.word)^0
local tag = lex:tag(lexer.TAG, '<' * P('/')^-1 * (name + #P('>')) + '/>')
-- Quoted strings stop at end of line, so apostrophes in JSX text (e.g. "I'm") don't run on
local str = lex:tag(lexer.STRING, lexer.range("'", true) + lexer.range('"', true) + lexer.range('`'))
local regex = lex:tag(lexer.REGEX, lexer.after_set('+-*%^!=&|?:;,([{<>', lexer.range('/', true) * S('igm')^0))
lex:modify_rule('string', tag + str + regex)

-- Attributes: name="..." or name={...}
local attribute = lex:tag(lexer.ATTRIBUTE, lexer.word * #(P('=') * S('"\'{')))
lex:modify_rule('identifier', attribute + lex:get_rule('identifier'))

return lex
