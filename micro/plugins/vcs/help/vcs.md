# VCS Plugin

This plugin provides support for Git and Mercurial. At the moment there is only one command:

### `> diff [action]`

Marks every changed line and shows its old state in the status bar. Inspired by IntelliJ IDEA.

Note that this saves the file in order to run a diff.

You can supply the optional `action` argument to `hide` or `toggle` the line marks instead.
A substring is also permitted, e.g. `> diff h`.

These actions are also available as functions. For example: `> bind CtrlG vcs.toggle`.
