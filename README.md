# Гайд по установке Debian + bspwm 
Собраны все шаги, чтобы не решать каждый раз одни и те же проблемы :shit: и не вспоминать команды :rage:
Можете кидаться тапками, мне пох :sunglasses:

## Подготовка и установка
:exclamation:Не забудь сохранить все важные файлы.:exclamation:

### Подготовка флешки
1. Скачать ISO образ Debian
**MSI**
Достаточно netist образа.
**LENOVO**
Бери DVD образ, чтобы избежать танцев с бубном для wifi/lan, 
И чтобы избежать проблем с wifi используй LAN сразу, тогда после установки будет работать инет.
И не пропускай настройку зеркала, а то apt sources list будет пустой и придется руками заполнять.
2. Узнать имя флешки - будет что-то типа `/dev/sda`
```
lsblk
```
3. Записать образ на диск
Поменять в команде 
- `if` на путь до образа
- `of` на название флешки, обязательно с /dev/
Пример:
```
sudo dd if=/home/<USER>/Downloads/debian_13.iso of=/dev/sda bs=4M status=progress oflag=sync
``` 
4. После записи
```
sync
```
### Установка Debian
Все просто - ставь чистую систему без DE.  
Разметка диска (примерно):
- `EFI` - 500 MB
    - тип: `EFI System`
    - ФС: `FAT32` (но вроде он сам выбирает)
- `swap` — 15 GB (~размер RAM)
    - тип: `swap area`
- `/` - 50 GB
    - ФС: `ext4` (по умолчанию)
- `/boot` - 500 MB или 1 GB
    - ФС: `ext4`
- `/var` - 10GB
    - ФС: `ext4`
- `/home` - все оставшееся
    - ФС: `ext4`

## Настройка системы
### Добавление юзера в sudo
1. Зайти под root и установить sudo
```
apt install sudo
```
Если был использовался образ DVD, то sudo уже есть в системе.

2. Добавить юзера в sudo 
```
usermod -aG sudo username
```
Под рутом может говориить что команды нет (не верь, она приезжает в пакете passwd, который уже стоит), поэтому стоит пробовать как ниже, и все будет ок:
```
/usr/bins/usermod -aG sudo username
```

## Установка первых пакетов
Установить первые пакеты.  
Все что необходимо для работы в терминале и первичной настройки окружения.
```
sudo apt install xorg xinit x11-xserver-utils kitty bspwm sxhkd picom rofi polybar git curl tree nnn vim network-manager network-manager-gnome firefox-esr lightdm lm-sensors brightnessctl feh
```
Возможно xinit x11-xserver-utils уже установлены, в Debian 13 они идут в вместе с `xorg`

## Перенос конфигов/скриптов
Клонируй репозиторий.
В репозитории есть уже готовая папка `.config`
Скопируй ее и перенеси в `/home/<USER>`
Содержимое:
- `.config/bspwm/bspwmrc`
- `.config/bspwm/monitors.sh` - логика мониторов + их переключение через kvm
- `.config/sxhkd/sxhkdrc` 
- `.config/polybar/config.ini`
- `.config/polybar/launch.sh` - запуск polybar
- `.config/rofi/config.rasi`
- `.config/rofi/powermenu.sh` - кнопка poweroff/reboot в polybar
- `.config/kitty/kitty.conf`
- `.config/picom/picom.sample.conf`
- `.config/tmux/tmux.conf`
- `.config/mpd/mpd.conf`
- `.config/ncmpcpp/config`

Отдельно лежащий файл brave (скрипт для запуска brave с local proxy) перетащи сюда:
```
/.local/bin/brave
```

Сделать исполняемыми:
```
chmod +x ~/.config/bspwm/bspwmrc
chmod +x ~/.config/sxhkd/sxhkdrc
chmod +x ~/.config/bspwm/monitors.sh
chmod +x ~/.config/rofi/powermenu.sh
chmod +x ~/.config/polybar/launch.sh
```
??? `/usr/local/bin/brave` - тоже делать исполняемым? 

## Установка шрифтов
- `fonts-font-awesome` - для polybar
- `fonts-noto-color-emoji` - эмоджи в браузере и редакторах
- `fonts-noto fonts-noto-core fonts-noto-ui-core` - доп пакет шрифтов

```
sudo apt install fonts-font-awesome fonts-noto-color-emoji fonts-noto fonts-noto-core fonts-noto-ui-core
```

Проверь что они есть в системе ??? добавь остальные в команду
```
fc-list | grep -i awesome
```

## Подключение wifi
До этого все работало из-за заданной при установки Debian настройки в `/etc/network/interfaces`.  
Проверить доступные интерфейсы
```
nmcli dev status
```
Если только lo, открыть файл:
```
sudo vim /etc/network/interfaces
```
Закоментить или удалить (удаляем настройку заданную при установке):
```
allow-hotplug wlo1
iface wlo1 inet dhcp
```
Также открыть конфиг:
```
sudo vim /etc/NetworkManager/NetworkManager.conf 
```
И установить `true` вместо `false`
```
[ifupdown] 
managed=true
```
Перезапустить `NetworkManager` или просто ребутнуть тачку
```
sudo systemctl restart NetworkManager
```
Проверь снова доступные интерфейсы:
```
nmcli dev status
```
Проверь что отображаются wifi сети:
```
nmcli dev wifi list 
```
Подключайся так:
```
nmcli dev wifi connect "SSID" password "PASSWORD"
```
Или через через `nm-applet`

Еще можно проверить что wifi интерфейс поднят командой
```
ip a
```
Должно быть UP


## Настройка модулей Polybar
Все по их [вики](https://github.com/polybar/polybar/wiki)
### Температура
Настрой lm-sensors (на все соглашайся)
```
sudo sensors-detect
```
Проверь вывод
```
sensors
```
Смотри что там по `Package id 0`
- MSI - найди нужный сенсор ??? `Package id 0`
- LENOVO - надо поменять hwmon-path

### Батарея
Просто заменить пару значений в соответствии с гайдом

### Подсветка
Поменять карту
- MSI - intel_backlight
- LENOVO - nvidia

#### Изменения яркости колесом мышки
Ниже детали найтроки для MSI
??? хз нужно ли для lenovo

Создать файл 
```
touch /etc/udev/rules.d/backlight.rules
```
Вписать туда
```
ACTION=="add", SUBSYSTEM=="backlight", KERNEL=="acpi_video0", RUN+="/usr/bin/chgrp video /sys/class/backlight/acpi_video0/brightness"
ACTION=="add", SUBSYSTEM=="backlight", KERNEL=="acpi_video0", RUN+="/usr/bin/chmod g+w /sys/class/backlight/acpi_video0/brightness"
```
Перезагрузиться

### Изменения яркости и громкости кнопками FN+
Открыть sxhkdrc
```
vim ~/.config/sxhkd/sxhkdrc
```
#### Яркость
Ниже детали настройки для MSI.
Для lenovo нужно сперва поставить дрова nvidia.

Раскомментировать/Вписать
```
XF86MonBrightnessUp
    brightnessctl s 5+
XF86MonBrightnessDown
    brightnessctl s 5-
```

### Громкость
Для pipewire.  
Раскомментировать/Вписать
```
XF86AudioRaiseVolume
    wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+

XF86AudioLowerVolume
    wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-

XF86AudioMute
    wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
```

## Установка остальных пакетов
```
sudo apt install pipewire wireplumber pavucontrol bluez blueman libspa-0.2-bluetooth zip unzip thunar dunst flameshot lxappearance transmission vlc htop gimp peek libreoffice xss-lock i3lock jq viewnior btop blueman-applet adb keepassxc tmux mpd ncmpcpp
```

## Настройка lightdm
### Отключение ненужной сесии
Проверить что после установки создался файл отвечающий за запуск bspwm: 
```
/usr/share/xsessions/bspwm.desktop
```
Если создался еще `/usr/share/xsessions/lightdm.desktop` - добавь в него параметр ниже, чтобы эта сессия не предлагалась и был только bspwm
```
Hidden=true
```

### Выбор юзера из списка
Чтобы не вводить каждый раз логин вручную, а выбирать из списка.
Открой конфиг:
```
sudo vim /etc/lightdm/lightdm.conf
```
Паскоментируй
```
[Seat:*]
greeter-hide-users=false
```

### Установка темы
Узнать greeter
```
dpkg -l | grep lightdm
```
Скорее всего будет lightdm-gtk-greeter.  
Открыть файл
```
sudo vim /etc/lightdm/lightdm-gtk-greeter.conf
```
Раскоментировать и вписать тему (смотри какая тема стоит в системе, Adwaita-dark приезжает вероятно с thunar)
```
[greeter]
theme-name=Adwaita-dark
```

### Установка фона
Сделать копию картинки фона в `/usr/share/`
```
sudo cp /path/to/image.jpg /usr/share/pixmaps/bg.jpg
```
Прописать путь к картинке 
```
sudo vim /etc/lightdm/lightdm-gtk-greeter.conf
```
Параметр `background=/путь/к/картинке`
После рестарта все должно быть ок.

Альтернативный вариант - настроить права для картинок/папки в которой они лежат.


## Драйверы для видеокарты
### MSI
Для msi нужно заменить дефолтный `i915` на `mesa`
```
sudo apt install mesa-utils mesa-vulkan-drivers
```
`mesa-vulkan-drivers` должен приехать вместе с `xorg` (как и основной пакет mesa)
#### Проверка драйвера видео
```
glxinfo | grep "OpenGL renderer"
```
Должно быть "Mesa Intel..."
```
lsmod | grep i915
```
Тут останется i915, это ок


### LENOVO
??? ДРОВА NVIDIA 

Также не забудь поставить
```
sudo apt install nvtop
```
#### Проверка драйвера видео
??? 

## Звук
Активация
```
systemctl --user enable --now pipewire
systemctl --user enable --now wireplumber
```
Если что попробуй перезагрузиться.

## Bluetooth
После установки `bluez` и `blueman`, проверь включен ли сервис (или перезагрузка ???)
```
sudo systemctl enable --now bluetooth
```
`bluez` вроде приезжает с Debian сразу.


## Раскладка EN+RU
Открыть файл
```
sudo vim /etc/default/keyboard
```
Отредактировать
```
XKBMODEL="pc105"
XKBLAYOUT="us,ru"
XKBVARIANT=""
XKBOPTIONS="grp:alt_shift_toggle"

BACKSPACE="guess"
```

## Screensaver
Отвечают `xss-lock` и `i3lock`
Проверить путь к изображению в `bspwmrc`.  
**Важно** - нужно именно png.  
Пример команды из `bspwmrc`
```
xss-lock -- i3lock -i ~/Pictures/wallpaper.png
```

## OhMyZsh и Powerlevel10k
Все по [гайду](https://habr.com/ru/articles/739376/)
```
apt install zsh
```
Не забудь сменить bash и перелогиниться
```
chsh -s /usr/bin/zsh
```

## Настройка viewnior (просмотрщик изображений)
После установки, чтобы формат открывались в нем по дефолту выполнить:
```
xdg-mime default viewnior.desktop image/png
xdg-mime default viewnior.desktop image/jpeg
```

## Установка остальных утилит
Остальное ставится не из репозиториев Debian
+ subime text
+ chrome
+ brave
+ v2rayN
+ telegram
+ insomnia
+ pycharm
+ charles proxy - с версией 5.xx проблемы, падает с NullPointerException, чтобы не разбираться с версиями java - ставь более старую, 4.8.x версию
+ http toolkit
+ android studio

### Установка утилит в deb пакетах
```
sudo dpkg -i package.deb
```

### Установка утилит из архивов
```
tar -xzf <FILE_NAME>.tar.gz
tar -xJf <FILE_NAME>.tar.xz
```
После распаковки лучше перетащить файлы в `/opt`

### Создание алиасов
На примере telegram
```
sudo ln -s ~/.local/bin/telegram /usr/local/bin/telegram
```

## Настройка открытия большинства файлов в текстовом редакторе
Пример для `Sublime Text`, но для других все аналогично.
Скопировать дефолтный конфиг.
```
cp /usr/share/applications/sublime_text.desktop ~/.local/share/applications/
```
Отредактировать
```
vim ~/.local/share/applications/sublime_text.desktop
```
Добавив
```
MimeType=text/plain;text/*;application/json;application/javascript;application/xml;application/x-yaml;application/yaml;application/x-toml;application/x-ini;application/x-shellscript;application/x-sh;application/x-bash;application/x-zsh;application/x-python;application/x-php;application/x-ruby;application/x-perl;application/x-c;application/x-c++src;application/x-java;application/x-go;application/x-rust;application/x-typescript;application/sql;application/graphql;application/x-dockerfile;
```

Выполнить
```
xdg-mime default sublime_text.desktop text/plain
xdg-mime default sublime_text.desktop text/markdown
```

Обновить 
```
update-desktop-database ~/.local/share/applications 
```

Проверить тут
```
vim ~/.config/mimeapps.list 
```
Что добавлены
```
[Default Applications]
text/plain=sublime_text.desktop
text/markdown=sublime_text.desktop
```

Проверить так или прямо через файловый менеджер
```
xdg-open dotfiles/dotfiles_2/README.md
```

## mpd + ncmpcpp
Запуск
```
systemctl --user enable mpd
systemctl --user start mpd
```


## Forti
Чтобы заработал forti - проверь запускается ли его трей, если нет, скроее всего нет libgtk2.0-0
Попробуй сперва его запустить /opt/forticlient/fortitraylauncher
Если там ошибка ставь 
```
sudo apt install libgtk2.0-0
```
Еще forti хочет чтобы в системе был iptables, придется ставить и его

--- 


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
- jq
- feh
- viewnior
- btop
- blueman-applet
- adb
- keepassxc
- tmux
- mpd
- ncmpcpp


## TODO
1. Разобраться со скриптом подключения/перекчения мониторов
launch.sh
monitors.sh
Чтобы все в одном месте проверялось
2. Опиши инструкцию по установке дров NVIDIA
дрова nvidia по инструкции, но лучше выписать команды
там заголовки ядра надо обновлять еще и правильно включать репозитории в sources.list, чтобы не было повторов (надо с этим разобраться)
3. С яркостью для nvidia нужно также выдавать права + не забыть в них поменять значение в KERNEL и PATH (для lenovo там будет nvidia_0 ???)
4. в конфиге polybar сделать второй блок с lenovo для батарейки, чтобы переключать раскоментированием
5. блок по настройке tmux
6. В mpd нужно ли создавать папку для плейлистов?
7. Описать что надо запускать в tmux для установки плагинов
8. gtk2-engines-murrine gtk2-engines-pixbuf - чтобы GTK2/GTK3 работали норм с lxappearance - сами приедут или как ???
