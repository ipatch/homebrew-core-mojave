class Epic5 < Formula
  desc "Enhanced, programmable IRC client"
  homepage "http://www.epicsol.org/"
  url "http://ftp.epicsol.org/pub/epic/EPIC5-PRODUCTION/epic5-2.1.12.tar.xz"
  mirror "https://www.mirrorservice.org/sites/distfiles.macports.org/epic5/epic5-2.1.12.tar.xz"
  sha256 "c89ae4fc014ddcf0084b748e22f47b46a85ab1ac9bf0b22560360ba8626b6da6"
  license "BSD-3-Clause"
  revision 1
  head "http://git.epicsol.org/epic5.git", branch: "master"

  livecheck do
    url "http://ftp.epicsol.org/pub/epic/EPIC5-PRODUCTION/"
    regex(/href=.*?epic5[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/epic5"
    sha256 mojave: "aa105b62d0e194632b5f792ee3a16c9e878b10cf58c1e23594f588d610c24ab4"
  end

  depends_on "openssl@3"

  uses_from_macos "libxcrypt"
  uses_from_macos "ncurses"

  def install
    system "./configure", *std_configure_args,
                          "--mandir=#{man}",
                          "--with-ipv6",
                          "--with-ssl=#{Formula["openssl@3"].opt_prefix}"
    system "make"
    system "make", "install"
  end

  test do
    connection = fork do
      exec bin/"epic5", "irc.freenode.net"
    end
    sleep 5
    Process.kill("TERM", connection)
  end
end
