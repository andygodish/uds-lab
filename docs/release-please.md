# Semantic Versioning 

This project uses release please for semantic versioning. Source code:

- [Release Please](https://github.com/googleapis/release-please)
- [Release Please Action](https://github.com/googleapis/release-please-action)

#### Pushing empty commits:

git commit --allow-empty -S -m "chore: release 0.2.0-uds.1" -m "Release-As: 0.2.0-uds.1"

#### Required GH Repo Permissions

```
Error: release-please failed: GitHub Actions is not permitted to create or approve pull requests.
```

Repo Settings --> Actions (dropdown, left) --> Workflow permissions --> Allow GitHub Actions to create and approve pull requests 