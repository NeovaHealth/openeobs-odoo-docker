resource "aws_ecr_repository" "odoo" {
  name = "odoo"
}

output "odoo-ecr_url" {
  value = "${aws_ecr_repository.odoo_base.repository_url}"
}
