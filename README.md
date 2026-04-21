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

Unter einer Management-Group liegen ein oder mehrere **Komponenten-Stacks** —
jede Komponente bekommt ein eigenes Unterverzeichnis mit eigener
`terragrunt.stack.hcl`:

```
tenant/modellrechner/
├── managementgroup.hcl
├── workload.hcl
├── container_app_environment/
│   └── terragrunt.stack.hcl   # Komponente "cae"
└── container_app_gatus/
    └── terragrunt.stack.hcl   # Komponente "gatus"
```

Jede solche Datei liest die gemeinsamen Locals aus `workload.hcl` (Stacks
unterstützen kein `include`), setzt den `component_name` und definiert
**mehrere `stack`-Blöcke** — einen je Stage (dev, prod, …) — die denselben
Catalog-Stack referenzieren, aber unterschiedliche `values` liefern:

```hcl
locals {
  workload       = read_terragrunt_config(find_in_parent_folders("workload.hcl"))
  name           = local.workload.locals.name
  location       = local.workload.locals.location
  catalog_url    = local.workload.locals.catalog_url
  catalog_ref    = local.workload.locals.catalog_ref
  component_name = "cae"
}

stack "dev" {
  source = "${local.catalog_url}//stacks/container_app_environment?ref=${local.catalog_ref}"
  path   = "dev"
  values = {
    name                     = local.component_name
    location                 = local.location
    resource_group_name      = "rg-${local.name}-dev-${local.component_name}"
    uami_resource_group_name = "rg-${local.name}-dev-${local.component_name}-uami"
    infrastructure_subnet_id = "/subscriptions/…/subnets/snet-cae-dev"
  }
}

stack "prod" {
  source = "${local.catalog_url}//stacks/container_app_environment?ref=${local.catalog_ref}"
  path   = "prod"
  values = {
    name                     = local.component_name
    location                 = local.location
    resource_group_name      = "rg-${local.name}-prod-${local.component_name}"
    uami_resource_group_name = "rg-${local.name}-prod-${local.component_name}-uami"
    infrastructure_subnet_id = "/subscriptions/…/subnets/snet-cae-prod"
  }
}
```

Welche Stages angelegt werden, entscheidet jede Komponente selbst — es ist
nicht erforderlich, alle in `managementgroup.hcl` definierten Stages zu
instanziieren.

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
