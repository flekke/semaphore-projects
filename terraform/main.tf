
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

resource "openstack_compute_instance_v2" "vm0" {  # 첫 번째 VM
  name         = "vm-0"  # 이름
  flavor_name  = "aem.2c4r.50g"  # VM 크기 설정
  key_pair     = "newkey"  # 사용할 SSH 키

  block_device {
    boot_index            = 0  # 부팅 순서
    delete_on_termination = true  # VM 삭제 시 볼륨도 삭제
    destination_type      = "volume"  # 볼륨 부팅
    source_type           = "image"  # 이미지로부터 생성
    uuid                  = "44cae3e6-0907-4d6b-8376-2858e234f4d8"  # 사용할 이미지 UUID
    volume_size           = 10  # 볼륨 크기 (GB)
  }

  network {
    name = "oslomet"  # 연결할 네트워크 이름
  }
}

resource "openstack_compute_instance_v2" "vm1" {  # 두 번째 VM
  name         = "vm-1"
  flavor_name  = "aem.2c4r.50g"
  key_pair     = "newkey"

  block_device {
    boot_index            = 0
    delete_on_termination = true
    destination_type      = "volume"
    source_type           = "image"
    uuid                  = "44cae3e6-0907-4d6b-8376-2858e234f4d8"
    volume_size           = 10
  }

  network {
    name = "oslomet"
  }

  depends_on = [openstack_compute_instance_v2.vm0]  # vm0이 먼저 생성된 후 실행
}

resource "openstack_compute_instance_v2" "vm2" {  # 세 번째 VM
  name         = "vm-2"
  flavor_name  = "aem.2c4r.50g"
  key_pair     = "newkey"

  block_device {
    boot_index            = 0
    delete_on_termination = true
    destination_type      = "volume"
    source_type           = "image"
    uuid                  = "44cae3e6-0907-4d6b-8376-2858e234f4d8"
    volume_size           = 10
  }

  network {
    name = "oslomet"
  }

  depends_on = [openstack_compute_instance_v2.vm1]  # vm1 생성 후 실행
}

  output "instance_ips" {
    value = {
      node1 = openstack_compute_instance_v2.vm0.network[0].fixed_ip_v4
      node2 = openstack_compute_instance_v2.vm1.network[0].fixed_ip_v4
      node3 = openstack_compute_instance_v2.vm2.network[0].fixed_ip_v4
    }
  }

