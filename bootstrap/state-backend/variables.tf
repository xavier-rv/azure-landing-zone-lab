variable "location" {
  description = "Región de Azure donde se crean los recursos."
  type        = string
  default     = "swedencentral"
}

variable "location_short" {
  description = "Abreviatura de la región para los nombres de recursos."
  type        = string
  default     = "swc"
}

variable "workload" {
  description = "Prefijo corto de la carga de trabajo, usado en los nombres."
  type        = string
  default     = "alz"
}

variable "tags" {
  description = "Etiquetas obligatorias aplicadas a todos los recursos."
  type        = map(string)
  default = {
    owner       = "xavier-rv"
    environment = "lab"
    cost-center = "cc-portfolio-lab"
  }
}
