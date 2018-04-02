# mtenv

`mtenv` is a version manager for the Myst programming language, inspired by rbenv and other similar version managers.



# Installation

For platforms with a pre-built binary (see the [releases page](https://github.com/myst-lang/mtenv/releases/tag/v0.0.1) to find these), simply download the binary, place it on your `PATH` and you're good to go!

```shell
# macOS example:
curl -o mtenv https://github.com/myst-lang/mtenv/releases/download/v0.0.1/mtenv-macos-10.12
cp ./mtenv /usr/local/bin/mtenv
chmod +x /usr/local/bin/mtenv
```

For other platforms, you'll need to compile from source. To do so, you can clone this repository and run `shards build`, then move the compiled binary onto your $PATH.

```shell
git clone https://github.com/myst-lang/mtenv.git
cd mtenv
shards build
cp ./bin/mtenv /usr/local/bin/mtenv
```

If you create a new pre-built binary, I'd appreciate you sending in the binary for others to download themselves. The [Myst language discord](https://discord.myst-lang.org) is a great place to discuss this.

Once `mtenv` is on your `PATH`, the installation is complete.



# Usage

`mtenv` uses sub-commands to perform its various tasks. To see these commands listed out, just run `mtenv` to see the usage instructions. Further explanations are given here.


### Initial setup

When first installing `mtenv`, run `mtenv setup` to initialize the `~/.mtenv` directory and install the shims.

```shell
mtenv setup
```

`mtenv setup` will:

  - ensure that `~/.mtenv/` exists and add some basic configuration.
  - create `/usr/local/bin/myst` as a symlink to `~/.mtenv/shims/myst`, the executable that `mtenv` manages to control `myst` versions.

Now you are fully set up to use `mtenv` and install new versions of Myst.

_Note_: If you have existing versions of Myst installed via Homebrew or any other method, be sure to remove them from your PATH before using `mtenv`! Otherwise `mtenv` may not take precedence and may cause unexpected behavior._


### Installing new versions of Myst

To install a new version of Myst, use `mtenv install <version>`. `version` can be a tagged release number (e.g., `v0.5.0`, `v0.6.0`), or a commit SHA from the official myst-lang repository. `install` also accepts an optional second argument for a different name to use for the installation.

```shell
$ mtenv install v0.5.0
Version v0.5.0 of Myst is now installed
$ mtenv versions
v0.5.0
$ mtenv install v0.5.0 beta-5
Version beta-5 of Myst is now installed
$ mtenv versions
beta-5
v0.5.0
```

To _uninstall_ a specific version of Myst, use `mtenv uninstall <version>`. This will remove the installation

```shell
$ mtenv versions
v0.4.0
v0.5.0
$ mtenv uninstall v0.4.0
Version v0.4.0 of Myst has been uninstalled.
$ mtenv versions
v0.5.0
```


### Switching versions

To see which version of Myst is currently active, use `mtenv version`.

To see which versions of Myst are currently installed, use `mtenv versions`.

To switch between active versions of Myst (i.e., what the `myst` command will use), use `mtenv use <version>`.

```shell
$ mtenv version
v0.3.0
$ myst -v
v0.3.0
$ mtenv versions
v0.3.0
v0.4.0
v0.5.0
v0.6.0
$ mtenv use v0.4.0
Active Myst version is now v0.4.0
$ mtenv version
v0.4.0
$ myst -v
v0.4.0
```


### Uninstalling `mtenv`

To unlink `mtenv` from your PATH and remove all installations, use `mtenv implode`. This command removes _everything_ relating to `mtenv`, except for the `mtenv` binary itself.

```
$ ./bin/mtenv implode
Are you sure you want to completely uninstall mtenv? This cannot be undone.
The `mtenv` command will remain installed, but all installations will be lost.
Type 'implode' to confirm your intent.
> implode
...
$
```



# Development

Just a normal Crystal project. This project uses [Admiral](https://github.com/jwaldrip/admiral.cr) for setting up the CLI, and each command lives in the `src/commands` folder.
