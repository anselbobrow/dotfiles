local status, jdtls = pcall(require, 'jdtls')
if not status then
  return
end

-- Setup Workspace
local workspace_root = vim.fn.stdpath 'data' .. '/jdtls/'
local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
local workspace = workspace_root .. project_name

-- Setup Testing and Debugging (DAP)
-- https://github.com/mfussenegger/nvim-jdtls?tab=readme-ov-file#nvim-dap-configuration
local bundles = {}
local mason_path = vim.fn.glob(vim.fn.stdpath 'data' .. '/mason/')
vim.list_extend(
  bundles,
  vim.fn.glob(mason_path .. 'packages/java-debug-adapter/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-*.jar', false, true)
)
vim.list_extend(bundles, vim.fn.glob(mason_path .. 'packages/java-test/extension/server/*.jar', false, true))

-- gathers all of the bemol-generated files and adds them to the LSP workspace
local function bemol()
  local bemol_dir = vim.fs.find({ '.bemol' }, { upward = true, type = 'directory' })[1]
  if not bemol_dir then
    return
  end

  local file = io.open(bemol_dir .. '/ws_root_folders', 'r')
  if not file then
    return
  end

  local ws_folders_lsp = {}
  for line in file:lines() do
    table.insert(ws_folders_lsp, line)
  end
  file:close()

  local current_folders = vim.lsp.buf.list_workspace_folders()
  for _, folder in ipairs(ws_folders_lsp) do
    if not vim.tbl_contains(current_folders, folder) then
      vim.lsp.buf.add_workspace_folder(folder)
    end
  end
end

local config = {
  cmd = {
    'java',
    '-Declipse.application=org.eclipse.jdt.ls.core.id1',
    '-Dosgi.bundles.defaultStartLevel=4',
    '-Declipse.product=org.eclipse.jdt.ls.core.product',
    '-Dlog.protocol=true',
    '-Dlog.level=ALL',
    '-javaagent:' .. mason_path .. 'packages/jdtls/lombok.jar',
    '-Xmx1g',
    '--add-modules=ALL-SYSTEM',
    '--add-opens',
    'java.base/java.util=ALL-UNNAMED',
    '--add-opens',
    'java.base/java.lang=ALL-UNNAMED',
    '-jar',
    vim.fn.glob(mason_path .. 'packages/jdtls/plugins/org.eclipse.equinox.launcher_*.jar'),

    '-configuration',
    mason_path .. 'packages/jdtls/config_mac_arm',
    '-data',
    workspace,
  },

  root_dir = vim.fs.root(0, { 'packageInfo' }),

  settings = {
    java = {
      configuration = {
        runtimes = {
          {
            name = 'JavaSE-17',
            path = '/Library/Java/JavaVirtualMachines/amazon-corretto-17.jdk/Contents/Home',
          },
        },
      },
      eclipse = {
        downloadSources = true,
      },
      maven = {
        downloadSources = true,
      },
      implementationsCodeLens = {
        enabled = true,
      },
      referencesCodeLens = {
        enabled = true,
      },
      references = {
        includeDecompiledSources = true,
      },
      inlayHints = {
        parameterNames = {
          enabled = 'all', -- literals, all, none
        },
      },
      format = {
        enabled = true,
      },
      sources = {
        organizeImports = {
          starThreshold = 9999,
          staticStarThreshold = 9999,
        },
      },
    },
  },

  init_options = {
    bundles = bundles,
  },
}

config['on_attach'] = function()
  -- With `hotcodereplace = 'auto' the debug adapter will try to apply code changes
  -- you make during a debug session immediately.
  -- Remove the option if you do not want that.
  require('jdtls').setup_dap { hotcodereplace = 'auto' }
end

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('java-lsp', { clear = true }),
  pattern = '*.java',
  callback = bemol,
})

jdtls.start_or_attach(config)
