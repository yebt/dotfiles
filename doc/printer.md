# Printer

CPUS is the manage to control this

```sh
sudo dnf install cups
sudo systemctl enable --now cups
```

Add users to sudo list

```sh
sudo usermod -aG sys tu_usuario
sudo usermod -aG lpadmin tu_usuario
```
