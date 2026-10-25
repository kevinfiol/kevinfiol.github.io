.PHONY: build serve

build:
	luasmith theme.lua

serve: build
	sfz --cors --render-index public/
