class Libmonome < Formula
  include Language::Python::Shebang

  desc "Library for easy interaction with monome devices"
  homepage "https://monome.org/"
  url "https://github.com/monome/libmonome/archive/v1.4.5.tar.gz"
  sha256 "c7109014f47f451f7b86340c40a1a05ea5c48e8c97493b1d4c0102b9ee375cd4"
  license "ISC"
  head "https://github.com/monome/libmonome.git", branch: "main"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/libmonome"
    sha256 cellar: :any, mojave: "8488ac9fc22090ebd4f1e289d3f9fc113fec685218e8dd658aaf3274ad95cfb0"
  end

  depends_on "python@3.10" => :build
  depends_on "liblo"

  def install
    # Fix build on Mojave
    # https://github.com/monome/libmonome/issues/62
    inreplace "wscript", /conf.env.append_unique.*-mmacosx-version-min=10.5.*/,
                         "pass"

    rewrite_shebang detected_python_shebang, *Dir.glob("**/{waf,wscript}")

    system "./waf", "configure", "--prefix=#{prefix}"
    system "./waf", "build"
    system "./waf", "install"

    pkgshare.install Dir["examples/*.c"]
  end

  test do
    assert_match "failed to open", shell_output("#{bin}/monomeserial", 1)
  end
end
