-- Runs once when the package loads. Exercises prompt pieces, hooks and env.
prompt.add_piece("ashpkg_badge", "aepkg " .. (ash.config().username or "user"))
prompt.add_piece("ashpkg_now", "ready")

hooks.register("command", function(args)
    if args.cmd == "ashpkg" or args.cmd == "ashpkg-echo" or args.cmd == "ashpkg-extra" then
        env.set("ASH_PKG_LAST_COMMAND", args.cmd)
    end
end)

hooks.register("command_done", function(args)
    if args.cmd == "ashpkg" or args.cmd == "ashpkg-echo" or args.cmd == "ashpkg-extra" then
        print("\27[38;5;213m[ashpkg hook] " .. args.cmd .. " -> " .. tostring(args.status) .. "\27[0m")
    end
end)
