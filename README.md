# PrivaSuite website

Static home, support, and legal pages for PrivaAssist, PrivaPage, PrivaMeet, and PrivaStudy,
served at **https://privasuite.harrisonsmith.ai** by GitHub Pages. Plain HTML and CSS: no build
step, no framework, no dependencies, nothing loaded from third parties.

| Page | File | URL | App Store Connect field |
|---|---|---|---|
| Home | `index.html` | `/` | Marketing URL (optional) |
| Support | `support/index.html` | `/support/` | **Support URL** (all four apps; per-app anchors `#privapage` etc.) |
| Privacy Policy | `privacy/index.html` | `/privacy/` | **Privacy Policy URL** (all four apps; per-app anchors) |
| Terms of Use | `terms/index.html` | `/terms/` | License Agreement / EULA link |
| Not found | `404.html` | any missing page | |

## Editing

Edit the HTML directly. Preview with `python3 -m http.server 4173` and open
http://localhost:4173. Paths are relative (`assets/style.css` at the root, `../assets/style.css`
in subfolders) so pages also work from disk; `404.html` uses absolute URLs because GitHub serves
it at any depth.

Repeated across pages (edit every page when they change): the header and footer, the support
email `support@harrisonsmith.ai`, and the effective date on the privacy and terms pages.

The privacy policy describes what each app actually does (on-device models, which hosts models
download from, permissions, PrivaAssist's optional hosted models). When an app gains a network
call, a permission, or a data store, update its section here **before** that version ships, and
keep it consistent with the app's `PrivacyInfo.xcprivacy` and App Store privacy label.

## Hosting

GitHub Pages from `main` at `/`, custom domain in `CNAME`. DNS: a `CNAME` record
`privasuite` → `hsmith-dev.github.io` at the `harrisonsmith.ai` registrar.
