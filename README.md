# mtenv

`mtenv` is a version manager for the Myst programming language, inspired by rbenv and other similar version managers.

**It is currently a work in progress and should not be used for actual installations**. See the installation instructions in [Myst's README](https://github.com/myst-lang/myst#installation) for the time being.


# Installation

Since `mtenv` is contained in a single executable file, installing it is as simple as copying the single `mtenv` file to somewhere on your `$PATH`.

From a command line, something as simple as

```shell
# Download the script
curl -o mtenv 'https://raw.githubusercontent.com/myst-lang/mtenv/master/mtenv'
# Copy it onto the `PATH`
cp ./mtenv /usr/local/bin/mtenv
# Make sure it's executable
chmod +x /usr/local/bin/mtenv
```

And that's it! Running `mtenv` should now work and show you the usage instructions. However, `mtenv` also expects and depends on a `.mtenv` directory existing in your home directory (i.e., `~/.mtenv/`). This directory is used to store the installed versions of Myst and some other settings.

When first installing `mtenv`, run `mtenv setup` to make sure this directory exists and has the proper content:

```shell
mtenv setup
```

`mtenv setup` will:

  - ensure that `~/.mtenv/` exists and add some basic configuration.
  - create `/usr/local/bin/myst` as a symlink to `~/.mtenv/shims/myst`, the executable that `mtenv` manages to control `myst` versions.

Now you are fully set up to use `mtenv` and install new versions of Myst.

_Note_: If you have existing versions of Myst installed via Homebrew or any other method, be sure to remove them from your PATH before using `mtenv`! Otherwise `mtenv` may not take precedence and may cause unexpected behavior._


# Usage

`mtenv` uses sub-commands to perform its various tasks. To see these commands listed out, just run `mtenv` to see the usage instructions. Further explanations are given here.

- `mtenv install <version>`: install the version of Myst given by the argument. This will _not_ override the currently in-use version.
- `mtenv version`: show the version number of the currently in-use version of Myst.
- `mtenv installled`: show all currently-installed versions of Myst.
- `mtenv available`: show all versinos of Myst that are available for installation.
