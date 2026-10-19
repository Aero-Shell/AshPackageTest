local function accent(text)
    local code = colors.get("ashpkg_accent")
    if code and code ~= "" then
        return code .. text .. "\27[0m"
    end
    return text
end

local function usage()
    print("usage: ashpkg <subcommand> [args]")
    print("  hello [name]  greeting using ash.version/ash.config")
    print("  env           env.get/env.set/env.unset")
    print("  files         ash.dir/ash.package_path/os file helpers")
    print("  exec          os.execute")
    print("  color         colors.get/colors.set/prompt.color")
    print("  prompt        prompt.add_piece")
    print("  info [args]   config, version and argv")
    print("  fail          return exit code 3")
end

local commands = {}

function commands.hello(args)
    local name = args[1] or ash.config().username or "world"
    print(accent("Hello, " .. name .. "!") .. " (Ash " .. ash.version .. ")")
    return 0
end

function commands.env(_args)
    print("last command: " .. (env.get("ASH_PKG_LAST_COMMAND") or "<none>"))
    env.set("ASH_PKG_DEMO", "set by ashpkg")
    print("ASH_PKG_DEMO=" .. (env.get("ASH_PKG_DEMO") or "<unset>"))
    env.unset("ASH_PKG_DEMO")
    print("after unset: " .. (env.get("ASH_PKG_DEMO") or "<unset>"))
    return 0
end

function commands.files(_args)
    local dir = ash.dir()
    print("ash.dir()=" .. dir)

    local path = ash.package_path("data.txt")
    print("ash.package_path('data.txt')=" .. path)
    os.write_file(path, "written by ashpkg\n")
    print("os.read_file=" .. (os.read_file(path) or ""):gsub("\n$", ""))

    local entries = os.read_dir(dir)
    table.sort(entries)
    print("os.read_dir=" .. table.concat(entries, ","))
    return 0
end

function commands.exec(_args)
    local code = os.execute("printf 'hello from os.execute\\n'")
    print("os.execute exit=" .. tostring(code))
    return 0
end

local function show_color(name)
    local code = colors.get(name)
    if code then
        print(name .. "=" .. string.format("%q", code))
    else
        print(name .. "=<unset>")
    end
end

function commands.color(_args)
    show_color("ashpkg_accent")
    colors.set("ashpkg_accent", "\27[38;5;45m")
    prompt.color("ashpkg_secondary", "\27[38;5;214m")
    show_color("ashpkg_accent")
    show_color("ashpkg_secondary")
    return 0
end

function commands.prompt(_args)
    prompt.add_piece("ashpkg_now", "at {time}")
    print("registered prompt piece {{ashpkg_now}} for theme " .. tostring(ash.config().active_theme))
    return 0
end

function commands.info(args)
    local cfg = ash.config()
    print("cmd=" .. tostring(args.cmd) .. " argc=" .. tostring(#args))
    print("version=" .. ash.version)
    print("theme=" .. tostring(cfg.active_theme) .. " color=" .. tostring(cfg.color))
    for i = 1, #args do
        print("arg[" .. i .. "]=" .. args[i])
    end
    return 0
end

function commands.fail(_args)
    print("returning exit code 3")
    return 3
end

-- Drop the subcommand name but keep the cmd field for diagnostics.
local function shifted(args)
    local out = { cmd = args.cmd }
    for i = 2, #args do
        out[#out + 1] = args[i]
    end
    return out
end

return function(args)
    local sub = args[1]
    if not sub then
        usage()
        return 1
    end

    local handler = commands[sub]
    if not handler then
        print("unknown subcommand: " .. sub)
        usage()
        return 1
    end
    return handler(shifted(args))
end
