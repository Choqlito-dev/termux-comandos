#!/data/data/com.termux/files/usr/bin/bash

# Configuración de colores para mejor visualización
RED="\e[1;31m"
GREEN="\e[1;32m"
YELLOW="\e[1;33m"
BLUE="\e[1;34m"
CYAN="\e[1;36m"
NC="\e[0m" # No Color

# Función para mostrar mensajes con formato
show_msg() {
  echo -e "$1 $2 $NC"
  sleep 0.5
}

# Banner de inicio
clear
echo -e "${RED}╔══════════════════════════════════════════════╗${NC}"
echo -e "${RED}║        ${YELLOW}OPTIMIZADOR FF by: Choqlito Dev${RED}        ║${NC}"
echo -e "${RED}╚══════════════════════════════════════════════╝${NC}"
echo

# Verificar si estamos en Termux
if [ ! -d /data/data/com.termux ]; then
  show_msg "${RED}❌" "Este script solo funciona en Termux"
  exit 1
fi

# Detalles del dispositivo
show_msg "${CYAN}📱" "Detectando dispositivo..."
model=$(getprop ro.product.model)
brand=$(getprop ro.product.brand)
version=$(getprop ro.build.version.release)
kernel=$(uname -r)
show_msg "${YELLOW}✅" "Dispositivo: $brand $model - Android $version"
show_msg "${YELLOW}📊" "Kernel: $kernel"

# Mostrar uso de RAM antes de optimizar
free_before=$(free -m | grep Mem | awk '{print $4}')
show_msg "${BLUE}💾" "RAM libre antes: ${free_before}MB"

# Liberar RAM y matar procesos innecesarios
show_msg "${CYAN}🚀" "Liberando RAM y cerrando apps en segundo plano..."
am kill-all > /dev/null 2>&1
sync; echo 3 > /proc/sys/vm/drop_caches > /dev/null 2>&1 || show_msg "${YELLOW}⚠️" "No se pudo liberar caché del sistema (se requiere root)"

# Optimización de archivos temporales
show_msg "${CYAN}🧹" "Limpiando archivos temporales..."
rm -rf /data/data/com.termux/files/home/tmp/* 2>/dev/null
rm -rf /data/data/com.termux/files/usr/tmp/* 2>/dev/null
rm -rf /data/data/com.termux/cache/* 2>/dev/null

# Ajustes de touch (solo si el kernel lo permite)
show_msg "${CYAN}🎯" "Ajustando sensibilidad táctil..."
settings put system pointer_speed 7 > /dev/null 2>&1 || show_msg "${YELLOW}⚠️" "No se pudo modificar la sensibilidad"

# Mejorar prioridad de procesos
show_msg "${CYAN}⚙️" "Configurando prioridad de procesos..."
renice -n -20 -p $$ > /dev/null 2>&1

# Intentar dar prioridad al juego (Free Fire) si está en ejecución
FF_PID=$(pidof com.dts.freefireth || pidof com.dts.freefiremax || pidof com.dts.freefiremax.th)
if [ ! -z "$FF_PID" ]; then
  show_msg "${GREEN}🎮" "Free Fire detectado en ejecución, optimizando..."
  renice -n -10 -p $FF_PID > /dev/null 2>&1 || show_msg "${YELLOW}⚠️" "No se pudo modificar prioridad (requiere root)"
fi

# Configuración para mejorar respuesta del sistema
settings put global power_save_mode 0 > /dev/null 2>&1 || show_msg "${YELLOW}⚠️" "No se pudo desactivar ahorro de energía"

# Verificar resultados
free_after=$(free -m | grep Mem | awk '{print $4}')
ram_improved=$((free_after - free_before))
show_msg "${GREEN}📊" "RAM liberada: ${ram_improved}MB"

# Resultado final
echo
show_msg "${GREEN}✅" "Optimización completa. ¡Ya puedes entrar a Free Fire y pegar todo rojo! 🔥🔥🔥"

# Notificación toast
termux-toast -b red -c yellow -g middle "✅ Optimizador completado. ¡Pega todo rojo! 🎯"

# Mostrar recomendaciones adicionales
echo
echo -e "${BLUE}💡 RECOMENDACIONES:${NC}"
echo -e "${YELLOW}1.${NC} Cierra todas las demás aplicaciones antes de jugar"
echo -e "${Y
