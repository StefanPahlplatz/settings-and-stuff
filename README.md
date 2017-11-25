# settings-and-stuff

> A collection of settings for various programs and plugins. 

Install & configures some basic stuff like zsh and vim.
```
wget -O install.sh https://raw.githubusercontent.com/StefanPahlplatz/settings-and-stuff/master/install.sh
chmod +x install.sh
./install.sh
```
Press CTRL+D when zsh opens to continue the installation.

## Useful VS Code extensions
- Auto Close Tag
- Auto Rename Tag
- Babel Javascript
- Debugger for Chrome
- EditorConfig for VS Code
- EditorConfigGenerator
- ESLint
- IntelliJ IDEA Keybindings
- InteliSense for CSS class names
- Markdown preview enhanced
- Material Icon Theme
- npm
- npm Intellisense
- GraphQL for VSCode
- One Dark Pro
- Path Intellisense
- Prettier - JavaScript formatter

## My VS Code settings

```
{
  "javascript.validate.enable": true,
  "editor.formatOnSave": true,
  "prettier.trailingComma": "es5",
  "prettier.singleQuote": true,
  "eslint.autoFixOnSave": true,
  "files.autoSave": "off",

  "editor.snippetSuggestions": "top",
  "editor.tabSize": 2,
  "editor.quickSuggestions": true,
  "editor.wordBasedSuggestions": true,
  "editor.parameterHints": true,
  "editor.scrollBeyondLastLine": false,
  "editor.smoothScrolling": true,
  "editor.tabCompletion": true,

  "extensions.ignoreRecommendations": false,

  "workbench.iconTheme": "material-icon-theme",
  "workbench.startupEditor": "newUntitledFile",
  "workbench.colorTheme": "One Dark Pro",

  "emmet.syntaxProfiles": {
    "javascript": "jsx"
  },

  "files.exclude": {
    "**/.git": true,
    "**/.svn": true,
    "**/.DS_Store": true,
    "**/node_modules": true,
    "**/.idea": true,
    "**/.vscode": true,
    "**/yarn.lock": true,
    "**/yarn-error.log": true,
    "**/tmp": true
  },
  "files.watcherExclude": {
    "**/.git/objects/**": true,
    "**/node_modules/**": true,
    "**/tmp": true
  },
  "search.exclude": {
    "**/node_modules": true,
    "**/bower_components": true,
    "**/.git": true,
    "**/.DS_Store": true,
    "**/tmp": true,
    "**/coverage": true,
    "**/ios": true,
    "**/android": true
  }
}
```