# Module Testing

Die Module werden mit dem integrierten `terraform test` Framework getestet (Terraform 1.7+).
Tests verwenden `mock_provider "azurerm"` — es werden keine Azure-Credentials benötigt.

## Voraussetzungen

- Terraform >= 1.7
- `terraform init` muss einmalig pro Modul ausgeführt werden

## Test ausführen

```bash
cd modules/<modul-name>
terraform init
terraform test
```

### Beispiel

```bash
cd modules/resource-group
terraform init
terraform test
```

```
main.tftest.hcl... in progress
  run "plan"... pass
main.tftest.hcl... tearing down
main.tftest.hcl... pass

Success! 1 passed, 0 failed.
```

## Alle Module auf einmal testen

```bash
for mod in resource-group container-app-environment uami container-app; do
  echo "=== $mod ==="
  cd modules/$mod && terraform init -upgrade 2>&1 | tail -1 && terraform test
  cd -
done
```

## Testdateien

Jedes Modul enthält eine `main.tftest.hcl` mit einem `plan`-Run und Beispielwerten für alle Pflichtfelder.
