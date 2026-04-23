Сделай репозиторий публичным

https://github.com/RandolphKarter/dotfiles_2.git


1. нужен ли .config/rofi/config.rasi   ??? вероятно да
2. 

==============================

# конфиги/скрипты

```
.config/bspwm/bspwmrc
.config/bspwm/monitors.sh - логика мониторов + их переключение через kvm

.config/sxhkd/sxhkdrc 

.config/polybar/config.ini
.config/polybar/launch.sh - запуск polybar

Переложить в конфиг?
~/dev/rofi_ext/powermenu.sh - кнопка poweroff/restart в polybar

Положить сюда
/usr/local/bin/brave - алиас для brave с local proxy
```
Под root

Установить sudo
apt install sudo

Добавить юзера в sudo 
usermod -aG sudo username

Установить первые пакеты
apt install xorg kitty bspwm sxhkd picom rofi polybar lightdm git curl tree nnn

Возможно понадобятся xinit x11-xserver-utils, но в Debian 13 они идут в xorg

Установить 


apt install xorg

------------------------
После уставноки lightdm проверить что создался файл отвечающий за запуск bspwm: 
/usr/share/xsessions/bspwm.desktop

Скачать гитом конфиги
Создать директорию ~/.config
Перенести файлы



------------------------
xorg (должен включать xinit и x11-xserver-utils)
kitty 
bspwm 
sxhkd 
rofi
polybar 
picom 
git 
curl 
lightdm
tree 
nnn

