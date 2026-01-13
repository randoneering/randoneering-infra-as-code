locals {
  ansible_runner_user = var.ansible_runner_user == "" ? "name of ansible user" : var.ansible_runner_user
  ansible_group       = var.ansible_group == "" ? "ansible_group" : var.ansible_group
  ansible_host        = var.ansible_host == "" ? "name of host" : var.ansible_host

}


#Initialized with playbook below,
resource "ansible_group" "ansible_runner_group" {
  name = local.ansible_group
}

resource "ansible_host" "ansible_runner" {
  name   = local.ansible_host
  groups = [ansible_group.ansible_runner_group.name]
  variables = {
    ansible_user                 = local.ansible_runner_user
    ansible_ssh_private_key_file = ""
  }
}

resource "ansible_playbook" "db_init_mysql" {
  playbook   = var.playbook_path
  name       = ansible_host.ansible_runner.name
  replayable = false

  extra_vars = {
    ansible_user                 = local.ansible_runner_user
    ansible_ssh_private_key_file = ""
    service_user                 = var.service_user
    anbile_runner_password       = ""
    service_user_password        = var.service_user_password
    target_db_instance           = var.dns_endpoint
    target_db_name               = var.database_name
    db_username                  = var.username
    db_password                  = var.master_username_password
  }
}
