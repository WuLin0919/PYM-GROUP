# Publication author data sources

- The 186 original records use the author order and full names in `source_data/publications/web_of_science_publications.xls`. Records without a DOI were matched by their exact title (case-insensitive).
- The two later additions, DOI `10.1016/j.tws.2026.115754` and `10.1016/j.apm.2026.117418`, use the publisher screenshots supplied with those additions, including the corresponding-author icons.
- Names are displayed as surname plus given-name initials. Hyphenated Chinese given names are treated as one name. Where the source supplies initials only, those initials are preserved.
- Corresponding authors are identified from the WoS Reprint Addresses field. The previously verified paper-level classification of Yongmao Pei is retained.
- In DOI `10.3390/ma19081613`, WoS abbreviates both Haitao Wang and Hongtao Wang as `Wang, HT`. The [publisher page](https://www.mdpi.com/1996-1944/19/8/1613) resolves this: Hongtao Wang (author 6) and Yongmao Pei are corresponding authors.
- WoS does not provide an equal-contribution field. The template supports `equal_contribution: true`; no equal-contribution flags have been inferred from author order or the paper-level first-author flag. The MDPI page marks its first two authors with a separate symbol, but the explanatory footnote could not be retrieved; those flags remain pending explicit verification.

`scripts/prepare_publication_authors.py` records the original import logic. It is a read-only patch generator requiring `xlrd` and `PyYAML`; it refuses to append authors to already populated records.
