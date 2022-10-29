.PHONY: lint

lint:
	luacheck lua

fmt:
	stylua --config-path stylua.toml --glob 'lua/**/*.lua' -- lua

test:
	nvim --headless --noplugin -u tests/minimal.vim -c "PlenaryBustedDirectory tests/ {minimal_init = 'tests/minimal.vim'}"
