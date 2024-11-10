variable "region" {
  type    = string
  default = "us-east-1"
}

locals { timestamp = regex_replace(timestamp(), "[- TZ:]", "") }

source "amazon-ebs" "basic1-example" {
  ami_name      = "packer-windows-demo-${local.timestamp}"
  instance_type = "t2.medium"
  communicator  = "winrm"
  region        = "${var.region}"
  

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
    environment_vars = ["DEVOPS_LIFE_IMPROVER=PACKER"]
    inline           = ["Write-Host \"HELLO NEW USER; WELCOME TO $Env:DEVOPS_LIFE_IMPROVER\"", "Write-Host \"You need to use backtick escapes when using\"", "Write-Host \"characters such as DOLLAR`$ directly in a command\"", "Write-Host \"or in your own scripts.\""]
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

  
