output "subnet_ids" {
  description = "Map of subnet names to their Azure resource IDs"
  value = {
    for key, subnet in azurerm_subnet.example :
    key => subnet.id
  }
}