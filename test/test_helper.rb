require 'minitest/autorun'
require 'nit/app'

MiniTest::Spec.class_eval do
  let (:output) do <<-EOF
    # On branch master
    # Changes not staged for commit:
    #   (use "git add <file>..." to update what will be committed)
    #   (use "git checkout -- <file>..." to discard changes in working directory)
    #
    #\tmodified:   on_stage.rb
    #\tmodified:   staged.rb
    #
    # Untracked files:
    #   (use "git add <file>..." to include in what will be committed)
    #
    #\tbrandnew.rb
    #\tnew.rb
    #\t../lib/new.rb
    #\tdb/migrate/
    no changes added to commit (use "git add" and/or "git commit -a")
    EOF
  end
end