#!/bin/bash

# Apple TV USB Connectivity Test
# Verifica que el dispositivo pueda ser detectado y comunicarse con el Mac

print_header() {
    echo "════════════════════════════════════════════════"
    echo "  $1"
    echo "════════════════════════════════════════════════"
}

print_test() {
    echo ""
    echo "[TEST] $1"
}

print_ok() {
    echo "  ✓ $1"
}

print_fail() {
    echo "  ✗ $1"
}

print_header "Apple TV USB Connectivity Test"

# Test 1: Versión de macOS
print_test "Versión de macOS"
MACOS_VERSION=$(sw_vers -productVersion)
echo "  Version: $MACOS_VERSION"
print_ok "Detectado"

# Test 2: Dispositivos USB
print_test "Dispositivos USB conectados"
if command -v system_profiler &>/dev/null; then
    USB_DEVICES=$(system_profiler SPUSBDataType 2>/dev/null | grep -E "Product|Vendor" | head -10)
    if [ -z "$USB_DEVICES" ]; then
        print_fail "No se detectaron dispositivos USB"
    else
        echo "$USB_DEVICES"
        print_ok "Dispositivos detectados"
    fi
else
    print_fail "system_profiler no disponible"
fi

# Test 3: Buscar Apple TV específicamente
print_test "Búsqueda de Apple TV"
APPLETV=$(system_profiler SPUSBDataType 2>/dev/null | grep -i "apple" || echo "")
if [ -z "$APPLETV" ]; then
    print_fail "Apple TV no detectado (verifica conexión USB)"
else
    echo "  Encontrado: Apple TV"
    print_ok "Apple TV detectado"
fi

# Test 4: Herramientas disponibles
print_test "Herramientas necesarias"
TOOLS=("xpwntool" "vfdecrypt" "imagetool" "genpass")
for tool in "${TOOLS[@]}"; do
    if command -v "$tool" &>/dev/null || [ -f "/Applications/Seas0nPass.app/Contents/Resources/bin/$tool" ]; then
        print_ok "$tool disponible"
    else
        print_fail "$tool no encontrado"
    fi
done

# Test 5: Permisos de Seas0nPass
print_test "Permisos de Seas0nPass"
if [ -d "/Applications/Seas0nPass.app" ]; then
    BIN_DIR="/Applications/Seas0nPass.app/Contents/Resources/bin"
    PERMS_OK=1
    
    for binary in xpwntool vfdecrypt imagetool genpass; do
        if [ -f "$BIN_DIR/$binary" ]; then
            if [ -x "$BIN_DIR/$binary" ]; then
                print_ok "$binary: ejecutable"
            else
                print_fail "$binary: no ejecutable"
                PERMS_OK=0
            fi
        fi
    done
    
    if [ $PERMS_OK -eq 1 ]; then
        print_ok "Permisos verificados"
    fi
else
    print_fail "Seas0nPass no instalado en /Applications"
fi

# Test 6: Drivers y módulos
print_test "Estado de los drivers"
if [ -d "/System/Library/Extensions" ]; then
    KEXTS=$(ls -la /System/Library/Extensions/ 2>/dev/null | wc -l)
    echo "  KEXTs instalados: $KEXTS"
    print_ok "Sistema de drivers accesible"
else
    echo "  Sistema de drivers de macOS"
    print_ok "Estándar"
fi

# Test 7: Seguridad y firma de código
print_test "Firma de código"
if command -v codesign &>/dev/null; then
    if [ -f "/Applications/Seas0nPass.app/Contents/Resources/bin/xpwntool" ]; then
        if codesign -v /Applications/Seas0nPass.app/Contents/Resources/bin/xpwntool &>/dev/null; then
            print_ok "xpwntool: Firmado correctamente"
        else
            print_fail "xpwntool: Sin firma válida (puede requerir firma manual en Tahoe)"
        fi
    fi
else
    echo "  codesign no disponible (normal en algunos sistemas)"
    print_ok "Continuando"
fi

print_header "Recomendaciones"

echo ""
echo "Si el Apple TV no fue detectado:"
echo "1. Verifica que esté conectado al Mac con cable USB"
echo "2. En el Apple TV, selecciona 'Confiar' si aparece un diálogo"
echo "3. Reinicia el Mac y el Apple TV"
echo "4. Intenta con otro cable USB"
echo ""

echo "Si Seas0nPass no inicia:"
echo "1. Ejecuta: bash /path/to/install.sh"
echo "2. O manualmente: chmod +x /Applications/Seas0nPass.app/Contents/Resources/bin/*"
echo "3. En macOS Tahoe, puede necesitar firma de código:"
echo "   sudo codesign -s - /Applications/Seas0nPass.app/Contents/Resources/bin/*"
echo ""

print_header "Test Completado"
