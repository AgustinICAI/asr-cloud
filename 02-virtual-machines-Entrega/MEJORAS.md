#MEJORAS
- Meter más reglas para distintos tipos de ataques
- Implantación CDN: cacheo y distribución de la carga en zonas más cercanas al usuario.
- Servidores en standby en otra zona. Para ello hará falta discos probablemente multiregionales.
- Servidores en HA zonal o global
- Limitar conexiones simultaneas al servidor en el balanceador
- Meter autenticación al servidor
- Usar logging y meter alertas en caso de problemas de rendimiento (volumen poco o mucho, tiempo de respuesta y volumen de errores) o seguridad
- implantar recaptcha
- Implantar nuestra web con contenedores
- Limitar versiones TLS y SSL
- Backup de discos controlados
- Añadir protección DDoS
- Ajustar a la IP origen la máquina de salto incluso apagarla cuando no se use
- Usar grupos de escalado automático de máquinas con Autohealing
- Uso de IAP o OSLOGIN
- Uso de servidores Honeypoot.
- Implantación de VPNs
- Revisar ciclo de parcheado de la aplicación y S.0.

## Otras mejoras que se le ocurrieron al profe no dichas antes
- Implantación de modelos de CICD y IaC para la configuración del servidor NGINX mediante el uso de playbooks de Ansible.
- No usar Cloud NAT y hacer la instalación de la paquetería movimiendo los artefactos.
- Cambiar a una solución PaaS
- Cambiar a una solución SaaS

