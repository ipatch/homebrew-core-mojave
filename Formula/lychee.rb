class Lychee < Formula
  desc "Fast, async, resource-friendly link checker"
  homepage "https://github.com/lycheeverse/lychee"
  url "https://github.com/lycheeverse/lychee/archive/v0.8.1.tar.gz"
  sha256 "88416f4c674fdf76cb92cf1b744b4f246116aaf9bdbe0da05a3b75f73f64fcf5"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/lycheeverse/lychee.git"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/lychee"
    rebuild 2
    sha256 cellar: :any, mojave: "e6bfe5408b27b81aaba0abb3e7dc0e8005b405c54f2475c7af2bbed96c4b8df8"
  end

  depends_on "rust" => :build
  depends_on "openssl@1.1"

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    cd "lychee-bin" do
      system "cargo", "install", *std_cargo_args
    end
  end

  test do
    (testpath/"test.md").write "[This](https://example.com) is an example.\n"
    output = shell_output(bin/"lychee #{testpath}/test.md")
    assert_match "🔍 1 Total ✅ 1 OK 🚫 0 Errors", output
  end
end
