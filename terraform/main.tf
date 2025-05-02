
terraform {
  required_providers {
    openstack = {
      source = "terraform-provider-openstack/openstack"
    }
  }
}

provider "openstack" {
  cloud = "openstack" # ~/.config/openstack/clouds.yaml 기준
}

resource "openstack_compute_instance_v2" "vm" {
  count        = 4  # VM 4개 생성
  name         = "vm-${count.index}"  # 이름: vm-0, vm-1, ...
  flavor_name  = "aem.1c2r.50g"  # 원하는 flavor 이름
  key_pair     = "newkey"  # OpenStack에 등록된 SSH 키 이름
  security_groups = ["ssh"]  # SSH 허용 시큐리티 그룹

  block_device {
    uuid = "44cae3e6-0907-4d6b-8376-2858e234f4d8"
    source_type           = "image"
    destination_type      = "volume"
    volume_size           = 25  # 볼륨 크기 (GB)
    boot_index            = 0
    delete_on_termination = true
  }

  network {
    name = "oslomet"
  }
}
