# S.B.E-Laboratory

A Godot 4.4 game project.

## Table of Contents
- [About](#about)
- [How to Fork This Project](#how-to-fork-this-project)
- [Prerequisites](#prerequisites)
- [Setup](#setup)
- [Development](#development)
- [Project Structure](#project-structure)

## About

S.B.E-Laboratory is a game project built with Godot Engine 4.4 using the Forward Plus rendering method.

## How to Fork This Project

Forking this project allows you to create your own copy of the repository where you can make changes without affecting the original project.

### Step 1: Fork the Repository on GitHub

1. Navigate to the repository page: https://github.com/BozWorld/SB-1_laboratory
2. Click the **Fork** button in the top-right corner of the page
3. Select where you want to fork the repository (your personal account or an organization)
4. Wait for GitHub to create your fork

### Step 2: Clone Your Fork

After forking, clone your forked repository to your local machine:

```bash
# Replace YOUR_USERNAME with your GitHub username
git clone https://github.com/YOUR_USERNAME/SB-1_laboratory.git
cd SB-1_laboratory
```

### Step 3: Set Up the Upstream Remote (Optional but Recommended)

To keep your fork synchronized with the original repository:

```bash
# Add the original repository as "upstream"
git remote add upstream https://github.com/BozWorld/SB-1_laboratory.git

# Verify the remote was added
git remote -v
```

### Step 4: Sync Your Fork with Upstream

To get the latest changes from the original repository:

```bash
# Fetch the latest changes from upstream
git fetch upstream

# Checkout your main branch
git checkout main

# Merge the upstream changes
git merge upstream/main
```

## Prerequisites

- **Godot Engine 4.4** or later
- Basic knowledge of GDScript (Godot's scripting language)

## Setup

1. Download and install [Godot Engine 4.4](https://godotengine.org/download)
2. Open Godot Engine
3. Click on **Import** and navigate to the cloned repository folder
4. Select the `project.godot` file
5. Click **Import & Edit**

## Development

### Running the Project

1. Open the project in Godot Engine
2. Press **F5** or click the **Play** button to run the project
3. The main scene will start automatically

### Project Configuration

- **Window Size**: 1920x1080
- **Godot Version**: 4.4
- **Rendering Method**: Forward Plus

## Project Structure

```
SB-1_laboratory/
├── Scene/              # Game scenes (.tscn files)
├── Script/             # GDScript files
│   ├── basic_math/
│   ├── basics_actor/
│   └── debug_hud/
├── visual/             # Visual assets
├── project.godot       # Main project configuration
└── NAMING_CONVENTION_SOURCE.tscn
```

## Contributing

1. Fork the project (see [How to Fork This Project](#how-to-fork-this-project))
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

Please check with the project maintainers for license information.

---

*For French documentation, see [README_FR.md](README_FR.md)*
