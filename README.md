1. + нужен ли .config/rofi/config.rasi   ??? вероятно да
2. + нужно установить шрифты
3. Разобраться со скриптом подключения/перекчения мониторов
launch.sh
monitors.sh
Чтобы все в одном месте проверялось
4. из bspwmrc:
- удалить nitrogen
- разобраться где хранить обои и поменять путь
+/- и вообще удалить лишнее из всех конфигов
+ 5. Разобраться как в lightdm по дефолту установить своего юзера
+ и что там за сессия вторая?
6. Что за ошибки в systemctl --user status wireplumber ???
7. Проверить автопереключние микрофон в приложениях со звонками
+ 8. поменяй раскладку и язык системы
9. поискать темы в apt search gtk-theme
10. Добавить в powermenu опцию для лока экрана?
11. Разбить readme на команды в зависимости от этапа установки
- в части установки пакетов, пока нет браузера

==============================

# конфиги/скрипты

```
.config/bspwm/bspwmrc
.config/bspwm/monitors.sh - логика мониторов + их переключение через kvm

.config/sxhkd/sxhkdrc 

.config/polybar/config.ini
.config/polybar/launch.sh - запуск polybar

.config/rofi/config.rasi
.config/rofi/powermenu.sh

.config/kitty/kitty.conf

.config/picom/picom.sample.conf

Положить сюда
/usr/local/bin/brave - алиас для brave с local proxy
```
Под root

Установить sudo
```
apt install sudo
```

Добавить юзера в sudo 
```
usermod -aG sudo username
```


Установить первые пакеты
```
sudo apt install xorg xinit x11-xserver-utils kitty bspwm sxhkd picom rofi polybar git curl tree nnn vim network-manager network-manager-gnome firefox-esr
```

Остальные пакеты
```
sudo apt install lightdm pipewire wireplumber pavucontrol bluez blueman libspa-0.2-bluetooth zip unzip thunar dunst flameshot lm-sensors brightnessctl lxappearance transmission vlc htop gimp peek libreoffice xss-lock i3lock 
```


Для msi
```
sudo apt install  mesa-utils mesa-vulkan-drivers
```

Для Lenovo
ДРОВА NVIDIA 
```
sudo apt install nvtop
```

Возможно понадобятся xinit x11-xserver-utils, но в Debian 13 они идут в xorg
mesa-vulkan-drivers должен приехать вместе с xorg (как и основной пакет mesa)
bluez тоже должен быть уже установлен


------------------------
После уставноки lightdm проверить что создался файл отвечающий за запуск bspwm: 
```
/usr/share/xsessions/bspwm.desktop
```
Если создался еще /usr/share/xsessions/lightdm.desktop - добавь в него, чтобы такая сессия не предлагалась
```
Hidden=true
```

Скачать гитом конфиги
Скопировать директорию .config

Сделать исполняемыми:
```
chmod +x ~/.config/bspwm/bspwmrc
chmod +x ~/.config/sxhkd/sxhkdrc
chmod +x ~/.config/bspwm/monitors.sh
chmod +x ~/.config/rofi/powermenu.sh
chmod +x ~/.config/polybar/launch.sh
```

Установи шрифты для polybar
```
sudo apt install fonts-font-awesome
```

Проверь что они в системе
```
fc-list | grep -i awesome
```

Интернет
```
nmcli dev status
```
Если только lo, нужно:
```
sudo vim /etc/network/interfaces
```
закоментить или удалить 
```
allow-hotplug wlo1
iface wlo1 inet dhcp
```
И еще 
```
sudo vim /etc/NetworkManager/NetworkManager.conf 
```
установить true вместо false
```
[ifupdown] managed=true
```

Перезапуск или вообще ребутнуть тачку
```
sudo systemctl restart NetworkManager
```

После можно подключаться к сети


Проверка драйвера видео
Для msi после установки mesa
```
glxinfo | grep "OpenGL renderer"
```
Должно быть "Mesa Intel..."
```
lsmod | grep i915
```
Тут останется i915, это ок

Звук
pipewire wireplumber запустятся после перезагрузки?
или нужно сначала активировать через ??
```
systemctl --user enable --now pipewire
systemctl --user enable --now wireplumber
```

Polybar
По гайду из их вики
Температура:
После установки lm-sensors
Настройка
```
sudo sensors-detect
```
Вывод
```
sensors
```
Дальше по гайду Module:-temperature
MSI
Найди нужный сенсор ?? "Package id 0" ?? 
LENOVO
(что будет на втором компе?)

Батарейка
По гайду, заменить пару значений

backlight
поменять карту
msi - intel_backlight
lenovo - nvidia

??? Ниже для MSI, хз нужно ли для lenovo
создать файл /etc/udev/rules.d/backlight.rules

вписать туда
```
ACTION=="add", SUBSYSTEM=="backlight", KERNEL=="acpi_video0", RUN+="/usr/bin/chgrp video /sys/class/backlight/acpi_video0/brightness"
ACTION=="add", SUBSYSTEM=="backlight", KERNEL=="acpi_video0", RUN+="/usr/bin/chmod g+w /sys/class/backlight/acpi_video0/brightness"
```
перезагрузиться


Управление клавишами FN+ на msi
В sxhkd
яркость 
```
XF86MonBrightnessUp
    brightnessctl s 5+
XF86MonBrightnessDown
    brightnessctl s 5-
```

Громкость (с pipewire)
```
XF86AudioRaiseVolume
    wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+

XF86AudioLowerVolume
    wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-

XF86AudioMute
    wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
```

ZSH
тут все по гайду 
```
apt install zsh
```
не забыть сменить bash и перелогиниться
```
chsh -s /usr/bin/zsh
```

Oh My Zsh
(скопируй из гайда с хабра)

Раскладка EN+RU
sudo vim /etc/default/keyboard
```
XKBMODEL="pc105"
XKBLAYOUT="us,ru"
XKBVARIANT=""
XKBOPTIONS="grp:alt_shift_toggle"

BACKSPACE="guess"
```

lightdm
Выбор юзера, чтобы не вводить логин постоянно
```
sudo vim /etc/lightdm/lightdm.conf
```
раскоментировать
```
[Seat:*]
greeter-hide-users=false
```

Тема
Узнать greeter
```
dpkg -l | grep lightdm
```
Скорее всего будет lightdm-gtk-greeter
В этом файле
```
sudo vim /etc/lightdm/lightdm-gtk-greeter.conf
```
Раскоментировать и вписать тему 
```
[greeter]
theme-name=Adwaita-dark
```

Скринсейвер
Проверить путь к изображению в bspwmrc
Важно - нужно именно png
````
xss-lock -- i3lock -i ~/Pictures/wallpaper.png
```

Открывать большинство файлов в текстовом редакторе.
Создать/отредактировать
```
vim ~/.local/share/applications/lite-xl.desktop
```
Выглядеть должен так 
```
[Desktop Entry]
Name=Lite XL
Exec=/home/fixmymind/.local/bin/lite-xl %F
Type=Application
MimeType=text/*;application/json;application/javascript;application/xml;application/x-yaml;application/yaml;application/x-toml;application/x-ini;application/x-shellscript;application/x-sh;application/x-bash;application/x-zsh;application/x-python;application/x-php;application/x-ruby;application/x-perl;application/x-c;application/x-c++src;application/x-java;application/x-go;application/x-rust;application/x-typescript;application/sql;application/graphql;application/x-httpd-php;application/x-nginx-conf;application/x-apache-conf;application/x-dockerfile;
Categories=Utility;TextEditor;
```
Обновить 
```
update-desktop-database ~/.local/share/applications 
```
Првоерить или прямо через файловвый менеджер
```
xdg-open dotfiles/dotfiles_2/README.md
```

Установка утилит в deb пакетах
```
sudo dpkg -i package.deb
```

Для архивов
```
tar -xzf file.tar.gz
tar -xJf file.tar.xz
```
Перетащить если надо в /opt

Создание алиаса на примере lite-xl
```
sudo ln -s ~/.local/bin/lite-xl /usr/local/bin/lite-xl
```
------------------------
- xorg (должен включать xinit и x11-xserver-utils)
- kitty 
- bspwm 
- sxhkd 
- rofi
- polybar 
- picom 
- git 
- curl 
- lightdm
- tree 
- nnn
- vim
- network-manager
- network-manager-gnome
- firefox-esr - хоть какой-то первый браузер
- pipewire
- wireplumber
- pavucontrol
- bluez 
- blueman
- libspa-0.2-bluetooth - иначе блютуз не сможет подключиться
- zip
- unzip
- thunar
- dunst - уведомления
- flameshot
- lm-sensors
- brightnessctl - для управления яркостью и громкостью через клавиши
- lxappearance - темы
- transmission
- vlc
- htop
- nvtop - только для NVIDIA
- gimp
- peek
- libreoffice
- xss-lock 
- i3lock 

Подумать (не включены в список):
??? Diodon или все же parcellite
gtk2-engines-murrine gtk2-engines-pixbuf - чтобы GTK2/GTK3 работали норм с lxappearance


Осталось:
+ zsh + 1000 что-то там


+ subl или lite xl
+ insomnia (postman)
+ pycharm
+ chrome
+ brave
+ v2rayN
+ telegram
+ charles proxy
+ http toolkit
+ android studio


