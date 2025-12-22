# typed: false
# frozen_string_literal: true

class BamlRest < Formula
  desc "CLI tool for BAML REST server"
  homepage "https://github.com/invakid404/baml-rest"
  url "https://github.com/invakid404/baml-rest.git",
      tag: "0.0.3"
  license "MIT"

  depends_on "go" => :build

  def install
    # Determine binary name for this platform
    binary_name = if OS.mac? && Hardware::CPU.arm?
      "baml-rest-darwin-arm64"
    elsif OS.linux? && Hardware::CPU.intel?
      "baml-rest-linux-amd64"
    elsif OS.linux? && Hardware::CPU.arm?
      "baml-rest-linux-arm64"
    end

    # Try to download prebuilt binary if available for this platform
    if binary_name
      binary_url = "https://github.com/invakid404/baml-rest/releases/download/#{version}/#{binary_name}"
      begin
        system "curl", "-fL", binary_url, "-o", binary_name
        bin.install binary_name => "baml-rest"
        chmod 0555, bin/"baml-rest"
        return
      rescue
        # Download failed, fall through to build from source
      end
    end

    # Build from source
    system "go", "build", "-o", bin/"baml-rest", "./cmd/build/main.go"
  end
end
