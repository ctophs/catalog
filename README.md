# Catalog-Repository — Wiederverwendbare Bausteine

Dieses Repository enthält die wiederverwendbaren Bausteine für die Azure-Infrastruktur:
Terraform-Module, die zugehörigen Terragrunt-Units und die daraus gebündelten Stacks.
Konsumiert wird es per Git-Referenz, üblicherweise aus dem
[Infra-Repository](https://github.com/ctophs/infra.git).

---

## Verzeichnisstruktur

```
catalog/
├── modules/      # Terraform-Module (je eine Azure-Ressource)
├── units/        # Terragrunt-Units — wrappen je ein Modul
└── stacks/       # Terragrunt-Stacks — bündeln mehrere Units
```

---

## Die drei Ebenen

### `modules/<name>/`

Reines Terraform. Jedes Modul kapselt **eine** Azure-Ressource (`resource_group`,
`uami`, `container_app_environment`, `container_app`). Getestet mit
`terraform test` und `mock_provider` — siehe [modules/README.md](modules/README.md).

### `units/<name>/terragrunt.hcl`

Wrappt ein Modul. Holt `catalog_url` / `catalog_ref` per
`include "root" { expose = true }` und bildet damit `terraform.source`.
Units definieren `dependency`-Blöcke zu Nachbar-Units und `inputs`, die aus
`values.*` oder Dependency-Outputs befüllt werden.

### `stacks/<name>/terragrunt.stack.hcl`

Bündelt mehrere Units zu einer fachlich zusammenhängenden Einheit (z. B. CAE +
Resource Groups + UAMI). Stacks unterstützen **kein** `include` — daher wird
`catalog.hcl` direkt per
`read_terragrunt_config(find_in_parent_folders("catalog.hcl"))` eingelesen.

---

## Konsumierung aus einem Infra-Repo

Ein Infra-Stack referenziert einen Catalog-Stack per `source` und reicht
umgebungsspezifische Werte über `values` durch:

```hcl
stack "dev" {
  source = "${local.catalog_url}//stacks/container_app_environment?ref=${local.catalog_ref}"
  path   = "dev"
  values = {
    name                     = "cae"
    location                 = "westeurope"
    resource_group_name      = "rg-…"
    uami_resource_group_name = "rg-…-uami"
    infrastructure_subnet_id = "/subscriptions/…"
  }
}
```

Der Catalog-Stack reicht die Werte an seine Units weiter (teils mit
`try(values.x, default)` für optionale Felder).

Details zum DRY-Pattern auf Infra-Seite (`catalog.hcl`, `root.hcl`,
`workload.hcl`) stehen im Infra-README.

---

## Neues Modul anlegen

1. `modules/<name>/` mit `main.tf`, `variables.tf`, `outputs.tf`, `versions.tf`.
2. `main.tftest.hcl` mit mindestens einem `plan`-Run (Vorlage siehe bestehende Module).
3. Passende Unit unter `units/<name>/terragrunt.hcl` anlegen.
4. Falls fachlich sinnvoll: Unit in einen bestehenden oder neuen Stack aufnehmen.

---

## Versionierung

Konsumenten pinnen per `ref` in `catalog.hcl` auf Branch, Tag oder Commit-SHA.
Änderungen, die bestehende Stack-Interfaces brechen (entfernte/umbenannte
`values.*`-Felder, geänderte Pflichtfelder in Units), sind Breaking Changes
und sollten per Tag sichtbar gemacht werden.
