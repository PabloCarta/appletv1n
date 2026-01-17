#!/bin/bash

# Seas0nPass Launcher - Compatibility wrapper for modern macOS
# Ejecuta configuraciones de compatibilidad antes de iniciar la app

APP_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
RESOURCES_DIR="$APP_DIR/Resources"
BIN_DIR="$RESOURCES_DIR/bin"

# Función para remover restricciones de cuarentena
remove_quarantine() {
    local file=$1
    if [ -f "$file" ] && xattr -p com.apple.quarantine "$file" &>/dev/null; then
        echo "[*] Removiendo cuarentena de $(basename $file)..."
        xattr -d com.apple.quarantine "$file"
    fi
}

# Función para hacer ejecutables todos los binarios
ensure_executables() {
    echo "[*] Asegurando permisos de ejecución..."
    find "$BIN_DIR" -type f -executable -o -type f -name "*.sh" | while read binary; do
        chmod +x "$binary"
        remove_quarantine "$binary"
    done
}

# Función para limpiar binarios i386
strip_i386() {
    for binary in "$BIN_DIR"/{genpass,imagetool,vfdecrypt,xpwntool}; do
        if [ -f "$binary" ]; then
            if file "$binary" | grep -q "i386"; then
                echo "[*] Limpiando arquitectura i386 de $(basename $binary)..."
                # Backup
                cp "$binary" "${binary}.backup"
                # Extraer solo x86_64
                if lipo -thin x86_64 "$binary" -output "$binary.x86_64" 2>/dev/null; then
                    mv "$binary.x86_64" "$binary"
                    chmod +x "$binary"
                else
                    # Si lipo falla, restaurar backup
                    mv "${binary}.backup" "$binary"
                fi
            fi
        fi
    done
}

# Función para aplicar permisos de dispositivo
apply_device_permissions() {
    echo "[*] Aplicando permisos de dispositivo USB..."
    
    # Remover atributos de quarantine de todos los binarios
    find "$BIN_DIR" -type f -exec xattr -d com.apple.quarantine {} \; 2>/dev/null || true
    
    # Si tenemos acceso a codesign, intentar firmar los binarios
    if command -v codesign &>/dev/null; then
        for binary in "$BIN_DIR"/{genpass,imagetool,vfdecrypt,xpwntool}; do
            if [ -f "$binary" ]; then
                # Verificar si tiene firma válida
                if ! codesign -v "$binary" &>/dev/null; then
                    echo "[*] Requiere firma de código: $(basename $binary)"
                    # Nota: Los usuarios deben firmar manualmente o ejecutar con sudo
                fi
            fi
        done
    fi
}

# Función para detectar y conectar Apple TV
detect_appletv() {
    echo "[*] Detectando dispositivos Apple TV conectados..."
    
    # Buscar dispositivos USB de Apple
    if command -v system_profiler &>/dev/null; then
        DEVICES=$(system_profiler SPUSBDataType 2>/dev/null | grep -i "apple" | grep -i "tv\|appleid" || echo "")
        if [ -n "$DEVICES" ]; then
            echo "[+] Dispositivos Apple detectados:"
            echo "$DEVICES" | head -5
        fi
    fi
}

# Ejecutar todas las preparaciones
main() {
    echo "═══════════════════════════════════════════════════"
    echo "  Seas0nPass - Compatibility Launcher"
    echo "  macOS $(sw_vers -productVersion)"
    echo "═══════════════════════════════════════════════════"
    echo ""
    
    ensure_executables
    strip_i386
    apply_device_permissions
    detect_appletv
    
    echo ""
    echo "[+] Lanzando Seas0nPass..."
    echo ""
    
    # Ejecutar la aplicación
    # Nota: Este script normalmente sería reemplazado por el binario real
    # o ejecutado como prelanzador
}

main "$@"
