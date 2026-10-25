-- Haxe lexer for Scintillua (adapted from Scintillua's java.lua)
local lexer = lexer
local P, S = lpeg.P, lpeg.S

local lex = lexer.new(...)

-- Classes.
lex:add_rule('classdef', lex:tag(lexer.KEYWORD, lexer.word_match('class interface enum abstract typedef')) *
  lex:get_rule('whitespace') * lex:tag(lexer.CLASS, lexer.word))

-- Keywords.
lex:add_rule('keyword', lex:tag(lexer.KEYWORD, lex:word_match(lexer.KEYWORD)))

-- Types.
lex:add_rule('type', lex:tag(lexer.TYPE, lex:word_match(lexer.TYPE)))

-- Functions.
lex:add_rule('function', lex:tag(lexer.FUNCTION, lexer.word) * #(lexer.space^0 * '('))

-- Identifiers.
lex:add_rule('identifier', lex:tag(lexer.IDENTIFIER, lexer.word))

-- Strings and regexes (~/pattern/flags).
local sq_str = lexer.range("'", true)
local dq_str = lexer.range('"', true)
lex:add_rule('string', lex:tag(lexer.STRING, sq_str + dq_str) +
  lex:tag(lexer.REGEX, '~' * lexer.range('/', true) * S('gimsu')^0))

-- Comments.
lex:add_rule('comment', lex:tag(lexer.COMMENT, lexer.to_eol('//', true) + lexer.range('/*', '*/')))

-- Numbers.
lex:add_rule('number', lex:tag(lexer.NUMBER, lexer.number))

-- Conditional compilation (#if, #end, ...) and metadata (@:keep, @author).
lex:add_rule('preprocessor', lex:tag(lexer.PREPROCESSOR, '#' * lexer.word))
lex:add_rule('annotation', lex:tag(lexer.ANNOTATION, '@' * P(':')^-1 * lexer.word))

-- Operators.
lex:add_rule('operator', lex:tag(lexer.OPERATOR, S('+-/*%<>!=^&|?~:;.,()[]{}')))

-- Word lists.
lex:set_word_list(lexer.KEYWORD, {
  'abstract', 'break', 'case', 'cast', 'catch', 'class', 'continue', 'default', 'do', 'dynamic',
  'else', 'enum', 'extends', 'extern', 'final', 'for', 'function', 'if', 'implements', 'import',
  'in', 'inline', 'interface', 'macro', 'new', 'operator', 'overload', 'override', 'package',
  'private', 'public', 'return', 'static', 'super', 'switch', 'this', 'throw', 'try', 'typedef',
  'untyped', 'using', 'var', 'while', --
  'true', 'false', 'null' -- literals
})

lex:set_word_list(lexer.TYPE, {
  'Any', 'Array', 'Bool', 'Class', 'Dynamic', 'Enum', 'EnumValue', 'Float', 'Int', 'Iterable',
  'Iterator', 'Map', 'Null', 'String', 'UInt', 'Void'
})

return lex
