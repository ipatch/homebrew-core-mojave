class Helmsman < Formula
  desc "Helm Charts as Code tool"
  homepage "https://github.com/Praqma/helmsman"
  url "https://github.com/Praqma/helmsman.git",
      tag:      "v3.7.7",
      revision: "321afde41994fb847b36a1da3590d5d405b34f1d"
  license "MIT"
  head "https://github.com/Praqma/helmsman.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/helmsman"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "45519c51b38d029d88a2335f05fa9d624d3665b2eeb4df0c611e52e8ad1328db"
  end

  depends_on "go" => :build
  depends_on "helm"
  depends_on "kubernetes-cli"

  def install
    system "go", "build", *std_go_args, "-ldflags", "-s -w -X main.version=#{version}", "./cmd/helmsman"
    pkgshare.install "examples/example.yaml"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/helmsman version")

    output = shell_output("#{bin}/helmsman --apply -f #{pkgshare}/example.yaml 2>&1", 1)
    assert_match "helm diff not found", output
  end
end
