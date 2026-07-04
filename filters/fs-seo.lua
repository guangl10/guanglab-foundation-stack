-- Foundation Stack posts: Google Scholar meta, canonical URL, JSON-LD (ScholarlyArticle)

local default_canonical_base = "https://fs.guanglab.org"
local schema_keywords =
  "adolescent PPCS, aerobic exercise prescription, post-concussive symptoms"
local description_phrase = "adolescent PPCS aerobic exercise prescription"

local function is_fs_post()
  local input = quarto.doc.input_file or ""
  return input:find("/posts/", 1, true) ~= nil or input:match("^posts/") ~= nil
end

local function canonical_base(doc_meta)
  local cfg = doc_meta and doc_meta["fs-seo"]
  if cfg and cfg["canonical-base"] then
    return pandoc.utils.stringify(cfg["canonical-base"])
  end
  return default_canonical_base
end

local function page_path()
  local input = quarto.doc.input_file or ""
  local path = input:gsub("^.*/posts/", "posts/"):gsub("index%.qmd$", ""):gsub("%.qmd$", "")
  if not path:match("/$") then
    path = path .. "/"
  end
  return path
end

local function page_url(doc_meta)
  return canonical_base(doc_meta) .. "/" .. page_path()
end

local function escape_html(s)
  return (s or "")
    :gsub("&", "&amp;")
    :gsub("<", "&lt;")
    :gsub(">", "&gt;")
    :gsub('"', "&quot;")
end

local function escape_json(s)
  return (s or ""):gsub("\\", "\\\\"):gsub('"', '\\"'):gsub("\n", "\\n")
end

local function meta_string(val)
  if not val then
    return ""
  end
  return pandoc.utils.stringify(val)
end

local function article_description(meta)
  local desc = meta_string(meta.description)
  if desc == "" then
    desc =
      "Educational synthesis on adolescent PPCS aerobic exercise prescription. Not medical advice."
  elseif not desc:lower():find(description_phrase, 1, true) then
    desc = desc .. " — adolescent PPCS aerobic exercise prescription."
  end
  return desc
end

function Pandoc(doc)
  if not is_fs_post() then
    return doc
  end

  local title = meta_string(doc.meta.title)
  local date = meta_string(doc.meta.date)
  local url = page_url(doc.meta)
  local desc = article_description(doc.meta)

  quarto.doc.add_html_dependency({
    name = "fs-scholarly-meta",
    meta = {
      ["citation_title"] = title,
      ["citation_author"] = "Guang Li",
      ["citation_publication_date"] = date,
      ["citation_online_date"] = date,
      ["citation_url"] = url,
    },
    head = string.format('<link rel="canonical" href="%s">', escape_html(url)),
  })

  local json_ld = string.format(
    [[<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "ScholarlyArticle",
  "headline": "%s",
  "author": {"@type": "Person", "name": "Guang Li"},
  "datePublished": "%s",
  "url": "%s",
  "description": "%s",
  "keywords": "%s"
}
</script>]],
    escape_json(title),
    escape_json(date),
    escape_json(url),
    escape_json(desc),
    escape_json(schema_keywords)
  )

  table.insert(doc.blocks, pandoc.RawBlock("html", json_ld))
  return doc
end
