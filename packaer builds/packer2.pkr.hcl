variable "region" {
  type    = string
  default = "us-east-1"
}

locals { timestamp = regex_replace(timestamp(), "[- TZ:]", "") }

source "amazon-ebs" "basic1-example" {
  ami_name      = "packer4-windows-demo-${local.timestamp}"
  instance_type = "t2.medium"
  communicator  = "winrm"
  region        = "${var.region}"
  access_key = "AKIAT4GVRQKTEBDJCBTD"
  secret_key = "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"

  source_ami_filter {
    filters = {
      name                = "Windows_Server-2019-English-Full-Base-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }

    most_recent = true
    owners      = ["amazon"]
    
  }



  user_data_file = "./bootstarp_win.txt"
  winrm_username = "Administrator"
  winrm_password = "Radhi1234*"
  winrm_insecure = true
  winrm_use_ssl  = true

}



build {
  sources = ["source.amazon-ebs.basic1-example"]
  

 provisioner "powershell" {
    environment_vars = ["VAR1=A$Dollar", "VAR2=A`Backtick", "VAR3=A'SingleQuote", "VAR4=A\"DoubleQuote"]
    script           = "./copy.ps1"
  } 

   provisioner "file" {
    source      = "VNC-Viewer-7.12.1-Windows.zip"
    destination = "/test5/"
  }

  

   provisioner "windows-restart" {
    restart_check_command = "powershell -command \"& {Write-Output 'restarted.'}\""
    timeout               = "300s"

  }

  provisioner "powershell" {
    environment_vars = ["VAR1=A$Dollar", "VAR2=A`Backtick", "VAR3=A'SingleQuote", "VAR4=A\"DoubleQuote"]
    script           = "./sample_script.ps1"
  }

 
}

 

  
