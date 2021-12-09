class QpidProton < Formula
  desc "High-performance, lightweight AMQP 1.0 messaging library"
  homepage "https://qpid.apache.org/proton/"
  url "https://www.apache.org/dyn/closer.lua?path=qpid/proton/0.36.0/qpid-proton-0.36.0.tar.gz"
  mirror "https://archive.apache.org/dist/qpid/proton/0.36.0/qpid-proton-0.36.0.tar.gz"
  sha256 "d2a6bf00265a07ba526983b07604534c7c7b564923254565b42d1f97274e92d8"
  license "Apache-2.0"
  head "https://gitbox.apache.org/repos/asf/qpid-proton.git", branch: "main"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/qpid-proton"
    rebuild 2
    sha256 cellar: :any, mojave: "cc0f4114cb4f7be790be953df3b5a4a6d44e88f6fa4f8efaa96a908fb18c3ead"
  end

  depends_on "cmake" => :build
  depends_on "libuv"
  depends_on "openssl@1.1"

  def install
    mkdir "build" do
      system "cmake", "..", "-DBUILD_BINDINGS=",
                         "-DLIB_INSTALL_DIR=#{lib}",
                         "-DBUILD_TESTING=OFF",
                         "-Dproactor=libuv",
                         *std_cmake_args
      system "make", "install"
    end
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include "proton/message.h"
      #include "proton/messenger.h"
      int main()
      {
          pn_message_t * message;
          pn_messenger_t * messenger;
          pn_data_t * body;
          message = pn_message();
          messenger = pn_messenger(NULL);
          return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lqpid-proton", "-o", "test"
    system "./test"
  end
end
