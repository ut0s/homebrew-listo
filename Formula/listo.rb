class Listo < Formula
  desc "Local todo.txt web UI, REST API, and MCP server"
  homepage "https://github.com/ut0s/homebrew-listo"
  url "https://github.com/ut0s/homebrew-listo/releases/download/v0.2.7/listo-v0.2.7.tar.gz"
  version "0.2.7"
  sha256 "fa4fdaca3e7e143b6170059ce005542f875735d08a115ed0f111ded626da0111"
  license :cannot_represent

  depends_on "node"

  def install
    libexec.install "dist", "node_modules", "package.json", "public"
    chmod 0555, libexec/"dist/cli.js"
    bin.install_symlink libexec/"dist/cli.js" => "listo"
  end

  test do
    assert_match "Usage:", shell_output("#{bin}/listo --help")
  end
end
