class Listo < Formula
  desc "Local todo.txt web UI, REST API, and MCP server"
  homepage "https://github.com/ut0s/homebrew-listo"
  url "https://github.com/ut0s/homebrew-listo/releases/download/v0.2.13/listo-v0.2.13.tar.gz"
  version "0.2.13"
  sha256 "58730a83412fcc50e11bf4fe4231a248d073087a95f6fb8239e2f4504a95ed88"
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

    todo = testpath/"todo.txt"
    todo.write("Review Homebrew MCP +listo\n")
    port = free_port
    pid = fork do
      ENV["LISTO_NO_OPEN"] = "1"
      exec (bin/"listo").to_s, "--port", port.to_s, todo.to_s
    end
    begin
      response = nil
      30.times do
        begin
          response = shell_output <<~EOS
            curl -sS -X POST http://127.0.0.1:#{port}/mcp \
              -H 'content-type: application/json' \
              -H 'accept: application/json, text/event-stream' \
              --data '{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-06-18","capabilities":{},"clientInfo":{"name":"brew-test","version":"0.0.0"}}}'
          EOS
          break if response.include?('"name":"listo"')
        rescue RuntimeError
          sleep 0.2
        end
      end
      assert_match '"name":"listo"', response
      assert_match '"tools"', response
    ensure
      begin
        Process.kill("TERM", pid)
        Process.wait(pid)
      rescue Errno::ESRCH, Errno::ECHILD
        nil
      end
    end
  end
end
