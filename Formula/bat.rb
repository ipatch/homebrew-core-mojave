class Bat < Formula
  desc "Clone of cat(1) with syntax highlighting and Git integration"
  homepage "https://github.com/sharkdp/bat"
  url "https://github.com/sharkdp/bat/archive/v0.20.0.tar.gz"
  sha256 "12eca3add56f21b8056a4c17cfb5bffc45e107f23f75a8e0f5de948d8e997c39"
  license any_of: ["Apache-2.0", "MIT"]

bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/bat"
    sha256 cellar: :any_skip_relocation, mojave: "a3d1302fe0c120e90718810f16f79b43a8e5db94a75752510be5cea4cc8f0614"
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    ENV["SHELL_COMPLETIONS_DIR"] = buildpath
    system "cargo", "install", *std_cargo_args

    assets_dir = Dir["target/release/build/bat-*/out/assets"].first
    man1.install "#{assets_dir}/manual/bat.1"
    bash_completion.install "#{assets_dir}/completions/bat.bash" => "bat"
    fish_completion.install "#{assets_dir}/completions/bat.fish"
    zsh_completion.install "#{assets_dir}/completions/bat.zsh" => "_bat"
  end

  test do
    pdf = test_fixtures("test.pdf")
    output = shell_output("#{bin}/bat #{pdf} --color=never")
    assert_match "Homebrew test", output
  end
end
