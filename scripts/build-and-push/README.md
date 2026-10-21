# Build and Push to ECR Script

Builds Docker images and pushes them to AWS ECR with auto-generated tags based on component versions.

## Prerequisites

### Required Tools

| Tool     | Notes                                     |
|----------|-------------------------------------------|
| `yq`     | YAML parsing - `brew install yq`          |
| `git`    | Usually pre-installed                     |
| `docker` | For building images                       |
| `aws`    | For ECR push - `brew install awscli`      |

---

## Quick Start

```bash
make build-and-push-images         # Interactive mode
make build-and-push-images-dry-run # Preview without building/pushing
```

Or run directly:

```bash
./scripts/build-and-push/build-and-push-to-ecr
./scripts/build-and-push/build-and-push-to-ecr --dry-run
```

---

## Workflow Steps

### Step 1: Select Images

Choose which images to build and push from the numbered list. You can select using the same formats as the update-dockerfile script:

- Individual images: `1 3 5`
- Comma-separated: `1,3,5`
- Ranges: `1-5` or `1-3 5 7-9`
- All images: `a`
- All Go-based images: `g`

### Step 2: Configure AWS Profile

Specify which AWS profile to use for ECR authentication (defaults to `dp-ci`). The script will automatically retrieve the AWS Account ID from the profile.

You can confirm or override the Account ID if needed.

### Step 3: Review Generated Tags

The script displays the generated tag for each image based on the `format` field in tag-config.yaml and component versions.

### Step 4: Confirm Each Build

For each selected image, confirm you want to proceed. The script will:

1. Build the Docker image locally
2. Tag it with the generated tag
3. Push it to ECR
4. Optionally push as `latest` if `requiresIsLatest: true`

### Step 5: Review Results

The script shows a summary with total, successful, and skipped image builds/pushes.

---

## Tag Generation

Tags are generated from the `format` field in `tag-config.yaml` using component versions.

**Example tag-config.yaml:**

```yaml
components:
  - name: golang
    arg: GOLANG_VERSION
    version: "1.26.8"
    version_tag: "patch"
    distro_suffix: "bookworm"
  - name: node
    arg: NODEJS_VERSION
    version: "24.19.0"
    version_tag: "major"
format: "{golang}-node-{node}"
requiresIsLatest: true
```

**Result tag:** `1.26.8-bookworm-node-24` (golang uses full version, node extracts major)

## ECR Repository Naming

Images are pushed to:

```bash
<AWS_ACCOUNT_ID>.dkr.ecr.eu-west-2.amazonaws.com/onsdigital/dp-concourse-tools-<TOP_LEVEL_DIR>:<TAG>
```

**Examples:**

- `golang` → `dp-concourse-tools-golang:1.26.8-bookworm`
- `node-go/node24` → `dp-concourse-tools-node-go:1.26.8-bookworm-node-24`

## Latest Tag

If an image has `requiresIsLatest: true` in tag-config.yaml, you'll be prompted to also push as `latest`. The image gets pushed twice: once with the version tag, once as `latest`.

---

## Example Workflow

Here's a real-world example of building and pushing a single image to ECR:

```bash
$ make build-and-push-images
✓ All required dependencies are installed
ℹ Discovering Docker images...
✓ Discovered 18 Docker image(s)
ℹ
Available Docker images:

   1) chrome-go
   2) concourse-build-tools
   3) docker-go
   4) docker-go-python
   5) java
   6) lint-go
   7) lint-go-node/node24
   8) lint-go-python
   9) node-go/node24
  10) node-java/node24
  11) packer
  12) python-minimal
  13) terraform-alpine
  14) ubuntu-20
  15) ubuntu-22
  16) vulncheck
  17) vulncheck-node/node24
  18) vulncheck-python

  Options:
    Enter numbers (space, comma, or range: e.g., '1 3 5-7' or '1,3,5-7')
    'a' = Select all images
    'g' = Select all Go-based images
    'q' = Quit

Select images: 17
✓ Selected 1 image(s) for build/push

Enter AWS Profile (default: dp-ci, blank to keep): dp-sandbox
[AWS SSO login and account ID retrieval...]
✓ Retrieved AWS Account ID: XXXXXXXXX
Confirm AWS Account ID (press Enter to use XXXXXXXXX, or type a different one):
✓ Using AWS Account ID: XXXXXXXXX

ℹ ========== Image Tags ==========
ℹ Generated tag for vulncheck-node/node24: 1.27.4-vulncheck-0.6.1-node-24

ℹ ========== Starting Build ==========

ℹ Ready to update: vulncheck-node/node24
Continue? (Enter to continue, 'n' to skip):
ℹ Building vulncheck-node/node24...
[Build output would display here]
✓ Built vulncheck-node/node24 with tag 1.27.4-vulncheck-0.6.1-node-24

ℹ ========== Built Images ==========
  • vulncheck-node/node24: 1.27.4-vulncheck-0.6.1-node-24

ℹ Ready to push 1 image(s) to ECR
Approve and push to ECR? (Enter to push, 'n' to cancel):

ℹ ========== Starting Push ==========
ℹ Pushing vulncheck-node/node24...
[Push output would display here]
✓ Pushed vulncheck-node/node24 with tag 1.27.4-vulncheck-0.6.1-node-24 (+ latest)

ℹ ========== Update Summary ==========
ℹ Total images: 1
✓ Successful: 1
```
