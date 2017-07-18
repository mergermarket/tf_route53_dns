variable "domain" {
  description = "The domain to use as a base"
}

variable "name" {
  description = "The name of the component to build a domain for"
}

variable "env" {
  description = "The environment this component is running in"
}

variable "target" {
  description = "Where the DNS should send traffic"
}

variable "ttl" {
  description = "The TTL for the dns record"
  default     = 60
}
