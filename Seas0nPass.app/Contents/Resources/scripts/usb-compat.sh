#!/bin/bash

# USB Compatibility Layer for macOS Tahoe (26.0+)
# Este script asegura que los binarios antiguos funcionen con dispositivos USB en macOS moderno

set -e

# Detectar versión de macOS
MACOS_VERSION=$(sw_vers -productVersion)
MACOS_MAJOR=$(echo $MACOS_VERSION | cut -d. -f1)
MACOS_MINOR=$(echo $MACOS_VERSION | cut -d. -f2)

# Variables de configuración
BIN_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../bin" && pwd)"
TEMP_DIR="/tmp/appletv-$$"
mkdir -p "$TEMP_DIR"

trap "rm -rf $TEMP_DIR" EXIT

# Función para detectar y preparar binarios
prepare_binary() {
    local binary=$1
    local name=$(basename "$binary")
    
    # Si es una arquitectura universal con i386, extraer solo x86_64
    if file "$binary" | grep -q "universal binary" && file "$binary" | grep -q "i386"; then
        echo "[*] Extrayendo arquitectura x86_64 de $name (removiendo i386)..."
        lipo -thin x86_64 "$binary" -output "$TEMP_DIR/$name"
        cp "$TEMP_DIR/$name" "$binary"
        chmod +x "$binary"
    fi
}

# Función para aplicar entitlements
apply_entitlements() {
    local binary=$1
    local name=$(basename "$binary")
    
    # Crear archivo de entitlements temporal
    cat > "$TEMP_DIR/entitlements.xml" << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>com.apple.security.device.usb</key>
    <true/>
    <key>com.apple.security.device.firewire</key>
    <true/>
    <key>com.apple.security.files.user-selected.read-only</key>
    <true/>
    <key>com.apple.security.files.user-selected.read-write</key>
    <true/>
    <key>com.apple.security.temporary-exception.files.absolute-path.read-write</key>
    <array>
        <string>/dev</string>
        <string>/dev/disk*</string>
    </array>
</dict>
</plist>
EOF
}

# Función para remover firma malformada
fix_code_signature() {
    local binary=$1
    
    # Remover firma de código existente si está corrupta
    if codesign -v "$binary" 2>&1 | grep -q "invalid"; then
        echo "[*] Removiendo firma de código corrupta de $(basename $binary)..."
        codesign --remove-signature "$binary" 2>/dev/null || true
    fi
}

# Función principal de compatibilidad
ensure_usb_compatibility() {
    echo "[+] Preparando compatibilidad USB para macOS $MACOS_VERSION"
    
    # Permitir que la app acceda a dispositivos USB
    if [ "$MACOS_MAJOR" -ge 11 ]; then
        echo "[*] Configurando permisos de dispositivo USB..."
        
        # Remover restricciones de cuarentena
        for binary in "$BIN_DIR"/{genpass,imagetool,vfdecrypt,xpwntool}; do
            if [ -f "$binary" ]; then
                xattr -d com.apple.quarantine "$binary" 2>/dev/null || true
                fix_code_signature "$binary"
                prepare_binary "$binary"
            fi
        done
    fi
    
    echo "[+] Configuración de compatibilidad USB completada"
}

# Ejecutar solo si es necesario
if [ "$MACOS_MAJOR" -ge 15 ]; then
    ensure_usb_compatibility
fi
