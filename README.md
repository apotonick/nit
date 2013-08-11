# Nit

_Improving your Git workflow since 2013._

Nit is a thin command-line wrapper for `git` commands. It gives you handy shortcuts for your everyday workflows.

## Installation

```
gem install 'nit'
```

## Status & Commit

The blank `nit` command will be your best friend - it's a `git status` on LSD.

```shell
nit
```

Shows file indexes. new files. bold branch FIXME.

```shell
# On branch 1-7
# Changes not staged for commit:
#   (use "git add <file>..." to update what will be committed)
#   (use "git checkout -- <file>..." to discard changes in working directory)
#
#	modified: [0]    Rakefile
#	modified: [1]    test/hash_test.rb
#	modified: [2]    test/private/prototype_test.rb
#
no changes added to commit (use "git add" and/or "git commit -a")
```

```
nit commit 0 1
```

Which will run

```
git add Rakefile test/hash_test.rb
git commit
```

## Add

Adding with nit becomes obsolete.

```
$ nit status

# On branch 1-7
# Changes not staged for commit:
#   (use "git add <file>..." to update what will be committed)
#   (use "git checkout -- <file>..." to discard changes in working directory)
#
#	modified: [0]    test/hash_test.rb
#
# Untracked files:
#   (use "git add <file>..." to include in what will be committed)
#
#	 [1] test/xml_test.rb
no changes added to commit (use "git add" and/or "git commit -a")
```

Now, running

```
nit commit 0 1
```

will add and commit for you.

```
git add test/hash_test.rb test/xml_test.rb
git commit
```

## Running Arbitrary Git Commands With File Interpolation

This is especially helpful for things like

`nit diff 1 2`

## Ignoring Files

## Speeding It Up

You can abbreviate commands.


## Pull & Push

```shell
nit pull
```

Will figure out the current branch and run

```shell
git pull origin <current branch>
```

The same works for `nit push`.