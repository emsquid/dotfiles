---@diagnostic disable
local xplr = xplr
---@diagnostic enable

local no_color = os.getenv("NO_COLOR")

local function red(x)
    if no_color == nil then
        return "\x1b[31m" .. x .. "\x1b[0m"
    else
        return x
    end
end

local function green(x)
    if no_color == nil then
        return "\x1b[32m" .. x .. "\x1b[0m"
    else
        return x
    end
end

local function yellow(x)
    if no_color == nil then
        return "\x1b[33m" .. x .. "\x1b[0m"
    else
        return x
    end
end

local function blue(x)
    if no_color == nil then
        return "\x1b[34m" .. x .. "\x1b[0m"
    else
        return x
    end
end

local function magenta(x)
    if no_color == nil then
        return "\x1b[35m" .. x .. "\x1b[0m"
    else
        return x
    end
end

local function bit(x, color, cond)
    if cond then
        return color(x)
    else
        return color("-")
    end
end

local function bold(text)
    if no_color then
        return text
    else
        return "\x1b[1m" .. text .. "\x1b[0m"
    end
end

local function datetime(num)
    return tostring(os.date("%a %b %d %H:%M:%S %Y", num / 1000000000))
end

local function permissions(p)
    local result = ""

    result = result .. bit("r", green, p.user_read)
    result = result .. bit("w", yellow, p.user_write)

    if p.user_execute == false and p.setuid == false then
        result = result .. bit("-", red, p.user_execute)
    elseif p.user_execute == true and p.setuid == false then
        result = result .. bit("x", red, p.user_execute)
    elseif p.user_execute == false and p.setuid == true then
        result = result .. bit("S", red, p.user_execute)
    else
        result = result .. bit("s", red, p.user_execute)
    end

    result = result .. bit("r", green, p.group_read)
    result = result .. bit("w", yellow, p.group_write)

    if p.group_execute == false and p.setuid == false then
        result = result .. bit("-", red, p.group_execute)
    elseif p.group_execute == true and p.setuid == false then
        result = result .. bit("x", red, p.group_execute)
    elseif p.group_execute == false and p.setuid == true then
        result = result .. bit("S", red, p.group_execute)
    else
        result = result .. bit("s", red, p.group_execute)
    end

    result = result .. bit("r", green, p.other_read)
    result = result .. bit("w", yellow, p.other_write)

    if p.other_execute == false and p.setuid == false then
        result = result .. bit("-", red, p.other_execute)
    elseif p.other_execute == true and p.setuid == false then
        result = result .. bit("x", red, p.other_execute)
    elseif p.other_execute == false and p.setuid == true then
        result = result .. bit("T", red, p.other_execute)
    else
        result = result .. bit("t", red, p.other_execute)
    end

    return result
end

local function icon(node)
    -- Special
    local name = node.relative_path
    local special = xplr.config.node_types.special[name]

    if special ~= nil then
        return special.meta.icon
    end

    -- Extension
    local ext = node.extension
    local extension = xplr.config.node_types.extension[ext]

    if extension ~= nil then
        return extension.meta.icon
    end

    -- Mime
    local mimes = node.mime_essence
    local mime_essence = xplr.config.node_types.mime_essence
    for mime in string.gmatch(mimes, "([^/]+)") do
        mime_essence = mime_essence["*"] or mime_essence
        mime_essence = mime_essence[mime] or mime_essence

        if mime_essence.meta ~= nil then
            return mime_essence.meta.icon
        end
    end

    -- Default
    if node.is_file then
        return xplr.config.node_types.file.meta.icon
    elseif node.is_symlink then
        return xplr.config.node_types.symlink.meta.icon
    elseif node.is_dir then
        return xplr.config.node_types.directory.meta.icon
    else
        return nil
    end
end

local function format(node)
    local function path_escape(path)
        local escaped = string.gsub(string.gsub(path, "\\", "\\\\"), "\n", "\\n")

        return escaped
    end

    -- ICON
    local meta_icon = icon(node)

    if meta_icon == nil then
        meta_icon = ""
    end
    -- NAME
    local name = path_escape(node.relative_path)

    if node.is_dir then
        name = name .. "/"
    end

    name = name .. xplr.config.general.default_ui.suffix

    if node.is_symlink then
        name = name .. " -> "

        if node.is_broken then
            name = name .. "×"
        else
            name = name .. path_escape(node.symlink.absolute_path)

            if node.symlink.is_dir then
                name = name .. "/"
            end
        end
    end

    if node.is_symlink then
        return magenta(meta_icon) .. " " .. magenta(name)
    elseif node.is_dir then
        return bold(blue(meta_icon)) .. " " .. bold(blue(name))
    else
        return meta_icon .. " " .. name
    end
end

local function stat(node)
    local type = node.mime_essence

    if node.is_symlink then
        if node.is_broken then
            type = "broken symlink"
        else
            type = "symlink to: " .. node.symlink.absolute_path
        end
    end

    return magenta(node.relative_path)
        .. "\n Type     : "
        .. type
        .. "\n Size     : "
        .. node.human_size
        .. "\n Owner    : "
        .. string.format("%s:%s", node.uid, node.gid)
        .. "\n Perm     : "
        .. permissions(node.permissions)
        .. "\n Created  : "
        .. datetime(node.created)
        .. "\n Modified : "
        .. datetime(node.last_modified)
end

local function explore(path, explorer_config, height)
    local subnodes = {}

    if xplr.util ~= nil then
        local config = { sorters = explorer_config.sorters, filters = {}, serchers = {} }
        local ok, nodes = pcall(xplr.util.explore, path, config)

        if not ok then
            nodes = {}
        end

        for i, node in ipairs(nodes) do
            if i > height + 1 then
                break
            else
                table.insert(subnodes, format(node))
            end
        end
    end

    return subnodes
end

local function read(path, height, highlight)
    local result = {}

    if highlight.enable then
        result = xplr.util.shell_execute(
            "highlight",
            {
                "--out-format=" .. (highlight.method or "xterm256"),
                "--line-range=1-" .. height,
                "--style=" .. (highlight.style or "night"),
                path
            })
    else
        result = xplr.util.shell_execute(
            "head",
            { "-" .. height, path }
        )
    end

    if result == {} or result.returncode == 1 then
        return "Unsupported format for Preview:\n" .. result.stderr
    else
        return result.stdout
    end
end

local function setup(args)
    args = args or {}

    xplr.fn.custom.preview_pane = { render = function(ctx)
        local node = ctx.app.focused_node

        if node then
            if node.is_file then
                return read(node.absolute_path, ctx.layout_size.height, args.highlight)
            elseif node.is_dir then
                local subnodes = explore(
                    node.absolute_path,
                    ctx.app.explorer_config,
                    ctx.layout_size.height
                )
                return table.concat(subnodes, "\n")
            else
                return stat(node)
            end
        else
            return ""
        end
    end }

    local preview_pane = {
        CustomContent = {
            title = "Preview",
            body = { DynamicParagraph = { render = "custom.preview_pane.render" } },
        },
    }

    xplr.config.layouts.builtin.default = {
        Vertical = {
            config = {
                constraints = {
                    { Min = 1 },
                    { Length = 3 },
                },
            },
            splits = {
                {
                    Horizontal = {
                        config = {
                            constraints = {
                                { Percentage = 55 },
                                { Percentage = 45 },
                            },
                        },
                        splits = {
                            "Table",
                            preview_pane
                        },
                    },
                },
                "InputAndLogs",
            },
        },
    }
end

return { setup = setup }
