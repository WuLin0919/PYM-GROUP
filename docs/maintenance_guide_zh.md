# PYM Group 网站维护指南

## 1. 最重要的原则

网站真正读取的是 `_data` 文件夹中的 YAML 文件：

- 成员：`_data/members.yml`
- 论文：`_data/publications.yml`
- 个人简介、教育经历、奖励与学术服务：`_data/profile.yml`
- 首页设置：`_data/site_settings.yml`

`source_data/members/group_members_master.xlsx` 是便于集中填写和核对的成员主表，
`source_data/publications/web_of_science_publications.xls` 是 Web of Science 原始记录。
修改 Excel 不会自动更新网站；最终仍需把确认后的信息写入相应 YAML 文件。

## 2. 增加或修改成员

### 2.1 放置位置

打开 `_data/members.yml`，将新成员放入对应类别。类别名称必须完全采用以下写法：

- `Current Graduate Student`：现有博士生
- `Current Postdoctoral Researcher`：现有博士后
- `Ph.D. Graduate`：毕业博士
- `Master's Graduate`：毕业硕士
- `Former Postdoctoral Researcher`：出站博士后

同一类别内，现有成员一般按入组年份从早到晚排列；毕业成员一般按毕业年份从近到远排列。

### 2.2 字段说明

```yaml
- category: Current Graduate Student
  name: English Name
  name_zh: 中文姓名
  link: https://orcid.org/xxxx-xxxx-xxxx-xxxx
  undergraduate: Official English Name of University
  masters: Official English Name of University
  degree: Ph.D.
  period: 2026–Present
  destination: Official English Name of Current Affiliation
```

- `category`、`name`、`name_zh`、`period` 为基本字段。
- `link` 可省略；优先使用学院官方主页或 ORCID，其次使用可靠的学术主页。
- `undergraduate` 为本科院校，`masters` 为硕士院校，`doctoral` 为博士毕业院校。
- 现有或出站博士后只需填写 `doctoral`。
- 毕业博士默认博士院校为北京大学；数据中可以保留 `doctoral: Peking University`，页面不重复显示。
- `destination` 表示当前工作单位或正式去向，没有可靠信息时直接省略，不要填写猜测内容。
- 时间区间使用半角数字和 en dash：`2021–2026`、`2026–Present`。
- 院校和机构名称使用官网的正式英文全称。

可直接复制 `docs/templates/member_entry.yml` 中的相应模板。

## 3. 增加论文

打开 `_data/publications.yml`，复制 `docs/templates/publication_entry.yml`，填写后放到相应年份附近。

```yaml
- number: 1
  date: 2026-01-15
  date_display: "Jan 15"
  title: "Article title in sentence case"
  journal: "Official Journal Title"
  volume: "83"
  issue: "1"
  pages: "102451"
  doi: "10.xxxx/xxxxx"
  first_author: true
  corresponding: true
```

填写规则：

- `date` 必须使用 `YYYY-MM-DD`，优先采用在线发表日期；没有在线发表日期时使用卷期发表日期。
- `date_display` 使用英文月份缩写和两位日期，例如 `Jan 05`。
- 标题使用 sentence case，仅首词、专有名词和缩写保留大写；DOI、Tb、Dy、Fe、Co、GFRP 等缩写不得改写。
- `journal` 使用期刊官网的正式名称和标点。
- `doi` 只填写 DOI，不要加入 `https://doi.org/`。
- 没有卷、期或页码时，直接省略对应字段。
- 只有裴永茂确为第一作者时才加入 `first_author: true`。
- 只有来源明确标注裴永茂为通讯作者时才加入 `corresponding: true`。
- 会议论文及没有 DOI 的记录暂不新增，除非后续另有要求。

### 3.1 自动重新编号

每年从最早论文开始编号为 1，页面会自动把该年最新论文放在最下面。新增论文后在 PowerShell 中运行：

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\scripts\renumber_publications.ps1
```

脚本会按照日期为每一年重新生成连续编号，不改变论文内容。

### 3.2 核对期刊名称

需要通过 Crossref 核对 DOI 对应的正式期刊名称时运行：

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\scripts\update_journal_names_from_crossref.ps1
```

该步骤需要联网。执行后应再次检查少数中文期刊、改名期刊及带冒号的期刊名称。

## 4. 图片材料

- 正式头像：`assets/images/photos/`
- 正式校徽：`assets/images/badges/`
- 未处理原始图片：`source_materials/`

网页中只引用 `assets/images` 下的正式文件。新增图片时使用简洁的小写英文文件名，单词之间用下划线连接。

## 5. 文件夹说明

- `_data/`：网站内容数据，日常维护重点
- `_includes/`：成员、论文、简介等页面模块
- `assets/`：样式和网站正式图片
- `scripts/`：论文数据维护脚本
- `source_data/`：成员主表和 Web of Science 原始记录
- `source_materials/`：未经处理的原始图片材料
- `archive/`：历史表格、预览图和检查记录，仅用于追溯
- `docs/`：维护说明和可复制模板

## 6. 修改后的快速检查

1. 确认 YAML 每一层使用空格缩进，不使用 Tab。
2. 确认英文引号成对，DOI 没有多余空格。
3. 确认同一年论文编号从 1 连续递增。
4. 确认姓名、院校、期刊和去向采用官方英文。
5. 提交 GitHub 时，在 Summary 中用一句简短英文概括本次修改。
