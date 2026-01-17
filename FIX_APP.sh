#!/bin/bash

# Reparación rápida de Seas0nPass - Ejecutar esto si la app no abre

echo "🔧 Reparando Seas0nPass..."
echo ""

# Directorio de la app
APP_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/Seas0nPass.app/Contents" && pwd)"

if [ ! -d "$APP_DIR" ]; then
    echo "❌ Seas0nPass.app no encontrado"
    exit 1
fi

echo "📁 Directorio: $APP_DIR"
echo ""

# 1. Permisos del ejecutable principal
echo "1. Reparando permisos..."
chmod +x "$APP_DIR/MacOS/Seas0nPass"
chmod +x "$APP_DIR/Resources/bin"/* 2>/dev/null
chmod +x "$APP_DIR/Resources/scripts"/*.sh 2>/dev/null
echo "   ✅ Permisos aplicados"

# 2. Remover cuarentena
echo "2. Removiendo restricciones de seguridad..."
xattr -d com.apple.quarantine "$APP_DIR/MacOS/Seas0nPass" 2>/dev/null || true
find "$APP_DIR/Resources/bin" -type f -exec xattr -d com.apple.quarantine {} \; 2>/dev/null || true
echo "   ✅ Restricciones removidas"

# 3. Verificación
echo ""
echo "✅ VERIFICACIÓN"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

if [ -x "$APP_DIR/MacOS/Seas0nPass" ]; then
    echo "✓ Ejecutable principal: OK"
else
    echo "✗ Ejecutable principal: ERROR"
    exit 1
fi

BINS_OK=0
for bin in xpwntool vfdecrypt imagetool genpass; do
    if [ -x "$APP_DIR/Resources/bin/$bin" ]; then
        BINS_OK=$((BINS_OK + 1))
    fi
done

echo "✓ Binarios ejecutables: $BINS_OK/4"

echo ""
echo "🎉 REPARACIÓN COMPLETADA"
echo ""
echo "Ahora puedes abrir:"
echo "  open '$(dirname "$APP_DIR")/Seas0nPass.app'"
echo ""
