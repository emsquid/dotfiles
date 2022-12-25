require('mini.comment').setup {
    mappings = { comment_line = '<c-c>' }
}

require('mini.tabline').setup {}

local statusline = require('mini.statusline')

local modes = setmetatable({
    ['n']     = { long = 'Normal', short = 'N', hl = 'MiniStatuslineModeNormal' },
    ['v']     = { long = 'Visual', short = 'V', hl = 'MiniStatuslineModeVisual' },
    ['V']     = { long = 'V-Line', short = 'V-L', hl = 'MiniStatuslineModeVisual' },
    ['<C-V>'] = { long = 'V-Block', short = 'V-B', hl = 'MiniStatuslineModeVisual' },
    ['s']     = { long = 'Select', short = 'S', hl = 'MiniStatuslineModeVisual' },
    ['S']     = { long = 'S-Line', short = 'S-L', hl = 'MiniStatuslineModeVisual' },
    ['<C-S>'] = { long = 'S-Block', short = 'S-B', hl = 'MiniStatuslineModeVisual' },
    ['i']     = { long = 'Insert', short = 'I', hl = 'MiniStatuslineModeInsert' },
    ['R']     = { long = 'Replace', short = 'R', hl = 'MiniStatuslineModeReplace' },
    ['c']     = { long = 'Command', short = 'C', hl = 'MiniStatuslineModeCommand' },
    ['r']     = { long = 'Prompt', short = 'P', hl = 'MiniStatuslineModeOther' },
    ['!']     = { long = 'Shell', short = 'Sh', hl = 'MiniStatuslineModeOther' },
    ['t']     = { long = 'Terminal', short = 'T', hl = 'MiniStatuslineModeOther' },
}, {
    __index = function()
        return { long = 'Unknown', short = 'U', hl = '%#MiniStatuslineModeOther#' }
    end,
})

local diagnostic_levels = {
    { id = vim.diagnostic.severity.ERROR, sign = 'E' },
    { id = vim.diagnostic.severity.WARN, sign = 'W' },
    { id = vim.diagnostic.severity.INFO, sign = 'I' },
    { id = vim.diagnostic.severity.HINT, sign = 'H' },
}

local get_filetype_icon = function()
    local devicons = require('nvim-web-devicons')
    local file_name, file_ext = vim.fn.expand('%:t'), vim.fn.expand('%:e')
    return devicons.get_icon(file_name, file_ext, { default = true })
end

statusline.section_mode = function(args)
    local mode_info = modes[vim.fn.mode()]

    local mode = mode_info.long

    return mode, mode_info.hl
end

statusline.section_diagnostics = function(args)
    local hasnt_attached_client = next(vim.lsp.buf_get_clients()) == nil
    local dont_show_lsp = statusline.is_truncated(args.trunc_width) or vim.bo.buftype ~= '' or
        hasnt_attached_client
    if dont_show_lsp then return '' end

    -- Construct diagnostic info using predefined order
    local t = {}
    for _, level in ipairs(diagnostic_levels) do
        local n = #vim.diagnostic.get(0, { severity = level.id })
        -- Add level info only if diagnostic is present
        if n > 0 then table.insert(t, string.format(' %s%s', level.sign, n)) end
    end

    local icon = ''
    if vim.tbl_count(t) == 0 then return ('%s -'):format(icon) end
    return string.format('%s%s', icon, table.concat(t, ''))
end

statusline.section_filename = function(args)
    if vim.bo.buftype == 'terminal' then
        return '%t'
    else
        return '%f%m%r'
    end
end

statusline.section_fileinfo = function(args)
    local filetype = vim.bo.filetype

    -- Don't show anything if can't detect file type or not inside a "normal
    -- buffer"
    if (filetype == '') or vim.bo.buftype ~= '' then return '' end

    -- Add filetype icon
    local icon = get_filetype_icon()
    if icon ~= '' then filetype = string.format('%s %s', icon, filetype) end

    -- Construct output string if truncated
    if statusline.is_truncated(args.trunc_width) then return filetype end

    -- Construct output string with extra file info
    local encoding = vim.bo.fileencoding or vim.bo.encoding
    local format = vim.bo.fileformat

    return string.format('%s|%s[%s]', filetype, encoding, format)
end

statusline.section_location = function(args)
    return '%l/%L│%2v/%-2{virtcol("$") - 1}'
end

statusline.setup {
    set_vim_settings = false,
}
