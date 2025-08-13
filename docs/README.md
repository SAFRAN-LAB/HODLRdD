# HODLRdD Documentation

This directory contains the developer documentation for the HODLRdD library, designed to be served via GitHub Pages.

## Viewing the Documentation

### Option 1: GitHub Pages (Online)
1. Go to your repository settings on GitHub
2. Navigate to "Pages" section
3. Set source to "Deploy from a branch"
4. Select "main" branch and "/docs" folder
5. The documentation will be available at: `https://[username].github.io/HODLRdD/`

### Option 2: Local Development
```bash
# Install Jekyll (one-time setup)
gem install jekyll bundler

# Navigate to docs directory
cd docs

# Create Gemfile
bundle init
echo 'gem "minima", "~> 2.5"' >> Gemfile
echo 'gem "github-pages", group: :jekyll_plugins' >> Gemfile

# Install dependencies
bundle install

# Serve locally
bundle exec jekyll serve

# Open browser to http://localhost:4000
```

### Option 3: Direct Markdown Viewing
The documentation is also readable directly as markdown files:
- [Main Documentation](./index.md)

## Files Structure

- `index.md` - Main documentation page
- `_config.yml` - Jekyll configuration for GitHub Pages
- `README.md` - This file

## Updating Documentation

To update the documentation:
1. Edit `index.md` with your changes
2. Commit and push to the main branch
3. GitHub Pages will automatically rebuild (may take a few minutes)

## Customization

The documentation uses the minimal Jekyll theme. You can customize:
- Site title and description in `_config.yml`
- Theme and plugins in `_config.yml`
- Add custom CSS by creating `assets/main.scss`
- Add custom layouts in `_layouts/` directory