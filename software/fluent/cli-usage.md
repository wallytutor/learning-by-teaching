# CLI Usage

## License usage

```shell
export LMUTIL=/<path-to-ansys>/ansys_inc/<version>/licensingclient/linx64/lmutil

"${LMUTIL}" lmstat -c 1055@<ip> -a | grep "Users of" | \
    awk -F'[ ]' '{printf "%-25s %3s /%3s\n", $3, $13, $7}'
```
