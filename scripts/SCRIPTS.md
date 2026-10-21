# Docker Image Build & Update Scripts

Automated scripts to update component versions and build/push Docker images to AWS ECR.

## Overview

- **`update-dockerfile-images`** - Updates component versions in `tag-config.yaml` and `Dockerfile`
- **`build-and-push-to-ecr`** - Builds Docker images and pushes them to AWS ECR

Both scripts have interactive menus, batch operations, and dry-run modes.

---

## Prerequisites

### Required Tools

| Tool     | Notes                                     |
|----------|-------------------------------------------|
| `yq`     | YAML parsing - `brew install yq`          |
| `git`    | Usually pre-installed                     |
| `docker` | For build-and-push only                   |
| `aws`    | For ECR push only - `brew install awscli` |

---

## Script 1: `update-dockerfile-images`

Updates component versions in `tag-config.yaml` and `Dockerfile`.

### Quick Start

```bash
make update-images                 # Interactive mode
make update-images-dry-run         # Preview changes without applying
```

Or directly:

```bash
./scripts/update-dockerfile-images
./scripts/update-dockerfile-images --dry-run
```

### Interactive Menu

The script displays a numbered list of available images:

```bash
ℹ Available Docker images:
   1) chrome-go
   2) docker-go
   3) node-go
   ...
   
  Options:
    Enter numbers (space, comma, or range: e.g., '1 3 5-7' or '1,3,5-7')
    'A' = Select all images
    'G' = Select all Go-based images (batch update golang)
    'Q' = Quit

Select images: G
```

#### Selection Formats

| Format             | Example     | Selects                      |
|--------------------|-------------|------------------------------|
| Individual numbers | `1 3 5`     | Images 1, 3, and 5           |
| Comma-separated    | `1,3,5`     | Images 1, 3, and 5           |
| Range              | `1-5`       | Images 1 through 5           |
| Mixed              | `1-3 5 7-9` | Images 1-3, 5, and 7-9       |
| All                | `A`         | All available images         |
| Go-based batch     | `G`         | All images with Go component |

### Batch Go Updates (Option 'G')

Select `G` to update Go version across multiple Go-based images at once:

```bash
Select images: G
✓ Selected 10 image(s) for update

ℹ Go-based images selected:
  • chrome-go
  • docker-go
  • lint-go
  • node-go/node24
  ...

Enter golang base version for all selected images: 1.26.8
```

For each image, you'll confirm the update and optionally adjust distro suffixes:

```bash
ℹ Ready to update: chrome-go
Continue? (y/n): y

ℹ Configuring versions for: chrome-go
  golang suffix (current: bookworm) [leave blank to keep current]: 
  golang: 1.27.2-bookworm → 1.26.8-bookworm (batch)
  chrome (current: googlechromestablelatest) [leave blank to skip]: 
```

### Version Prompts

For each selected image, you're prompted for each component:

```bash
ℹ Configuring versions for: docker-go-python
  golang: 1.27.2 → 1.26.8 (batch)
  docker (current: 28.5.2) [leave blank to skip]: 
  python (current: 3.15) [leave blank to skip]: 
```

- Press **Enter** to skip and keep current version
- Enter a new version to update

### Output

```bash
✓ Updated tag-config.yaml
✓ Updated Dockerfile

========== Update Summary ==========
ℹ Total images: 10
✓ Successful: 10
✗ Failed: 0
```

## Script 2: `build-and-push-to-ecr`

Builds Docker images and pushes them to AWS ECR with auto-generated tags based on component versions.

### Quick Start

```bash
make build-and-push-images         # Interactive mode
make build-and-push-images-dry-run # Preview without building/pushing
```

Or directly:

```bash
./scripts/build-and-push-to-ecr
./scripts/build-and-push-to-ecr --dry-run
```

### Usage

1. Select images from the menu (same format as update script)
2. Enter AWS Account ID (or leave blank to skip ECR push)
3. Optionally specify AWS profile (defaults to `dp-ci`)
4. Confirm each image before building

```bash
Select images: 1 3
✓ Selected 2 image(s) for build/push

Enter AWS Account ID (or leave blank to skip ECR push): 123456789012
Enter AWS Profile (default: dp-ci, blank to keep): 

========== Starting Build & Push ==========

ℹ Ready to update: chrome-go
Continue? (y/n): y

ℹ Building and pushing chrome-go...
ℹ Generated tag for chrome-go: 1.26.8-bookworm-googlechromelatest
✓ Built and pushed chrome-go with tag 1.26.8-bookworm-googlechromelatest
```

### Tag Generation

Tags are generated from the `format` field in `tag-config.yaml` using component versions:

**Example:**

```yaml
components:
  - name: golang
    arg: GOLANG_VERSION
    version: "1.26.8-bookworm"
    has_distro_suffix: true
  - name: node
    arg: NODEJS_VERSION
    version: "24.19.0"
    versioning:
      enum:
        - "major"
        - "minor"
        - "patch"
format: "{golang}-node-{node}"
requiresIsLatest: true
```

Result: `1.26.8-bookworm-node-24` (major versions extracted)

**Versioning Rules:**

- **With `versioning: enum`** - Extracts major version (first part before dot)
- **Without versioning** - Uses full version as-is

### ECR Repository

Images are pushed to:

```bash
<AWS_ACCOUNT_ID>.dkr.ecr.eu-west-2.amazonaws.com/onsdigital/dp-concourse-tools-<TOP_LEVEL_DIR>:<TAG>
```

**Examples:**

- `golang` → `dp-concourse-tools-golang:1.26.8-bookworm`
- `node-go/node24` → `dp-concourse-tools-node-go:1.26.8-bookworm-node-24`

### Latest Tag

If an image has `requiresIsLatest: true`, you're prompted to also tag as `latest`:

```bash
Push with 'latest' tag? (y/n): y
```

The image gets pushed twice: once with version tag, once as `latest`.

---

## Workflows

### Batch Update Go Versions

**Scenario:** Update Go across all Go-based images

Preview first with dry-run:

```bash
$ make update-images-dry-run

✓ Discovered 18 Docker image(s)

ℹ Available Docker images:
   1) chrome-go
   2) docker-go
   3) docker-go-python
   4) lint-go
   5) lint-go-node/node24
   ...

Select images: G
✓ Selected 10 image(s) for update

ℹ Go-based images selected:
  • chrome-go
  • docker-go
  • docker-go-python
  • lint-go
  • lint-go-node/node24
  • lint-go-python
  • node-go/node24
  • vulncheck
  • vulncheck-node/node24
  • vulncheck-python

Enter golang base version for all selected images: 1.27.3

========== Starting Updates ==========

ℹ Ready to update: chrome-go
Continue? (y/n): y

ℹ Configuring versions for: chrome-go
  golang suffix (current: bookworm) [leave blank to keep current]: 
  golang: 1.27.2-bookworm → 1.27.3-bookworm (batch)
  chrome (current: googlechromestablelatest) [leave blank to skip]: 

ℹ Ready to update: docker-go
Continue? (y/n): y

ℹ Configuring versions for: docker-go
  golang: 1.26.8 → 1.27.3 (batch)
  docker (current: 28.5.2) [leave blank to skip]: 

ℹ Ready to update: docker-go-python
Continue? (y/n): y

ℹ Configuring versions for: docker-go-python
  golang: 1.27.2 → 1.27.3 (batch)
  docker (current: 28.5.2) [leave blank to skip]: 
  python (current: 3.15) [leave blank to skip]: 

... (continues for other selected images)

========== Update Summary ==========
ℹ Total images: 10
✓ Successful: 10
```

Apply the changes:

```bash
$ make update-images

# Select 'G' and enter 1.27.3
# Confirm each image
# Files are updated
```

Then build and push to ECR:

```bash
$ make build-and-push-images

# Select 'G'
# Enter AWS Account ID
# Confirm each build
```
