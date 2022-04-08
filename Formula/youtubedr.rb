class Youtubedr < Formula
  desc "Download Youtube Video in Golang"
  homepage "https://github.com/kkdai/youtube"
  url "https://github.com/kkdai/youtube/archive/v2.7.10.tar.gz"
  sha256 "04a4f0b745094884fb2902945ac3b1c966fbe4fbd67a027cb482d491662900f9"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/youtubedr"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "6b5d89a8bc4799a84b6235bf1ca9ea8b7be1c128aad1b896b0735fbbccf8f654"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.date=#{time.iso8601}
    ].join(" ")

    ENV["CGO_ENABLED"] = "0"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/youtubedr"
  end

  test do
    version_output = pipe_output("#{bin}/youtubedr version").split("\n")
    assert_match(/Version:\s+#{version}/, version_output[0])

    info_output = pipe_output("#{bin}/youtubedr info https://www.youtube.com/watch\?v\=pOtd1cbOP7k").split("\n")
    assert_match "Title:       History of homebrew-core", info_output[0]
    assert_match "Author:      Rui Chen", info_output[1]
    assert_match "Duration:    13m15s", info_output[2]
  end
end
