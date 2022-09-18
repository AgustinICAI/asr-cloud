## Ansible VS Terraform

Ansible hace un muy buen trabajo de aprovisionamiento y administración de la infraestructura. Pero hay herramientas como Terraform, que también hace un gran trabajo en el aprovisionamiento de infraestructura, ya que funciona con "states", por lo que es fácil de revertir la infraestructura a estados anteriores.

Por lo tanto, la forma recomendada es trabajar tanto Terraform como Ansible. Terraform para el aprovisionamiento de infraestructura y Ansible para la gestión de la configuración (instalar aplicaciones, parchear los sistemas, actualizar el software, etc.). 

NO se trata de "Ansible vs Terraform" sino de "Ansible y Terraform"
