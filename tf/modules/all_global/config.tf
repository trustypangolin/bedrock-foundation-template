resource "aws_iam_service_linked_role" "config" {
  aws_service_name = "config.amazonaws.com"
  description      = "Allows Config to call AWS services and collect resource configurations on your behalf."
}
