class Listo < Formula
  desc "Local todo.txt web UI, REST API, and MCP server"
  homepage "https://github.com/ut0s/homebrew-listo"
  url "https://github.com/ut0s/homebrew-listo/releases/download/v0.2.3/listo-v0.2.3.tar.gz"
  version "0.2.3"
  sha256 "573e3d87374b2ca00fa0725f3c3ed2141fc21d5c7ff72c077ebbd8dabb435def"
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
