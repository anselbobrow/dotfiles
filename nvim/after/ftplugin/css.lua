vim.keymap.set('n', '<leader>gs', function()
  local f = vim.fn.expand '%:p'
  local b = vim.fn.expand '%:r'
  vim.cmd('edit ' .. (f:match '%.tsx$' and b .. '.css' or b .. '.tsx'))
end, { desc = 'Toggle TSX/CSS' })
