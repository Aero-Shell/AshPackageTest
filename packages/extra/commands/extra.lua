return function(args)
    print("nested package ashpkg-extra says hi " .. (args[1] or "there"))
    return 0
end
