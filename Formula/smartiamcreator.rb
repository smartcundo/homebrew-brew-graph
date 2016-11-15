require 'formula'

class Smartiamcreator < Formula
  homepage 'https://github.com/smartcundo/smartiamcreator'
  url 'https://github.com/smartcundo/smartiamcreator/archive/0.0.1.tar.gz'
  sha256 '232fa18d7a92d95bc32161de3c2e9c9fc131cb8b6a28d55ccaff3029d24170f0'

  def install
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
    bin.install "smartiamcreator-0.0.1/formula-smartiamcreator/create_iam_accounts.py"
    mv "#{bin}/formula-smartiamcreator/create_iam_accounts.py", "#{bin}/create_iam_accounts"
    puts "This is the end of the install"
  end

end

