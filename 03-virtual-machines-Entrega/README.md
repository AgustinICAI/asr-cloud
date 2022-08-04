
Crear una máquina expuesta directamente a internet es un gran problema de seguridad. Algunas reglas de seguridad que vamos a aplicar en esta práctica son:
- Regla del mínimo privilegio.
- Exponer únicamente lo mínimo imprescindible a internet.
- Usar siempre tráfico cifrado (siempre en internet)
- Usar siempre un doble salto para un acceso a un servidor si este está expuesto a internet


Partiendo de la práctica 1, la versión desplegada en Google, es necesario realizar las siguientes evoluciones (por cada punto adjuntar evidencia en un documento PDF)
## 1a Solución  - 5 puntos
- Exponer únicamente nuestra máquina a la ip pública por la que salimos a internet.
- Convertir el tráfico de nuestro servidor NGINX para que trabaje únicamente por https.

## 2da Solución - 4 puntos
- Convertir nuestra máquina para que no tenga ip pública, y montar un balanceador con servicio de WAF haciendo HTTPS offloading. ¿Qué ventajas e incovenientes tiene hacer https offloading en el balanceador?
- Proteger nuestra máquina de ataques SQL Injection, Cross Syte Scripting y restringir el tráfico sólo a paises de confianza de la UE.

## 3ra solución - 1 punto
¿Qué otras mejoras se te ocurrirían? (No hace falta implementarlas)
