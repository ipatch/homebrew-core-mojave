class PythonTkAT310 < Formula
  desc "Python interface to Tcl/Tk"
  homepage "https://www.python.org/"
  url "https://www.python.org/ftp/python/3.10.6/Python-3.10.6.tgz"
  sha256 "848cb06a5caa85da5c45bd7a9221bb821e33fc2bdcba088c127c58fad44e6343"
  license "Python-2.0"

  livecheck do
    formula "python@3.10"
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/python-tk@3.10"
    sha256 cellar: :any, mojave: "7fad6271142f96bb4ef7d61f1e93b819240ad17df7f696a8fe2885c01b3533f0"
  end

  keg_only :versioned_formula

  depends_on "python@3.10"
  depends_on "tcl-tk"

  def install
    cd "Modules" do
      tcltk_version = Formula["tcl-tk"].any_installed_version.major_minor
      (Pathname.pwd/"setup.py").write <<~EOS
        from setuptools import setup, Extension

        setup(name="tkinter",
              description="#{desc}",
              version="#{version}",
              ext_modules = [
                Extension("_tkinter", ["_tkinter.c", "tkappinit.c"],
                          define_macros=[("WITH_APPINIT", 1)],
                          include_dirs=["#{Formula["tcl-tk"].opt_include}"],
                          libraries=["tcl#{tcltk_version}", "tk#{tcltk_version}"],
                          library_dirs=["#{Formula["tcl-tk"].opt_lib}"])
              ]
        )
      EOS
      system Formula["python@3.10"].bin/"python3", *Language::Python.setup_install_args(libexec),
                                                  "--install-lib=#{libexec}"
      rm_r Dir[libexec/"*.egg-info"]
    end
  end

  test do
    system Formula["python@3.10"].bin/"python3", "-c", "import tkinter"

    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    system Formula["python@3.10"].bin/"python3", "-c", "import tkinter; root = tkinter.Tk()"
  end
end
