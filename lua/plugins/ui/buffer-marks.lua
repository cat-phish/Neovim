return {
  'folke/snacks.nvim',
  keys = {
    -- Mark buffer with a key instantly (no prompt)
    {
      '<leader>m',
      function()
        local key = vim.fn.getcharstr()
        if key and #key == 1 and key:match '[a-zA-Z]' then
          local bufnr = vim.api.nvim_get_current_buf()
          local bufname = vim.api.nvim_buf_get_name(bufnr)

          -- Store in global table
          _G.buffer_marks = _G.buffer_marks or {}
          _G.buffer_marks[key] = {
            bufnr = bufnr,
            bufname = bufname,
            timestamp = os.time(),
          }

          Snacks.notify(string.format("Marked '%s' as [%s]", vim.fn.fnamemodify(bufname, ':t'), key), { title = 'Buffer Mark' })
        end
      end,
      desc = 'Mark buffer',
    },

    -- Jump to marked buffer instantly (no prompt)
    {
      "<leader>'",
      function()
        local key = vim.fn.getcharstr()
        if key and #key == 1 then
          _G.buffer_marks = _G.buffer_marks or {}
          local mark = _G.buffer_marks[key]

          if mark then
            -- Check if buffer still exists
            if vim.api.nvim_buf_is_valid(mark.bufnr) then
              vim.api.nvim_set_current_buf(mark.bufnr)
            else
              -- Buffer was deleted, try to open file
              vim.cmd('edit ' .. vim.fn.fnameescape(mark.bufname))
            end

            -- Jump to last edit position in that buffer
            vim.cmd 'normal! g`"'

            Snacks.notify(string.format('Jumped to [%s]', key), { title = 'Buffer Mark' })
          else
            Snacks.notify(string.format('Buffer mark [%s] not found', key), { title = 'Buffer Mark', level = 'warn' })
          end
        end
      end,
      desc = 'Buffer Mark',
    },

    -- Show all marks in Snacks picker
    {
      '<leader>fm',
      function()
        _G.buffer_marks = _G.buffer_marks or {}

        local items = {}
        local display = {}
        for key, mark in pairs(_G.buffer_marks) do
          local filename = vim.fn.fnamemodify(mark.bufname, ':t')
          local dir = vim.fn.fnamemodify(mark.bufname, ':h:t')
          table.insert(items, {
            key = key,
            file = mark.bufname,
            bufnr = mark.bufnr,
            display = string.format('[%s] %s/%s', key, dir, filename),
          })
          table.insert(display, string.format('[%s] %s/%s', key, dir, filename))
        end

        -- Sort by key
        table.sort(items, function(a, b) return a.key < b.key end)
        table.sort(display)

        if #items == 0 then
          Snacks.notify('No buffer marks set', { title = 'Buffer Marks', level = 'info' })
          return
        end

        vim.ui.select(display, {
          prompt = 'Buffer Marks',
          format_item = function(item) return item end,
        }, function(choice, idx)
          if choice then
            local item = items[idx]
            if vim.api.nvim_buf_is_valid(item.bufnr) then
              vim.api.nvim_set_current_buf(item.bufnr)
            else
              vim.cmd('edit ' .. vim.fn.fnameescape(item.file))
            end
            vim.cmd 'normal! g`"'
          end
        end)
      end,
      desc = 'Buffer Marks',
    },

    -- Clear all marks
    {
      '<leader>mc',
      function()
        _G.buffer_marks = {}
        Snacks.notify('Cleared all buffer marks', { title = 'Buffer Marks' })
      end,
      desc = 'Clear Buffer Marks',
    },
  },
}
