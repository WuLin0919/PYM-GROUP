# PYM Group Website

This repository contains the Jekyll source for the PYM Group academic website.

## Common updates

- Personal profile, education, experience, awards, and service: `_data/profile.yml`
- Group members: `_includes/widgets/group_members_card.html`
- Publications displayed on the homepage: `_data/news.yml`
- Homepage section visibility and publication count: `_data/display.yml`
- Navigation: `_data/navigation.yml`
- Global styles: `assets/css/global.css`

## Publication data

The original Web of Science export is stored at `source_data/publications/savedrecs.xls`.

Each year in `_data/news.yml` is numbered independently. Within a year, entries are displayed from the earliest publication at the top to the latest publication at the bottom. Set `first_author: true` only when Yongmao Pei is listed first in the source record, and set `corresponding: true` only when the source record explicitly identifies him as a corresponding author.

After adding DOI-based records, run `scripts/sync_journal_titles.ps1` to retrieve the publisher-deposited journal titles from Crossref. The script preserves official punctuation and capitalization, applies verified title overrides, and leaves non-journal conference records unchanged.

## Images

- Website-ready portraits: `assets/images/photos/`
- Website-ready university logos: `assets/images/badges/`
- Unmodified local source images: `source_materials/` (excluded from the Jekyll build and Git tracking)

## Local build

```bash
bundle install
bundle exec jekyll serve
```

The deployed site uses the base URL configured in `_config.yml`.
