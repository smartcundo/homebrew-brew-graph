require 'formula'

class Smartiamcreator < Formula
  homepage 'https://github.com/smartcundo/smartiamcreator'
  url 'https://github.com/smartcundo/smartiamcreator/archive/0.0.2.tar.gz'
  sha256 '8b11e2384cfc11d388eb6681420ac6f830b85571972c4f42fe01c9588d30ef9f'

  resource "boto" do
    url "https://pypi.python.org/packages/source/b/boto/boto-2.36.0.tar.gz"
    sha256 "8033c6f7a7252976df0137b62536cfe38f1dbd1ef443a7a6d8bc06c063bc36bd"
  end

  def install
    boto_path = libexec/"boto/lib/python2.7/site-packages"
    ENV.prepend_create_path "PYTHONPATH", boto_path
    resource("boto").stage do
      system "python", *Language::Python.setup_install_args(libexec/"boto")
    end
    (lib/"python2.7/site-packages").mkpath
    (lib/"python2.7/site-packages/homebrew-smart-boto.pth").write "#{boto_path}\n"

    Language::Python.each_python(build) do |python, version|
      ENV.prepend_create_path "PATH", buildpath/"vendor/bin"
      ENV.prepend_create_path "PYTHONPATH", buildpath/"vendor/lib/python#{version}/site-packages"

      bundle_path = libexec/"lib/python#{version}/site-packages"
      ENV.prepend_create_path "PYTHONPATH", bundle_path
      resource("six").stage do
        system python, *Language::Python.setup_install_args(libexec)
      end
      (lib/"python#{version}/site-packages/homebrew-h5py-bundle.pth").write "#{bundle_path}\n"

      args = Language::Python.setup_install_args(prefix)
      args << "configure"
      args << "--hdf5=#{Formula["homebrew/science/hdf5"].opt_prefix}"
      args << "--mpi" if build.with? :mpi

      ENV.prepend_create_path "PYTHONPATH", lib/"python#{version}/site-packages"
      system python, *args
    end
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

