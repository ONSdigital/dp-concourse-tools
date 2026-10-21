# Update Dockerfile Script

Updates component versions in `tag-config.yaml` and `Dockerfile` files across Docker images.

## Prerequisites

### Required Tools

| Tool     | Notes                                     |
|----------|-------------------------------------------|
| `yq`     | YAML parsing - `brew install yq`          |
| `git`    | Usually pre-installed                     |

---

## Quick Start

```bash
make update-images                 # Interactive mode
make update-images-dry-run         # Preview changes without applying
```

Or run directly:

```bash
./scripts/update-dockerfile/update-dockerfile
./scripts/update-dockerfile/update-dockerfile --dry-run
```

---

## Workflow Steps

### Step 1: Select Update Mode

Choose how to update your images:

- **Mode 1**: Update component versions in both `tag-config.yaml` AND `Dockerfile`  
  Use this when you want to change component versions and update both files.

- **Mode 2**: Update `Dockerfile` only from existing `tag-config.yaml`  
  Use this when you want to sync the Dockerfile without re-entering versions.

### Step 2: Select Images

Choose which images to update from the numbered list. You can select:

- Individual images: `1 3 5`
- Comma-separated: `1,3,5`
- Ranges: `1-5` or `1-3 5 7-9`
- All images: `a`
- All Go-based images: `g` (batch updates golang across multiple images)

### Step 3: Confirm Each Image

For each selected image, confirm you want to proceed. You can skip individual images if needed.

### Step 4: Enter Component Versions

For each component in the image (golang, node, python, etc.), enter the new version with full patch, or leave blank to keep the current version. You can also update distro suffixes if present.

### Step 5: Review Results

The script shows a summary with total, successful, and skipped image updates.

---

## Example Workflow

Here's a real-world example of updating a single image:

```bash
$ make update-images
✓ All required dependencies are installed
ℹ Discovering Docker images...
✓ Discovered 18 Docker image(s)

ℹ Select update mode:

  1) Update tag-config AND Dockerfiles
     - Prompt for new component versions
     - Update tag-config.yaml with new versions
     - Update Dockerfile with new versions

  2) Update Dockerfiles only
     - Use current versions from tag-config.yaml
     - Only update Dockerfile ARGs
     - No version prompts

Select mode (1 or 2): 1
ℹ Available Docker images:

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

Select images: 7
✓ Selected 1 image(s)
ℹ ========== Starting Updates ==========

ℹ Ready to update: lint-go-node/node24
Continue? (Enter to continue, 'n' to skip): 
ℹ Configuring versions for: lint-go-node/node24
  golang (current: 1.26.8) [leave blank to skip]: 1.27.4
  golang distro suffix (current: bookworm) [leave blank to keep current]: 
  golangci-lint (current: 2.12.2) [leave blank to skip]: 
  node (current: 24.19.0) [leave blank to skip]: 24.22.0
ℹ Updating <YOUR_GIT_REPO_LOCATION>/dp-concourse-tools/lint-go-node/node24/tag-config.yaml...
✓ Updated <YOUR_GIT_REPO_LOCATION>/dp-concourse-tools/lint-go-node/node24/tag-config.yaml
ℹ Updating <YOUR_GIT_REPO_LOCATION>/dp-concourse-tools/lint-go-node/node24/Dockerfile...
✓ Updated <YOUR_GIT_REPO_LOCATION>/dp-concourse-tools/lint-go-node/node24/Dockerfile

ℹ ========== Update Summary ==========
ℹ Total images: 1
✓ Successful: 1
```
