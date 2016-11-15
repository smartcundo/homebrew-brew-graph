require 'formula'

class Smartiamcreator < Formula
  homepage 'https://github.com/smartcundo/smartiamcreator'
  url 'https://github.com/smartcundo/homebrew-smartiamcreator.git'
  version '0.0.1'

  def install
    opoo <<-EOS.undent
      Once you've tapped this repository, you've got the command. 
      And whenever you run `brew update`, this command will be updated automatically.
    EOS
  end
end

