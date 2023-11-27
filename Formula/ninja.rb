class Ninja < Formula
  desc "Small build system for use with gyp or CMake"
  homepage "https://ninja-build.org/"
  url "https://github.com/ninja-build/ninja/archive/refs/tags/v1.11.1.tar.gz"
  sha256 "31747ae633213f1eda3842686f83c2aa1412e0f5691d1c14dbbcc67fe7400cea"
  license "Apache-2.0"
  head "https://github.com/ninja-build/ninja.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/ninja"
    rebuild 2
    sha256 cellar: :any_skip_relocation, mojave: "88db86ddb7c439a3d47524e32306a68a7518f609fc2fea1b5ae75243d10f1dd3"
  end

  # Ninja only needs Python for some non-core functionality.
  depends_on "python@3.11" => :build
  uses_from_macos "python" => :test, since: :catalina

  def python3
    "python3.11"
  end

  # Fix `source code cannot contain null bytes` for Python 3.11.4+
  # https://github.com/ninja-build/ninja/pull/2311
  patch do
    url "https://github.com/ninja-build/ninja/commit/67834978a6abdfb790dac165b8b1f1c93648e624.patch?full_index=1"
    sha256 "078c7d08278aebff346b0e7490d98f3d147db88ebfa6abf34be615b5f12bdf42"
  end

  def install
    # xy = Language::Python.major_minor_version "python3"
    # system "#{xy}", "configure.py", "--bootstrap", "--verbose", "--with-python=python3"

    # system Formula["python@3.11"].opt_bin/"python3", "configure.py", "--bootstrap", "--verbose", "--with-python=python3"
    system "python3.11", "configure.py", "--bootstrap", "--verbose", "--with-python=python3"

    bin.install "ninja"
    bash_completion.install "misc/bash-completion" => "ninja-completion.sh"
    zsh_completion.install "misc/zsh-completion" => "_ninja"
    doc.install "doc/manual.asciidoc"
    elisp.install "misc/ninja-mode.el"
    (share/"vim/vimfiles/syntax").install "misc/ninja.vim"
  end

  test do
    (testpath/"build.ninja").write <<~EOS
      cflags = -Wall

      rule cc
        command = gcc $cflags -c $in -o $out

      build foo.o: cc foo.c
    EOS
    system bin/"ninja", "-t", "targets"
    port = free_port
    fork do
      exec bin/"ninja", "-t", "browse", "--port=#{port}", "--hostname=127.0.0.1", "--no-browser", "foo.o"
    end
    sleep 15
    assert_match "foo.c", shell_output("curl -s http://127.0.0.1:#{port}?foo.o")
  end
end
