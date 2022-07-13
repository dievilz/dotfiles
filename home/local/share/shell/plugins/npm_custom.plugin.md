## npm plugin

The npm plugin provides completion as well as adding many useful aliases.

To use it, add npm to the plugins array of your zshrc file:
```
plugins=(... npm)
```

## Aliases

| Alias    | Command                      | Descripton                                                      |
|:-------  |:-----------------------------|:----------------------------------------------------------------|
| `npmG`   | `npm install -g`             | Install dependencies globally                                   |
| `npmD`   | `npm install -D`             | Install and save to dev-dependencies in your package.json       |
| `npmE`   | `PATH="$(npm bin)":"$PATH"`  | Run command from node_modules folder based on current directory |
| `npmO`   | `npm outdated`               | Check which npm modules are outdated                            |
| `npmV`   | `npm -v`                     | Check package versions                                          |
| `npmL`   | `npm list`                   | List local installed packages                                   |
| `npmL0`  | `npm list --depth=0`         | List local top-level installed packages                         |
| `npmL1`  | `npm list --depth=1`         | List local level-1 installed packages                           |
| `npmLG`  | `npm list -g`                | List global installed packages                                  |
| `npmLG0` | `npm list -g --depth=0`      | List global top-level installed packages                        |
| `npmLG1` | `npm list -g --depth=1`      | List global level-1 installed packages                          |
| `npmSt`  | `npm start`                  | Run npm start                                                   |
| `npmT`   | `npm test`                   | Run npm test                                                    |
| `npmR`   | `npm run`                    | Run npm scripts                                                 |
| `npmRD`  | `npm run dev`                | Run npm dev scripts                                             |
| `npmP`   | `npm publish`                | Run npm publish                                                 |
| `npmI`   | `npm init`                   | Run npm init                                                    |
