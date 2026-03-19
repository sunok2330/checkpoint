# Checkpoint

**讓你的 AI 不再失憶。**

Checkpoint 是一個持久化記憶存檔技能，專為 AI 程式助手設計。它系統性地捕捉成功經驗、失敗嘗試、使用者偏好和專案脈絡 — 讓你的 AI 永遠不會重複解決同一個問題。

[English](README.md)

---

## 問題

AI 程式助手在單次對話中非常聰明 — 但開啟新對話後，一切都忘了：

- **第 1 次對話**：花 30 分鐘發現 API 需要用 site-based 路徑
- **第 2 次對話**：又花 30 分鐘重新發現同樣的事
- **第 3 次對話**：你很挫折，AI 完全「失智」

## 解決方案

Checkpoint 建立一套結構化的持久記憶系統，跨對話保留知識：

```
你：  /checkpoint
AI：  掃描對話中... 發現 3 個新知識：

      1. [已儲存] project_auth_config.md
         - 租戶封鎖 app consent，必須用預授權的 client ID
         - 類型：project

      2. [已儲存] feedback_no_admin.md
         - 永遠不要建議「請找管理員」— 使用者沒有管理員權限
         - 類型：feedback

      3. [已更新] reference_api_paths.md
         - 新增今天發現的端點路徑
         - 類型：reference

      記憶索引已更新。已儲存/更新 3 筆條目。
```

## 運作方式

Checkpoint 以兩層防線運作：

### 主動層：`/checkpoint` 指令
明確觸發完整的知識存檔。AI 會：
1. **掃描**對話中的所有發現
2. **檢查**現有記憶以避免重複
3. **整理** — 修復索引問題（ghost 死連結、orphan 孤立檔案、跨 scope 重複）
4. **儲存**新發現為結構化記憶檔案（或更新已有的同主題記憶）
5. **更新** MEMORY.md 索引
6. **驗證**完整性並報告整理結果

### 記憶整理：`/checkpoint:consolidate`
隨著時間推移，記憶會累積重複和過時的條目。執行 `/checkpoint:consolidate` 做深度維護：
- **重複偵測** — 找到並合併同主題的記憶（需你核准）
- **跨 scope 解決** — 偵測 project 和 global 記憶之間的重複
- **過時偵測** — 標記含過期日期或過時參考的 project 記憶
- **品質檢查** — 找出缺少必要結構（Why/How to apply）的記憶
- **索引修復** — 移除死連結、加入未索引的檔案

### 被動層：Anti-Amnesia Protocol（防失智協議）
一組加入 `CLAUDE.md`（或等效設定檔）的規則，自動執行：
- **工作前**：檢查記憶中的先前發現
- **突破後**：立即儲存，不要等待
- **重試前**：檢查是否已解決 — 不重複探索

## 記憶類型

| 類型 | 用途 | 範例 |
|------|------|------|
| **user** | 你是誰 | 「資深後端工程師，React 新手」 |
| **feedback** | 你糾正了什麼 | 「整合測試不要 mock 資料庫」 |
| **project** | 工作背後的脈絡 | 「Auth 重寫是合規需求，不是技術債」 |
| **reference** | 去哪找東西 | 「Pipeline bug 追蹤在 Linear 專案 INGEST」 |

## 安裝

### Claude Code

```bash
claude install-skill Jyo238/checkpoint
```

安裝內容：
- `/checkpoint` 斜線指令
- `/checkpoint:consolidate` 記憶整理子命令
- AI 遵循的技能定義
- 記憶類型、整理演算法和防失智協議的參考文件

**選用**：將 Anti-Amnesia Protocol 加入專案的 `CLAUDE.md`：

```bash
cat skills/checkpoint/references/anti-amnesia-protocol.md >> CLAUDE.md
```

### Cursor

複製規則檔到專案：

```bash
mkdir -p .cursor/rules
cp cursor/rules/checkpoint.mdc .cursor/rules/
```

### VSCode / GitHub Copilot

複製指令和提示檔：

```bash
cp vscode/instructions/checkpoint.md .github/copilot-instructions.md
cp vscode/prompts/checkpoint.prompt.md .github/prompts/
```

### OpenAI Codex CLI

```bash
cp codex/checkpoint/SKILL.md your-project/
cp .codex/INSTALL.md your-project/.codex/
```

### 手動安裝（任何 AI 工具）

1. 將 `skills/checkpoint/SKILL.md` 的內容複製到你的 AI 工具的系統提示或指令檔中
2. 將 `skills/checkpoint/references/anti-amnesia-protocol.md` 的 Anti-Amnesia Protocol 複製到專案設定中
3. 建立 `memory/` 目錄，內含空的 `MEMORY.md` 索引檔

## 檔案結構

```
checkpoint/
├── skills/checkpoint/
│   ├── SKILL.md                          # 核心技能定義
│   └── references/
│       ├── anti-amnesia-protocol.md      # 被動防線（貼進 CLAUDE.md）
│       ├── consolidation.md             # 記憶整理演算法
│       └── memory-types.md              # 四種記憶類型詳細指南
├── commands/
│   ├── checkpoint.md                    # /checkpoint 指令觸發器
│   └── checkpoint/
│       └── consolidate.md              # /checkpoint:consolidate 子命令
├── cursor/rules/
│   └── checkpoint.mdc                   # Cursor AI 規則
├── vscode/
│   ├── instructions/checkpoint.md       # Copilot 指令
│   └── prompts/checkpoint.prompt.md     # Copilot 提示
├── codex/checkpoint/
│   └── SKILL.md                         # Codex CLI 版本
├── .claude-plugin/
│   ├── plugin.json                      # Claude Code 外掛清單
│   └── marketplace.json                 # Marketplace 元資料
├── .codex/
│   └── INSTALL.md                       # Codex 安裝指南
├── .github/workflows/
│   └── release.yml                      # 打 tag 自動發布
├── LICENSE                              # MIT
├── README.md                            # 英文版
└── README.zh-TW.md                      # 本檔案
```

## 真實案例

這個技能源自實際痛點。在一個多次對話的 OneNote API 專案中，AI 反覆：
- 忘記共用筆記本需要 site-based API 路徑（`/sites/{id}/onenote/`）
- 忘記租戶封鎖 app consent，需要預授權的 client ID
- 忘記使用者沒有管理員權限，一直建議「請找管理員」

每次重新發現都浪費 20-30 分鐘。實裝 Checkpoint 後，AI 在每次對話開始時讀取記憶，直接跳到可用的解決方案。

**使用前**：3 次對話 x 30 分鐘重新發現 = 浪費 90 分鐘
**使用後**：浪費 0 分鐘。記憶在幾秒內載入。

## 貢獻

歡迎貢獻！你可以：
- 新增更多 AI 程式工具的支援
- 改進記憶類型系統
- 分享你的 Anti-Amnesia Protocol 變體
- 回報問題或提出建議

## 授權

[MIT](LICENSE)
