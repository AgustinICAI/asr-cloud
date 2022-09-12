
Crear una máquina expuesta directamente a internet es un gran problema de seguridad. Algunas reglas de seguridad que vamos a aplicar en esta práctica son:
- Regla del mínimo privilegio.
- Exponer únicamente lo mínimo imprescindible a internet.
- Usar siempre tráfico cifrado (siempre en internet)
- Usar siempre un doble salto para un acceso a un servidor si este está expuesto a internet


Partiendo de la práctica 1, la versión desplegada en Google, es necesario realizar las siguientes evoluciones (por cada punto adjuntar evidencia en un documento PDF)
## 1a Solución  - 4 puntos
- Exponer únicamente en el servidor web lo mínimo indispensable
- Montar una máquina de salto para poder acceder a nuestra máquina. Esta máquina se debería encender y apagar cada vez que se quiera modificar algo del servidor web.

## 2da mejora solución - 4 puntos
- Convertir nuestra máquina para que no tenga ip pública, y montar un balanceador con servicio de WAF haciendo HTTPS offloading. ¿Qué ventajas e incovenientes tiene hacer https offloading en el balanceador? ¿Qué pasos adicionales has tenido que hacer para que la máquina pueda salir a internet para poder instalar el servidor nginx?
- Proteger nuestra máquina de ataques SQL Injection, Cross Syte Scripting y restringir el tráfico sólo a paises de confianza de la UE implantando un WAF a nuestro balanceador.

## 3ra mejora solución - 1 punto
- Cifrar el contenido web también dentro del cloud y quitar el HTTPS offloading.

## 4ta mejora solución - 1 punto
¿Qué otras mejoras se te ocurrirían para mejorar la seguridad o disponibilidad del servidor web? (No hace falta implementarlas)
