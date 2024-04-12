# Documentation: https://docs.brew.sh/Formula-Cookbook
#                https://rubydoc.brew.sh/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!
class Envcraft < Formula
  desc "EnvCraft is an .env file creator. You feed it with a given env.sample file and EnvCraft will create a corresponding .env file while asking you for all mandatory values. EnvCraft supports defining default values (press return to accept) and custom prompts."
  homepage "https://ausdertechnik.de"
  url "https://git.ausdertechnik.de/adt-tools/envcraft/-/raw/main/envcraft.sh?ref_type=heads"
  version "1.0.0"
  sha256 "8331d52d705267e166a3bbb452caf2f5daa2a6d3b00de777f8ccb7f0dccadabd"
  license "BSD-2-Clause"

  # depends_on "cmake" => :build

  def install
    bin.install "envcraft.sh" => "envcraft"
  end

  #test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! For Homebrew/homebrew-core
    # this will need to be a test that verifies the functionality of the
    # software. Run the test with `brew test envcraft`. Options passed
    # to `brew install` such as `--HEAD` also need to be provided to `brew test`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system "#{bin}/program", "do", "something"`.
   # system "false"
  #end
end
