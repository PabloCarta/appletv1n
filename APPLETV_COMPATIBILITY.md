# Seas0nPass - Guía de Compatibilidad macOS Tahoe (26.0)

## Problema Identificado

macOS Tahoe rechaza los binarios antiguos porque:

1. **Contienen arquitectura i386 (32-bit)**: Tahoe solo soporta 64-bit
2. **No tienen firma de código válida**: Requerido desde Big Sur
3. **Atributos de cuarentena**: Necesitan ser removidos
4. **Permisos USB antiguos**: Los drivers de USB han cambiado

## Solución Implementada

### 1. Actualización de Info.plist
```
✓ DTPlatformVersion: 26.0
✓ DTSDKName: macosx26.0
✓ Xcode: 17.0 compatible
```

### 2. Scripts de Compatibilidad

#### usb-compat.sh
Ejecutado automáticamente al lanzar la app para:
- Remover arquitectura i386 de binarios universales
- Aplicar entitlements de dispositivo USB
- Corregir firmas de código corrupta

#### launcher.sh
Wrapper que prepara el entorno:
- Asegura permisos ejecutables
- Limpia atributos de cuarentena
- Detecta dispositivos Apple TV conectados

## Instalación y Uso

### Opción 1: Ejecución Automática (Recomendado)

```bash
# Hacer ejecutable el launcher
chmod +x /path/to/Seas0nPass.app/Contents/Resources/scripts/usb-compat.sh

# Los scripts se ejecutarán automáticamente al abrir la app
```

### Opción 2: Ejecución Manual

```bash
# Ejecutar script de compatibilidad
bash "/Applications/Seas0nPass.app/Contents/Resources/scripts/usb-compat.sh"

# Ejecutar launcher
bash /path/to/launcher.sh
```

### Opción 3: Con Permisos Elevados (Si es necesario)

```bash
# En caso de problemas de permisos
sudo bash "/Applications/Seas0nPass.app/Contents/Resources/scripts/usb-compat.sh"
```

## Pasos para Conectar Apple TV

### En macOS Tahoe:

1. **Conectar Apple TV por USB**
   ```
   Conecta el cable USB-A a Apple TV 2 y a tu Mac
   ```

2. **Ejecutar Seas0nPass**
   ```bash
   open /Applications/Seas0nPass.app
   ```

3. **Verificar Detección**
   - La app debería detectar automáticamente el dispositivo
   - Si no, ver sección "Troubleshooting" abajo

4. **Proceder Como Normal**
   - Seleccionar firmware
   - Aplicar jailbreak
   - Listo!

## Troubleshooting

### Problema: "Dispositivo no detectado"

**Causa**: Permisos de dispositivo insuficientes

**Solución**:
```bash
# 1. Permitir permisos al primer uso
defaults write com.firecore.Seas0nPass NSUbiquitousContainers -bool YES

# 2. O ejecutar con permisos elevados:
sudo open /Applications/Seas0nPass.app

# 3. O dar permisos manualmente a los binarios:
cd /Applications/Seas0nPass.app/Contents/Resources/bin
chmod +x genpass imagetool vfdecrypt xpwntool
```

### Problema: "No se puede ejecutar" o "Binario dañado"

**Causa**: Firma de código faltante en Tahoe

**Solución**:
```bash
# Remover cuarentena
xattr -d com.apple.quarantine /Applications/Seas0nPass.app/Contents/Resources/bin/xpwntool
xattr -d com.apple.quarantine /Applications/Seas0nPass.app/Contents/Resources/bin/vfdecrypt
xattr -d com.apple.quarantine /Applications/Seas0nPass.app/Contents/Resources/bin/imagetool
xattr -d com.apple.quarantine /Applications/Seas0nPass.app/Contents/Resources/bin/genpass

# Hacer ejecutables
chmod +x /Applications/Seas0nPass.app/Contents/Resources/bin/*

# Ejecutar de nuevo
open /Applications/Seas0nPass.app
```

### Problema: "Error de seguridad" o "No verificable"

**Causa**: macOS rechaza binarios sin firma en Tahoe

**Solución 1 - Para usuarios sin acceso a Xcode**:
```bash
# Permitir temporalmente en preferencias
# System Settings → Privacy & Security → Allow anyway

# Y ejecutar:
sudo bash /path/to/launcher.sh
```

**Solución 2 - Para desarrolladores**:
```bash
# Firmar los binarios con tu certificado de desarrollo
codesign -s - /Applications/Seas0nPass.app/Contents/Resources/bin/xpwntool
codesign -s - /Applications/Seas0nPass.app/Contents/Resources/bin/vfdecrypt
codesign -s - /Applications/Seas0nPass.app/Contents/Resources/bin/imagetool
codesign -s - /Applications/Seas0nPass.app/Contents/Resources/bin/genpass

# Verificar
codesign -v /Applications/Seas0nPass.app/Contents/Resources/bin/xpwntool
```

## Verificación de Compatibilidad

### Verificar versión de macOS
```bash
sw_vers -productVersion
# Debe mostrar 26.x o superior para Tahoe
```

### Verificar binarios
```bash
# Ver arquitecturas de los binarios
file /Applications/Seas0nPass.app/Contents/Resources/bin/xpwntool

# Debería mostrar solo x86_64, no i386
```

### Verificar firma de código
```bash
codesign -v /Applications/Seas0nPass.app/Contents/Resources/bin/xpwntool

# En Tahoe, requerirá firma válida
```

### Verificar permisos USB
```bash
# Listar dispositivos USB
system_profiler SPUSBDataType

# Verificar si Apple TV aparece
```

## Limpieza Manual de Binarios i386

Si los scripts no funcionan, puede hacer limpieza manual:

```bash
# Backup primero
cp /Applications/Seas0nPass.app/Contents/Resources/bin/xpwntool{,.backup}

# Extraer solo x86_64
lipo -thin x86_64 /Applications/Seas0nPass.app/Contents/Resources/bin/xpwntool \
     -output /Applications/Seas0nPass.app/Contents/Resources/bin/xpwntool.x86_64

# Reemplazar
mv /Applications/Seas0nPass.app/Contents/Resources/bin/xpwntool.x86_64 \
   /Applications/Seas0nPass.app/Contents/Resources/bin/xpwntool

# Hacer ejecutable
chmod +x /Applications/Seas0nPass.app/Contents/Resources/bin/xpwntool

# Remover cuarentena
xattr -d com.apple.quarantine /Applications/Seas0nPass.app/Contents/Resources/bin/xpwntool
```

Repetir para: vfdecrypt, imagetool, genpass

## Verificación Final

Después de aplicar soluciones:

```bash
# Ejecutar script de compatibilidad
bash /path/to/launcher.sh

# Verificar que no haya errores
# Conectar Apple TV
# Ejecutar Seas0nPass

# Si funciona, listo! 🎉
```

## Información del Sistema

La app ahora soporta:

| Componente | Versión |
|-----------|---------|
| macOS Mínimo | 10.13 (High Sierra) |
| macOS Máximo | 26.0+ (Tahoe) |
| SDK | macOS 26.0 |
| Xcode | 17.0+ |
| Arquitectura | x86_64 + Apple Silicon |

## Contacto y Soporte

Para problemas adicionales:
- Verificar los logs: `Console.app` → Sistema
- Revisar permisos: `Privacy & Security` → Extensiones
- Contactar: https://files.firecore.com

---
**Guía Versión**: 2.0  
**macOS Tahoe**: 26.0  
**Actualizado**: 2025-01-17
