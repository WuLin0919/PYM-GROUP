# PYM Group Website

This repository contains the Jekyll source for the PYM Group academic website.

For step-by-step instructions in Chinese, see [`docs/maintenance_guide_zh.md`](docs/maintenance_guide_zh.md).

## Common updates

- Personal profile, education, experience, awards, and service: `_data/profile.yml`
- Homepage settings: `_data/site_settings.yml`
- Group member names, links, previous education, periods, and destinations: `_data/members.yml`
- Publications displayed on the homepage: `_data/publications.yml`
- Profile card: `_includes/widgets/profile_card.html`
- Profile biography: `_includes/widgets/profile_bio_card.html`
- Education, experience, awards, and service card: `_includes/widgets/academic_profile_card.html`
- Group members: `_includes/widgets/group_members_card.html`
- Publications card: `_includes/widgets/publications_card.html`
- Navigation: `_data/navigation.yml`
- Global styles: `assets/css/global.css`

## Data sources

- Editable member reference workbook: `source_data/members/group_members_master.xlsx`
- Original Web of Science export: `source_data/publications/web_of_science_publications.xls`
- Historical spreadsheet outputs and previews: `archive/member_workbook_history/`

Source spreadsheets do not update the website automatically. Confirmed changes must be transferred to
`_data/members.yml` or `_data/publications.yml`.

## Publication data

The original Web of Science export is stored at `source_data/publications/web_of_science_publications.xls`.

Each year in `_data/publications.yml` is numbered independently. Within a year, entries are displayed from the earliest publication at the top to the latest publication at the bottom. Set `first_author: true` only when Yongmao Pei is listed first in the source record, and set `corresponding: true` only when the source record explicitly identifies him as a corresponding author.

After adding records, run `scripts/renumber_publications.ps1` to regenerate the annual numbering.

After adding DOI-based records, run `scripts/update_journal_names_from_crossref.ps1` to retrieve the publisher-deposited journal titles from Crossref. The script preserves official punctuation and capitalization, applies verified title overrides, and leaves non-journal conference records unchanged.

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
