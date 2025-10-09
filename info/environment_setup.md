# UNIX shell scripting: setting-up your environment

Please complete the setup instructions given in this document
**before the start of the course**.

## Mac OS
Mac OS comes with `bash` pre-installed, but `bash` is no longer the default
shell on Mac OS. Instead, the default shell is now `zsh` (since Mac OS
Catalina, released in 2019).

For the most part, `zsh` and `bash` behave very similarly, and it is possible
to do the course using `zsh` instead of `bash`.

If you want to use `bash` on Mac OS, you can either:
* Start a terminal, then type the command `bash` to switch to the `bash` shell.
* Or make `bash` the default shell for your user in the system preferences by
  going to:
  1. **System Preferences** > **Users & Groups** > Click the **lock** icon and
     enter your password.
  2. Hold the **Ctrl key**, click your **user account’s name** in the left
     pane, and select **Advanced Options**.
  3. Click the “Login Shell” drop-down box and select `/bin/bash` to use
     `bash` as your default shell. Select `/bin/zsh` to revert to using `zsh`
     as the default shell.

but there are a
few significant differences.

To check your version of `bash`, open a terminal and run:
```sh
/bin/bash --version
```

## Windows
Windows does not natively come with a `bash` shell, but it can be installed
via different means.

We here suggest 2 options, in order of ease of installation (easiest first):
* Install [Git for windows](https://gitforwindows.org), which comes with the
  `bash` shell emulator `GitBash`.
* Install/Enable **WSL**, the Windows Subsystem for Linux. This essentially
  installs a small Linux distribution in your Windows machine.


## Linux
Virtually all Linux distribution come with a recent version of `bash` installed
out-of-the-box. So there is no need to install anything.

To check your version of `bash`, open a terminal and run:
```sh
bash --version
```
