output "dns_writer" {
  value = aws_route53_record.dns_writer.name
}

output "dns_reader" {
  value = aws_route53_record.dns_reader[*].name
}