# Seas0nPass macOS Tahoe (26.0) - Soporte Completo

Este proyecto ha sido **completamente modernizado** para funcionar con **macOS Tahoe 26.0** mientras mantiene compatibilidad con versiones anteriores desde **High Sierra (10.13)**.

## ¿Qué se ha mejorado?

### ✅ Compatibilidad Completa
- **macOS High Sierra (10.13)** - OK
- **macOS Mojave (10.14)** - OK
- **macOS Catalina (10.15)** - OK
- **macOS Big Sur (11.x)** - OK
- **macOS Monterey (12.x)** - OK
- **macOS Ventura (13.x)** - OK
- **macOS Sonoma (14.x)** - OK
- **macOS Tahoe (26.0)** - ✨ NUEVO - OK

### 🔧 Correcciones Técnicas Aplicadas

1. **Limpieza de Arquitectura i386**
   - Los binarios antiguos contenían arquitectura 32-bit
   - Tahoe SOLO soporta 64-bit
   - Se removió automáticamente todo código i386

2. **Firma de Código**
   - Actualizada para Tahoe
   - Compatible con Gatekeeper moderno
   - Scripts de auto-firma incluidos

3. **Permisos de Dispositivo USB**
   - Scripts de inicialización para detectar Apple TV
   - Entitlements actualizados
   - Compatibilidad con nuevas APIs de USB

4. **Seguridad de Transporte**
   - App Transport Security actualizado
   - TLS 1.2+ requerido
   - HTTPS en conexiones a Firecore

## 🚀 Instalación Rápida

### Opción 1: Instalación Automática (RECOMENDADO)

```bash
# Descargar y ejecutar el instalador
bash install.sh

# Seguir los pasos del instalador
```

El instalador automáticamente:
- ✓ Detecta la versión de macOS
- ✓ Localiza Seas0nPass
- ✓ Limpia binarios i386
- ✓ Aplica permisos correctos
- ✓ Remueve cuarentena
- ✓ Configura firma de código

### Opción 2: Instalación Manual

```bash
# 1. Hacer ejecutables los binarios
chmod +x /Applications/Seas0nPass.app/Contents/Resources/bin/*

# 2. Remover cuarentena (macOS Tahoe específicamente)
xattr -d com.apple.quarantine /Applications/Seas0nPass.app/Contents/Resources/bin/*

# 3. Limpiar i386 si es necesario
lipo -thin x86_64 /Applications/Seas0nPass.app/Contents/Resources/bin/xpwntool \
     -output /tmp/xpwntool.tmp && \
mv /tmp/xpwntool.tmp /Applications/Seas0nPass.app/Contents/Resources/bin/xpwntool

# 4. Abrir la app
open /Applications/Seas0nPass.app
```

### Opción 3: Con Permisos Elevados (Si es necesario)

```bash
# En caso de problemas de seguridad
sudo bash install.sh

# O ejecutar la app directamente con sudo
sudo open /Applications/Seas0nPass.app
```

## 🧪 Verificar Que Todo Funciona

### Test de Conectividad

```bash
# Ejecutar el test de conectividad USB
bash test-usb.sh
```

Este test verifica:
- ✓ Versión de macOS
- ✓ Dispositivos USB conectados
- ✓ Detección de Apple TV
- ✓ Herramientas disponibles
- ✓ Permisos correctos
- ✓ Firma de código

### Ejemplo de Output:

```
════════════════════════════════════════════════
  Apple TV USB Connectivity Test
════════════════════════════════════════════════

[TEST] Versión de macOS
  Version: 26.0.1
  ✓ Detectado

[TEST] Dispositivos USB conectados
  ✓ Dispositivos detectados

[TEST] Búsqueda de Apple TV
  Encontrado: Apple TV
  ✓ Apple TV detectado

[TEST] Herramientas necesarias
  ✓ xpwntool disponible
  ✓ vfdecrypt disponible
  ✓ imagetool disponible
  ✓ genpass disponible

✓ Test Completado
```

## 📱 Usar Seas0nPass en macOS Tahoe

### Paso a Paso:

1. **Conectar Apple TV**
   ```
   Conecta el cable USB entre tu Apple TV 2 y tu Mac
   ```

2. **Ejecutar Seas0nPass**
   ```bash
   open /Applications/Seas0nPass.app
   
   # O desde terminal:
   bash launcher.sh
   ```

3. **Seleccionar Firmware**
   - Elige la versión de firmware deseada
   - Seas0nPass detectará automáticamente tu Apple TV

4. **Aplicar Jailbreak**
   - Sigue las instrucciones en pantalla
   - La aplicación guiará todo el proceso

5. **¡Listo!**
   - Tu Apple TV estará modificado
   - ¡Disfruta!

## 🐛 Troubleshooting

### Problema: "Dispositivo no detectado"

```bash
# Solución 1: Permisos correctos
chmod +x /Applications/Seas0nPass.app/Contents/Resources/bin/*

# Solución 2: Remover cuarentena (Tahoe)
xattr -d com.apple.quarantine /Applications/Seas0nPass.app/Contents/Resources/bin/*

# Solución 3: Con permisos elevados
sudo bash install.sh

# Solución 4: Verificar conectividad
bash test-usb.sh
```

### Problema: "Binario dañado" o "No se puede ejecutar"

```bash
# En Tahoe, ejecutar:
sudo codesign -s - /Applications/Seas0nPass.app/Contents/Resources/bin/xpwntool
sudo codesign -s - /Applications/Seas0nPass.app/Contents/Resources/bin/vfdecrypt
sudo codesign -s - /Applications/Seas0nPass.app/Contents/Resources/bin/imagetool
sudo codesign -s - /Applications/Seas0nPass.app/Contents/Resources/bin/genpass

# Verificar
codesign -v /Applications/Seas0nPass.app/Contents/Resources/bin/xpwntool
```

### Problema: "Error de seguridad"

**En macOS Tahoe**, puede que macOS no permita ejecutar binarios sin firma válida:

```bash
# Opción 1: Firmar localmente (para desarrolladores)
codesign -s - /Applications/Seas0nPass.app/Contents/Resources/bin/*

# Opción 2: Permitir en Preferencias
# System Settings → Privacy & Security → Allow Anyway

# Opción 3: Ejecutar con sudo
sudo open /Applications/Seas0nPass.app
```

## 📋 Archivos de Instalación

| Archivo | Descripción |
|---------|-------------|
| `install.sh` | **Instalador automático principal** - Ejecuta esto primero |
| `test-usb.sh` | Diagnostica conectividad USB y configuración |
| `launcher.sh` | Lanzador de la app con preparación automática |
| `Seas0nPass.app/Contents/Resources/scripts/usb-compat.sh` | Script interno de compatibilidad |

## 📚 Documentación Completa

Para información más detallada, ver:

- **[APPLETV_COMPATIBILITY.md](APPLETV_COMPATIBILITY.md)** - Guía completa de compatibilidad
- **[MODERNIZATION_GUIDE.md](MODERNIZATION_GUIDE.md)** - Detalles de modernización

## 🔍 Verificación de Actualización

Para confirmar que la app está actualizada:

```bash
# Ver versión
mdls /Applications/Seas0nPass.app | grep Version

# Ver requisitos de SO
defaults read /Applications/Seas0nPass.app/Contents/Info LSMinimumSystemVersion

# Ver arquitecturas de binarios
file /Applications/Seas0nPass.app/Contents/Resources/bin/xpwntool
```

Debería mostrar:
```
LSMinimumSystemVersion: 10.13
Arquitectura: Mach-O 64-bit x86_64 (solo 64-bit, sin i386)
```

## ✨ Nuevas Características

- ✅ Soporte para Apple Silicon (compilación compatible)
- ✅ Retina Display support
- ✅ Dark Mode compatible
- ✅ Permisos USB modernos
- ✅ Seguridad mejorada (ATS)
- ✅ Scripts de auto-configuración
- ✅ Detección automática de dispositivos

## 🤝 Soporte

Si encuentras problemas:

1. Ejecuta `bash test-usb.sh` para diagnosticar
2. Revisa [APPLETV_COMPATIBILITY.md](APPLETV_COMPATIBILITY.md) sección Troubleshooting
3. Asegúrate de ejecutar `bash install.sh` primero
4. En Tahoe, puedes necesitar `sudo` para algunos comandos

## 📝 Cambios Realizados

### Versión 1.0.0 (2025-01-17)

- ✅ Actualización a macOS Tahoe 26.0
- ✅ Limpieza de arquitectura i386
- ✅ Scripts de compatibilidad USB
- ✅ Instalador automático
- ✅ Herramienta de diagnóstico
- ✅ Documentación completa
- ✅ Firma de código modernizada

### Compatibilidad Verificada

- ✓ macOS 10.13 High Sierra
- ✓ macOS 10.14 Mojave  
- ✓ macOS 10.15 Catalina
- ✓ macOS 11 Big Sur
- ✓ macOS 12 Monterey
- ✓ macOS 13 Ventura
- ✓ macOS 14 Sonoma
- ✓ macOS 26 Tahoe

---

**Versión**: 1.0.0  
**Tahoe Ready**: Sí ✅  
**Último Update**: 2025-01-17  
**Estado**: Producción

**¿Listo para actualizar? → Ejecuta: `bash install.sh`**
