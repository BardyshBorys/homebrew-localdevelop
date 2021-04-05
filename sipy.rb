$TAG = "2021.04.01"

class Sipy < Formula
  include Language::Python::Virtualenv
  desc "python packages related to scientific work"
  homepage "https://github.com/BardyshBorys/ScienceBundleMacOS"
  url  "git@github.com:BardyshBorys/ScienceBundleMacOS.git", :using => :git
  head "git@github.com:BardyshBorys/ScienceBundleMacOS.git"
  version "#$TAG"
  sha256 "54c1f67fb1672908032d060020640f6a1e20057c7c31bb62a3f4791a3fee8cba"

  depends_on "python@3.9"

  resource "pandas" do
    url "https://files.pythonhosted.org/packages/cf/6a/b662206fd22c2f9bf70793ceb2db99cf45cfaf13f11effdee45f6e5c22e1/pandas-1.2.3-cp37-cp37m-macosx_10_9_x86_64.whl"
    sha256 "4d821b9b911fc1b7d428978d04ace33f0af32bb7549525c8a7b08444bce46b74"
  end

  resource "matplotlib" do
    url "https://files.pythonhosted.org/packages/3c/a7/8d0b394272f2a25aa8ba4cadd396fb04e106dd277c3be621d5fadca41ced/matplotlib-3.4.1-cp37-cp37m-macosx_10_9_x86_64.whl"
    sha256 "7a54efd6fcad9cb3cd5ef2064b5a3eeb0b63c99f26c346bdcf66e7c98294d7cc"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/29/c1/24814557f1d22c56d50280771a17307e6bf87b70727d975fd6b2ce6b014a/requests-2.25.1-py2.py3-none-any.whl"
    sha256 "c210084e36a42ae6b9219e00e48287def368a26d03a048ddad7bfee44f75871e"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/ee/ff/48bde5c0f013094d729fe4b0316ba2a24774b3ff1c52d924a8a4cb04078a/six-1.15.0-py2.py3-none-any.whl"
    sha256 "8b74bedcbbbaca38ff6d7491d76f2b06b3592611af620f8426e82dddb04a5ced"
  end

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
      bin.install 'bin/sipy.py'
      bin.install Dir[libexec/"bin/*"]
      bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

end
