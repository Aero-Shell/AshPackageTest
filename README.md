# AshPackageTest

Test package for the Ash package system.

## Install

Local checkout:

```bash
aepkg install /path/to/AshPackageTest
```

From git (after committing/pushing):

```bash
aepkg install /Aero-Shell/AshPackageTest
aepkg install /Aero-Shell/AshPackageTest/tree/main/packages/extra
```

Full URLs (`https://github.com/Aero-Shell/AshPackageTest`) also work.

The nested package can also be installed from a checkout with:

```bash
aepkg install /path/to/AshPackageTest/packages/extra
```

## Commands

```bash
ashpkg hello [name]   # greeting, ash.version, ash.config
ashpkg env            # env.get/set/unset
ashpkg files          # ash.dir, ash.package_path, os file helpers
ashpkg exec           # os.execute
ashpkg color          # colors.get/set and prompt.color
ashpkg prompt         # prompt.add_piece
ashpkg info [args]    # config, version and argv
ashpkg fail           # returns exit code 3
ashpkg-echo a b c     # second command entry
ashhello              # manifest alias for `ashpkg hello`
ashextra              # alias from the nested package
```

## Contributions exercised

- Two commands and a completion definition.
- `init.lua` prompt piece plus a manifest prompt template and piece.
- `command` and `command_done` hooks.
- A color, an alias, a config setting (`active_theme`) and prompt pieces.
- A nested package for testing `/tree/<ref>/<path>` and `#<path>` installs.
