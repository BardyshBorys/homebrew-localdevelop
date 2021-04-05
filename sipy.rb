$TAG = "2021.04.01"

class Sipy < Formula
  include Language::Python::Virtualenv
  desc "python packages related to scientific work"
  homepage "https://github.com/BardyshBorys/ScienceBundleMacOS"
  url  "git@github.com:BardyshBorys/ScienceBundleMacOS.git", :using => :git, :branch => "main"
  head "git@github.com:BardyshBorys/ScienceBundleMacOS.git"
  version "#$TAG"
  sha256 "54c1f67fb1672908032d060020640f6a1e20057c7c31bb62a3f4791a3fee8cba"

  depends_on "python@3.9"

  fails_with :clang do
    build 425
    cause "https://bugs.python.org/issue24844"
  end

  # setuptools remembers the build flags python is built with and uses them to
  # build packages later. Xcode-only systems need different flags.
  pour_bottle? do
    reason <<~EOS
      The bottle needs the Apple Command Line Tools to be installed.
        You can install them, if desired, with:
          xcode-select --install
    EOS
    satisfy { MacOS::CLT.installed? }
  end

  def install
    venv = virtualenv_create(libexec)
    %w[
      pandas matplotlib requests
    ].each do |r|
      venv.pip_install resource(r)
    end

    ENV.prepend_create_path "PYTHONPATH", Formula["Sipy"].opt_lib/"python3.9/site-packages"
    (bin/"sipy").write_env_script libexec/"bin/sipy", :PYTHONPATH => ENV["PYTHONPATH"]
  end

end
