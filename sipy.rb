$TAG = "2021.04.01"

class Sipy < Formula
  include Language::Python::Virtualenv
  desc "Simple Science Bundle for local dev"
  homepage "https://github.com/BardyshBorys/homebrew-localdevelop"
  url "https://github.com/BardyshBorys/homebrew-localdevelop"
  license "MIT"
  head "git@github.com:BardyshBorys/homebrew-localdevelop.git"
  sha256 "0678199725ceba9afe8c64f6026acf3d81994c1ff3e480f351b6afbb0ce903c2"
  version "#$TAG"

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

  def install
    venv = virtualenv_create(libexec, Formula["python@3.9"].opt_bin/"python3")
    venv.pip_install resources
    venv.pip_install buildpath

    # Make the Homebrew site-packages available in the interpreter environment
    xy = Language::Python.major_minor_version Formula["python@3.9"].opt_bin/"python3"
    ENV.prepend_path "PYTHONPATH", HOMEBREW_PREFIX/"lib/python#{xy}/site-packages"
    ENV.prepend_path "PYTHONPATH", libexec/"lib/python#{xy}/site-packages"
    combined_pythonpath = ENV["PYTHONPATH"] + "${PYTHONPATH:+:}$PYTHONPATH"
    %w[bpdb bpython].each do |cmd|
      (bin/cmd).write_env_script libexec/"bin/#{cmd}", PYTHONPATH: combined_pythonpath
    end
  end
end
