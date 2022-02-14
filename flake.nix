{
  description = "Default values for the Nixpkgs parameters, overridable with follows";

  outputs = { self }: {
    lib.pkgsParameters = {
      # buildSystem: Where the derivations will be built; the `system` parameters of a derivation.
      # host system: Where a derivation's outputs can be executed.
      # buildSystem = null: same as host system; non-cross compilation.
      buildSystem = null;

      config = { };
      overlays = [ ];
    };
  };
}
