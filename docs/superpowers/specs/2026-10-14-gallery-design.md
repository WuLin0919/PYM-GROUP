# PYM Group Gallery Design

## Goal

Add a dedicated gallery page to the PYM Group website while preserving the existing teacher profile card on the left. The gallery occupies the right column and presents group activity photos as individual cards in reverse chronological order.

## Navigation

- Add `Gallery` to the primary navigation.
- Keep the navigation order as `Home`, then `Gallery`.
- Highlight `Gallery` while the gallery page is active.

## Page Structure

- Create a dedicated `gallery.html` page using the existing default layout.
- Reuse `_includes/widgets/profile_card.html` in the left column without changing its content or styling.
- Use the existing responsive column proportions: `col-lg-3 col-md-4` on the left and `col-lg-9 col-md-8` on the right.
- Render the gallery in a white, rounded, shadowed container consistent with the existing site cards.

## Gallery Cards

- Display one photo per card so that people and the embedded event text remain legible.
- Preserve each image's full aspect ratio and avoid cropping.
- Place an English event title and formatted date below each image.
- Sort all gallery entries by date from newest to oldest.
- Stack cards vertically on desktop and mobile; images scale to the available width.

## Initial Content

1. `2026-09-20` — **Hiking at Beijing Fenghuangling Scenic Area**
2. `2026-05-09` — **Classic Xiangbala Hiking Route at Beijing Xiangshan Park**
3. `2025-03-29` — **Mount Tai Hiking Trip, Tai’an, Shandong**

## Data and Assets

- Copy optimized web versions of the three source photos into `assets/images/gallery/` using lowercase English filenames.
- Keep the original source photos in the parent folder unchanged.
- Store gallery metadata in `_data/gallery.yml` so future photos can be added without editing page markup.
- Each entry contains `date`, `title`, `image`, and `alt` fields.

## Responsive and Accessibility Requirements

- Use descriptive English alternative text for every photo.
- Keep dates machine-readable in YAML and display them in an English month-day-year format.
- Ensure images never overflow the right column.
- Preserve readable spacing and card separation at mobile widths.

## Verification

- Confirm navigation order and active-page highlighting.
- Confirm the left profile card is unchanged.
- Confirm all three images load from local site assets.
- Confirm the displayed order is September 2026, May 2026, then March 2025.
- Confirm the page contains no horizontal overflow at desktop or mobile widths.
- Run repository checks available in the local environment and inspect the final diff for unrelated changes.
