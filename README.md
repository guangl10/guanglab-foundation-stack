# Foundation Stack

**Canonical URL:** https://fs.guanglab.org/

Public series on adolescent PPCS aerobic prescription. **Not** hosted on `projects.guanglab.org` (confidential dissertation / advisor operations).

## Local

```bash
cd ~/Documents/guanglab-foundation-stack
quarto render
bash deploy.sh
```

## Server setup

1. **DNS:** `fs.guanglab.org` → same A record as `guanglab.org`
2. **Directory:** `mkdir -p /home/ubuntu/projects/guanglab/foundation-stack`
3. **Nginx:** copy `nginx/fs.guanglab.org.conf` → `/etc/nginx/sites-available/`, enable, `nginx -t && systemctl reload nginx`
4. **TLS:** `sudo certbot --nginx -d fs.guanglab.org` (expand cert SAN if needed)
5. **Legacy redirect:** enable `foundation-stack-redirect` snippet on `guanglab.org` (see `nginx/guanglab-redirect-foundation-stack.conf`)

## New installment

1. Copy `posts/pillar2-001-six-protocols-comparison/` → `posts/pillar{N}-{seq}-{slug}/`
2. YAML: `installment`, `pillar`, `audience`, `date`, `title`, `description`
3. `quarto render` then `bash deploy.sh`

## Layout

```
├── index.qmd          # Hub + listing
├── posts/pillar{N}-{seq}-{slug}/index.qmd
├── filters/fs-seo.lua
└── deploy.sh
```
