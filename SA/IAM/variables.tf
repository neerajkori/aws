variable "users" {
  type        = set(string)
  description = "list of users to be created on the aws account."
  default     = ["ram", "sham", "mohan", "sundar", "rahul", "rajan"]
}

variable "groups" {
  type        = set(string)
  description = "list of groups where users need to be mapped"
  default     = ["developer", "operations"]
}

variable "developers" {
  type = list(string)
  description = "This is the list of developers."
  default = [ "ram","sham","mohan" ]
}

variable "operations" {
  type = list(string)
  description = "This is the list of operators."
  default = [ "sundar","rahul" ]
}

