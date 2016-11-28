require 'formula'

class Smartiamcreator < Formula
  homepage 'https://github.com/smartcundo/smartiamcreator'
  url 'https://github.com/smartcundo/smartiamcreator/archive/v0.0.4.tar.gz'
  sha256 '322a6387177837fc3184deeef23f77a5952edfd93553d5dd5f04f699aeb225ab'

  head do
    url "https://github.com/aws/aws-cli.git", :branch => :develop

    resource "botocore" do
      url "https://github.com/boto/botocore.git", :branch => :develop
    end

    resource "bcdoc" do
      url "https://github.com/boto/bcdoc.git", :branch => :develop
    end

    resource "jmespath" do
      url "https://github.com/boto/jmespath.git", :branch => :develop
    end
  end

  depends_on :python

  #
  # Required by the 'boto3' module
  # https://github.com/boto/boto3
  #
  resource "botocore" do
    url "https://pypi.python.org/packages/source/b/botocore/botocore-1.4.11.tar.gz"
    sha256 "96295db1444e9a458a3018205187ec424213e0a69c937062347f88b7b7e078fb"
  end

  resource "boto" do
    url "https://pypi.python.org/packages/source/b/boto/boto-2.36.0.tar.gz"
    sha256 "8033c6f7a7252976df0137b62536cfe38f1dbd1ef443a7a6d8bc06c063bc36bd"
  end

  resource "boto3" do
    url "https://pypi.python.org/packages/source/b/boto3/boto3-1.3.0.tar.gz"
    sha256 "8f85b9261a5b4606d883248a59ef1a4e82fd783602dbec8deac4d2ad36a1b6f4"
  end

  resource "bcdoc" do
    url "https://pypi.python.org/packages/source/b/bcdoc/bcdoc-0.12.2.tar.gz"
    sha256 "96f83b0ab784e1e003111ff14927e4857df42aa169acccabd357ae84ec800897"
  end

  def install
    vendor_site_packages = libexec+"lib/python2.7/site-packages"
    ENV.prepend_create_path "PYTHONPATH", vendor_site_packages

    install_args = [ "setup.py", "install", "--prefix=#{libexec}" ]

    if build.head? then
      resource("jmespath").stage { system "python", *install_args }
    end

    resource("botocore").stage { system "python", *install_args }
    # resource("bcdoc").stage { system "python", *install_args }
    # resource("six").stage { system "python", *install_args }
    # resource("colorama").stage { system "python", *install_args }
    # resource("docutils").stage { system "python", *install_args }
    # resource("rsa").stage { system "python", *install_args }

    system "python", "setup.py", "install", "--prefix=#{prefix}",
      "--single-version-externally-managed", "--record=installed.txt"

    bin.env_script_all_files(libexec+"bin", :PYTHONPATH => ENV["PYTHONPATH"])

    puts "This is the start of the install"
    puts Dir.pwd
    basedir = '.'
    puts Dir.glob("*.py")
    bin.install "create_iam_accounts.py"
    mv "#{bin}/create_iam_accounts.py", "#{bin}/create_iam_accounts"
    puts "#{bin}/create_iam_accounts"
    File.symlink("#{bin}/create_iam_accounts","/usr/local/bin/create_iam_accounts")
    puts "This is the end of the install"
    
  end

end

