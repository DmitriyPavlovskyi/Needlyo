# Git Workflow

Every feature:

Build

Simulator

Update docs if behavior or structure changed

Commit

Push

Commit format

feat:

fix:

refactor:

docs:

chore:

## Suggested habit

- Keep changes small and logically grouped.
- Follow this sequence for every feature or code change: implement the change, build and verify the app, update documentation if behavior or structure changed, then run test coverage and report the result to the user.
- Update documentation in the same iteration as any code or feature change, before considering the task done.
- When you build, also run the existing test suite and check for compiler/project errors.
- After a successful build and documentation pass, run the coverage workflow and surface the coverage summary to the user.
- Only add new tests when they are explicitly requested or required by the task.
- Commit only when the app still builds, tests pass, and the docs match the implementation.
