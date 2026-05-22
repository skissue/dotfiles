# Based on <https://github.com/NixOS/nixpkgs/pull/490230>
{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  makeBinaryWrapper,
  versionCheckHook,
}:
buildNpmPackage (finalAttrs: {
  pname = "playwright-cli";
  version = "0.1.13";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "playwright-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-hHK/GR5Drlt+e0L9kyNmn+ht1PCrVH6WrVbxGB1Wsxg=";
  };

  npmDepsHash = "sha256-Ulp6IttsZcOOA7LaYDpVKkBYbe2j4RFG8lJARWifOSk=";

  dontNpmBuild = true;

  nativeBuildInputs = [
    makeBinaryWrapper
  ];

  doInstallCheck = true;

  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  versionCheckProgram = "${placeholder "out"}/bin/playwright-cli";
  versionCheckProgramArg = "--version";

  meta = {
    description = "Playwright CLI for browser automation";
    homepage = "https://github.com/microsoft/playwright-cli";
    changelog = "https://github.com/microsoft/playwright-cli/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    mainProgram = "playwright-cli";
  };
})
