# elm-starter

A starter repo for single page elm apps

## Development

### Prerequisites

- [elm](http://elm-lang.org/) 0.19
- [node](https://nodejs.org/)
- [nvm for macOS & Linux](https://github.com/nvm-sh/nvm) or [nvm for Windows](https://github.com/coreybutler/nvm-windows)
- After cloning the repo and running `npm i` you will also need to `npm run prepare` to install [husky](https://blog.typicode.com/husky-git-hooks-autoinstall/)

### Formatting

We recommend integrating `elm-format@0.8.6` and `prettier` into your code editor. A pre-commit hook is configured to take care of this if not.

### Build

- `npm run dev` for a hot reload server at [http://localhost:3000](http://localhost:3000)
- `npm run build` to generate a production build in `dist`

### Test

We are using [elm-test-rs](https://github.com/mpizenberg/elm-test-rs).

- `npm test` to run

### Linting

This repo does not provide linting, consider adding [elm-review](https://github.com/jfmengels/elm-review) if needed.

## Deployment

- [cCc]

## Code and configs

### What it's for

- Static code generated with [elm](https://elm-lang.org/docs) and [vite](https://vitejs.dev/guide/)
- `elm.json` for elm packages
- `package.json` for node scripts and packages
- `vite.config.js` for configuring [vite](https://vitejs.dev/config/)
- `package-lock.json` for current versions of node packages
- `.env` for generating a `Constants.elm` via [elm-constants](https://github.com/jaredramirez/elm-constants), currently gitignored for secrets. Rename `.env.example` to test it or remove if not needed. These variables can also be accessed in JS via [vite](https://vitejs.dev/guide/env-and-mode.html#env-variables-and-modes)
- `[cCc]` for build config
- `[cCc]` for deploy config
- `src/*` contains app source files
- `public/*` contains static assets which will live at the root of the served site

### Content & Pages

- [cCc]
- Copy not in `content/` (e.g. UI copy) is in `src/I18n`, keys should match UI elements and a language map should provide the copy
- We use `[cCc] to denote placeholder copy`
- We use `[fFf] to denote placeholder UI feature or section`

### Styling & layouts

- Vanilla CSS lives in `src/css` a reset is provided.
- It will be added to a style element in the head of the page

## Development workflow

### Adding issues

- add effort & value labels (if you know enough about it)
- put the issue in a milestone (if it is part of a current epic)

### Working on issue

- assign it to yourself before starting work
- make a branch that includes the issue type (fix/feat/chore etc & number)
- make sure you understand the acceptance criteria
- don't forget to include tests if it's a new feature
- ask questions & make plan

### Code review & merge

- check the acceptance criteria have been met (with tests if appropriate)
- add comments & questions
- once approved, leave for the author to squash and merge

## License

Source code is released under the [Hippocratic License](https://firstdonoharm.dev/version/3/0/license/).
