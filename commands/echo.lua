return function(args)
    print("ashpkg-echo: " .. table.concat(args, " "))
    return 0
end
