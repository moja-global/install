<div align="center">
<img src="https://moja.global/wp-content/uploads/2021/03/Asset-66@4x.png" alt="FLINT UI logo" height ="auto" width="200" />
<br />
</div>

# About
Cross-platform set of scripts to install moja global's FLINT and GCBM.

# Install
A bash script, [install.sh](https://github.com/moja-global/install/blob/main/install.sh) is provided to install, update or uninstall FLINT AppImages.

You can clone this repository, and run the script as follows:
```sh
git clone https://github.com/moja-global/install
cd install
chmod +x ./install.sh
./install.sh --help
```

or you can use `curl` or `wget`.


- `curl`:
```sh
curl -sL https://raw.githubusercontent.com/moja-global/install/main/install.sh | bash -s -- '--help'
```


# Parameters
- `--install <release>`: Installs FLINT AppImage by fetching the latest release and placing it into `.local/bin/` folder in your home directory (Installs stable release by default). `release` can either be `dev` or `stable`.
- `--uninstall`: Uninstalls any existing FLINT installation.
- `--update`: Updates the FLINT AppImage if the version on the host machine is out of date.
- `--help`: Provides with usage help.

## Examples
- Install FLINT AppImage (stable release)
```sh
./install.sh --install
```
- Install FLINT AppImage without cloning the repository (stable release)
```sh
curl --insecure -sL https://raw.githubusercontent.com/moja-global/install/main/install.sh | bash -s -- '--install'
```

- Install FLINT AppImage (dev release)
```sh
./install.sh --install dev
```

- Uninstall FLINT AppImage
```sh
./install.sh --uninstall
```

- Update FLINT AppImage
```sh
./install.sh --update
```
