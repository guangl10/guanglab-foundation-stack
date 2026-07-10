-- Rewrite cross-post links to absolute URLs so RSS/index.xml and bots resolve correctly.

local default_canonical_base = "https://fs.guanglab.org"

local function canonical_base()
  local cfg = quarto.doc.metadata and quarto.doc.metadata["fs-seo"]
  if cfg and cfg["canonical-base"] then
    return pandoc.utils.stringify(cfg["canonical-base"])
  end
  return default_canonical_base
end

local function fix_cross_post_url(url)
  if type(url) ~= "string" or url:match("^https?://") then
    return url
  end
  local slug = url:match("(pillar2%-%d+%-[%w%-]+)")
  if not slug then
    return url
  end
  return canonical_base() .. "/posts/" .. slug .. "/"
end

function Link(el)
  el.target = fix_cross_post_url(el.target)
  return el
end

function Image(el)
  el.src = fix_cross_post_url(el.src)
  return el
end
