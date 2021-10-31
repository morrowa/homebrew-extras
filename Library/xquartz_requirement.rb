# typed: false
# frozen_string_literal: true

require "requirement"

# A requirement on XQuartz.
class XquartzRequirement < Requirement
  # extend T::Sig

  fatal true

  cask "xquartz"

  # TODO: satisfies block?

  # TODO: prevent superenv from stripping these vars
  env {
    ENV.append "CFLAGS", "-I/opt/X11/include -I/opt/X11/include/freetype2"
    ENV.append "LDFLAGS", "-L/opt/X11/lib"
  }

end


