# How this FCJ Hugo theme works

## Main folders

- `config.toml`: site URL, languages, title, theme options, and shortcut links.
- `content/`: Markdown pages. Folder names and `weight` values control the sidebar.
- `static/images/`: screenshots and architecture diagrams referenced as
  `/images/file-name.png`.
- `layouts/partials/`: local overrides for theme components such as the sidebar logo
  and footer.
- `static/css/theme-workshop.css`: the AWS workshop color variant.
- `themes/hugo-theme-learn/`: the reusable Hugo Learn theme.
- `.github/workflows/hugo.yaml`: GitHub Pages build and deployment.

## Page front matter

Each page starts with metadata:

```yaml
---
title: "Page title"
weight: 1
chapter: false
pre: "<b>1.</b>"
---
```

`weight` determines order. A folder `_index.md` represents the section itself.
Translations use the same path and add a language suffix, for example
`_index.vi.md`.

## Useful shortcodes

```text
{{% notice info %}}
Important information.
{{% /notice %}}
```

The Learn theme also supports `warning`, `tip`, `note`, tabs, attachments,
search, visited links, and automatic previous/next navigation.

## Images

Store images below `static/images/` and reference them from Markdown:

```markdown
![Description](/images/example.png)
```

Use lowercase file names without spaces. Linux and GitHub Pages paths are
case-sensitive.

## Vendored dependency note

The unused theme `exampleSite/` is intentionally omitted. The legacy jQuery
3.3.1 asset was replaced with the compatible current 3.x build, jQuery 3.7.1,
downloaded from `https://code.jquery.com/jquery-3.7.1.min.js`.

SHA-256: `fc9a93dd241f6b045cbff0481cf4e1901becd0e12fb45166a8f17f95823f0b1a`

`static/js/hugo-learn.js` also includes a defensive guard for images whose URL has
no query string; this prevents the legacy theme code from reading a property from
`undefined` during page load.

