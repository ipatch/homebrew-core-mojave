class Restund < Formula
  desc "Modular STUN/TURN server"
  homepage "https://web.archive.org/web/20200427184619/www.creytiv.com/restund.html"
  url "https://sources.openwrt.org/restund-0.4.12.tar.gz"
  sha256 "3170441dc882352ab0275556b6fc889b38b14203d936071b5fa12f39a5c86d47"
  revision 2

  livecheck do
    url "https://sources.openwrt.org/"
    regex(/href=.*?restund[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/restund"
    sha256 mojave: "27126fa8fee74ae8d00b0c2a1e500000f217c079dd2b218e4f97e2427d8843aa"
  end

  depends_on "libre"

  def install
    # Configuration file is hardcoded
    inreplace "src/main.c", "/etc/restund.conf", "#{etc}/restund.conf"

    libre = Formula["libre"]
    system "make", "install", "PREFIX=#{prefix}",
                              "LIBRE_MK=#{libre.opt_share}/re/re.mk",
                              "LIBRE_INC=#{libre.opt_include}/re",
                              "LIBRE_SO=#{libre.opt_lib}"
    system "make", "config", "DESTDIR=#{prefix}",
                              "PREFIX=#{prefix}",
                              "LIBRE_MK=#{libre.opt_share}/re/re.mk",
                              "LIBRE_INC=#{libre.opt_include}/re",
                              "LIBRE_SO=#{libre.opt_lib}"
  end

  test do
    system "#{sbin}/restund", "-h"
  end
end
