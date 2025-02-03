# Git

## Version control in Windows

- [TortoiseGIT](https://tortoisegit.org/): for Windows users, this applications add the possibility of managing version control and other features directly from the file explorer.

## Adding submodules

Generally speaking adding a submodule to a repository should be a simple matter of

```shell
git submodule add https://<path>/<to>/<repository>
```

Nonetheless this might fail, especially for large sized repositories; I faced [this issue](https://stackoverflow.com/questions/66366582) which I tried to fix by increasing buffer size as reported in the link. This solved the issue but led me to [another problem](https://stackoverflow.com/questions/59282476) which could be solved by degrading HTTP protocol.

The reverse operation cannot be fully automated as discussed [here](https://stackoverflow.com/questions/1260748). In general you start with

```shell
git rm <path-to-submodule>
```

and then manually remove the history with

```shell
rm -rf .git/modules/<path-to-submodule>

git config remove-section submodule.<path-to-submodule>
```
