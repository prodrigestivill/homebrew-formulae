class Iaito < Formula
  desc "Official radare2 GUI"
  homepage "https://radare.org"
  url "https://github.com/radareorg/iaito/archive/refs/tags/5.9.9.tar.gz"
  sha256 "333e56c13ca05570eac4ae9dd53ecd7650444092aedf5b5e8959c3fb20c3316b"
  license "GPL-3.0-only"
  head "https://github.com/radareorg/iaito.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  depends_on "pkgconf" => :build
  depends_on "radare2"
  depends_on "graphviz"
  depends_on "qt"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    if OS.mac?
      prefix.install buildpath/"build/iaito.app"
      bin.install_symlink prefix/"iaito.app/Contents/MacOS/iaito"
    else
      system "make", "install"
    end
  end

  test do
    # Set QT_QPA_PLATFORM to minimal to avoid error "qt.qpa.xcb: could not connect to display"
    ENV["QT_QPA_PLATFORM"] = "minimal" if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    assert_match "iaito #{version}", shell_output("#{bin}/iaito -v")
  end
end
