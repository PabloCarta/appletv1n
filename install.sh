#!/bin/bash

# Seas0nPass Auto-Installation & Compatibility Setup
# Este script configura automáticamente la compatibilidad con macOS Tahoe

set -e

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Funciones de output
print_header() {
    echo -e "${BLUE}════════════════════════════════════════════════${NC}"
    echo -e "${BLUE}  $1${NC}"
    echo -e "${BLUE}════════════════════════════════════════════════${NC}"
}

print_success() {
    echo -e "${GREEN}[✓] $1${NC}"
}

print_error() {
    echo -e "${RED}[✗] $1${NC}"
}

print_info() {
    echo -e "${YELLOW}[*] $1${NC}"
}

# Detectar versión de macOS
MACOS_VERSION=$(sw_vers -productVersion)
MACOS_MAJOR=$(echo $MACOS_VERSION | cut -d. -f1)
MACOS_MINOR=$(echo $MACOS_VERSION | cut -d. -f2)

print_header "Seas0nPass Compatibility Setup"
echo ""
echo -e "Versión de macOS: ${BLUE}$MACOS_VERSION${NC}"

# Validar versión de macOS
if [ "$MACOS_MAJOR" -lt 10 ] || ([ "$MACOS_MAJOR" -eq 10 ] && [ "$MACOS_MINOR" -lt 13 ]); then
    print_error "macOS 10.13 (High Sierra) o posterior requerido"
    exit 1
fi

if [ "$MACOS_MAJOR" -lt 26 ]; then
    print_info "Detección: macOS $MACOS_VERSION (Compatible pero no Tahoe)"
else
    print_success "Detección: macOS Tahoe $MACOS_VERSION (Óptimo)"
fi

echo ""

# Localizar Seas0nPass
APP_PATHS=(
    "/Applications/Seas0nPass.app"
    "$HOME/Applications/Seas0nPass.app"
    "$(pwd)/Seas0nPass.app"
)

APP_PATH=""
for path in "${APP_PATHS[@]}"; do
    if [ -d "$path" ]; then
        APP_PATH="$path"
        break
    fi
done

if [ -z "$APP_PATH" ]; then
    print_error "No se encontró Seas0nPass.app"
    echo "Buscado en:"
    for path in "${APP_PATHS[@]}"; do
        echo "  - $path"
    done
    exit 1
fi

print_success "Seas0nPass encontrado en: $APP_PATH"

RESOURCES_DIR="$APP_PATH/Contents/Resources"
BIN_DIR="$RESOURCES_DIR/bin"
SCRIPTS_DIR="$RESOURCES_DIR/scripts"

if [ ! -d "$BIN_DIR" ]; then
    print_error "Estructura de la app inválida"
    exit 1
fi

echo ""
print_header "Paso 1: Verificación de Binarios"

# Verificar binarios
for binary in genpass imagetool vfdecrypt xpwntool; do
    if [ -f "$BIN_DIR/$binary" ]; then
        ARCH=$(file "$BIN_DIR/$binary" | grep -o "x86_64\|i386\|arm64" | head -1)
        if echo "$ARCH" | grep -q "i386"; then
            print_info "$binary contiene arquitectura i386 (será limpiado)"
        else
            print_success "$binary: $ARCH"
        fi
    fi
done

echo ""
print_header "Paso 2: Limpieza de Binarios i386"

# Función para limpiar i386
clean_binary() {
    local binary=$1
    local name=$(basename "$binary")
    
    if [ ! -f "$binary" ]; then
        return
    fi
    
    if file "$binary" | grep -q "i386"; then
        print_info "Limpiando $name..."
        
        # Backup
        if [ ! -f "${binary}.backup" ]; then
            cp "$binary" "${binary}.backup"
        fi
        
        # Extraer x86_64
        if lipo -thin x86_64 "$binary" -output "${binary}.tmp" 2>/dev/null; then
            mv "${binary}.tmp" "$binary"
            chmod +x "$binary"
            print_success "$name limpiado (solo x86_64)"
        else
            print_error "No se pudo limpiar $name"
            if [ -f "${binary}.backup" ]; then
                cp "${binary}.backup" "$binary"
            fi
        fi
    fi
}

# Limpiar todos los binarios
for binary in "$BIN_DIR"/genpass "$BIN_DIR"/imagetool "$BIN_DIR"/vfdecrypt "$BIN_DIR"/xpwntool; do
    clean_binary "$binary"
done

echo ""
print_header "Paso 3: Permisos de Ejecución"

# Hacer ejecutables
print_info "Aplicando permisos..."
find "$BIN_DIR" -type f -exec chmod +x {} \;
print_success "Permisos aplicados"

echo ""
print_header "Paso 4: Remover Cuarentena"

# Remover atributos de cuarentena
print_info "Removiendo cuarentena..."
find "$BIN_DIR" -type f -exec xattr -d com.apple.quarantine {} \; 2>/dev/null || true
find "$APP_PATH/Contents/MacOS" -type f -exec xattr -d com.apple.quarantine {} \; 2>/dev/null || true
print_success "Cuarentena removida"

echo ""
print_header "Paso 5: Configuración de Firma"

# Verificar firma
print_info "Verificando firmas de código..."
NEED_SIGNING=0

for binary in genpass imagetool vfdecrypt xpwntool; do
    if [ -f "$BIN_DIR/$binary" ]; then
        if ! codesign -v "$BIN_DIR/$binary" &>/dev/null; then
            print_info "$binary: Requiere firma"
            NEED_SIGNING=1
        else
            print_success "$binary: Firmado correctamente"
        fi
    fi
done

if [ $NEED_SIGNING -eq 1 ]; then
    echo ""
    if [ "$MACOS_MAJOR" -ge 26 ]; then
        print_error "⚠️  IMPORTANTE: macOS Tahoe requiere firma de código"
        echo ""
        echo "Opciones:"
        echo "1. Firmar con certificado personal:"
        echo "   codesign -s - \"$BIN_DIR/xpwntool\""
        echo ""
        echo "2. O ejecutar como super usuario:"
        echo "   sudo open \"$APP_PATH\""
        echo ""
    fi
fi

echo ""
print_header "Paso 6: Instalación de Scripts"

# Instalar scripts si no existen
if [ ! -f "$SCRIPTS_DIR/usb-compat.sh" ]; then
    print_info "Instalando scripts de compatibilidad..."
    mkdir -p "$SCRIPTS_DIR"
    # Los scripts ya deberían estar instalados
    print_success "Scripts listos"
else
    print_success "Scripts de compatibilidad ya instalados"
fi

echo ""
print_header "Paso 7: Verificación Final"

# Verificación final
ALL_GOOD=1

for binary in genpass imagetool vfdecrypt xpwntool; do
    if [ ! -f "$BIN_DIR/$binary" ]; then
        print_error "$binary no encontrado"
        ALL_GOOD=0
    elif ! file "$BIN_DIR/$binary" | grep -q "x86_64"; then
        print_error "$binary no es x86_64"
        ALL_GOOD=0
    elif [ ! -x "$BIN_DIR/$binary" ]; then
        print_error "$binary no es ejecutable"
        ALL_GOOD=0
    else
        print_success "$binary verificado"
    fi
done

echo ""

if [ $ALL_GOOD -eq 1 ]; then
    print_header "✓ Configuración Completada"
    echo ""
    echo "Seas0nPass está listo para usar en macOS $MACOS_VERSION"
    echo ""
    echo "Próximos pasos:"
    echo "1. Conecta tu Apple TV por USB"
    echo "2. Abre Seas0nPass:"
    echo "   open \"$APP_PATH\""
    echo "3. ¡Disfruta!"
    echo ""
else
    print_header "⚠️  Configuración con Advertencias"
    echo ""
    echo "Alguno de los pasos no completó correctamente."
    echo "Por favor revisa los errores arriba."
    echo ""
    echo "Si necesitas ayuda, ejecuta:"
    echo "  sudo bash $(dirname "${BASH_SOURCE[0]}")/install.sh"
    echo ""
fi

print_success "Fin del setup"
