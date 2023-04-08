data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "node_group_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "ec2_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

data "tls_certificate" "openid" {
  url = module.eks.cluster_openid_url
}

data "aws_caller_identity" "current" {}

data "template_file" "lb_trust_policy" {
  template = file(abspath("load-balancer-role-trust-policy.json"))
  vars = {
    ACCOUNT_ID = data.aws_caller_identity.current.account_id,
    OPENID_URL = trim(module.eks.cluster_openid_url, "https://")
  }
}

data "template_file" "lb_policy" {
  template = file(abspath("load-balancer-role-policy.json"))
}