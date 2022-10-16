## PRUEBAS DE CARGA CON HERRAMIENTAS

Vamos a avanzar un poco más en las pruebas de rendimiento. Antes de nada, vamos a parar el bucle infinito anterior de busybox. 

Vamos a lanzar ahora unas pruebas de rendimiento controladas. Estas son algunas de las 3 herramientas existentes para lanzar pruebas de rendimiento:
- JMETER (6500 ★ en github) basada en java, tiene múltiples plugins lo que permite casi probar y medir rendimiento de infinidad de tecnologías. Basado en un nodo master que hace de servidor y nodos slaves que lanzan las pruebas de rendimiento. Los escenarios se pueden configurar mediante clicks en el nodo servidor, o evolucionar escribiéndolos en groovy.
- Locust (20.000 ★ en github): supone una evolución, está basado en eventos en vez de hilos y las pruebas de rendimiento son programadas en python. El consumo de recursos es de un 70% menos.
- Artillery (6.000 ★ en github): herramienta muy sencilla, la cual a partir de un fichero yaml lanza el escenario definido.
 [Artillery](https://www.artillery.io/docs/guides/guides/http-reference)
- Apachebench (desde 1996): fue de las primeras herramientas para lanzar pruebas de carga. Está basada en el cliente "ab", el cual permite de forma cómoda lanzar peticiones rest. Si lanzaramos ab desde local, tendría esta forma.	
```bash
# Esto lanzará 10000 peticiones HTTP, desde 10 hilos a la url especificada.
ab -n 10000 -c 10 "http://localhost/index.html"
```




