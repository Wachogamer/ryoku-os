# Ryoku OS Justfile - Contiene utilidades post-instalación

# Configura automáticamente los discos secundarios
setup-mounts:
    #!/usr/bin/env bash
    set -e
    
    echo "=== Creando puntos de montaje en /var/mnt (aka /mnt) ==="
    sudo mkdir -p /var/mnt/JUEGOSM2
    sudo mkdir -p /var/mnt/JUEGOSM2ONLINE
    sudo mkdir -p /var/mnt/JUEGOSYISO
    
    echo "=== Añadiendo entradas a /etc/fstab ==="
    FSTAB=/etc/fstab
    
    add_entry() {
        local line="$1"
        local marker="$2"
        if grep -q "$marker" "$FSTAB"; then
            echo "  [SKIP] Ya existe: $marker"
        else
            echo "$line" | sudo tee -a "$FSTAB" > /dev/null
            echo "  [OK] Añadido: $marker"
        fi
    }
    
    add_entry "UUID=3E3014E93014AA43  /var/mnt/JUEGOSM2       ntfs-3g  uid=1000,gid=1000,umask=0022,nofail,x-systemd.automount,x-systemd.idle-timeout=60  0 0" "3E3014E93014AA43"
    add_entry "UUID=D058BCF158BCD784  /var/mnt/JUEGOSM2ONLINE ntfs-3g  uid=1000,gid=1000,umask=0022,nofail,x-systemd.automount,x-systemd.idle-timeout=60  0 0" "D058BCF158BCD784"
    add_entry "UUID=6ACC6DCDCC6D945B  /var/mnt/JUEGOSYISO     ntfs-3g  uid=1000,gid=1000,umask=0022,nofail,x-systemd.automount,x-systemd.idle-timeout=60  0 0" "6ACC6DCDCC6D945B"
    
    echo "=== Recargando systemd ==="
    sudo systemctl daemon-reload
    
    echo "=== Montando ahora ==="
    sudo mount /var/mnt/JUEGOSM2       && echo "  ✓ JUEGOSM2 montado"       || true
    sudo mount /var/mnt/JUEGOSM2ONLINE && echo "  ✓ JUEGOSM2ONLINE montado" || true
    sudo mount /var/mnt/JUEGOSYISO     && echo "  ✓ JUEGOSYISO montado"     || true
    
    echo "✅ Discos listos."
