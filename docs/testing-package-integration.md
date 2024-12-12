# Testing Package Integration

The testing workflow for UDS package integration steps from the `test.yaml` workflow forked from [here](https://github.com/defenseunicorns/uds-package-template/tree/main/.github/workflows). The worflow is comprised of two steps. 

### Check Flavor 

Calls [this remote action](https://github.com/defenseunicorns/uds-common/blob/main/.github/actions/test-flavor/action.yaml) which determines if upgrade tests are necessary, and which package flavors to upgrade-test. The `upgrade-flavors` variable is outputted as comma-separated list of flavors.

### Validate

The `upgrade-flavors` array is passed in as an input to the Validate job, which uses the [callable-test workflow found here.](https://github.com/defenseunicorns/uds-common/blob/main/.github/workflows/callable-test.yaml). This job is run up to six times depending on the `upgrade-flavors` input varialbe. 

It executes under the following conditions:

1. All installation tests (type = 'install') will always run regardless of flavor 
2. Upgrade tests will only run for flavors that are listed in the upgrade-flavors output

based on the following conditional logic:

```
if: contains(inputs.upgrade-flavors, inputs.flavor) || inputs.type == 'install'
```

---


test.yaml
|__ check-flavor (GH Actions Workflow Jobs)
  |__ test-flavor (step)
    |__ (o) `upgrade-flavors=upstream,registry1,unicorn`--|
|__ validate (i)<_________________________________________|
  |__ [setup-uds](https://github.com/defenseunicorns/setup-uds) ***
  |__ [clean-gh-runner](https://raw.githubusercontent.com/defenseunicorns/uds-common/v1.4.0/tasks/actions.yaml)
  |__ [setup-environment](https://raw.githubusercontent.com/defenseunicorns/uds-common/v1.4.0/tasks/actions.yaml) ***
  | |__ install-deps
  | |__ authenticate-registries (uses GH secrets to authenticate to registries)
  |__ [test-deploy](https://raw.githubusercontent.com/defenseunicorns/uds-common/v1.4.0/tasks/actions.yaml) ^^^
  |__ [verify-badge](https://raw.githubusercontent.com/defenseunicorns/uds-common/v1.4.0/tasks/actions.yaml)

> *** setup-uds, which is a standalone gh action, in its own repository is needed to execute the software tools called in the subsequent "setup-environment" step by calling a UDS task, `uds run install-deps`.

> ^^^ the test-deploy task is meat and potatoes of the validation job. It's either going to execute the `test-upgrade` or `test-{package,install}` task, depending on the flavor/type combo fed into the job as inputs. These tasks are found in the `tasks.yaml` file in the root dir of the package repo.

---

## Miscellaneous

> GitHub Actions automatically sets CI=true as an environment variable in all workflow runs. This is a standard practice across many CI platforms (like GitLab CI, Jenkins, CircleCI, etc.) to indicate that the code is running in a CI environment.