--- Compiles ag from source after download
--- @param ctx table Context provided by vfox
function PLUGIN:PostInstall(ctx)
    local shell = require("shell")

    local sdkInfo = ctx.sdkInfo["ag"]
    local path = sdkInfo.path
    local version = sdkInfo.version

    -- The tarball extracts to a subdirectory
    local srcDir = path .. "/the_silver_searcher-" .. version

    --- Run autogen.sh to generate configure script
    local autogenResult = shell.run_command({
        command = "./autogen.sh",
        work_dir = srcDir,
    })
    if autogenResult.exit_code ~= 0 then
        error("autogen.sh failed: " .. (autogenResult.stderr or autogenResult.stdout or "unknown error"))
    end

    --- Run configure with prefix set to installation path
    local configureArgs = os.getenv("AG_CONFIGURE_ARGS") or ""
    local configureCmd = "./configure --prefix=" .. path .. " " .. configureArgs
    local configureResult = shell.run_command({
        command = configureCmd,
        work_dir = srcDir,
    })
    if configureResult.exit_code ~= 0 then
        error("configure failed: " .. (configureResult.stderr or configureResult.stdout or "unknown error"))
    end

    --- Run make
    local makeResult = shell.run_command({
        command = "make",
        work_dir = srcDir,
    })
    if makeResult.exit_code ~= 0 then
        error("make failed: " .. (makeResult.stderr or makeResult.stdout or "unknown error"))
    end

    --- Run make install
    local installResult = shell.run_command({
        command = "make install",
        work_dir = srcDir,
    })
    if installResult.exit_code ~= 0 then
        error("make install failed: " .. (installResult.stderr or installResult.stdout or "unknown error"))
    end
end
