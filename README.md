<a id="readme-top"></a>

<!-- PROJECT LOGO -->
<div align="center">
  <a href="https://github.com/aymnms/aymnms-archives">
    <img src="https://avatars.githubusercontent.com/u/175542870?s=500&v=4" alt="Logo" width="200" height="200">
  </a>

  <h3 align="center">aymnms-archives</h3>

  <p align="center">
    A simple CLI tool to quickly push old or archived projects to the <strong>aymnms-archives</strong> GitHub organization.
  </p>
</div>

---

## 📚 Table of Contents

- [📚 Table of Contents](#-table-of-contents)
- [📝 Overview](#-overview)
- [⚙️ Prerequisites](#️-prerequisites)
- [🚀 Usage](#-usage)
- [📄 License](#-license)

---

## 📝 Overview

This script automates the process of publishing one or more local projects to the `aymnms-archives` GitHub organization.

It can:
- Automatically create the repository in your organization via the GitHub CLI
- Set the correct remote
- Push the current branch (e.g. `main` or `master`) to GitHub
- (Optionally) Delete the local folder after push

This tool is ideal for publishing archived or old projects in batch.

---

## ⚙️ Prerequisites

Make sure you have the following tools installed:

- [Git](https://git-scm.com/)
- [GitHub CLI (`gh`)](https://cli.github.com/)
- SSH access to your GitHub account (or HTTPS configured)
- A valid GitHub session (`gh auth login`)

---

## 🚀 Usage

1. **Download or clone this repository**
2. **Place your project folders next to `push.sh`**
3. **Make the script executable**:
   ```bash
   chmod +x push.sh
   ```

4. **Run the script with your project folder names**:
   ```bash
   ./push.sh my-project another-project
   ```

5. ✅ The script will:
   - Navigate into each folder
   - Create a new repository under `aymnms-archives` (private by default)
   - Push the current branch to GitHub
   - Show a success message for each

---

## 📄 License

This project does not currently include a license. You may add one if needed (e.g. MIT, GPL, etc).

<p align="right">(<a href="#readme-top">back to top</a>)</p>