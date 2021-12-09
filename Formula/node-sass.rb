class NodeSass < Formula
  require "language/node"

  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.44.0.tgz"
  sha256 "b9aa8a6b9ede9f8187e3405e0df2480e7a759c4a77bdf45a666526c3c49e556c"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/node-sass"
    rebuild 2
    sha256 cellar: :any_skip_relocation, mojave: "fa43992e7eb6ebdd56ecd7fa978825b368abac1259d009d6cfab2c2deb07b2de"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test.scss").write <<~EOS
      div {
        img {
          border: 0px;
        }
      }
    EOS

    assert_equal "div img{border:0px}",
    shell_output("#{bin}/sass --style=compressed test.scss").strip
  end
end
