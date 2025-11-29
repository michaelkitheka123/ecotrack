# GitHub & GitHub Pages Deployment Guide for EcoTrack

## Step 1: Initialize Git Repository

```powershell
# Navigate to your project directory
cd c:\Users\victor\Desktop\aethra

# Initialize git repository
git init

# Add all files to staging
git add .

# Create initial commit
git commit -m "Initial commit: EcoTrack environmental tracking app"
```

## Step 2: Create GitHub Repository

1. Go to https://github.com/new
2. Repository name: `ecotrack` (or your preferred name)
3. Description: "Track your carbon footprint, set sustainability goals, and watch your environmental impact grow."
4. Choose: **Public** (required for free GitHub Pages)
5. **DO NOT** initialize with README, .gitignore, or license (we already have these)
6. Click "Create repository"

## Step 3: Connect Local Repository to GitHub

```powershell
# Add GitHub remote (replace YOUR_USERNAME with your actual GitHub username)
git remote add origin https://github.com/YOUR_USERNAME/ecotrack.git

# Verify remote was added
git remote -v

# Push to GitHub
git branch -M main
git push -u origin main
```

## Step 4: Create .gitignore (if not exists)

Create a `.gitignore` file in the root directory with Flutter-specific ignores:

```gitignore
# Miscellaneous
*.class
*.log
*.pyc
*.swp
.DS_Store
.atom/
.buildlog/
.history
.svn/
migrate_working_dir/

# IntelliJ related
*.iml
*.ipr
*.iws
.idea/

# VS Code
.vscode/

# Flutter/Dart/Pub related
**/doc/api/
**/ios/Flutter/.last_build_id
.dart_tool/
.flutter-plugins
.flutter-plugins-dependencies
.packages
.pub-cache/
.pub/
/build/

# Web related
lib/generated_plugin_registrant.dart

# Symbolication related
app.*.symbols

# Obfuscation related
app.*.map.json

# Android Studio will place build artifacts here
/android/app/debug
/android/app/profile
/android/app/release

# Firebase
firebase_options.dart
.firebase/
.firebaserc
firebase.json

# Environment variables
.env
.env.local
.env.*.local

# Windows
Thumbs.db
ehthumbs.db
Desktop.ini
```

## Step 5: Build Flutter Web App

```powershell
# Clean previous builds
flutter clean

# Get dependencies
flutter pub get

# Build for web with release mode
flutter build web --release

# This creates files in: build/web/
```

## Step 6: Prepare for GitHub Pages

```powershell
# Create a gh-pages branch
git checkout -b gh-pages

# Copy web build to root (GitHub Pages serves from root or /docs)
# Option A: Copy to docs folder
New-Item -ItemType Directory -Force -Path docs
Copy-Item -Path build\web\* -Destination docs\ -Recurse -Force

# Add and commit
git add docs/
git commit -m "Add web build for GitHub Pages"

# Push gh-pages branch
git push -u origin gh-pages

# Switch back to main branch
git checkout main
```

**OR Option B: Serve directly from build/web**

```powershell
# Stay on gh-pages branch
git checkout -b gh-pages

# Remove everything except build/web
git rm -rf .
git clean -fxd

# Copy web build to root
Copy-Item -Path ..\build\web\* -Destination . -Recurse -Force

# Add and commit
git add .
git commit -m "Deploy web build to GitHub Pages"

# Push
git push -u origin gh-pages

# Switch back to main
git checkout main
```

## Step 7: Enable GitHub Pages

1. Go to your repository on GitHub
2. Click **Settings** tab
3. Scroll to **Pages** section (left sidebar)
4. Under "Source":
   - Branch: `gh-pages`
   - Folder: `/docs` (if using Option A) or `/ (root)` (if using Option B)
5. Click **Save**
6. Wait 1-2 minutes for deployment

Your site will be available at:
```
https://YOUR_USERNAME.github.io/ecotrack/
```

## Step 8: Update README with Live Demo Link

```powershell
# Edit README.md and add:
# Live Demo: https://YOUR_USERNAME.github.io/ecotrack/

git add README.md
git commit -m "Add live demo link to README"
git push origin main
```

## Step 9: Automated Deployment (Optional)

Create `.github/workflows/deploy.yml` for automatic deployment:

```yaml
name: Deploy to GitHub Pages

on:
  push:
    branches: [ main ]

jobs:
  build-and-deploy:
    runs-on: ubuntu-latest
    
    steps:
    - uses: actions/checkout@v3
    
    - uses: subosito/flutter-action@v2
      with:
        flutter-version: '3.16.0'
    
    - name: Install dependencies
      run: flutter pub get
    
    - name: Build web
      run: flutter build web --release --base-href /ecotrack/
    
    - name: Deploy to GitHub Pages
      uses: peaceiris/actions-gh-pages@v3
      with:
        github_token: ${{ secrets.GITHUB_TOKEN }}
        publish_dir: ./build/web
```

## Important Notes

### Base HREF for GitHub Pages

When building for GitHub Pages, you need to set the base href:

```powershell
flutter build web --release --base-href /ecotrack/
```

Replace `ecotrack` with your actual repository name.

### Firebase Configuration

⚠️ **IMPORTANT**: Your `firebase_options.dart` contains sensitive API keys. 

**For public repository:**
1. Add `firebase_options.dart` to `.gitignore`
2. Use environment variables or Firebase Hosting instead
3. Or use Firebase's web SDK configuration in `index.html`

**Recommended approach:**
```powershell
# Remove firebase_options.dart from git if already committed
git rm --cached lib/firebase_options.dart
git commit -m "Remove Firebase config from version control"

# Add to .gitignore
echo "lib/firebase_options.dart" >> .gitignore
git add .gitignore
git commit -m "Ignore Firebase configuration"
git push
```

### Web-Specific Configuration

Edit `web/index.html` to add Firebase configuration:

```html
<!-- Add before </body> -->
<script src="https://www.gstatic.com/firebasejs/10.7.1/firebase-app-compat.js"></script>
<script src="https://www.gstatic.com/firebasejs/10.7.1/firebase-firestore-compat.js"></script>
<script src="https://www.gstatic.com/firebasejs/10.7.1/firebase-auth-compat.js"></script>

<script>
  const firebaseConfig = {
    apiKey: "YOUR_API_KEY",
    authDomain: "YOUR_PROJECT.firebaseapp.com",
    projectId: "YOUR_PROJECT_ID",
    storageBucket: "YOUR_PROJECT.appspot.com",
    messagingSenderId: "YOUR_SENDER_ID",
    appId: "YOUR_APP_ID"
  };
  firebase.initializeApp(firebaseConfig);
</script>
```

## Complete Workflow Summary

```powershell
# 1. Initialize and push to GitHub
cd c:\Users\victor\Desktop\aethra
git init
git add .
git commit -m "Initial commit: EcoTrack app"
git remote add origin https://github.com/YOUR_USERNAME/ecotrack.git
git push -u origin main

# 2. Build web version
flutter clean
flutter pub get
flutter build web --release --base-href /ecotrack/

# 3. Deploy to GitHub Pages
git checkout -b gh-pages
New-Item -ItemType Directory -Force -Path docs
Copy-Item -Path build\web\* -Destination docs\ -Recurse -Force
git add docs/
git commit -m "Deploy to GitHub Pages"
git push -u origin gh-pages
git checkout main

# 4. Enable GitHub Pages in repository settings
# Settings > Pages > Source: gh-pages branch, /docs folder

# 5. Access your site at:
# https://YOUR_USERNAME.github.io/ecotrack/
```

## Troubleshooting

### Issue: Blank page on GitHub Pages
**Solution:** Make sure you used `--base-href` flag when building

### Issue: Firebase not working
**Solution:** Configure Firebase for web domain in Firebase Console:
1. Go to Firebase Console > Project Settings
2. Add `YOUR_USERNAME.github.io` to authorized domains

### Issue: 404 errors
**Solution:** GitHub Pages may take a few minutes to deploy. Wait and refresh.

### Issue: Assets not loading
**Solution:** Check that all asset paths are relative, not absolute

## Next Steps

1. ✅ Push code to GitHub
2. ✅ Build web version
3. ✅ Deploy to GitHub Pages
4. ✅ Update README with live demo link
5. ⭐ Star your own repository
6. 📢 Share your project!

---

**Your Live Site:** `https://YOUR_USERNAME.github.io/ecotrack/`

**Repository:** `https://github.com/YOUR_USERNAME/ecotrack`
