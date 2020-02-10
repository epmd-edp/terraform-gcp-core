# Requires roles/dns.admin
module "dns-public-zone" {
  source      = "terraform-google-modules/cloud-dns/google"
  project_id  = var.project_id
  type        = "public"
  name        = "${var.platform_name}-zone"
  domain      = var.domain

  recordsets  = [
    {
      name    = "*"
      type    = "A"
      ttl     = 600
      records = module.address.addresses
    },
    {
      name    = ""
      type    = "NS"
      ttl     = 21600
      records = [
        "ns-cloud-c1.googledomains.com.",
        "ns-cloud-c2.googledomains.com.",
        "ns-cloud-c3.googledomains.com.",
        "ns-cloud-c4.googledomains.com."
      ]
    },
    {
      name    = ""
      type    = "TXT"
      ttl     = 300
      records = [
        "\"v=spf1 -all\"",
      ]
    },
  ]
}

