# Nit

TODO: Write a gem description

## Installation

Add this line to your application's Gemfile:

    gem 'nit'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install nit

## Usage

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
nit commit 1 2
```

Allows commiting using shortcut indexes.

```

