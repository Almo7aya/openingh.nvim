.PHONY: lint fmt test clean

lint:
	luacheck lua

fmt:
	stylua --config-path stylua.toml --glob 'lua/**/*.lua' -- lua

/tmp/openingh.nvim/:
	mkdir -p /tmp/openingh.nvim

/tmp/openingh.nvim/plenary.nvim/: /tmp/openingh.nvim/
	git clone --depth 1 https://github.com/nvim-lua/plenary.nvim /tmp/openingh.nvim/plenary.nvim

/tmp/openingh.nvim/pack/vendor/opt/openingh.nvim/: /tmp/openingh.nvim/
	mkdir -p /tmp/openingh.nvim/pack/vendor/opt
	ln -s $$PWD /tmp/openingh.nvim/pack/vendor/opt

test: /tmp/openingh.nvim/plenary.nvim/ /tmp/openingh.nvim/pack/vendor/opt/openingh.nvim/
	nvim --headless --noplugin -u tests/minimal.vim -c "PlenaryBustedDirectory tests/ {minimal_init = 'tests/minimal.vim'}"

clean:
	rm -rf /tmp/openingh.nvim
