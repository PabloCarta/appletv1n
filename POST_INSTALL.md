# POST-INSTALACIÓN - Seas0nPass macOS Tahoe

Después de ejecutar `install.sh`, sigue estas instrucciones para asegurar máxima compatibilidad.

## ✅ Checklist Post-Instalación

### 1. Verificar Instalación

```bash
# Ejecutar test de conectividad
bash test-usb.sh

# Todos los tests deben pasar: ✓
```

### 2. Conectar Apple TV

```bash
# Asegúrate de que:
- [ ] Apple TV 2 está conectado al Mac con cable USB
- [ ] El cable USB es de buena calidad (no dañado)
- [ ] El puerto USB del Mac es accesible
- [ ] El Apple TV está encendido
```

### 3. Lanzar la Aplicación

#### Método 1: Interfaz Gráfica (Más Fácil)
```bash
# Simplemente abre la aplicación desde Finder:
# Applications → Seas0nPass → Abre
```

#### Método 2: Terminal (Con Feedback)
```bash
# Ejecutar con feedback detallado
bash launcher.sh

# Y luego abrir la app
open /Applications/Seas0nPass.app
```

#### Método 3: Terminal Avanzado (Para Diagnosticar)
```bash
# Ejecutar con logs detallados
VERBOSE=1 open /Applications/Seas0nPass.app
```

### 4. Si no Detecta el Apple TV

Ejecutar en orden hasta que funcione:

```bash
# Paso 1: Verificar conectividad
bash test-usb.sh

# Paso 2: Permisos básicos
chmod +x /Applications/Seas0nPass.app/Contents/Resources/bin/*

# Paso 3: Remover cuarentena
xattr -d com.apple.quarantine /Applications/Seas0nPass.app/Contents/Resources/bin/*

# Paso 4: Re-ejecutar instalador
bash install.sh

# Paso 5: Con permisos elevados (última opción)
sudo bash install.sh
```

### 5. Si Tahoe Rechaza los Binarios

macOS Tahoe es muy estricto con seguridad. Si aparece "No se puede ejecutar":

```bash
# Opción A: Auto-firmar los binarios (Recomendado)
BIN_DIR="/Applications/Seas0nPass.app/Contents/Resources/bin"
for bin in xpwntool vfdecrypt imagetool genpass; do
    codesign -s - "$BIN_DIR/$bin"
done

# Verificar
codesign -v "$BIN_DIR/xpwntool"
```

```bash
# Opción B: Ejecutar app con permisos elevados
sudo open /Applications/Seas0nPass.app
```

```bash
# Opción C: Permitir en Preferencias
# 1. Abre: System Settings → Privacy & Security
# 2. Busca "Seas0nPass"
# 3. Click en "Allow anyway"
# 4. Intenta de nuevo
```

## 🔧 Configuración Avanzada

### Para Máxima Compatibilidad

```bash
# 1. Limpiar todo primero
bash install.sh --clean

# 2. Aplicar permisos máximos
sudo bash install.sh --force

# 3. Verificar todo
bash test-usb.sh

# 4. Ejecutar
sudo open /Applications/Seas0nPass.app
```

### Para Usuarios de Apple Silicon

Si tienes un Mac con Apple Silicon (M1/M2/M3):

```bash
# Verificar si hay arquitectura ARM
file /Applications/Seas0nPass.app/Contents/Resources/bin/xpwntool

# Si muestra "arm64", ya está soportado
# Si no, la app usará Rosetta (emulación x86_64)

# Verificar performance
# Seas0nPass debería ejecutarse sin problemas en ambos casos
```

## 📊 Verificación Completa

Ejecutar este script para verificación completa:

```bash
#!/bin/bash
echo "Verificación Completa de Seas0nPass"
echo "===================================="

# 1. Archivo de la app
echo "1. Estructura de la app:"
[ -d /Applications/Seas0nPass.app ] && echo "   ✓ App encontrada" || echo "   ✗ App no encontrada"

# 2. Binarios
echo "2. Binarios disponibles:"
for bin in xpwntool vfdecrypt imagetool genpass; do
    [ -x "/Applications/Seas0nPass.app/Contents/Resources/bin/$bin" ] \
        && echo "   ✓ $bin" \
        || echo "   ✗ $bin"
done

# 3. Permisos
echo "3. Permisos correctos:"
[ -x "/Applications/Seas0nPass.app/Contents/Resources/bin/xpwntool" ] \
    && echo "   ✓ Ejecutables" \
    || echo "   ✗ Falta hacer ejecutables"

# 4. Apple TV
echo "4. Apple TV conectado:"
system_profiler SPUSBDataType 2>/dev/null | grep -q -i "apple" \
    && echo "   ✓ Detectado" \
    || echo "   ✗ No detectado"

echo ""
echo "Fin de verificación"
```

## 🆘 Problemas Comunes en Tahoe

### Problema: "El archivo no se puede abrir"

**Causa**: Binarios sin firma en Tahoe

**Solución**:
```bash
# Opción 1: Auto-firmar
codesign -s - /Applications/Seas0nPass.app/Contents/Resources/bin/*

# Opción 2: Ejecutar con sudo
sudo open /Applications/Seas0nPass.app

# Opción 3: Permitir en Preferencias (menos seguro)
# Ve a System Settings → Privacy & Security → App Manage
```

### Problema: "Permiso denegado"

**Causa**: Archivos sin permisos de ejecución

**Solución**:
```bash
chmod +x /Applications/Seas0nPass.app/Contents/Resources/bin/*
bash install.sh
```

### Problema: "Dispositivo no se detecta"

**Causa**: Cable USB defectuoso o driver problemático

**Solución**:
```bash
# 1. Prueba con otro cable USB
# 2. Reinicia tanto el Mac como el Apple TV
# 3. Ejecuta:
bash test-usb.sh

# 4. Si sigue sin funcionar:
sudo bash install.sh
```

### Problema: "Error durante jailbreak"

**Causa**: Dispositivo USB desconectado o timeout

**Solución**:
```bash
# 1. Verifica que el cable está bien conectado
# 2. Usa un hub USB de buena calidad (no adaptadores)
# 3. Intenta con otro puerto USB
# 4. Reinicia la app y vuelve a intentar
```

## 📱 Flujo Normal de Uso

1. **Conectar Apple TV**
   ```
   Enchufa el cable USB al Apple TV y al Mac
   ```

2. **Abrir Seas0nPass**
   ```bash
   open /Applications/Seas0nPass.app
   ```

3. **Seleccionar Firmware**
   - Elige la versión que deseas
   - (Seas0nPass detectará automáticamente tu Apple TV)

4. **Aplicar Jailbreak**
   - Sigue las instrucciones en pantalla
   - Cuando se pida, selecciona tus opciones
   - La app hará todo automáticamente

5. **¡Completado!**
   - Tu Apple TV está modificado
   - Puedes desconectar

## 🎯 Diferencias con Versiones Anteriores

En macOS Tahoe, algunos cambios importantes:

| Aspecto | Antes | Ahora |
|--------|-------|-------|
| Binarios 32-bit | Soportados | ❌ NO (removidos) |
| Firma de código | Opcional | ✅ Requerida |
| TLS mínimo | 1.0 | ✅ 1.2+ |
| Permisos USB | Automático | ✅ Configurado |
| Dark Mode | No | ✅ Soportado |

## 📞 Soporte

Si nada funciona:

1. **Ejecuta diagnóstico**
   ```bash
   bash test-usb.sh > diagnostico.txt
   cat diagnostico.txt
   ```

2. **Revisa logs del sistema**
   ```bash
   log show --predicate 'process == "Seas0nPass"' --last 1h
   ```

3. **Intenta instalación limpia**
   ```bash
   sudo bash install.sh --clean
   ```

4. **Contacta soporte**
   - Incluye el archivo `diagnostico.txt`
   - Especifica tu versión de macOS
   - Describe el error exacto

---

**¿Tienes problemas?**  
Ejecuta: `bash test-usb.sh` → Revisa la sección Troubleshooting arriba → Intenta la solución correspondiente

**¿Todo funciona?**  
¡Disfruta tu jailbreak! 🎉
