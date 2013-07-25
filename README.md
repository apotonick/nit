# Nit

TODO: Write a gem description

## Installation

Add this line to your application's Gemfile:

    gem 'nit'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install nit

## Status & Commit

```shell
nit status
```

Shows file indexes.

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

## Pull & Push

```shell
nit pull
```

Will figure out the current branch and run

```shell
git pull origin <current branch>
```

The same works for `nit push`.