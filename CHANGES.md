## 0.0.5

* Make nit compatible with a git upgrade where the status command doesn't prepend lines with a hash (#) anymore (as seen in git 1.8.5.2).

## 0.0.4

* Fixed a bug where new files starting with one of the chars in [modified] weren't recognized.
* Finally allow `nit commit -m "awesome work" abc", it didn't really work on the CLI before.

## 0.0.3

* Some bug fixes.
* Allow passing arbitrary git arguments to all nit commands, like `nit commit -m "awesome work" abc"