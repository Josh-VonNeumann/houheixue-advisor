# 厚黑軍師（houheixue-advisor）

以李宗吾《厚黑學》（1936 年版）為理論基礎的職場疑難顧問。本專案提供一個 Claude Skill，也附上可用於任何大型語言模型的 system prompt。

> 「我們雖不想實行厚黑，也須提防人在我們名下施行厚黑，所以他們的法術，我們不能不知道。」
> ——李宗吾《厚黑學・緒論》

## 它會做什麼

問它職場問題（功勞被搶、加薪被推託、跨部門甩鍋、新官上任、被同事排擠……），它會用厚黑學的框架回答：

1. **局勢判讀**：誰掌「飯甑子」（你的考核與資源）？你缺的是「厚」還是「黑」？
2. **對方招式**：別人可能正在對你用哪一招，例如鋸箭法、補鍋法。
3. **策略與話術**：引用求官六字、做官六字、辦事二妙法，給出可以直接說出口的話。
4. **面子上糊什麼**：這套策略對外的說法。
5. **風險**：哪裡會露出跡象、哪裡會用過頭。
6. **典故點評**：三國、楚漢人物的對照。

完整示範見 [examples/sample-conversations.md](examples/sample-conversations.md)。

## 目錄結構

```
houheixue-advisor/
├── skill/houheixue-advisor/       # Claude Skill 本體
│   ├── SKILL.md                   # 核心指示（心法、招式庫、回答格式、界線）
│   └── references/
│       ├── cases.md               # 人物案例速查與原文要句
│       └── original-text.md       # 《厚黑學》完整原文
├── prompts/
│   └── system-prompt.md           # 獨立版 system prompt，適用 ChatGPT、Gemini、API 等
├── examples/
│   └── sample-conversations.md    # 範例對話
├── scripts/
│   └── build-skill-zip.sh         # 檢查並打包 skill 成 zip
├── .github/workflows/release.yml  # 自動打包；推 v* 標籤時發布 Release
└── LICENSE
```

## 使用方式

### 1. Claude（網頁版、桌面版、手機版）

1. 取得 skill 的 zip 檔：到本 repo 的 Releases 下載 `houheixue-advisor.zip`，或自行打包：
   ```bash
   bash scripts/build-skill-zip.sh   # 產生 dist/houheixue-advisor.zip
   ```
2. 在 claude.ai 前往 [Customize › Skills](https://claude.ai/customize/skills)，新增並上傳 zip，然後把它打開。
3. Skill 需要開啟程式碼執行功能。

之後問職場問題時，Claude 會自動載入這個 skill；只想要一般建議時，在問題裡說一聲即可。

### 2. Claude Code

```bash
# 個人層級（所有專案都能用）
cp -r skill/houheixue-advisor ~/.claude/skills/

# 或專案層級（跟著專案 repo 走）
mkdir -p .claude/skills && cp -r skill/houheixue-advisor .claude/skills/
```

### 3. Claude Projects

1. 新建一個 Project，把 [prompts/system-prompt.md](prompts/system-prompt.md) 的內容貼進專案指示。
2. 把 `skill/houheixue-advisor/references/` 裡的 `original-text.md` 與 `cases.md` 上傳為專案知識檔。

### 4. ChatGPT、Gemini 及其他 LLM

把 [prompts/system-prompt.md](prompts/system-prompt.md) 貼到自訂指令欄位（例如自訂 GPT 或 Gem 的 Instructions），平台支援知識檔的話，再上傳 `original-text.md` 與 `cases.md`。

### 5. API

```python
import anthropic
from pathlib import Path

client = anthropic.Anthropic()
system_prompt = Path("prompts/system-prompt.md").read_text(encoding="utf-8")

message = client.messages.create(
    model="claude-sonnet-5-5",
    max_tokens=2048,
    system=system_prompt,
    messages=[{"role": "user", "content": "主管在會議上把我的成果說成是他的，怎麼辦？"}],
)
print(message.content[0].text)
```

## 設計說明

- **忠於原文，轉成職場語言。** 「飯甑子」（掌握你生計的人）、「鋸箭法」、「補鍋法」等概念保留原名，再對應到現代職場情境。
- **原文的「送」「弄」「恐」「兇」已轉成合法版本。** 原文中這四字分別指送銀元、弄錢、嚇唬上峰、不顧他人死活。本專案一律改為人情往來、爭取功勞與資源、讓決策者看見不安置你的代價、做決定不手軟，並明確排除賄賂、侵占、勒索、造謠等做法。
- **攻防兼備。** 依李宗吾「提防人在我們名下施行厚黑」之說，每次回答都會指出對方可能正在用的招式。
- **保留作者自己的但書。** 李宗吾自承厚黑學源自性惡說，是「一偏之見」，認真厚黑起來終歸要失敗。顧問會在厚黑不划算時直說。

## 原文來源與授權

- 《厚黑學》原文取自[維基文庫](https://zh.wikisource.org/wiki/厚黑學)。作者李宗吾於 1943 年逝世，原文屬公有領域。
- 本專案其餘內容（skill、prompt、範例、腳本）以 [MIT License](LICENSE) 授權。

## 免責聲明

本專案的回答僅供思考與娛樂參考，不構成法律、人資或心理諮詢意見。遇到職場霸凌、違法對待或身心健康問題，請尋求專業協助。
