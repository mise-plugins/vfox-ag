# vfox-ag

[vfox](https://github.com/version-fox/vfox) plugin for [The Silver Searcher (ag)](https://github.com/ggreer/the_silver_searcher).

## Prerequisites

ag is compiled from source, so you need build dependencies installed:

### macOS

```bash
brew install automake pkg-config pcre xz
```

### Debian/Ubuntu

```bash
sudo apt-get install automake pkg-config libpcre3-dev zlib1g-dev liblzma-dev
```

### Fedora/RHEL

```bash
sudo dnf install automake pkgconfig pcre-devel xz-devel zlib-devel
```

## Installation

```bash
vfox add ag
```

## Usage

```bash
# List available versions
vfox search ag

# Install a specific version
vfox install ag@2.2.0

# Use a version globally
vfox use -g ag@2.2.0
```

## Configuration

You can pass additional configure arguments via the `AG_CONFIGURE_ARGS` environment variable:

```bash
AG_CONFIGURE_ARGS="--disable-lzma" vfox install ag@2.2.0
```

## License

Apache-2.0
