.PHONY: build serve dev

build:
	luasmith theme.lua

serve: build
	darkhttpd ./public/ --port 5000 --header 'Access-Control-Allow-Origin: *'

dev:
	watchexec -r -i 'public/**' -- $(MAKE) serve
