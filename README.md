# Conduit Memory Test

This test profiles memory usage over rotate operations implemented using conduit.

Rotate operation is:
- Hold the first N elements
- Yield the rest
- Yield the elements held at the first step

So it looks like:

```hs
> rotate 3 [1,2,3,4,5]
[4,5,1,2,3]
```

## Profiles

It is implemented in 3 different ways, though the differences are slight.

These profiles are taken while running those 3 implementations sequencially.


### Rotate: 0, Total: 60000

![0-60000](https://github.com/kayhide/conduit-memory-test/raw/master/doc/0-60000.png)

### Rotate: 20000, Total: 60000

![20000-60000](https://github.com/kayhide/conduit-memory-test/raw/master/doc/20000-60000.png)


## How to take profiles

First build with profile option.
With `stack`, the option is literally `--profile`.

```
$ stack build --profile --work-dir .stack-work-profile
```

Note that `--work-dir` is explicitly given here.
In this way you can keep profile-able binaries separately from "regular" ones.
Otherwise, `stack` will rebuild everything when you switch profile option.


Then execute and take a profile.

```
$ stack exec --work-dir .stack-work-profile -- conduit-memory-test 20 60 +RTS -hc
```

The key point is the last `+RTS -hc` option, which directs the executable to take heap profiling.


After finishing the execution, it outputs `*.hp`.
To visualize this, use `hp2ps` command.

```
$ hp2ps -c conduit-memory-test.hp
```

Filnally, you get `conduit-memory-test.ps` which you can open with an ordinary viewer.

On macOS, just `open` it.

```
$ open conduit-memory-test.ps
```

These whole steps are organized into `Makefile`.

Try it with:

```
$ make build
$ make run
$ make open
```
