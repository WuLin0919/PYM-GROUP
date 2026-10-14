# PYM Group Gallery Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add a dedicated, responsive Gallery page that keeps the existing teacher profile card on the left and displays three group activity photos from newest to oldest on the right.

**Architecture:** Gallery content is data-driven through `_data/gallery.yml`. A focused Liquid include renders the right-column gallery, while `gallery.html` reuses the existing default layout and profile card. Optimized JPEG assets live under `assets/images/gallery/`, and a small CSS block supplies card-specific presentation without changing the homepage.

**Tech Stack:** Jekyll, Liquid, YAML, Bootstrap 4.6, site CSS, Pillow for lossless-or-quality-controlled asset preparation.

---

### Task 1: Prepare web gallery assets

**Files:**
- Create: `assets/images/gallery/fenghuangling-hike-2026-09-20.jpg`
- Create: `assets/images/gallery/xiangshan-hike-2026-05-09.jpg`
- Create: `assets/images/gallery/mount-tai-hike-2025-03-29.jpg`

- [ ] **Step 1: Confirm the source files and dimensions**

Run a Pillow inspection against the three PNG files in the parent directory.

Expected: three images at approximately `5760 × 4320`, each larger than 30 MB.

- [ ] **Step 2: Create optimized JPEG copies**

Use Pillow with EXIF orientation correction, a maximum width of 2400 px, RGB conversion, progressive JPEG output, optimization enabled, and quality 86. Map the source files as follows:

```text
课题组相册_03.png -> fenghuangling-hike-2026-09-20.jpg
课题组相册_02.png -> xiangshan-hike-2026-05-09.jpg
课题组相册_01.png -> mount-tai-hike-2025-03-29.jpg
```

Do not modify the source PNG files.

- [ ] **Step 3: Verify the generated files**

Run a Pillow inspection and verify that all three outputs are JPEG files, no wider than 2400 px, and smaller than their source PNG files.

- [ ] **Step 4: Commit the assets**

```powershell
git add assets/images/gallery
git commit -m "Add optimized group gallery photos"
```

### Task 2: Add gallery data and navigation

**Files:**
- Create: `_data/gallery.yml`
- Modify: `_data/navigation.yml`

- [ ] **Step 1: Verify the gallery data does not yet exist**

Run: `Test-Path _data/gallery.yml`

Expected: `False`.

- [ ] **Step 2: Add the three gallery records**

Create `_data/gallery.yml` with these exact fields and reverse-chronological records:

```yaml
- date: 2026-09-20
  date_display: "Sep 20, 2026"
  title: "Hiking at Beijing Fenghuangling Scenic Area"
  image: "/assets/images/gallery/fenghuangling-hike-2026-09-20.jpg"
  alt: "PYM Group members hiking at Beijing Fenghuangling Scenic Area"
- date: 2026-05-09
  date_display: "May 9, 2026"
  title: "Classic Xiangbala Hiking Route at Beijing Xiangshan Park"
  image: "/assets/images/gallery/xiangshan-hike-2026-05-09.jpg"
  alt: "PYM Group members on the classic Xiangbala hiking route at Beijing Xiangshan Park"
- date: 2025-03-29
  date_display: "Mar 29, 2025"
  title: "Mount Tai Hiking Trip, Tai’an, Shandong"
  image: "/assets/images/gallery/mount-tai-hike-2025-03-29.jpg"
  alt: "PYM Group members during a hiking trip to Mount Tai in Tai’an, Shandong"
```

- [ ] **Step 3: Add Gallery after Home in navigation**

Update `_data/navigation.yml` to contain:

```yaml
pages:
- name: Home
  url: /
- name: Gallery
  url: /gallery.html
```

- [ ] **Step 4: Verify order and dates**

Use a PowerShell check to confirm navigation is `Home, Gallery` and gallery dates are `2026-09-20, 2026-05-09, 2025-03-29`.

- [ ] **Step 5: Commit data and navigation**

```powershell
git add _data/gallery.yml _data/navigation.yml
git commit -m "Add gallery content and navigation"
```

### Task 3: Build the Gallery page and renderer

**Files:**
- Create: `_includes/widgets/gallery_card.html`
- Create: `gallery.html`

- [ ] **Step 1: Verify the page and renderer do not yet exist**

Run: `Test-Path gallery.html; Test-Path _includes/widgets/gallery_card.html`

Expected: both values are `False`.

- [ ] **Step 2: Create the gallery renderer**

Create `_includes/widgets/gallery_card.html` that sorts `site.data.gallery` by `date`, reverses the result, and renders each item as an `<article>` containing a local image, `<h2>` title, and semantic `<time datetime="...">` date.

- [ ] **Step 3: Create the dedicated page**

Create `gallery.html` with front matter `layout: default`, `title: Gallery`, `browser_title: Gallery | PYM Group`, and `navbar_title: Gallery`. Reuse the same left and right Bootstrap column classes as `index.html`, include `widgets/profile_card.html` on the left, and include `widgets/gallery_card.html` on the right.

- [ ] **Step 4: Verify structural requirements**

Confirm `gallery.html` contains the unchanged profile-card include and gallery-card include, and confirm the renderer includes the sort/reverse pipeline plus semantic image and time fields.

- [ ] **Step 5: Commit the page structure**

```powershell
git add gallery.html _includes/widgets/gallery_card.html
git commit -m "Add data-driven gallery page"
```

### Task 4: Add responsive gallery styling

**Files:**
- Modify: `assets/css/global.css`

- [ ] **Step 1: Confirm no gallery-specific styles exist**

Run: `rg -n "gallery-" assets/css/global.css`

Expected: no matches.

- [ ] **Step 2: Add focused gallery styles**

Append styles for `.gallery-shell`, `.gallery-item`, `.gallery-image`, `.gallery-meta`, `.gallery-title`, and `.gallery-date`. Use the existing card radius and shadow language, `width: 100%`, `height: auto`, and `display: block` for uncropped responsive images. Add a mobile media query below 576 px that reduces card and heading spacing.

- [ ] **Step 3: Verify overflow protections**

Confirm the CSS contains `max-width: 100%`, `height: auto`, and mobile rules, with no fixed image width or fixed image height.

- [ ] **Step 4: Commit styling**

```powershell
git add assets/css/global.css
git commit -m "Style responsive gallery cards"
```

### Task 5: Document gallery maintenance

**Files:**
- Modify: `README.md`
- Modify: `docs/maintenance_guide_zh.md`

- [ ] **Step 1: Add repository pointers**

Document `_data/gallery.yml`, `gallery.html`, `_includes/widgets/gallery_card.html`, and `assets/images/gallery/` in the README.

- [ ] **Step 2: Add Chinese maintenance instructions**

Add a concise section explaining the four gallery fields, English filenames, reverse-chronological display, source-image preservation, and web-image optimization.

- [ ] **Step 3: Verify documentation references**

Run `rg -n "gallery.yml|images/gallery|Gallery" README.md docs/maintenance_guide_zh.md` and confirm both files cover future additions.

- [ ] **Step 4: Commit documentation**

```powershell
git add README.md docs/maintenance_guide_zh.md
git commit -m "Document gallery maintenance"
```

### Task 6: Validate the completed feature

**Files:**
- Verify all gallery files and existing site files.

- [ ] **Step 1: Run static content checks**

Use PowerShell assertions to verify three gallery entries, unique local image paths, descending dates, navigation order, page includes, active navbar title, and alt text.

- [ ] **Step 2: Run asset checks**

Use Pillow to open every referenced image and verify JPEG format, width at most 2400 px, positive dimensions, and file size under 5 MB.

- [ ] **Step 3: Run repository checks**

Run `git diff --check` and inspect `git status --short`. Do not stage or commit unrelated pre-existing publication changes.

- [ ] **Step 4: Review the final diff against the design**

Confirm `Home` precedes `Gallery`, the left profile card include is unchanged, the right column contains only the gallery, and the records appear newest to oldest.
