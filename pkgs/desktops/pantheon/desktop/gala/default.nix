{ lib
, stdenv
, fetchFromGitHub
, nix-update-script
, pkg-config
, meson
, python3
, ninja
, vala
, desktop-file-utils
, gettext
, libxml2
, gtk3
, granite
, libgee
, bamf
, libcanberra-gtk3
, gnome-desktop
, mutter
, clutter
, gnome-settings-daemon
, wrapGAppsHook
, gexiv2
}:

stdenv.mkDerivation rec {
  pname = "gala";
  version = "6.3.2";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = "14cdefed9d7638fb608c5fc774d03f13efd6a63f";
    sha256 = "sha256-P8GdQYt3JSmu3oOtI0b1SjWp5vr675AeDIESL1+ahs0=";
  };

  patches = [
    # We look for plugins in `/run/current-system/sw/lib/` because
    # there are multiple plugin providers (e.g. gala and wingpanel).
    ./plugins-dir.patch
  ];

  nativeBuildInputs = [
    desktop-file-utils
    gettext
    libxml2
    meson
    ninja
    pkg-config
    python3
    vala
    wrapGAppsHook
  ];

  buildInputs = [
    bamf
    clutter
    gnome-settings-daemon
    gexiv2
    gnome-desktop
    granite
    gtk3
    libcanberra-gtk3
    libgee
    mutter
  ];

  mesonFlags = [
    # TODO: enable this and remove --builtin flag from session-settings
    # https://github.com/NixOS/nixpkgs/pull/140429
    "-Dsystemd=false"
  ];

  postPatch = ''
    chmod +x build-aux/meson/post_install.py
    patchShebangs build-aux/meson/post_install.py
  '';

  passthru = {
    updateScript = nix-update-script {
      attrPath = "pantheon.${pname}";
    };
  };

  meta = with lib; {
    description = "A window & compositing manager based on mutter and designed by elementary for use with Pantheon";
    homepage = "https://github.com/elementary/gala";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.pantheon.members;
    mainProgram = "gala";
  };
}
