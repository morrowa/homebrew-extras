# Based on the ngspice formula from homebrew/core

require_relative "../Library/xquartz_requirement.rb"

class NgspiceX < Formula
  desc "Spice circuit simulator with X11 support"
  homepage "https://ngspice.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/ngspice/ng-spice-rework/35/ngspice-35.tar.gz"
  sha256 "c1b7f5c276db579acb3f0a7afb64afdeb4362289a6cab502d4ca302d6e5279ec"

  livecheck do
    url :stable
    regex(%r{url=.*?/ngspice[._-]v?(\d+(?:\.\d+)*)\.t}i)
  end

  head do
    url "https://git.code.sf.net/p/ngspice/ngspice.git", branch: "master"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "bison" => :build
  depends_on "libtool" => :build

  depends_on "fftw"
  depends_on "readline"
  depends_on XquartzRequirement

  # fftw requires gcc anyway, and gcc includes libomp
  fails_with :clang

  conflicts_with "ngspice", because: "both install ngspice binary"
  conflicts_with "libngspice", because: "both install configs and script in share/ngspice"

  # required because I can't figure out how to prevent superenv from stripping X11 flags
  env :std

  def install
    system "./autogen.sh" if build.head?

    args = %W[
      --disable-dependency-tracking
      --disable-debug
      --prefix=#{prefix}
      --with-readline
      --enable-cider
      --enable-xspice
      --enable-openmp
      --with-x
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    (testpath/"test.cir").write <<~EOS
      RC test circuit
      v1 1 0 1
      r1 1 2 1
      c1 2 0 1 ic=0
      .tran 100u 100m uic
      .control
      run
      quit
      .endc
      .end
    EOS
    system "#{bin}/ngspice", "test.cir"
  end
end
