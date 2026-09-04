<div align="center">

# [ Yamd3s ]

> Quickshell dotfiles based on Material Design 3 and Material 3 Improv

<details>
  <summary><b>📷 Click to view Preview Image</b></summary>
  <br>
  <img width="70%" alt="Yamd3s Preview" src="https://github.com/user-attachments/assets/18755c31-85ec-496a-ab73-e7c7bb3dcca6"/>
</details>

</div>

---

## About

**Yamd3s** is a highly customizable shell built around [Quickshell](https://github.com/quickshell-mirror/quickshell), designed around Material Design 3 principles.

---

## Dependencies

Ensure the following packages are installed on your system before proceeding:

* **Hyprland** (`hyprland`)
* **Quickshell** (`quickshell`)
* **CMake** (`cmake`)
* **Ninja** (`ninja`)
* **C++ Compiler** (`gcc` or `clang`)

---

## Installation

> [!NOTE]
> You can install Yamd3s using **Yacli** (automated) or by compiling manually.

### Method 1: Yacli (Recommended)

> [!IMPORTANT]
> Before installing the shell, please follow the **Yacli** setup guide [here](https://github.com/sol-less/yacli).

Run this command after installing **Yacli**:

```bash
yacli shell install
```

### Method 2: Manual Installation

Clone the repository and compile using CMake and Ninja:

```bash
cd $HOME/.config/quickshell/
git clone https://github.com/sol-less/yamd3s yamd3s
cd yamd3s/

cmake -B build -G Ninja -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr
cmake --build build
sudo cmake --install build
```
