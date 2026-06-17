class Listo < Formula
  desc "Local todo.txt web UI, REST API, and MCP server"
  homepage "https://github.com/ut0s/homebrew-listo"
  url "https://github.com/ut0s/homebrew-listo/releases/download/v0.2.6/listo-v0.2.6.tar.gz"
  version "0.2.6"
  sha256 "701e7aff1357760feec46eead9fb380d5c29210483623df0e5a3306c88464524"
  license :cannot_represent

  depends_on "node"
  depends_on "pnpm" => :build

  def install
    system "pnpm", "install", "--prod", "--frozen-lockfile"

    libexec.install "dist", "node_modules", "package.json", "public"
    chmod 0555, libexec/"dist/cli.js"
    bin.install_symlink libexec/"dist/cli.js" => "listo"
  end

  test do
    assert_match "Usage:", shell_output("#{bin}/listo --help")
  end
end
