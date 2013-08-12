# Nit

_Improving your Git workflow since 2013._

Nit is a thin command-line wrapper for git. It gives you handy shortcuts for your everyday work with git, reduces your typing and is easily extendable with your own commands.


## Installation

```
gem install nit
```

This will install the `nit` shell command.


## Status

The blank `nit` command will be your best friend.

```shell
nit
```

It's a `git status` on LSD.

```shell
# On branch master
# Changes not staged for commit:
#   (use "git add <file>..." to update what will be committed)
#   (use "git checkout -- <file>..." to discard changes in working directory)
#
#	modified:   on_stage.rb  [a]
#	modified:   staged.rb  [b]
#
# Untracked files:
#   (use "git add <file>..." to include in what will be committed)
#
#	brandnew.rb  [c]
#	new.rb  [d]
```

First of all, it shows you the current branch in bold.

## File Indexes

Secondly, the status screen renders a file index for each file which can be used on the command-line.

Indexes per default are characters on the right-hand side of the filename. This can be configured, in case you prefer digits. You can also have the indexes prepended to the filename.

However, scientific studies with `nit` over the last 18 years have proven that characters instead of digits are faster to reach when typing. Also, indexes _appended_ to the filename make them easier to read when deciding what to commit.

## Commit

To commit files, you no longer use the filename but their indexes.

```shell
nit commit a c
```

Which will run

```
git add on_stage.rb
git add brandnew.rb
git commit
```

Note that nits adds and commits an already staged file _and_ an untracked file in the same step.

This could also be run as

```shell
nit commit ac
```

Nit will extract the correct indexes.


## Auto-Expansion Of Commands

You don't have to type `nit commit` everytime. Use a short-cut, nit figures out what command you want. This command will work, too.

```shell
nit co abc
```

## Add

Adding with nit becomes obsolete. It is handled by the `commit` command.


## Ignoring Files

When files on the status screen get in your way you can _ignore_ them. Nit will simply not consider them anymore until you `unignore` them.

Ignoring files is roughly equivalent to `git stash`. However, instead of having to remember dozens of stashes, you simply tell nit to hide files from your status. That helps focusing on the files you are actually working on. Trust us.


```shell
nit ignore a d
```

This tells nit to ignore `on_stage.rb` and `new.rb`.

```shell
$ nit

# On branch master
# Changes not staged for commit:
#   (use "git add <file>..." to update what will be committed)
#   (use "git checkout -- <file>..." to discard changes in working directory)
#
#	modified:   staged.rb  [a]
#
# Untracked files:
#   (use "git add <file>..." to include in what will be committed)
#
#	brandnew.rb  [b]
#
# Ignored files: 2
```

The ignored files are now longer visible. However, the last line reminds you that there are files ignored.

To get a list of ignored files, run:

```shell
nit ignore
```

```shell
[a] on_stage.rb
[b] new.rb
```

If you want to commit to the ignored files, just unignore them, again.

```shell
nit unignore a
```

## Push

To push your changes, run the following command.

```shell
nit push
```

Will figure out the current branch and run

```shell
git push origin <current branch>
```

## Pull

The same works for `nit pull`.


## Arbitrary Commands

You can use nit's index interpolation for any git command.

```shell
nit diff ab
``


## Manual Configuration

Some operations require nit to save application state. This is done in the `.nit` YAML file in your working directory. You can manually edit it.


## Alternative Indexing

You can have number-based indexing.

```shell
modified:   on_stage.rb  [0]
modified:   staged.rb  [1]
```

In `.nit`, do

```yaml
indexer = "IntegerIndexer"
```

Some people prefer the index prepending the file name.

```shell
modified:  [0] on_stage.rb
modified:  [1] staged.rb

```

Nap in the park.

```yaml
index_renderer = "PrependIndexRenderer"
```

## Extending Nit

Extending nit with your own commands can be done either with gems or by placing the extensions into your `.nit` directory. This will be implemented and documented soon.


## More

There are plenty of more features planned for the upcoming versions.


## License

Copyright (c) 2013, Nick Sutterer <apotonick@gmail.com>

Released under the MIT License.