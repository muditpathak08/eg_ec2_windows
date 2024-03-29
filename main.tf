data "aws_iam_policy_document" "default" {
  statement {
    sid = ""
    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    effect = "Allow"
  }
}
resource "aws_iam_role" "iam" {
  # name                 = local.iam_name
  name = local.iam_name
  # name  = join (local.iam_name)
  path                 = "/"
  assume_role_policy   = data.aws_iam_policy_document.default.json
  #permissions_boundary = var.permissions_boundary_arn
  tags                 = var.ec2_tags
}

resource "aws_iam_instance_profile" "test_profile" {
  name = var.instance_profile_name
  role = "${aws_iam_role.iam.name}"
}

data "aws_subnet" "test" {
  vpc_id = var.vpc_id

  tags = {
    Name = var.Subnet_Name
  }
}


# module "aws_security_group" {
#   source      = "./modules/security_group"
#   sg_count = length(var.security_groups)
#   name = var.security_groups
#   description = var.secgroupdescription
#   vpc_id      = var.vpc_id

# } 

# resource "random_integer" "ri" {
#   min = 10000
#   max = 99999
# }

module "new_security_group" {
  source = "./modules/security_group_new"
  # security_rules = var.security_rules  
  security_rules = local.security_rules
  vpc_id = var.vpc_id
  # depends_on = [random_integer.ri]
}

data "aws_instances" "foo" {
  filter {
    name   = "tag:Name"
    values = ["${var.aws_ec2_name}"]
  }
}

resource "null_resource" "test_duplicate_ec2" {
  # Changes to any instance of the cluster requires re-provisioning
  count   = length(data.aws_instances.foo.ids) > 0 ? 1 : 0
  }

module "existing_sg_rules" {
  source = "./modules/existing_sg_rules"
  existing_sg_rules = local.existing_sg_rules
}





resource "aws_instance" "project-iac-ec2-windows" {
  ami                                  = var.ami_id
  availability_zone                    = var.availability_zone
  instance_type                        = var.instance_type
  # ebs_optimized                        = var.ebs_optimized
  disable_api_termination              = true
  associate_public_ip_address 		     = var.associate_public_ip_address
  iam_instance_profile                 = aws_iam_instance_profile.test_profile.name
  private_ip                           = var.private_ip 
  key_name                             = var.key_name
  subnet_id                            =  data.aws_subnet.test.id
  monitoring                           = var.monitoring

  # vpc_security_group_ids = concat(module.aws_security_group.security_groups[*].id,var.security_group_ids[*])
  vpc_security_group_ids = concat(module.new_security_group.id[*],var.security_group_ids[*])


  root_block_device {
    volume_type           = var.root_volume_type
    volume_size           = var.root_volume_size
    iops                  = local.root_iops
    throughput            = local.root_throughput
    delete_on_termination = true
    encrypted             = true
    #kms_key_id            = var.root_block_device_kms_key_id
  }

 depends_on = [module.new_security_group.rds_security_groups, aws_iam_role.iam]

 tags = merge(tomap(var.ec2_tags),{ApplicationFunctionality = var.ApplicationFunctionality, 
      ApplicationDescription= var.ApplicationDescription, 
      ApplicationOwner = var.ApplicationOwner, 
      ApplicationTeam = var.ApplicationTeam, 
      BackupSchedule =var.BackupSchedule,
      BusinessOwner = var.BusinessOwner,
      ServiceCriticality = var.ServiceCriticality,
      Subnet-Name = var.Subnet_Name,
      Name = var.aws_ec2_name,
      VPC-id = var.vpc_id})

lifecycle {
     ignore_changes = [ami]
     }

}

resource "aws_eip_association" "eip_assoc" {
  count       = strcontains(var.Subnet_Name, "public") ? 1: 0
  instance_id   = aws_instance.project-iac-ec2-windows.id
  allocation_id = var.eip_allocation_id
}


module "ebs_volume" {
    source = "./modules/ebs_volume"
    
    ebs_volumes = var.ebs_volume_count
    azs =   var.availability_zone
    size= var.size
    ebs_device_name = var.ebs_device_name
    snapshot_id       = var.snapshot_id  ## To be set if Volume to be created from Snapshot
    ebs_tags = var.ebs_tags
    instance_id = aws_instance.project-iac-ec2-windows.id
    # ... omitted
  }

  

resource "aws_cloudwatch_metric_alarm" "reboot-alarm" {
  alarm_name                = "RebootAlarm"
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        =  var.reboot_evaluation_period
  metric_name               =  var.reboot_metric_name
  namespace                 = "AWS/EC2"
  period                    =  var.reboot_period
  statistic                 =  var.reboot_statistic_period
  threshold                 =  var.reboot_metric_threshold
  alarm_description         = "Trigger a reboot action when instance satus check fails for 15 consecutive minutes"
  actions_enabled           = "true"
  # alarm_actions             = var.reboot_actions_alarm
  # ok_actions                = var.reboot_actions_ok
  alarm_actions             = local.reboot_actions_alarm
  ok_actions                = local.reboot_actions_ok
    dimensions = {
        InstanceId = aws_instance.project-iac-ec2-windows.id
      }
  }
resource "aws_cloudwatch_metric_alarm" "recover-alarm" {
  alarm_name                = "RecoverAlarm"
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        =  var.recover_evaluation_period
  metric_name               =  var.recover_metric_name
  namespace                 = "AWS/EC2"
  period                    =  var.recover_period
  statistic                 =  var.recover_statistic_period
  threshold                 =  var.recover_metric_threshold
  alarm_description         = "Trigger a recover action when instance status check fails for 15 consecutive minutes"
  actions_enabled           = "true"
  alarm_actions             = local.recover_actions_alarm
  ok_actions                = local.recover_actions_ok
    dimensions = {
        InstanceId = aws_instance.project-iac-ec2-windows.id
      }
  }







