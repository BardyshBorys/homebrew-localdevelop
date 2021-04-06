$TAG = "2021.04.05"

class SipyAT20210405 < Formula
  include Language::Python::Virtualenv
  desc "python packages related to scientific work"
  homepage "https://github.com/BardyshBorys/ScienceBundleMacOS"
  url  "git@github.com:BardyshBorys/ScienceBundleMacOS.git", :using => :git, :tag => $TAG
  head  "git@github.com:BardyshBorys/ScienceBundleMacOS.git", :using => :git, :tag => $TAG
  version $TAG
  sha256 "54c1f67fb1672908032d060020640f6a1e20057c7c31bb62a3f4791a3fee8cba"

  livecheck do
    url "https://github.com/BardyshBorys/ScienceBundleMacOS/tags"
    regex(/^(\d{4}.\d{2}.\d{2})$/i)
    strategy :git do |tags, regex|
      tags.map { |tag| tag }.compact
    end
  end
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
      rm bin/"sipy"
      bin.install "bin/sipy.py" => "sipy"
  end

end
