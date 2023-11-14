variable "enabled" {
  type        = bool
  description = "Whether to create new EC2 instance"
  default     = true
}
variable "associate_public_ip_address" {
  type        = bool
  description = "Associate a public IP address with the instance"
  default     = false
}

variable "assign_eip_address" {
  type        = bool
  description = "Assign an Elastic IP address to the instance"
  default     = true
}
variable "iam_name" {
  type = string
  description = "ec2 iam role name"
}
variable "key_name" {
  type = string
  description = "ec2 key name"
}
variable "instance_type" {
  type        = string
  description = "The type of the instance"
}
variable "ami_id" {
  type        = string
  description = "The type of the instance"
  default     = "ami id"
}

variable "vpc_id" {
  type        = string
  description = "The ID of the VPC that the instance security group belongs to"
}

variable "instance_profile_name" {
  type        = string
  description = "The Instance Profile Name"
}

variable "private_ip" {
  type        = string
  description = "Private IP address to associate with the instance in the VPC"
  default     = null
}

variable "security_group_enabled" {
  type        = bool
  description = "Whether to create default Security Group for EC2."
  default     = true
}

variable "security_group_ids" {
  description = "A list of existing Security Group IDs to associate with EC2 instance."
  type        = list(string)
  default     = ["sg-0bd541cafc1955479"]
}

variable "security_groups" {
  description = "A list of new Security Group names to associate with EC2 instance."
  type        = list(string)
  default     = ["sg1","sg2"]
}

variable "security_group_description" {
  type        = string
  default     = "EC2 Security Group"
  description = "The Security Group description."
}

variable "ingress_security_group_rules" {
  type = list(any)
  default = [ 
    {
      type        = "ingress"
      from_port   = 0
      to_port     = 65535
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow all outbound traffic"
    }
  ]
  description = "list of security group rules"
}
variable "egress_security_group_rules" {
  type = list(any)
  default = [ 
{
      type        = "egress"
      from_port   = 0
      to_port     = 65535
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow all outbound traffic"
    },
    {
      type        = "egress"
      from_port   = 10
      to_port     = 65535
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow all outbound traffic"
    }
  ]
}
variable "subnet_id" {
  type        = string
  description = "VPC Subnet ID the instance is launched in"
}

variable "region" {
  type        = string
  description = "AWS Region the instance is launched in"
  default     = ""
}



variable "ACCTID" {
  type        = number
  description = "AWS Account ID"
  default     = ""
}


variable "instance_name" {
  type        = string
  default     = "test"
}


variable "availability_zone" {
  type        = string
  description = "Availability Zone the instance is launched in. If not set, will be launched in the first AZ of the region"
  default     = ""
}

variable "ebs_optimized" {
  type        = bool
  description = "Launched EC2 instance will be EBS-optimized"
  default     = true
}

variable "disable_api_termination" {
  type        = bool
  description = "Enable EC2 Instance Termination Protection"
  default     = false
}

variable "monitoring" {
  type        = bool
  description = "Launched EC2 instance will have detailed monitoring enabled"
  default     = true
}


variable "root_volume_type" {
  type        = string
  description = "Type of root volume. Can be standard, gp2, gp3, io1 or io2"
  default     = "gp2"
}

variable "root_volume_size" {
  type        = number
  description = "Size of the root volume in gigabytes"
  default     = 10
}

variable "root_iops" {
  type        = number
  description = "Amount of provisioned IOPS. This must be set if root_volume_type is set of `io1`, `io2` or `gp3`"
  default     = 0
}

variable "root_throughput" {
  type        = number
  description = "Amount of throughput. This must be set if root_volume_type is set to `gp3`"
  default     = 0
}


variable "ebs_volume_type" {
  type        = string
  description = "The type of the additional EBS volumes. Can be standard, gp2, gp3, io1 or io2"
  default     = "gp2"
}

variable "ebs_volume_size" {
  type        = number
  description = "Size of the additional EBS volumes in gigabytes"
  default     = 10
}

variable "ebs_volume_encrypted" {
  type        = bool
  description = "Whether to encrypt the additional EBS volumes"
  default     = true
}

variable "ebs_iops" {
  type        = number
  description = "Amount of provisioned IOPS. This must be set with a volume_type of `io1`, `io2` or `gp3`"
  default     = 0
}

variable "ebs_throughput" {
  type        = number
  description = "Amount of throughput. This must be set if volume_type is set to `gp3`"
  default     = 0
}

variable "ebs_volume_count" {
  type        = number
  description = "Count of EBS volumes that will be attached to the instance"
  default     = 0
}

variable "delete_on_termination" {
  type        = bool
  description = "Whether the volume should be destroyed on instance termination"
  default     = true
}


variable "reboot_evaluation_period" {
  type        = string
  default     = "3"
  description = "The evaluation period over which to use when triggering alarms."
}

variable "recover_evaluation_period" {
  type        = string
  default     = "2"
  description = "The evaluation period over which to use when triggering alarms."
}
variable "reboot_statistic_period" {
  type        = string
  default     = "Minimum"
  description = "The number of seconds that make each statistic period."
}
variable "recover_statistic_period" {
  type        = string
  default     = "Minimum"
  description = "The number of seconds that make each statistic period."
}

variable "reboot_metric_name" {
  type        = string
  default     = "StatusCheckFailed"
  description = "The name for the alarm's associated metric."
}
variable "recover_metric_name" {
  type        = string
  default     = "StatusCheckFailed_System"
  description = "The name for the alarm's associated metric."
}
variable "reboot_period" {
  type        = number
  default     = 60
  description = "The period in seconds over which the specified statistic is applied."
}
variable "recover_period" {
  type        = number
  default     = 60
  description = "The period in seconds over which the specified statistic is applied."
}

variable "reboot_actions_alarm" {
  type        = list
  default     = ["arn:aws:automate:us-east-2:ec2:reboot"]
  description = "A list of actions to take when alarms are triggered. Will likely be an SNS topic for event distribution."
}
variable "recover_actions_alarm" {
  type        = list
  default     = ["arn:aws:automate:us-east-2:ec2:recover"]
  description = "A list of actions to take when alarms are triggered. Will likely be an SNS topic for event distribution."
}

# variable "reboot_actions_ok" {
#   type        = list
#   default     = ["arn:aws:sns:us-east-2:215691912540:Ec2RebootRecover"]
#   description = "A list of actions to take when alarms are cleared. Will likely be an SNS topic for event distribution."
# }
# variable "recover_actions_ok" {
#   type        = list
#   default     = ["arn:aws:sns:us-east-2:215691912540:Ec2RebootRecover"]
#   description = "A list of actions to take when alarms are cleared. Will likely be an SNS topic for event distribution."
# }

variable "Environment" {
  type    = string
  default = "Dev"

validation {
   condition     = contains(["Dev", "Test" ,"Sandbox", "Staging", "Production"], var.Environment)
   error_message = "Please provide a valid value for variable Envrionment. Allowed values are Dev, Test, Sandbox, Staging and Production"
 }
}


variable "ApplicationFunctionality" {
  type    = string
  default = ""

}

variable "ApplicationDescription" {
  type    = string
  default = ""

}

variable "ApplicationOwner" {
  description = "Owner of the Application"
  type        = string
  default     = ""

  validation {
   condition     = contains(["abc@hotmail.com", "abc@gmail.com"], var.ApplicationOwner)
   error_message = "Please provide a valid Application Owner"
 }
}


variable "ApplicationTeam" {
  description = "Owner of the Application"
  type        = string
  default     = ""

  validation {
   condition     = contains(["Team1","Team2"], var.ApplicationTeam)
   error_message = "Please provide a valid Application Team"
 }
}


variable "BackupSchedule" {
  description = "BackupScheduled of the Volume"
  type        = string
  default     = ""

  validation {
   condition     = contains(["DR7y","DR1y","DR1m"], var.BackupSchedule)
   error_message = "Please provide a valid BackupSchedule. Valid values are DR7y,DR1y and DR1m"
 }
}


variable "BusinessTower" {
  description = "Business Tower"
  type        = string
  default     = ""

  validation {
   condition     = contains(["abc@gmail.com","xyz@gmail.com"], var.BusinessTower)
   error_message = "Please provide a valid BusinessTower"
 }
}



variable "BusinessOwner" {
  description = "Business Owner"
  type        = string
  default     = ""

  validation {
   condition     = contains(["abc@gmail.com","xyz@gmail.com"], var.BusinessOwner)
   error_message = "Please provide a valid BusinessOwner"
 }
}


variable "ServiceCriticality" {
  description = "Business Criticality of the Service"
  type        = string
  default     = ""

  validation {
   condition     = contains(["High","Low"," Medium"], var.ServiceCriticality)
   error_message = "Please provide a valid Service Criticality, Valid values are High, Low and Medium"
 }
}


variable "ec2_tags" {
    default = {
    }
    description = "Tags for WIndows Ec2 instances"
    type        = map(string)
  }


variable "secgroupdescription" {
  type = string
  default = "Allow tcp to client host"
  
}


variable "ingress_rules" {
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_block  = string
    description = string
  }))
  default = [

  ]
}



variable "egress_rules" {
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_block  = string
    description = string
  }))
  default = [

  ]
}

  variable "ebs_device_name" {
  type        = list(string)
  description = "Name of the EBS device to mount"
  #default     = ["/dev/xvdb", "/dev/xvdc", "/dev/xvdd", "/dev/xvde", "/dev/xvdf", "/dev/xvdg", "/dev/xvdh", "/dev/xvdi", "/dev/xvdj", "/dev/xvdk", "/dev/xvdl", "/dev/xvdm", "/dev/xvdn", "/dev/xvdo", "/dev/xvdp", "/dev/xvdq", "/dev/xvdr", "/dev/xvds", "/dev/xvdt", "/dev/xvdu", "/dev/xvdv", "/dev/xvdw", "/dev/xvdx", "/dev/xvdy", "/dev/xvdz"]
default = ["/dev/xvdb", "/dev/xvdc", "/dev/xvdd"]
}



