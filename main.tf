resource "aws_instance" "ec2_instance" {
    ami           = data.aws_ami.rhel_info.id
    instance_type = var.ec2_instance.instance_type
    vpc_security_group_ids = [var.allow_everything]

    root_block_device {
        encrypted             = false
        volume_type           = "gp3"
        volume_size           = 100
        iops                  = 3000
        throughput            = 125
        delete_on_termination = true
    }
    tags = {
        Name = "prometheus_server"
    }
}
resource "aws_route53_record" "ec2_instance_r53" {
    zone_id = var.zone_id
    name    = "prometheus.${var.domain_name}"
    type    = "A"
    ttl     = 1
    records = [aws_instance.ec2_instance.public_ip]
    allow_overwrite = true
}
