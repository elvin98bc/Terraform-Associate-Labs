terraform {

}

variable "worlds" {
	type = list
}

variable "worlds_map" {
	type = map
}

variable "worlds_splat" {
	type = list
}

# output "worlds_list" {
# #   value = { for w in var.worlds : w => "hello ${w}" }
# }

# output "world_map" {
# #   value = [for k, v in var.worlds_map : "key = ${k}, value = ${v}"]
# }

output "worlds_splat" {
  value = [for w in var.worlds_splat : upper(w.mars_name)]
}