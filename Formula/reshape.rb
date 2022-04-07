class Reshape < Formula
  desc "Easy-to-use, zero-downtime schema migration tool for Postgres"
  homepage "https://github.com/fabianlindfors/reshape"
  url "https://github.com/fabianlindfors/reshape/archive/v0.5.1.tar.gz"
  sha256 "7643ceed45e79202edadba70ed8f06f24fd25b3b21898ae0d6bca82f3753df98"
  license "MIT"
  head "https://github.com/fabianlindfors/reshape.git", branch: "main"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/reshape"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "f8005b147d04eb0ad6f5bc4a1b29ae5f1e14ffc75b3c406556fca1998f44bc41"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"migrations/test.toml").write <<~EOS
      [[actions]]
      type = "create_table"
      name = "users"
      primary_key = ["id"]

        [[actions.columns]]
        name = "id"
        type = "INTEGER"
        generated = "ALWAYS AS IDENTITY"

        [[actions.columns]]
        name = "name"
        type = "TEXT"
    EOS

    assert_match "SET search_path TO migration_test",
      shell_output("#{bin}/reshape generate-schema-query")

    assert_match "Error: error connecting to server:",
      shell_output("#{bin}/reshape migrate 2>&1", 1)
  end
end
