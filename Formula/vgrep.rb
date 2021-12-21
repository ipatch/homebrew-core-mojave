class Vgrep < Formula
  desc "User-friendly pager for grep"
  homepage "https://github.com/vrothberg/vgrep"
  url "https://github.com/vrothberg/vgrep/archive/v2.5.5.tar.gz"
  sha256 "6272ca460549813231bc046e6fde7e94baec03f66c4b8f88b197af7d70556013"
  license "GPL-3.0-only"
  version_scheme 1
  head "https://github.com/vrothberg/vgrep.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/vgrep"
    rebuild 3
    sha256 cellar: :any_skip_relocation, mojave: "cd6f7623c468695b8cacd7a0d7de233c215433544cc61b71c2e8c7ee301407bf"
  end

  depends_on "go" => :build
  depends_on "go-md2man" => :build

  def install
    system "make", "release"
    mkdir bin
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"test.txt").write "Hello from Homebrew!\n"
    output = shell_output("#{bin}/vgrep -w Homebrew --no-less .")
    assert_match "Hello from", output
    assert_match "Homebrew", output
  end
end
