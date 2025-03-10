(final: prev: {
  vpnc = prev.vpnc.overrideAttrs (_oldAttrs: {
    version = "unstable-2024-12-20";
    src = final.fetchFromGitHub {
      owner = "streambinder";
      repo = "vpnc";
      rev = "d58afaaafb6a43cb21bb08282b54480d7b2cc6ab";
      hash = "sha256-79DaK1s+YmROKbcWIXte+GZh0qq9LAQlSmczooR86H8=";
    };
  });
})
