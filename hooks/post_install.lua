--- Compiles ag from source after download
--- @param ctx table Context provided by vfox
function PLUGIN:PostInstall(ctx)
    local cmd = require("cmd")

    local sdkInfo = ctx.sdkInfo["ag"]
    local path = sdkInfo.path

    -- Source files are extracted directly to the install path
    local srcDir = path

    --- Run autogen.sh to generate configure script
    cmd.exec("cd '" .. srcDir .. "' && ./autogen.sh")

    --- Run configure with prefix set to installation path
    local configureArgs = os.getenv("AG_CONFIGURE_ARGS") or ""
    cmd.exec("cd '" .. srcDir .. "' && ./configure --prefix='" .. path .. "' " .. configureArgs)

    --- Run make
    cmd.exec("cd '" .. srcDir .. "' && make")

    --- Run make install
    cmd.exec("cd '" .. srcDir .. "' && make install")
end
