$TAG = "2021.04.01"

class ScienceBundle < Formula
  include Language::Python::Virtualenv

  desc "Simple Science Bundle for local dev"
  homepage "https://github.com/BardyshBorys/homebrew-localdevelop"
  url "git@github.com:BardyshBorys/homebrew-localdevelop.git"
  license "MIT"
  head "git@github.com:BardyshBorys/homebrew-localdevelop.git"
  version "0.1"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f576b76fa2209abfa8b0923f378318199af89ddfb4915150243d1d7e73543ac0"
    sha256 cellar: :any_skip_relocation, big_sur:       "24d61894796f80e46465356b2a45a85861789a430019efd07952c108018eaba4"
    sha256 cellar: :any_skip_relocation, catalina:      "cd96e71e3eaf910f6d70dd78a02ccd21048302a16eaaf2fbfedb15712d469752"
    sha256 cellar: :any_skip_relocation, mojave:        "cbf4b82ab3f8f26ac6c7363a411aa3b692b9f2464a390e634dc5b4f61f2da0b7"
  end

  depends_on "python@3.9"


  resource "pandas" do
    url "https://files.pythonhosted.org/packages/cf/6a/b662206fd22c2f9bf70793ceb2db99cf45cfaf13f11effdee45f6e5c22e1/pandas-1.2.3-cp37-cp37m-macosx_10_9_x86_64.whl"
    sha256 "7a54efd6fcad9cb3cd5ef2064b5a3eeb0b63c99f26c346bdcf66e7c98294d7cc"
  end

  resource "matplotlib" do
    url "https://files.pythonhosted.org/packages/3c/a7/8d0b394272f2a25aa8ba4cadd396fb04e106dd277c3be621d5fadca41ced/matplotlib-3.4.1-cp37-cp37m-macosx_10_9_x86_64.whl"
    sha256 "4d821b9b911fc1b7d428978d04ace33f0af32bb7549525c8a7b08444bce46b74"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/6b/47/c14abc08432ab22dc18b9892252efaf005ab44066de871e72a38d6af464b/requests-2.25.1.tar.gz"
    sha256 "27973dd4a904a4f13b263a19c866c13b92a39ed1c964655f025f3f8d3d75b804"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/6b/34/415834bfdafca3c5f451532e8a8d9ba89a21c9743a0c59fbd0205c7f9426/six-1.15.0.tar.gz"
    sha256 "30639c035cdb23534cd4aa2dd52c3bf48f06e5f4a941509c8bafd8ce11080259"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/29/e6/d1a1d78c439cad688757b70f26c50a53332167c364edb0134cadd280e234/urllib3-1.26.2.tar.gz"
    sha256 "19188f96923873c92ccb987120ec4acaa12f0461fa9ce5d3d0772bc965a39e08"
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
