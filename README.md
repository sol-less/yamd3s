<div align="center">
  <h1>[ Yamd3s ]</h1>
</div>

> or **Yet Another Material Design 3 Shell**

<details>
  <summary><b>Preview</b></summary>
  <div align="center">
    <img width="50%" alt="2026-08-16_15-10-28" src="https://github.com/user-attachments/assets/d0bd9677-b984-4687-ae02-6cf4e0945b95" />
  </div>
</details>

# About
**Yamd3s** is a Quickshell dotfile based on **Material Design 3**.

# Installation
> [!IMPORTANT]
> Install each dependency **via your system's package manager**. **Arch Linux** is highly recommended, as this project was originally built on it.

## Required dependencies
- `hyprland`
- `quickshell-git`
- `matugen` (accessible [here](https://github.com/InioX/matugen))
- `yacli` (optional, but recommended. Install [here](https://github.com/sol-less/yacli))
- `yay` (or `paru` for installing `quickshell-git`)
- `git`
- `cmake`

## Method 1: Manual Installation
> [!NOTE]
> You will need a `.config/` directory for this to work, or just use `cd yamd3s/ && chmod +x Yals && ./yamd3s/Yals`.

```bash
git clone https://github.com/sol-less/yamd3s.git
cd yamd3s/
cmake -B build
cmake --build build
```

## Method 2: Through Yacli
After installing [Yacli](https://github.com/sol-less/yacli), go ahead do this command:

```bash
yacli install
```

# Usage
> [!NOTE]
> You have **2 methods** to run this: through `./Yals` or `yacli`.

## Method 1: Manual Run
```bash
chmod +x Yals
./Yals
```

## Method 2: Yacli Run
```bash
yacli shell run
```

# Configuration
> [!NOTE]
> Due to the new migration to some C++, the configuration is still messy. Thank You!
