# YANDEX-CLOUD-TERRAFORM-IAAS

Examples of infrastructure as code tools include Yandex Cloud and Terraform.

## Install YC CLI
```bash
curl https://storage.yandexcloud.net/yandexcloud-yc/install.sh | bash
```

## Init YC CLI
```bash
yc init
```

## Get token, cloud-id, folder-id
```bash
yc config list
```

## Output:
```bash
token: xxx
cloud-id: xxx
folder-id: xxxx
compute-default-zone: ru-central1-a
```

# Terraform
## Set up terraform

### Download and install terraform CLI from https://www.terraform.io/downloads

## Set terraform mirror
```bash
nano ~/.terraformrc
```
with code

```bash
provider_installation {
  network_mirror {
    url = "https://terraform-mirror.yandexcloud.net/"
    include = ["registry.terraform.io/*/*"]
  }
  direct {
    exclude = ["registry.terraform.io/*/*"]
  }
}
```