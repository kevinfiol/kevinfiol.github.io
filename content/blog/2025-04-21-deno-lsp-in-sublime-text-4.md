+++
title = "Deno LSP in Sublime Text 4"
+++

Using [Deno](https://deno.com) with Sublime Text 4 can be deceivingly tricky. At the time of this writing, [SublimeLSP Docs](https://lsp.sublimetext.io) still recommend using the `LSP-Deno` package on packagecontrol.io. However, the package is rife with bugs and outdated at this point, its last update being before the release of Deno 2.

Fortunately, Deno's official docs include a section about using Deno LSP with [Sublime Text](https://docs.deno.com/runtime/getting_started/setup_your_environment/#sublime-text). The catch is it tries to encompass Sublime Text 3 and 4, and suggests using third-party `.sublime-syntax` files to enable the language server. This is unneeded in Sublime Text 4, which already includes syntax definitions for JavaScript, TypeScript, JSX, and TSX.

Assuming you're on Sublime Text 4, you can simple add `deno` to your `LSP.sublime-settings` file like so:

```json
// Settings in here override those in "LSP/LSP.sublime-settings"
{
    "clients": {
      "deno": {
        "command": ["deno", "lsp"],
        "initializationOptions": {
          // "config": "", // Sets the path for the config file in your project
          "enable": false,
          // "importMap": "", // Sets the path for the import-map in your project
          "lint": true,
          "unstable": false
        },
        "enabled": true,
        "languages": [
          {
            "languageId": "javascript",
            "scopes": ["source.js"],
            "syntaxes": [
              "Packages/JavaScript/JavaScript.sublime-syntax"
            ]
          },
          {
            "languageId": "javascriptreact",
            "scopes": ["source.jsx"],
            "syntaxes": [
              "Packages/JavaScript/JSX.sublime-syntax"
            ]
          },
          {
            "languageId": "typescript",
            "scopes": ["source.ts"],
            "syntaxes": [
              "Packages/JavaScript/TypeScript.sublime-syntax"
            ]
          },
          {
            "languageId": "typescriptreact",
            "scopes": ["source.tsx"],
            "syntaxes": [
              "Packages/JavaScript/TSX.sublime-syntax"
            ]
          }
        ]
      }
    }
}
```