class WildflyAs < Formula
  desc "Managed application runtime for building applications"
  homepage "https://www.wildfly.org/"
  url "https://github.com/wildfly/wildfly/releases/download/26.0.1.Final/wildfly-26.0.1.Final.tar.gz"
  sha256 "bd40fcf0bc2ff1a910eb6c2e5f2cb1946053cb2d15c0323aefb40f0f3852c5e5"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://www.wildfly.org/downloads/"
    regex(/href=.*?wildfly[._-]v?(\d+(?:\.\d+)+)\.Final\.t/i)
  end

  bottle do
    sha256 cellar: :any, all: "b04e4e4beb6c592f3aeb1a0478a14b829a6f7d7bbc9a00c4c9fa70b6fb8e6cba"
  end

  # Installs a pre-built x86_64-only `libwfssl`
  depends_on arch: :x86_64
  # Installs a pre-built `libartemis-native-64.so` file with linkage to libaio.so.1
  depends_on :macos
  depends_on "openjdk"

  def install
    buildpath.glob("bin/*.{bat,ps1}").map(&:unlink)
    buildpath.glob("**/win-x86_64").map(&:rmtree)

    inreplace "bin/standalone.sh", /JAVA="[^"]*"/, "JAVA='#{Formula["openjdk"].opt_bin}/java'"

    libexec.install Dir["*"]
    mkdir_p libexec/"standalone/log"
  end

  def caveats
    <<~EOS
      The home of WildFly Application Server #{version} is:
        #{opt_libexec}
      You may want to add the following to your .bash_profile:
        export JBOSS_HOME=#{opt_libexec}
        export PATH=${PATH}:${JBOSS_HOME}/bin
    EOS
  end


  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>KeepAlive</key>
        <dict>
          <key>SuccessfulExit</key>
          <false/>
          <key>Crashed</key>
          <true/>
        </dict>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_libexec}/bin/standalone.sh</string>
          <string>--server-config=standalone.xml</string>
        </array>
        <key>EnvironmentVariables</key>
        <dict>
          <key>JBOSS_HOME</key>
          <string>#{opt_libexec}</string>
          <key>WILDFLY_HOME</key>
          <string>#{opt_libexec}</string>
        </dict>
      </dict>
      </plist>
    EOS
  end

  test do
    ENV["JBOSS_HOME"] = opt_libexec
    system "#{opt_libexec}/bin/standalone.sh --version | grep #{version}"

    port = free_port

    pidfile = testpath/"pidfile"
    ENV["LAUNCH_JBOSS_IN_BACKGROUND"] = "true"
    ENV["JBOSS_PIDFILE"] = pidfile

    mkdir testpath/"standalone"
    mkdir testpath/"standalone/deployments"
    cp_r libexec/"standalone/configuration", testpath/"standalone"
    fork do
      exec opt_libexec/"bin/standalone.sh", "--server-config=standalone.xml",
                                            "-Djboss.http.port=#{port}",
                                            "-Djboss.server.base.dir=#{testpath}/standalone"
    end
    sleep 10

    begin
      system "curl", "-X", "GET", "localhost:#{port}/"
      output = shell_output("curl -s -X GET localhost:#{port}")
      assert_match "Welcome to WildFly", output
    ensure
      Process.kill "SIGTERM", pidfile.read.to_i
    end
  end
end
