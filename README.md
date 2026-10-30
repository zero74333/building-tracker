# Zeeshan Daily Life Style

Personal daily life tracker (health, mind, work, money, social, activities).
Data is stored on the phone in SQLite. Export to Markdown or a JSON backup from the Export tab.

## Build the APK on GitHub

1. Create a new GitHub repository (private is fine).
2. Upload everything in this folder, including the `.github` folder.
3. Open the **Actions** tab. The "Build Android APK" workflow runs on every push to `main`.
4. When it finishes, open the run and download the artifact `zeeshan-daily-life-style-apk`.
5. Unzip it, copy `app-release.apk` to your phone, and install it (allow installs from your file manager or browser).

To rebuild without a change, open Actions, choose the workflow, and press **Run workflow**.
