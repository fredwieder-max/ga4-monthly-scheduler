#!/usr/bin/env bash
# Vérification du projet : renvoie 0 si tout est valide, 1 sinon (avec la liste des erreurs).
# Utilisé à la main, par le skill /boucle-correction et par le hook d'arrêt.
set -u
cd "$(dirname "$0")/.."

python3 - <<'PY'
import glob, sys, yaml

errors = []
files = sorted(glob.glob(".github/workflows/*.yml") + glob.glob(".github/workflows/*.yaml"))
if not files:
    errors.append("Aucun workflow trouvé dans .github/workflows/")

for path in files:
    try:
        with open(path, encoding="utf-8") as f:
            doc = yaml.safe_load(f)
    except yaml.YAMLError as e:
        errors.append(f"{path}: YAML invalide : {str(e).splitlines()[0]} ({getattr(e, 'problem_mark', '')})")
        continue
    if not isinstance(doc, dict):
        errors.append(f"{path}: le fichier doit contenir un dictionnaire YAML")
        continue
    # PyYAML lit la clé « on » comme le booléen True
    on = doc.get("on", doc.get(True))
    if on is None:
        errors.append(f"{path}: clé 'on' manquante")
    jobs = doc.get("jobs")
    if not isinstance(jobs, dict) or not jobs:
        errors.append(f"{path}: clé 'jobs' manquante ou vide")
        continue
    for name, job in jobs.items():
        if not isinstance(job, dict):
            errors.append(f"{path}: le job '{name}' est mal formé")
            continue
        if "runs-on" not in job:
            errors.append(f"{path}: job '{name}' sans 'runs-on'")
        steps = job.get("steps")
        if not isinstance(steps, list) or not steps:
            errors.append(f"{path}: job '{name}' sans 'steps'")
            continue
        for i, step in enumerate(steps, 1):
            if "run" not in step and "uses" not in step:
                errors.append(f"{path}: job '{name}', étape {i} sans 'run' ni 'uses'")
    if isinstance(on, dict) and "schedule" in on:
        for item in on["schedule"] or []:
            if not isinstance(item, dict) or "cron" not in item:
                errors.append(f"{path}: entrée 'schedule' sans 'cron'")

if errors:
    print("ÉCHEC :")
    for e in errors:
        print(" -", e)
    sys.exit(1)
print(f"OK : {len(files)} workflow(s) valide(s)")
PY
