# Foundation Stack

**Canonical URL:** https://fs.guanglab.org/

Public 52-week series on adolescent PPCS aerobic prescription. **Not** hosted on `projects.guanglab.org` (confidential dissertation / advisor operations).

## Deploy

```bash
cd guanglab/foundation-stack
bash deploy.sh
```

## First-time server setup

1. **DNS:** `fs.guanglab.org` → same A record as `guanglab.org`
2. **Directory:** `mkdir -p /home/ubuntu/projects/guanglab/foundation-stack`
3. **Nginx:** copy `nginx/fs.guanglab.org.conf` → `/etc/nginx/sites-available/`, enable, `nginx -t && systemctl reload nginx`
4. **TLS:** `sudo certbot --nginx -d fs.guanglab.org` (expand cert SAN if needed)
5. **Legacy redirect:** enable `foundation-stack-redirect` snippet on `guanglab.org` (see `nginx/guanglab-redirect-foundation-stack.conf`)

## New week

1. Copy `posts/2026-w01-adherence-reporting-gap/` → `posts/2026-wNN-<slug>/`
2. Edit YAML + six sections
3. `bash deploy.sh`
4. Bump progress on `index.qmd` if needed

## Repo layout

```text
guanglab/foundation-stack/
├── _quarto.yml
├── index.qmd
├── about.qmd
├── resources/
├── posts/2026-wNN-<slug>/index.qmd
└── deploy.sh
```
