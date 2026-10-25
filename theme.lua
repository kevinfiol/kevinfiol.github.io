local plugin = fs.doThemeFile("theme/plugins.lua")

-- make theme/lexers/*.lua to highlightSyntax(), taking precedence over built-in lexers
plugin.addLexerPath("theme/lexers")

local site = {
  title = "kevin f.",
  url = "https://kevinfiol.com/",
}

return {
  -- read from content/ dir, and static/ dir straight -> output dir
  readFromSource("content"),
  readFromSource("static"),

  -- add empty items for pages with no source file; their templates fill them in below
  injectFiles({ ["404.html"] = "" }),

  -- for posts, set `date` ("2019-05-18") and `file` ("2019-05-18-foo.md") from the filename
  plugin.dateFromFilename("^blog/.+%.md$"),

  -- parse frontmatter into item fields, convert Markdown to HTML, and rename *.md to *.html
  -- in our case, the only *.md files we process are the ones we read earlier in `readFromSource("content")`
  processMarkdown(),

  -- enable syntax highlighting; alias `js` to `jsx` lexer, and `ts` to `typescript` lexer
  highlightSyntax({ aliases = { js = "jsx", ts = "typescript" } }),

  -- add table of contents for each page, and add "#" anchor links to headings in blog posts
  plugin.headings("%.html$", { file_match = "^blog/" }),

  -- move pages to pretty URL paths ("blog/2019-05-18-foo.html" -> "blog/foo/index.html", "about.html" -> "about/index.html")
  plugin.prettyUrls(function (item) return string.find(item.path, "%.html$") and item.path ~= "404.html" end),

  -- create the home page, archive, and feed, each with an `items` list of all blog posts
  -- `items` gets passed to whatever template is used to build the respective file (see below `applyTemplates` call)
  -- note: since at this point we've already processed the markdown -> html, and used prettyUrls, we look for blog/**/index.htmls
  aggregate("index.html", "^blog/.+/index%.html$"),
  aggregate("archive/index.html", "^blog/.+/index%.html$"),
  aggregate("atom.xml", "^blog/.+/index%.html$"),

  -- set the archive's <title>
  injectMetadata({ title = "archive" }, "^archive/index%.html$"),

  -- make site info and helper functions available to every template
  injectMetadata({
    site = site,
    sortedPosts = plugin.sortedPosts,
    formatDate = plugin.formatDate
  }),

  -- render the feed first, on its own, so the HTML templates below never apply to it
  applyTemplates({ { "^atom%.xml$", fs.readThemeFile("theme/templates/atom.etlua") } }),

  -- render each page's body; the last matching pattern wins, so page.etlua is the default.
  applyTemplates({
    { "%.html$", fs.readThemeFile("theme/templates/page.etlua") },
    { "^blog/.+/index%.html$", fs.readThemeFile("theme/templates/post.etlua") },
    { "^index%.html$", fs.readThemeFile("theme/templates/index.etlua") },
    { "^archive/index%.html$", fs.readThemeFile("theme/templates/archive.etlua") },
    { "^404%.html$", fs.readThemeFile("theme/templates/404.etlua") },

    -- render the resume markdown directly without a template
    { "^resume/index%.html$", "<%- content %>" }
  }),

  -- apply layout templates
  applyTemplates({
    { "%.html$", fs.readThemeFile("theme/templates/base.etlua") },
    { "^resume/index%.html$", fs.readThemeFile("theme/templates/resume.etlua") }
  }),

  -- write every item to public/ at its path
  writeToDestination("public"),
}
