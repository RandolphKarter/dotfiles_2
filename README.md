Сделай репозиторий публичным

https://github.com/RandolphKarter/dotfiles_2.git


1. + нужен ли .config/rofi/config.rasi   ??? вероятно да
2. + нужно установить шрифты
3. Разобраться со скриптом подключения/перекчения мониторов
4. 

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
apt install xorg kitty bspwm sxhkd picom rofi polybar lightdm git curl tree nnn vim

Возможно понадобятся xinit x11-xserver-utils, но в Debian 13 они идут в xorg

Установить 


apt install xorg

------------------------
После уставноки lightdm проверить что создался файл отвечающий за запуск bspwm: 
/usr/share/xsessions/bspwm.desktop

Скачать гитом конфиги
Создать директорию ~/.config
Перенести файлы
!!!! тут надо все что в .config - положить в эту папку, и сразу ее копировать


Сделать испольняемыми:
chmod +x ~/.config/bspwm/bspwmrc
chmod +x ~/.config/bspwm/monitors.sh
chmod +x ~/.config/sxhkd/sxhkdrc
chmod +x ~/.config/rofi/powermenu.sh

Установи шрифты для polebar
sudo apt install fonts-font-awesome

Проверь что они в системе
fc-list | grep -i awesome

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
vim
