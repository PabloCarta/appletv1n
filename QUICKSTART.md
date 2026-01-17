# ⚡ INICIO RÁPIDO - Seas0nPass Tahoe

## 🎯 En 3 Pasos

### Paso 1: Instalar (1 minuto)
```bash
bash install.sh
```

### Paso 2: Verificar (1 minuto)
```bash
bash test-usb.sh
```

### Paso 3: Usar (1 minuto)
```bash
open /Applications/Seas0nPass.app
```

---

## ✅ Si Todo Funciona

Conecta tu Apple TV y disfruta del jailbreak ✨

---

## ❌ Si Hay Problemas

### Opción 1: Ejecutar con permisos elevados
```bash
sudo bash install.sh
```

### Opción 2: Limpiar y reinstalar
```bash
sudo bash install.sh
bash test-usb.sh
sudo open /Applications/Seas0nPass.app
```

### Opción 3: Leer guía completa
Ver: [README_TAHOE.md](README_TAHOE.md)

---

## 📚 Documentación

| Archivo | Propósito |
|---------|-----------|
| [README_TAHOE.md](README_TAHOE.md) | **EMPEZAR AQUÍ** - Guía completa |
| [APPLETV_COMPATIBILITY.md](APPLETV_COMPATIBILITY.md) | Troubleshooting técnico |
| [POST_INSTALL.md](POST_INSTALL.md) | Después de instalar |
| [CHANGES_SUMMARY.md](CHANGES_SUMMARY.md) | Qué cambió |

---

## 🆘 Soporte Rápido

**¿Apple TV no se detecta?**
```bash
chmod +x /Applications/Seas0nPass.app/Contents/Resources/bin/*
xattr -d com.apple.quarantine /Applications/Seas0nPass.app/Contents/Resources/bin/*
```

**¿"Binario dañado" en Tahoe?**
```bash
codesign -s - /Applications/Seas0nPass.app/Contents/Resources/bin/xpwntool
codesign -s - /Applications/Seas0nPass.app/Contents/Resources/bin/vfdecrypt
codesign -s - /Applications/Seas0nPass.app/Contents/Resources/bin/imagetool
codesign -s - /Applications/Seas0nPass.app/Contents/Resources/bin/genpass
```

**¿Permiso denegado?**
```bash
sudo bash install.sh
```

---

**¿Listo?** → `bash install.sh`

**¿Problemas?** → Ver [README_TAHOE.md](README_TAHOE.md) sección "Troubleshooting"
