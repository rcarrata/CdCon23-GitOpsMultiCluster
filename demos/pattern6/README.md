# Pattern 6 Demo - Promotion between GitOps environments

## Folder Structure

```md
$ tree -L 2 apps/pattern6 
apps/pattern6
├── base
│   ├── kustomization.yaml
│   ├── welcome-app-deployment.yaml
│   ├── welcome-app-namespace.yaml
│   └── welcome-app-svc.yaml
├── envs
│   ├── dev-gpu
│   ├── dev-nogpu
│   ├── prod-eu
│   ├── prod-us
│   ├── staging-eu
│   └── staging-us
└── variants
    ├── eu
    └── us
```

## Scenario 1 - Promote application version from Dev to Staging Environment in the US:

```md
cp envs/dev-gpu/version.yaml envs/staging-us/version.yaml
```

## Scenario 2 - Promote application version from Staging to Prod Environment in the US:

```md
cp envs/staging-us/version.yaml envs/prod-us/version.yaml
```