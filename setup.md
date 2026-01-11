# Setup Guide for Blog (Hugo + Gokarna Theme)

This repository contains the source for [amitashukla.in](amitashukla.in), a Hugo blog using the Gokarna theme. The setup is designed to work out of the box on any system using Docker.


## Prerequisites

- Docker and Docker Compose installed
- Git installed
- SSH access to GitHub configured (for cloning submodules)

## 1. Clone the Repository
```
git clone git@github.com:amita-shukla/blog-hugo.git
cd blog-hugo
```

## 2. Initialize Submodules

The Gokarna theme is included as a git submodule. Initialize it to lock the theme version:
```
git submodule update --init --recursive
```
This ensures the exact same theme version is used across all machines.

## 3. Build and Run Locally (Docker)

All dependencies are included in Docker. You don’t need Hugo installed locally.
```
docker compose up
```
This will:
- Start a container with the Hugo server
- Watch for file changes (`-D` flag included for drafts)
- Serve the site at http://localhost:1313

To stop the server:
```
docker compose down
```

## 4. Adding New Content

- Blog posts: `content/blog/YYYY-MM-DD--post-slug/index.md`
- Notes: `content/notes/YYYY-MM-DD--note-slug/index.md`
- Pages (about, contact, follow, etc.): `content/<page>/_index.md`
- Drafts:
```
draft: true
```

## 5. Git Workflow

### Commit changes:
```
git add .
git commit -m "Your message"
git push
```

### Submodule updates:
If the theme submodule is ever updated:
```
cd themes/gokarna
git fetch
git checkout <desired_commit>
cd ../..
git add themes/gokarna
git commit -m "Update theme submodule"
git push
```

## 6. Deployment

Netlify is used for deployment. Ensure the baseURL in `hugo.toml` matches your production domain:
```
baseURL = "https://amitashukla.in/"
```
Netlify automatically builds Hugo using `hugo.toml` configuration.

## 7. Troubleshooting

- If docker compose up fails, ensure Docker is installed and the Docker daemon is running.
- To reset submodules:
```
git submodule sync
git submodule update --init --recursive
```
Hugo version is locked via Docker, so you don’t need to install Hugo locally.
