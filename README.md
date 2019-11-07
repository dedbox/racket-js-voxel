# Js-Voxel
[![Racket Package](https://img.shields.io/badge/raco%20pkg-js-voxel-red.svg)](https://pkgd.racket-lang.org/pkgn/package/js-voxel)
[![Documentation](https://img.shields.io/badge/read-docs-blue.svg)](http://docs.racket-lang.org/js-voxel/)
[![Build Status](https://travis-ci.org/dedbox/racket-algebraic.svg?branch=master)](https://travis-ci.org/dedbox/racket-js-voxel)
[![Coverage Status](https://coveralls.io/repos/github/dedbox/racket-algebraic/badge.svg?branch=master)](https://coveralls.io/github/dedbox/racket-js-voxel?branch=master)

A general-purpose voxel programming environment.

## Installation and Use

The [`js-voxel`](https://pkgd.racket-lang.org/pkgn/package/js-voxel) package in
the official Racket package repository can be installed from DrRacket's
package manager, or with `raco pkg` from the command line.

```
raco pkg install js-voxel
```

To start using it, set the initial line of your Racket source file to:

```
#lang js-voxel
```

## Examples

Several example programs are included in the
[js-voxel/examples](https://github.com/dedbox/racket-js-voxel/tree/master/examples)
collection.

The easiest way to run one from DrRacket is to run a `racket` program that
`requires` it:

```racket
#lang racket

(require js-voxel/examples/axes)
```

This will open a Web browser to display the program's output. Results of
commands entered into the interactions panel are also displayed in the Web
browser.

To run an example from the command line, run `racket` with the `-l` flag:

```
racket -l js-voxel/examples/axes
```

This will open a Web browser for output. To include a REPL for input, add the
`-i` flag:


```
racket -il js-voxel/examples/axes
```
