variable "name" {
  type        = string
  description = "The name of the group of SSM Parameters."
}

variable "ssm_parameter_name_prefix" {
  type        = string
  description = "The namespace prefix for SSM parameters."
}

variable "ssm_parameters" {
  type = list(object({
    name  = string
    value = string
  }))
  description = "A list of key/value pairs of SSM parameters."
}
