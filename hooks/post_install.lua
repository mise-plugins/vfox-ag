--- Compiles ag from source after download
--- @param ctx table Context provided by vfox
function PLUGIN:PostInstall(ctx)
    local cmd = require("cmd")

    local sdkInfo = ctx.sdkInfo["ag"]
    local path = sdkInfo.path
    local version = sdkInfo.version

    -- First, list the directory to see what was extracted
    local lsResult = cmd.exec("ls -la '" .. path .. "'")
    print("Contents of install path: " .. lsResult)

    -- Try to find the source directory
    -- GitHub tarballs may extract to repo-name-version or just directly
    local srcDir = path
    local possibleDir = path .. "/the_silver_searcher-" .. version
    local checkResult = cmd.exec("test -d '" .. possibleDir .. "' && echo 'exists' || echo 'not found'")
    if checkResult:find("exists") then
        srcDir = possibleDir
    end

    print("Using source directory: " .. srcDir)

    --- Run autogen.sh to generate configure script
    local autogenResult, autogenErr = pcall(function()
        return cmd.exec("cd '" .. srcDir .. "' && ./autogen.sh")
    end)
    if not autogenResult then
        error("autogen.sh failed: " .. tostring(autogenErr))
    end

    --- Run configure with prefix set to installation path
    local configureArgs = os.getenv("AG_CONFIGURE_ARGS") or ""
    local configureCmd = "cd '" .. srcDir .. "' && ./configure --prefix='" .. path .. "' " .. configureArgs
    local configureResult, configureErr = pcall(function()
        return cmd.exec(configureCmd)
    end)
    if not configureResult then
        error("configure failed: " .. tostring(configureErr))
    end

    --- Run make
    local makeResult, makeErr = pcall(function()
        return cmd.exec("cd '" .. srcDir .. "' && make")
    end)
    if not makeResult then
        error("make failed: " .. tostring(makeErr))
    end

    --- Run make install
    local installResult, installErr = pcall(function()
        return cmd.exec("cd '" .. srcDir .. "' && make install")
    end)
    if not installResult then
        error("make install failed: " .. tostring(installErr))
    end
end
