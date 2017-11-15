# Elasticsearch domain
data "aws_iam_policy_document" "es_management_access" {
  statement {
    actions = [
      "es:*",
    ]

    resources = [
      "${aws_elasticsearch_domain.es.arn}",
      "${aws_elasticsearch_domain.es.arn}/*",
    ]

    principals {
      type = "AWS"

      identifiers = ["${distinct(compact(var.management_iam_roles))}"]
    }

    condition {
      test     = "IpAddress"
      variable = "aws:SourceIp"

      values = ["${distinct(compact(var.management_public_ip_addresses))}"]
    }
  }
}

resource "aws_elasticsearch_domain" "this" {
  domain_name = "${var.namespaced ? format("%s-%s", var.environment, var.name) : format("%s", var.name)}"
  elasticsearch_version = "${var.es_version}"

  cluster_config {
    instance_type            = "${var.instance_type}"
    instance_count           = "${var.instance_count}"
    dedicated_master_enabled = "${var.instance_count >= 10 ? true : false}"
    dedicated_master_count   = "${var.instance_count >= 10 ? 3 : 0}"
    dedicated_master_type    = "${var.instance_count >= 10 ? (var.dedicated_master_type != "false" ? var.dedicated_master_type : var.instance_type) : ""}"
    zone_awareness_enabled   = "${var.es_zone_awareness}"
  }

  # advanced_options {
  # }

  ebs_options {
    ebs_enabled = "${var.ebs_volume_size > 0 ? true : false}"
    volume_size = "${var.ebs_volume_size}"
    volume_type = "${var.ebs_volume_type}"
  }
  snapshot_options {
    automated_snapshot_start_hour = "${var.snapshot_start_hour}"
  }
  tags = "${ merge(
    var.tags,
    map("Name", var.namespaced ?
     format("%s-%s", var.environment, var.name) :
     format("%s", var.name) ),
    map("Environment", var.environment),
    map("Terraform", "true") )}"
}

resource "aws_elasticsearch_domain_policy" "es_management_access" {
  domain_name     = "${aws_elasticsearch_domain.this.domain_name}"
  access_policies = "${data.aws_iam_policy_document.es_management_access.json}"
}

# vim: set et fenc= ff=unix ft=terraform sts=2 sw=2 ts=2 :
