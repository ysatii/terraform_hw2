# Домашнее задание к занятию «Основы Terraform. Yandex Cloud»

### Цели задания

1. Создать свои ресурсы в облаке Yandex Cloud с помощью Terraform.
2. Освоить работу с переменными Terraform.


### Чек-лист готовности к домашнему заданию

1. Зарегистрирован аккаунт в Yandex Cloud. Использован промокод на грант.
2. Установлен инструмент Yandex CLI.
3. Исходный код для выполнения задания расположен в директории [**02/src**](https://github.com/netology-code/ter-homeworks/tree/main/02/src).


### Задание 0

1. Ознакомьтесь с [документацией к security-groups в Yandex Cloud](https://cloud.yandex.ru/docs/vpc/concepts/security-groups?from=int-console-help-center-or-nav). 
Этот функционал понадобится к следующей лекции.

------
### Внимание!! Обязательно предоставляем на проверку получившийся код в виде ссылки на ваш github-репозиторий!
------

## Задание 1
В качестве ответа всегда полностью прикладывайте ваш terraform-код в git.
Убедитесь что ваша версия **Terraform** ~>1.8.4

1. Изучите проект. В файле variables.tf объявлены переменные для Yandex provider.
2. Создайте сервисный аккаунт и ключ. [service_account_key_file](https://terraform-provider.yandexcloud.net).
4. Сгенерируйте новый или используйте свой текущий ssh-ключ. Запишите его открытую(public) часть в переменную **vms_ssh_public_root_key**.
5. Инициализируйте проект, выполните код. Исправьте намеренно допущенные синтаксические ошибки. Ищите внимательно, посимвольно. Ответьте, в чём заключается их суть.
6. Подключитесь к консоли ВМ через ssh и выполните команду ``` curl ifconfig.me```.
Примечание: К OS ubuntu "out of a box, те из коробки" необходимо подключаться под пользователем ubuntu: ```"ssh ubuntu@vm_ip_address"```. Предварительно убедитесь, что ваш ключ добавлен в ssh-агент: ```eval $(ssh-agent) && ssh-add``` Вы познакомитесь с тем как при создании ВМ создать своего пользователя в блоке metadata в следующей лекции.;
8. Ответьте, как в процессе обучения могут пригодиться параметры ```preemptible = true``` и ```core_fraction=5``` в параметрах ВМ.

В качестве решения приложите:

- скриншот ЛК Yandex Cloud с созданной ВМ, где видно внешний ip-адрес;
- скриншот консоли, curl должен отобразить тот же внешний ip-адрес;
- ответы на вопросы.

## Решение 1
проверим версию 
```
terraform -v
```
вывод 
```
Terraform v1.8.4
on linux_amd64
+ provider registry.terraform.io/yandex-cloud/yandex v0.141.0

Your version of Terraform is out of date! The latest version
is 1.12.0. You can update by downloading from https://www.terraform.io/downloads.html
```

1.  Изучено!


2. Согласно инструкции создаем key.json сервисный авторизационный ключ!
https://yandex.cloud/ru/docs/cli/operations/authentication/service-account
и положим его в корнь домашней директории 

3. Используем готовый ключ и . Запишите его открытую(public) часть в переменную vms_ssh_public_root_key в файле variables.tf - Выполнено!

4. Инициализирем  проект, выполним код. Исправим намеренно допущенные синтаксические ошибки. чём заключается их суть.
- иницилизируем проект 
```
terraform init
```
 ![рис 1](https://github.com/ysatii/terraform_hw2/blob/main/img/img_1.jpg)

 паралельно заполняем файл variables.tf значаениями переменных которые запросит terraform
 ![рис 2](https://github.com/ysatii/terraform_hw2/blob/main/img/img_2.jpg)

запуск не удачен 
```
Error: Invalid function argument
│ 
│   on providers.tf line 15, in provider "yandex":
│   15:   service_account_key_file = file("~/.authorized_key.json")
│     ├────────────────
│     │ while calling file(path)
│ 
│ Invalid value for "path" parameter: no file exists at "~/.authorized_key.json"; this function works only with files that are distributed as part of the
│ configuration source code, so if this file will be created by a resource in this configuration you must instead obtain this result from an attribute of that
│ resource.
```

файл должен называться  **key.json**
изменим и попробуем снова
 ![рис 3](https://github.com/ysatii/terraform_hw2/blob/main/img/img_3.jpg)

gлан выполнен успешно!
 ![рис 4](https://github.com/ysatii/terraform_hw2/blob/main/img/img_4.jpg)
Заменетим что это не всегда приводит к успешному вывполнению скрита !

Пробуем запустить выполнение командой 
```
terraform apply
```
Снова ошибка 
```
 Error: Error while requesting API to create instance: client-request-id = cdfc6cc1-b6a2-493a-af28-59d09dda0edc client-trace-id = c70cc63a-96d8-49ab-bd7f-993d0c100502 rpc error: code = FailedPrecondition desc = Platform "standart-v4" not found
│ 
│   with yandex_compute_instance.platform,
│   on main.tf line 15, in resource "yandex_compute_instance" "platform":
│   15: resource "yandex_compute_instance" "platform" 
```
страница помощи  https://yandex.cloud/ru/docs/compute/concepts/vm-platforms говорит 
что такой платформы нет !
используем **standard-v1** 
и попробуем еще раз
```
yandex_compute_instance.platform: Creating...
╷
│ Error: Error while requesting API to create instance: client-request-id = 547a9075-49a7-4718-9721-60687519a8c1 client-trace-id = d0678886-e902-40c7-b303-689bfdeeed3f rpc error: code = InvalidArgument desc = the specified number of cores is not available on platform "standard-v1"; allowed core number: 2, 4
│ 
│   with yandex_compute_instance.platform,
│   on main.tf line 15, in resource "yandex_compute_instance" "platform":
│   15: resource "yandex_compute_instance" "platform" 

```
не правльно указано колличество ядер  нужно 2 или 4 ядра! установим 2 ядра и 4 ГБ памяти!
 ![рис 5](https://github.com/ysatii/terraform_hw2/blob/main/img/img_5.jpg)
 ![рис 6](https://github.com/ysatii/terraform_hw2/blob/main/img/img_6.jpg)


Успех!
 ![рис 7](https://github.com/ysatii/terraform_hw2/blob/main/img/img_7.jpg)

Содана виртуальная машина
 ![рис 8](https://github.com/ysatii/terraform_hw2/blob/main/img/img_8.jpg)

5. подключимся к машине
 ![рис 9](https://github.com/ysatii/terraform_hw2/blob/main/img/img_9.jpg)
 Подключение успешно!


## Задание 2

1. Замените все хардкод-**значения** для ресурсов **yandex_compute_image** и **yandex_compute_instance** на **отдельные** переменные. К названиям переменных ВМ добавьте в начало префикс **vm_web_** .  Пример: **vm_web_name**.
2. Объявите нужные переменные в файле variables.tf, обязательно указывайте тип переменной. Заполните их **default** прежними значениями из main.tf. 
3. Проверьте terraform plan. Изменений быть не должно. 

## Решение 2
Дополним variables.tf
```
variable vm_web_family_os{
  type        = string
  default     = "ubuntu-2004-lts"
  description = "os family"
}

variable vm_web_instance_name{
  type        = string
  default     = "netology-develop-platform-web"
  description = "instance name"
}

variable "vm_web_platform_id" {
  type        = string
  default     = "standard-v2"
  description = "VM platform type"
}

variable "vm_web_platform_configs" {
  type = map(object({
    cores         = number
    memory        = number
    core_fraction = number
  }))

  default = {
    "standard-v1" = {
      cores         = 2
      memory        = 4
      core_fraction = 5
    }
    "standard-v2" = {
      cores         = 4
      memory        = 8
      core_fraction = 20
    }
  }

  description = "Platform resource configurations"
}
```

 Изменений в конфигурации машины нет!
 при желании можем установить другую платформу default     = "standard-v2"
 ```variable "vm_web_platform_id" {
  type        = string
  default     = "standard-v2"
  description = "VM platform type"
}
 ```
 Получим 
 ![рис 10](https://github.com/ysatii/terraform_hw2/blob/main/img/img_10.jpg)
 Изменя имя платформы у нас меняеться колличество ядер, памяти и процент использования процессора! Достаточно поменять одну настройку для смены платформы!



### Задание 3

1. Создайте в корне проекта файл 'vms_platform.tf' . Перенесите в него все переменные первой ВМ.
2. Скопируйте блок ресурса и создайте с его помощью вторую ВМ в файле main.tf: **"netology-develop-platform-db"** ,  ```cores  = 2, memory = 2, core_fraction = 20```. Объявите её переменные с префиксом **vm_db_** в том же файле ('vms_platform.tf').  ВМ должна работать в зоне "ru-central1-b"
3. Примените изменения.


### Задание 4

1. Объявите в файле outputs.tf **один** output , содержащий: instance_name, external_ip, fqdn для каждой из ВМ в удобном лично для вас формате.(без хардкода!!!)
2. Примените изменения.

В качестве решения приложите вывод значений ip-адресов команды ```terraform output```.


### Задание 5

1. В файле locals.tf опишите в **одном** local-блоке имя каждой ВМ, используйте интерполяцию ${..} с НЕСКОЛЬКИМИ переменными по примеру из лекции.
2. Замените переменные внутри ресурса ВМ на созданные вами local-переменные.
3. Примените изменения.


### Задание 6

1. Вместо использования трёх переменных  ".._cores",".._memory",".._core_fraction" в блоке  resources {...}, объедините их в единую map-переменную **vms_resources** и  внутри неё конфиги обеих ВМ в виде вложенного map(object).  
   ```
   пример из terraform.tfvars:
   vms_resources = {
     web={
       cores=2
       memory=2
       core_fraction=5
       hdd_size=10
       hdd_type="network-hdd"
       ...
     },
     db= {
       cores=2
       memory=4
       core_fraction=20
       hdd_size=10
       hdd_type="network-ssd"
       ...
     }
   }
   ```
3. Создайте и используйте отдельную map(object) переменную для блока metadata, она должна быть общая для всех ваших ВМ.
   ```
   пример из terraform.tfvars:
   metadata = {
     serial-port-enable = 1
     ssh-keys           = "ubuntu:ssh-ed25519 AAAAC..."
   }
   ```  
  
5. Найдите и закоментируйте все, более не используемые переменные проекта.
6. Проверьте terraform plan. Изменений быть не должно.

------

## Дополнительное задание (со звёздочкой*)

**Настоятельно рекомендуем выполнять все задания со звёздочкой.**   
Они помогут глубже разобраться в материале. Задания со звёздочкой дополнительные, не обязательные к выполнению и никак не повлияют на получение вами зачёта по этому домашнему заданию. 


------
### Задание 7*

Изучите содержимое файла console.tf. Откройте terraform console, выполните следующие задания: 

1. Напишите, какой командой можно отобразить **второй** элемент списка test_list.
2. Найдите длину списка test_list с помощью функции length(<имя переменной>).
3. Напишите, какой командой можно отобразить значение ключа admin из map test_map.
4. Напишите interpolation-выражение, результатом которого будет: "John is admin for production server based on OS ubuntu-20-04 with X vcpu, Y ram and Z virtual disks", используйте данные из переменных test_list, test_map, servers и функцию length() для подстановки значений.

**Примечание**: если не догадаетесь как вычленить слово "admin", погуглите: "terraform get keys of map"

В качестве решения предоставьте необходимые команды и их вывод.

------

### Задание 8*
1. Напишите и проверьте переменную test и полное описание ее type в соответствии со значением из terraform.tfvars:
```
test = [
  {
    "dev1" = [
      "ssh -o 'StrictHostKeyChecking=no' ubuntu@62.84.124.117",
      "10.0.1.7",
    ]
  },
  {
    "dev2" = [
      "ssh -o 'StrictHostKeyChecking=no' ubuntu@84.252.140.88",
      "10.0.2.29",
    ]
  },
  {
    "prod1" = [
      "ssh -o 'StrictHostKeyChecking=no' ubuntu@51.250.2.101",
      "10.0.1.30",
    ]
  },
]
```
2. Напишите выражение в terraform console, которое позволит вычленить строку "ssh -o 'StrictHostKeyChecking=no' ubuntu@62.84.124.117" из этой переменной.
------

------

### Задание 9*

Используя инструкцию https://cloud.yandex.ru/ru/docs/vpc/operations/create-nat-gateway#tf_1, настройте для ваших ВМ nat_gateway. Для проверки уберите внешний IP адрес (nat=false) у ваших ВМ и проверьте доступ в интернет с ВМ, подключившись к ней через serial console. Для подключения предварительно через ssh измените пароль пользователя: ```sudo passwd ubuntu```

### Правила приёма работыДля подключения предварительно через ssh измените пароль пользователя: sudo passwd ubuntu
В качестве результата прикрепите ссылку на MD файл с описанием выполненой работы в вашем репозитории. Так же в репозитории должен присутсвовать ваш финальный код проекта.

**Важно. Удалите все созданные ресурсы**.


### Критерии оценки

Зачёт ставится, если:

* выполнены все задания,
* ответы даны в развёрнутой форме,
* приложены соответствующие скриншоты и файлы проекта,
* в выполненных заданиях нет противоречий и нарушения логики.

На доработку работу отправят, если:

* задание выполнено частично или не выполнено вообще,
* в логике выполнения заданий есть противоречия и существенные недостатки. 

