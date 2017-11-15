
output "arn" {
  description = "Amazon Resource Name (ARN) of Elasticsearch Domain"
  value       = "${aws_elasticsearch_domain.this.arn}"
}
output "availability_zones" {
  description = "Availability Zones of Elasticsearch Domain"
  value       = "${aws_elasticsearch_domain.this.vpc_options.0.availability_zones}"
}
output "endpoint" {
  description = "Domain-specific endpoint used to submit index, search, and data upload requests"
  value       = "${aws_elasticsearch_domain.this.endpoint}"
}
output "domain_id" {
  description = "ID of Elasticsearch Domain"
  value       = "${aws_elasticsearch_domain.this.domain_id}"
}
output "domain_name" {
  description = "Name of Elasticsearch Domain"
  value       = "${aws_elasticsearch_domain.this.domain_name}"
}
output "vpc_id" {
  description = "VPC ID of Elasticsearch Domain"
  value       = "${aws_elasticsearch_domain.this.vpc_options.0.vpc_id}"
}

/* vim: set et fenc= ff=unix ft=terraform sts=2 sw=2 ts=2 : */
