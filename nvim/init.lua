-- [[ Options ]]
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.have_nerd_font = true

vim.o.number = true
vim.o.relativenumber = true
vim.o.mouse = 'a'
vim.o.mousescroll = 'ver:1,hor:3'
vim.o.breakindent = true
vim.o.undofile = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.signcolumn = 'yes'
vim.o.updatetime = 250
vim.o.timeoutlen = 300
vim.o.splitright = true
vim.o.splitbelow = true
vim.o.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
vim.o.inccommand = 'split'
vim.o.cursorline = true
vim.o.confirm = true
-- Schedule the setting after `UiEnter` because it can increase startup-time.
vim.schedule(function() vim.o.clipboard = 'unnamedplus' end)

-- [[ Folding ]]
vim.o.foldmethod = 'manual' -- overridden in treesitter config
vim.o.foldcolumn = '0'
vim.o.foldlevel = 99
vim.o.foldlevelstart = 1
vim.o.foldnestmax = 2

-- [[ Keymaps ]]
vim.keymap.set('n', '<leader>w', '<cmd>w<CR>')
vim.keymap.set('i', '<c-e>', '<esc>A')
vim.keymap.set('n', '<Esc>', function()
  vim
    .iter(vim.api.nvim_tabpage_list_wins(0))
    :filter(function(win_id) return vim.api.nvim_win_get_config(win_id).relative ~= '' end)
    :each(function(win_id) vim.api.nvim_win_close(win_id, false) end)
  vim.cmd 'nohlsearch'
end)
vim.keymap.set('n', '<leader>p', 'o<esc>p')
vim.keymap.set('n', '<leader>P', 'O<esc>p')
vim.keymap.set({ 'n', 'v' }, 'H', '0^')
vim.keymap.set({ 'n', 'v' }, 'L', '$')
vim.keymap.set({ 'n', 'v' }, 'J', '6j')
vim.keymap.set({ 'n', 'v' }, 'K', '6k')
vim.keymap.set({ 'n', 'v' }, 'M', 'J')
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })
vim.keymap.set('n', '<leader>d', vim.diagnostic.open_float, { desc = 'Open [D]iagnostic under cursor' })

-- [[ Diagnostics ]]
vim.diagnostic.config {
  update_in_insert = false,
  severity_sort = true,
  float = { border = 'rounded', source = 'if_many' },
  underline = { severity = vim.diagnostic.severity.ERROR },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = '󰅚 ',
      [vim.diagnostic.severity.WARN] = '󰀪 ',
      [vim.diagnostic.severity.INFO] = '󰋽 ',
      [vim.diagnostic.severity.HINT] = '󰌶 ',
    },
  },
  -- Auto open the float, so you can easily read the errors when jumping with `[d` and `]d`
  jump = { float = true },
}

-- [[ Filetype mappings ]]
vim.filetype.add {
  filename = {
    ['Caddyfile'] = 'caddy',
  },
}

-- [[ Highlight when yanking text ]]
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function() vim.highlight.on_yank() end,
})

-- [[ Install `lazy.nvim` ]]
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { 'Failed to clone lazy.nvim:\n', 'ErrorMsg' },
      { out, 'WarningMsg' },
      { '\nPress any key to exit...' },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- [[ Configure and install plugins ]]
require('lazy').setup {
  { -- nvim-lspconfig
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs and related tools to stdpath for Neovim
      -- Mason must be loaded before its dependents so we need to set it up here.
      { 'mason-org/mason.nvim', opts = {} },
      {
        'mason-org/mason-lspconfig.nvim',
        opts = {
          automatic_enable = false,
        },
      },
      'WhoIsSethDaniel/mason-tool-installer.nvim',

      -- Useful status updates for LSP.
      {
        'j-hui/fidget.nvim',
        opts = {
          notification = {
            window = {
              winblend = 0,
            },
          },
        },
      },
    },
    config = function()
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc, mode)
            mode = mode or 'n'
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          -- Hover symbol under cursor.
          map('<leader>k', vim.lsp.buf.hover, 'Hover')

          -- Rename the variable under your cursor.
          --  Most Language Servers support renaming across files, etc.
          map('grn', vim.lsp.buf.rename, '[R]e[n]ame')

          -- Execute a code action, usually your cursor needs to be on top of an error
          -- or a suggestion from your LSP for this to activate.
          map('gra', vim.lsp.buf.code_action, '[G]oto Code [A]ction', { 'n', 'x' })

          -- Find references for the word under your cursor.
          map('grr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')

          -- Jump to the implementation of the word under your cursor.
          --  Useful when your language has ways of declaring types without an actual implementation.
          map('gri', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')

          -- Jump to the definition of the word under your cursor.
          --  This is where a variable was first declared, or where a function is defined, etc.
          --  To jump back, press <C-t>.
          map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')

          map('grD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

          -- Fuzzy find all the symbols in your current document.
          --  Symbols are things like variables, functions, types, etc.
          map('gO', require('telescope.builtin').lsp_document_symbols, 'Open Document Symbols')

          -- Fuzzy find all the symbols in your current workspace.
          --  Similar to document symbols, except searches over your entire project.
          map('gW', require('telescope.builtin').lsp_dynamic_workspace_symbols, 'Open Workspace Symbols')

          -- Jump to the type of the word under your cursor.
          --  Useful when you're not sure what type a variable is and you want to see
          --  the definition of its *type*, not where it was *defined*.
          map('grt', require('telescope.builtin').lsp_type_definitions, '[G]oto [T]ype Definition')

          -- The following two autocommands are used to highlight references of the
          -- word under your cursor when your cursor rests there for a little while.
          --    See `:help CursorHold` for information about when this is executed
          --
          -- When you move your cursor, the highlights will be cleared (the second autocommand).
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client:supports_method('textDocument/documentHighlight', event.buf) then
            local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd('LspDetach', {
              group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
              end,
            })
          end

          -- The following code creates a keymap to toggle inlay hints in your
          -- code, if the language server you are using supports them
          --
          -- This may be unwanted, since they displace some of your code
          if client and client:supports_method('textDocument/inlayHint', event.buf) then
            map('<leader>th', function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf }) end, '[T]oggle Inlay [H]ints')
          end
        end,
      })

      -- Enable the following language servers
      --
      --  Add any additional override configuration in the following tables. Available keys are:
      --  - cmd (table): Override the default command used to start the server
      --  - filetypes (table): Override the default list of associated filetypes for the server
      --  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
      --  - settings (table): Override the default settings passed when initializing the server.
      --        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
      ---@type table<string, vim.lsp.Config>
      local servers = {
        -- See `:help lspconfig-all` for a list of all the pre-configured LSPs
        bashls = {
          filetypes = { 'bash', 'sh', 'zsh' },
        },
        clangd = {},
        rust_analyzer = {},
        pyright = {},
        ts_ls = {
          init_options = {
            hostInfo = 'neovim',
            preferences = {
              -- ignore some solid-js invalid import dirs
              -- https://github.com/typescript-language-server/typescript-language-server/blob/master/docs/configuration.md
              autoImportSpecifierExcludeRegexes = {
                'solid-js/types',
              },
            },
          },
        },
        eslint = {},
        jsonls = {},
        yamlls = {},
        cssls = {},
        emmet_language_server = {
          filetypes = { 'html', 'typescriptreact', 'javascriptreact' },
        },
        -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#lua_ls
        lua_ls = {
          on_init = function(client)
            if client.workspace_folders then
              local path = client.workspace_folders[1].name
              if path ~= vim.fn.stdpath 'config' and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc')) then return end
            end

            client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
              runtime = {
                -- Tell the language server which version of Lua you're using (most
                -- likely LuaJIT in the case of Neovim)
                version = 'LuaJIT',
                -- Tell the language server how to find Lua modules same way as Neovim
                -- (see `:h lua-module-load`)
                path = {
                  'lua/?.lua',
                  'lua/?/init.lua',
                },
              },
              -- Make the server aware of Neovim runtime files
              workspace = {
                checkThirdParty = false,
                library = {
                  vim.env.VIMRUNTIME,
                  -- Depending on the usage, you might want to add additional paths
                  -- here.
                  '${3rd}/luv/library',
                },
              },
            })
          end,
          settings = {
            Lua = {
              completion = {
                callSnippet = 'Replace',
              },
              diagnostics = {
                disable = { 'missing-fields' },
              },
            },
          },
        },
        stylua = {},
      }

      -- Ensure the servers and tools above are installed
      local ensure_installed = vim.tbl_keys(servers or {})
      vim.list_extend(ensure_installed, {
        'prettierd', -- for formatting web stuff
        'jdtls', -- Set up with nvim-jdtls, so not added to servers list
        'yapf', -- for python formatting
      })
      require('mason-tool-installer').setup { ensure_installed = ensure_installed }

      for name, cfg in pairs(servers) do
        vim.lsp.config(name, cfg)
        vim.lsp.enable(name)
      end
    end,
  },
  { -- nvim-dap
    'mfussenegger/nvim-dap',
    dependencies = {
      -- Creates a beautiful debugger UI
      'rcarriga/nvim-dap-ui',

      -- Required dependency for nvim-dap-ui
      'nvim-neotest/nvim-nio',

      -- Installs the debug adapters for you
      'williamboman/mason.nvim',
      'jay-babu/mason-nvim-dap.nvim',

      -- Add your own debuggers here
    },
    keys = {
      -- Basic debugging keymaps, feel free to change to your liking!
      {
        '<F5>',
        function() require('dap').continue() end,
        desc = 'Debug: Start/Continue',
      },
      {
        '<F1>',
        function() require('dap').step_into() end,
        desc = 'Debug: Step Into',
      },
      {
        '<F2>',
        function() require('dap').step_over() end,
        desc = 'Debug: Step Over',
      },
      {
        '<F3>',
        function() require('dap').step_out() end,
        desc = 'Debug: Step Out',
      },
      {
        '<leader>b',
        function() require('dap').toggle_breakpoint() end,
        desc = 'Debug: Toggle Breakpoint',
      },
      {
        '<leader>B',
        function() require('dap').set_breakpoint(vim.fn.input 'Breakpoint condition: ') end,
        desc = 'Debug: Set Breakpoint',
      },
      -- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
      {
        '<F7>',
        function() require('dapui').toggle() end,
        desc = 'Debug: See last session result.',
      },
    },
    config = function()
      local dap = require 'dap'
      local dapui = require 'dapui'

      require('mason-nvim-dap').setup {
        -- You'll need to check that you have the required things installed
        -- online, please don't ask me how to install them :)
        ensure_installed = {
          'javadbg',
          'javatest',
          'cppdbg',
        },

        -- You can provide additional configuration to the handlers,
        -- see mason-nvim-dap README for more information
        handlers = {},
      }

      -- Change breakpoint icons
      local breakpoint_icons = { Breakpoint = '', BreakpointCondition = '', BreakpointRejected = '', LogPoint = '', Stopped = '' }
      for type, icon in pairs(breakpoint_icons) do
        local tp = 'Dap' .. type
        -- local hl = (type == 'Stopped') and 'GruvboxYellowSign' or 'GruvboxRedSign'
        vim.fn.sign_define(tp, { text = icon, texthl = '', numhl = '', linehl = '' })
      end

      dap.listeners.after.event_initialized['dapui_config'] = dapui.open
      dap.listeners.before.event_terminated['dapui_config'] = dapui.close
      dap.listeners.before.event_exited['dapui_config'] = dapui.close
    end,
  },
  { -- nvim-jdtls
    'mfussenegger/nvim-jdtls',
    dependencies = {
      'neovim/nvim-lspconfig',
      'mfussenegger/nvim-dap',
    },
  },
  { -- treesitter-textobjects
    {
      'nvim-treesitter/nvim-treesitter-textobjects',
      branch = 'main',
      init = function()
        -- Disable entire built-in ftplugin mappings to avoid conflicts.
        -- See https://github.com/neovim/neovim/tree/master/runtime/ftplugin for built-in ftplugins.
        vim.g.no_plugin_maps = true
      end,
      keys = {
        { 's>', function() require('nvim-treesitter-textobjects.swap').swap_next '@parameter.inner' end, desc = '[S]wap next [>]' },
        { 's<', function() require('nvim-treesitter-textobjects.swap').swap_previous '@parameter.inner' end, desc = '[S]wap prev [<]' },
        {
          ']f',
          function() require('nvim-treesitter-textobjects.move').goto_next_start('@function.outer', 'textobjects') end,
          { 'n', 'x', 'o' },
          desc = 'Next [f]unction',
        },
        {
          '[f',
          function() require('nvim-treesitter-textobjects.move').goto_previous_start('textobjects', '@function.outer') end,
          { 'n', 'x', 'o' },
          desc = 'Previous [f]unction',
        },
        {
          ']a',
          function() require('nvim-treesitter-textobjects.move').goto_next_start('@parameter.outer', 'textobjects') end,
          { 'n', 'x', 'o' },
          desc = 'Next [a]rgument',
        },
        {
          '[a',
          function() require('nvim-treesitter-textobjects.move').goto_previous_start('@parameter.outer', 'textobjects') end,
          { 'n', 'x', 'o' },
          desc = 'Previous [a]rgument',
        },
        {
          ']c',
          function() require('nvim-treesitter-textobjects.move').goto_next_start('@comment.outer', 'textobjects') end,
          { 'n', 'x', 'o' },
          desc = 'Next [c]omment',
        },
        {
          '[c',
          function() require('nvim-treesitter-textobjects.move').goto_previous_start('@comment.outer', 'textobjects') end,
          { 'n', 'x', 'o' },
          desc = 'previous [c]omment',
        },
      },
      config = function()
        require('nvim-treesitter-textobjects').setup {
          move = {
            set_jumps = true,
          },
        }
      end,
    },
  },
  { -- treesitter
    'nvim-treesitter/nvim-treesitter',
    lazy = false,
    build = ':TSUpdate',
    branch = 'main',
    -- [[ Configure Treesitter ]] See `:help nvim-treesitter-intro`
    config = function()
      -- ensure basic parser are installed
      local parsers = { 'bash', 'c', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'query', 'vim', 'vimdoc' }
      require('nvim-treesitter').install(parsers)

      ---@param buf integer
      ---@param language string
      local function treesitter_try_attach(buf, language)
        -- check if parser exists and load it
        if not vim.treesitter.language.add(language) then return end
        -- enables syntax highlighting and other treesitter features
        vim.treesitter.start(buf, language)

        vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
        vim.wo.foldmethod = 'expr'

        -- enables treesitter based indentation
        vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end

      local available_parsers = require('nvim-treesitter').get_available()
      vim.api.nvim_create_autocmd('FileType', {
        callback = function(args)
          local buf, filetype = args.buf, args.match

          local language = vim.treesitter.language.get_lang(filetype)
          if not language then return end

          local installed_parsers = require('nvim-treesitter').get_installed 'parsers'

          if vim.tbl_contains(installed_parsers, language) then
            -- enable the parser if it is installed
            treesitter_try_attach(buf, language)
          elseif vim.tbl_contains(available_parsers, language) then
            -- if a parser is available in `nvim-treesitter` auto install it, and enable it after the installation is done
            require('nvim-treesitter').install(language):await(function() treesitter_try_attach(buf, language) end)
          else
            -- try to enable treesitter features in case the parser exists but is not available from `nvim-treesitter`
            treesitter_try_attach(buf, language)
          end
        end,
      })
    end,
  },
  { -- telescope
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    dependencies = {
      'nvim-lua/plenary.nvim',
      { -- If encountering errors, see telescope-fzf-native README for installation instructions
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
        cond = function() return vim.fn.executable 'make' == 1 end,
      },
      { 'nvim-telescope/telescope-ui-select.nvim' },
      { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
    },
    config = function()
      require('telescope').setup {
        defaults = {
          path_display = { shorten = 2 },
        },
        pickers = {
          help_tags = {
            mappings = { i = { ['<cr>'] = 'select_vertical' } },
          },
        },
        extensions = {
          ['ui-select'] = {
            require('telescope.themes').get_dropdown(),
          },
        },
      }

      -- Enable Telescope extensions if they are installed
      pcall(require('telescope').load_extension, 'fzf')
      pcall(require('telescope').load_extension, 'ui-select')

      local builtin = require 'telescope.builtin'
      vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
      vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
      vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
      vim.keymap.set('n', '<leader>sn', function() builtin.find_files { cwd = vim.fn.stdpath 'config' } end, { desc = '[S]earch [N]eovim files' })
      vim.keymap.set('n', '<leader>st', builtin.git_status, { desc = '[S]earch Git s[T]atus' })
      vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
      vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
      vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
      vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
      vim.keymap.set('n', '<leader>s.', builtin.resume, { desc = '[S]earch Resume ("." for repeat)' })
      vim.keymap.set('n', '<leader>sr', builtin.oldfiles, { desc = '[S]earch Recent Files' })
      vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })
      vim.keymap.set(
        'n',
        '<leader>/',
        function()
          builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
            winblend = 10,
            previewer = false,
          })
        end,
        { desc = '[/] Fuzzily search in current buffer' }
      )
      vim.keymap.set(
        'n',
        '<leader>s/',
        function() builtin.live_grep { grep_open_files = true, prompt_title = 'Live Grep in Open Files' } end,
        { desc = '[S]earch [/] in Open Files' }
      )
    end,
  },
  { -- conform (formatters)
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
      {
        '<leader>f',
        function() require('conform').format { async = true, lsp_format = 'fallback' } end,
        mode = '',
        desc = '[F]ormat buffer',
      },
    },
    opts = {
      notify_on_error = false,
      format_on_save = function(bufnr)
        -- Disable "format_on_save lsp_fallback" for languages that don't
        -- have a well standardized coding style. You can add additional
        -- languages here or re-enable it for the disabled ones.
        local disable_filetypes = { c = true, cpp = true, java = true }
        if disable_filetypes[vim.bo[bufnr].filetype] then
          return nil
        else
          return {
            timeout_ms = 500,
            lsp_format = 'fallback',
          }
        end
      end,
      formatters_by_ft = {
        lua = { 'stylua' },
        python = { 'yapf' },
        --
        -- You can use 'stop_after_first' to run the first available formatter from the list
        html = { 'prettierd', 'prettier', stop_after_first = true },
        css = { 'prettierd', 'prettier', stop_after_first = true },
        typescript = { 'prettierd', 'prettier', stop_after_first = true },
        typescriptreact = { 'prettierd', 'prettier', stop_after_first = true },
      },
    },
  },
  { -- blink (completion)
    'saghen/blink.cmp',
    event = 'VimEnter',
    version = '1.*',
    dependencies = {
      -- Snippet Engine
      {
        'L3MON4D3/LuaSnip',
        version = '2.*',
        build = 'make install_jsregexp',
        dependencies = {
          -- `friendly-snippets` contains a variety of premade snippets.
          --    See the README about individual language/framework/plugin snippets:
          --    https://github.com/rafamadriz/friendly-snippets
          {
            'rafamadriz/friendly-snippets',
            config = function() require('luasnip.loaders.from_vscode').lazy_load() end,
          },
          {
            'solidjs-community/solid-snippets',
            config = function() require('luasnip.loaders.from_vscode').lazy_load() end,
          },
        },
        opts = {},
      },
    },
    opts = {
      keymap = {
        -- 'default' (recommended) for mappings similar to built-in completions
        --   <c-y> to accept ([y]es) the completion.
        --    This will auto-import if your LSP supports it.
        --    This will expand snippets if the LSP sent a snippet.
        -- 'super-tab' for tab to accept
        -- 'enter' for enter to accept
        -- 'none' for no mappings
        --
        -- For an understanding of why the 'default' preset is recommended,
        -- you will need to read `:help ins-completion`
        --
        -- No, but seriously. Please read `:help ins-completion`, it is really good!
        --
        -- All presets have the following mappings:
        -- <tab>/<s-tab>: move to right/left of your snippet expansion
        -- <c-space>: Open menu or open docs if already open
        -- <c-n>/<c-p> or <up>/<down>: Select next/previous item
        -- <c-e>: Hide menu
        -- <c-k>: Toggle signature help
        --
        -- See :h blink-cmp-config-keymap for defining your own keymap
        preset = 'default',

        -- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
        --    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
      },

      appearance = {
        -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
        -- Adjusts spacing to ensure icons are aligned
        nerd_font_variant = 'mono',
      },

      completion = {
        -- By default, you may press `<c-space>` to show the documentation.
        -- Optionally, set `auto_show = true` to show the documentation after a delay.
        documentation = { auto_show = false, auto_show_delay_ms = 500 },
      },

      sources = {
        default = { 'lsp', 'path', 'snippets' },
      },

      snippets = { preset = 'luasnip' },

      -- Blink.cmp includes an optional, recommended rust fuzzy matcher,
      -- which automatically downloads a prebuilt binary when enabled.
      --
      -- By default, we use the Lua implementation instead, but you may enable
      -- the rust implementation via `'prefer_rust_with_warning'`
      --
      -- See :h blink-cmp-config-fuzzy for more information
      fuzzy = { implementation = 'lua' },

      -- Shows a signature help window while you type arguments for a function
      signature = { enabled = true },
    },
  },
  { -- gitsigns
    'lewis6991/gitsigns.nvim',
    opts = {
      on_attach = function(bufnr)
        local gitsigns = require 'gitsigns'

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        map('n', ']h', function()
          if vim.wo.diff then
            vim.cmd.normal { ']h', bang = true }
          else
            gitsigns.nav_hunk 'next'
          end
        end)

        map('n', '[h', function()
          if vim.wo.diff then
            vim.cmd.normal { '[h', bang = true }
          else
            gitsigns.nav_hunk 'prev'
          end
        end)

        -- Actions
        -- visual mode
        map('v', '<leader>hs', function() gitsigns.stage_hunk { vim.fn.line '.', vim.fn.line 'v' } end, { desc = 'git [s]tage hunk' })
        map('v', '<leader>hr', function() gitsigns.reset_hunk { vim.fn.line '.', vim.fn.line 'v' } end, { desc = 'git [r]eset hunk' })
        -- normal mode
        map('n', '<leader>hs', gitsigns.stage_hunk, { desc = 'git [s]tage hunk' })
        map('n', '<leader>hr', gitsigns.reset_hunk, { desc = 'git [r]eset hunk' })
        map('n', '<leader>hS', gitsigns.stage_buffer, { desc = 'git [S]tage buffer' })
        map('n', '<leader>hu', gitsigns.stage_hunk, { desc = 'git [u]ndo stage hunk' })
        map('n', '<leader>hR', gitsigns.reset_buffer, { desc = 'git [R]eset buffer' })
        map('n', '<leader>hp', gitsigns.preview_hunk, { desc = 'git [p]review hunk' })
        map('n', '<leader>hb', gitsigns.blame_line, { desc = 'git [b]lame line' })
        map('n', '<leader>hd', gitsigns.diffthis, { desc = 'git [d]iff against index' })
        map('n', '<leader>hD', function() gitsigns.diffthis '@' end, { desc = 'git [D]iff against last commit' })
        -- Toggles
        map('n', '<leader>tb', gitsigns.toggle_current_line_blame, { desc = '[T]oggle git show [b]lame line' })
        map('n', '<leader>tD', gitsigns.preview_hunk_inline, { desc = '[T]oggle git show [D]eleted' })
      end,
    },
  },
  { -- which-key
    'folke/which-key.nvim',
    event = 'VimEnter', -- Sets the loading event to 'VimEnter'
    opts = {
      -- delay between pressing a key and opening which-key (milliseconds)
      -- this setting is independent of vim.o.timeoutlen
      delay = 150,
      icons = {
        -- set icon mappings to true if you have a Nerd Font
        mappings = vim.g.have_nerd_font,
      },

      -- Document existing key chains
      spec = {
        { '<leader>s', group = '[S]earch' },
        { '<leader>t', group = '[T]oggle' },
        { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
      },
    },
  },
  { -- vim tmux navigator
    'christoomey/vim-tmux-navigator',
    init = function()
      vim.g.tmux_navigator_no_mappings = 1
      vim.g.tmux_navigator_preserve_zoom = 1
    end,
    cmd = {
      'TmuxNavigateLeft',
      'TmuxNavigateDown',
      'TmuxNavigateUp',
      'TmuxNavigateRight',
      'TmuxNavigatePrevious',
      'TmuxNavigatorProcessList',
    },
    keys = {
      { '<M-h>', '<cmd>TmuxNavigateLeft<cr>' },
      { '<M-j>', '<cmd>TmuxNavigateDown<cr>' },
      { '<M-k>', '<cmd>TmuxNavigateUp<cr>' },
      { '<M-l>', '<cmd>TmuxNavigateRight<cr>' },
      { '<M-\\>', '<cmd>TmuxNavigatePrevious<cr>' },
    },
  },
  { -- mini
    'nvim-mini/mini.nvim',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    config = function()
      -- Expanded textobject manipulation for `a` and `i`
      local gen_spec = require('mini.ai').gen_spec
      require('mini.ai').setup {
        n_lines = 500,
        custom_textobjects = {
          F = gen_spec.treesitter { a = '@function.outer', i = '@function.inner' },
          o = gen_spec.treesitter { a = '@comment.outer', i = '@comment.inner' },
          r = gen_spec.pair('[', ']', { type = 'balanced' }),
          c = gen_spec.pair('{', '}', { type = 'balanced' }),
        },
      }

      -- Surround
      local ts_input = require('mini.surround').gen_spec.input.treesitter
      require('mini.surround').setup {
        n_lines = 500,
        custom_surroundings = {
          -- Use tree-sitter to allow function calls and arguments as inputs
          f = {
            input = ts_input { outer = '@call.outer', inner = '@call.inner' },
          },
          a = {
            input = ts_input { outer = '@parameter.outer', inner = '@parameter.inner' },
          },
          r = {
            input = { '%b[]', '^.().*().$' },
            output = { left = '[', right = ']' },
          },
          c = {
            input = { '%b{}', '^.().*().$' },
            output = { left = '{', right = '}' },
          },
        },
      }
    end,
  },
  { -- autopairs
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    config = true,
    -- use opts = {} for passing setup options
    -- this is equivalent to setup({}) function
  },
  { -- nvim-ts-autotag
    'windwp/nvim-ts-autotag',
    ft = { 'html', 'typescriptreact', 'javascriptreact' },
    opts = {},
  },
  { -- demicolon
    'mawkler/demicolon.nvim',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    opts = {},
  },
  { -- indent-blankline
    'lukas-reineke/indent-blankline.nvim',
    main = 'ibl',
    opts = {
      scope = {
        show_start = false,
      },
    },
  },
  { -- neoscroll
    'karb94/neoscroll.nvim',
    config = function()
      require('neoscroll').setup {
        -- All these keys will be mapped to their corresponding default scrolling animation
        mappings = { '<C-u>', '<C-d>', '<C-b>', '<C-f>', '<C-y>', '<C-e>', 'zt', 'zz', 'zb' },
        hide_cursor = true, -- Hide cursor while scrolling
        stop_eof = true, -- Stop at <EOF> when scrolling downwards
        use_local_scrolloff = false, -- Use the local scope of scrolloff instead of the global scope
        respect_scrolloff = false, -- Stop scrolling when the cursor reaches the scrolloff margin of the file
        cursor_scrolls_alone = false, -- The cursor will keep on scrolling even if the window cannot scroll further
        easing_function = 'sine', -- Default easing function
        duration_multiplier = 0.5,
      }
    end,
  },
  { -- tokyonight
    'folke/tokyonight.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      require('tokyonight').setup {
        style = 'night', -- The theme comes in three styles, `storm`, a darker variant `night` and `day`
        transparent = true,
        styles = {
          -- Style to be applied to different syntax groups
          -- Value is any valid attr-list value for `:help nvim_set_hl`
          comments = { italic = false },
          keywords = { italic = false },
          sidebars = 'transparent',
          floats = 'transparent',
        },
        on_colors = function(colors) colors.bg_statusline = require('tokyonight.util').blend_bg(colors.bg_statusline, 0.1) end,
        on_highlights = function() end,
      }
      vim.cmd.colorscheme 'tokyonight'
    end,
  },
  { -- lualine
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons', 'tpope/vim-obsession' },
    opts = {
      sections = {
        lualine_x = { 'encoding', 'filetype' },
        lualine_y = {
          'progress',
          function() return vim.fn.ObsessionStatus('󰑊', '󰏤') end,
        },
      },
    },
  },
  { -- todo-comments
    'folke/todo-comments.nvim',
    event = 'VimEnter',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = { signs = false },
  },
  { -- oil
    'stevearc/oil.nvim',
    opts = {
      delete_to_trash = true,
    },
    keys = {
      { '<leader>o', '<cmd>Oil<cr>', desc = 'Browse current directory' },
    },
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    -- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
    lazy = false,
  },
  { -- lazygit
    'kdheepak/lazygit.nvim',
    lazy = true,
    cmd = {
      'LazyGit',
      'LazyGitConfig',
      'LazyGitCurrentFile',
      'LazyGitFilter',
      'LazyGitFilterCurrentFile',
    },
    -- optional for floating window border decoration
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
    -- setting the keybinding for LazyGit with 'keys' is recommended in
    -- order to load the plugin when the command is run for the first time
    keys = {
      { '<leader>gg', '<cmd>LazyGit<cr>', desc = 'LazyGit' },
    },
  },
  { 'NMAC427/guess-indent.nvim', opts = {} },
  'tpope/vim-sleuth',
  'tpope/vim-abolish',
  'tpope/vim-obsession',
  'tpope/vim-commentary',
}

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
