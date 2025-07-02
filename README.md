
<div align="right">
  <details>
    <summary >🌐 Language</summary>
    <div>
      <div align="right">
        <p><a href="https://openaitx.github.io/view.html?user=sbwml&project=luci-app-openlist&lang=en">English</a></p>
        <p><a href="https://openaitx.github.io/view.html?user=sbwml&project=luci-app-openlist&lang=zh-CN">简体中文</a></p>
        <p><a href="https://openaitx.github.io/view.html?user=sbwml&project=luci-app-openlist&lang=zh-TW">繁體中文</a></p>
        <p><a href="https://openaitx.github.io/view.html?user=sbwml&project=luci-app-openlist&lang=ja">日本語</a></p>
        <p><a href="https://openaitx.github.io/view.html?user=sbwml&project=luci-app-openlist&lang=ko">한국어</a></p>
        <p><a href="https://openaitx.github.io/view.html?user=sbwml&project=luci-app-openlist&lang=hi">हिन्दी</a></p>
        <p><a href="https://openaitx.github.io/view.html?user=sbwml&project=luci-app-openlist&lang=th">ไทย</a></p>
        <p><a href="https://openaitx.github.io/view.html?user=sbwml&project=luci-app-openlist&lang=fr">Français</a></p>
        <p><a href="https://openaitx.github.io/view.html?user=sbwml&project=luci-app-openlist&lang=de">Deutsch</a></p>
        <p><a href="https://openaitx.github.io/view.html?user=sbwml&project=luci-app-openlist&lang=es">Español</a></p>
        <p><a href="https://openaitx.github.io/view.html?user=sbwml&project=luci-app-openlist&lang=it">Itapano</a></p>
        <p><a href="https://openaitx.github.io/view.html?user=sbwml&project=luci-app-openlist&lang=ru">Русский</a></p>
        <p><a href="https://openaitx.github.io/view.html?user=sbwml&project=luci-app-openlist&lang=pt">Português</a></p>
        <p><a href="https://openaitx.github.io/view.html?user=sbwml&project=luci-app-openlist&lang=nl">Nederlands</a></p>
        <p><a href="https://openaitx.github.io/view.html?user=sbwml&project=luci-app-openlist&lang=pl">Polski</a></p>
        <p><a href="https://openaitx.github.io/view.html?user=sbwml&project=luci-app-openlist&lang=ar">العربية</a></p>
        <p><a href="https://openaitx.github.io/view.html?user=sbwml&project=luci-app-openlist&lang=fa">فارسی</a></p>
        <p><a href="https://openaitx.github.io/view.html?user=sbwml&project=luci-app-openlist&lang=tr">Türkçe</a></p>
        <p><a href="https://openaitx.github.io/view.html?user=sbwml&project=luci-app-openlist&lang=vi">Tiếng Việt</a></p>
        <p><a href="https://openaitx.github.io/view.html?user=sbwml&project=luci-app-openlist&lang=id">Bahasa Indonesia</a></p>
      </div>
    </div>
  </details>
</div>

# luci-app-openlist

🗂️ A file list program that supports multiple storage, powered by Gin and Solidjs.

## How to build

- Install `libfuse` development package.

  - ubuntu/debian:
    ```shell
    sudo apt update
    sudo apt install libfuse-dev
    ```

  - redhat:
    ```shell
    sudo yum install fuse-devel
    ```

  - arch:
    ```shell
    sudo pacman -S fuse2
    ```

- Enter in your openwrt dir

- Openwrt official SnapShots

  *1. requires golang 1.24.x or latest version (Fix build for older branches of OpenWrt.)*
  ```shell
  rm -rf feeds/packages/lang/golang
  git clone https://github.com/sbwml/packages_lang_golang -b 24.x feeds/packages/lang/golang
  ```

  *2. get luci-app-openlist code & building*
  ```shell
  git clone https://github.com/sbwml/luci-app-openlist package/openlist
  make menuconfig # choose LUCI -> Applications -> luci-app-openlist
  make package/openlist/luci-app-openlist/compile V=s # build luci-app-openlist
  ```

--------------

## How to install prebuilt packages (LuCI2)

- Login OpenWrt terminal (SSH)

- Install `curl` package
  ```shell
  # for opkg package manager (openwrt 21.02 ~ 24.10)
  opkg update
  opkg install curl
  
  # for apk package manager
  apk update
  apk add curl
  ```

- Execute install script (Multi-architecture support)
  ```shell
  sh -c "$(curl -ksS https://raw.githubusercontent.com/sbwml/luci-app-openlist/main/install.sh)"
  ```

  install via ghproxy:
  ```shell
  sh -c "$(curl -ksS https://raw.githubusercontent.com/sbwml/luci-app-openlist/main/install.sh)" _ gh_proxy="https://gh.cooluc.com"
  ```

--------------

![luci-app-openlist](https://github.com/user-attachments/assets/50d8ee3a-e589-4285-922a-40c82f96b9f5)
