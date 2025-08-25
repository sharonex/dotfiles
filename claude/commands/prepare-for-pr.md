Make sure this branch is ready for a PR.
If frontend code changed in this PR, make sure to run the following commands:
- npx prettier -c -w .
- pushd typescript/apps/platform; ../../../node_modules/.bin/tsc --noEmit; popd

If backend code changed in this PR, make sure to run the following commands:
- cargo +nightly-2025-02-14 fmt --check
- cargo clippy --workspace --no-deps --all-targets --locked (Warnings are not accepted and need to be fixed)
- cargo nextest run --workspace --all-features --locked

