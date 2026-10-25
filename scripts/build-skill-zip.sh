#!/usr/bin/env bash
# 打包 skill，產生可上傳到 claude.ai 的 dist/houheixue-advisor.zip
# 用法：bash scripts/build-skill-zip.sh
set -euo pipefail

NAME="houheixue-advisor"
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SKILL_DIR="$ROOT/skill/$NAME"
OUT="$ROOT/dist/$NAME.zip"

# 檢查 SKILL.md frontmatter：name 須與資料夾同名、description 不超過 200 字元（claude.ai 上傳限制）
python3 - "$SKILL_DIR/SKILL.md" "$NAME" <<'PY'
import sys, re
path, expected = sys.argv[1], sys.argv[2]
text = open(path, encoding="utf-8").read()
m = re.match(r"^---\n(.*?)\n---\n", text, re.S)
if not m:
    sys.exit("SKILL.md 缺少 YAML frontmatter")
fields = dict(line.split(":", 1) for line in m.group(1).splitlines() if ":" in line)
fields = {k.strip(): v.strip() for k, v in fields.items()}
allowed = {"name", "description", "license", "compatibility", "metadata", "allowed-tools"}
extra = set(fields) - allowed
if extra:
    sys.exit(f"frontmatter 含 claude.ai 不接受的欄位：{sorted(extra)}")
if fields.get("name") != expected:
    sys.exit(f"name 應為 {expected}，目前是 {fields.get('name')}")
desc = fields.get("description", "")
if not desc or len(desc) > 200:
    sys.exit(f"description 長度須介於 1 到 200 字元，目前 {len(desc)}")
print(f"SKILL.md 檢查通過（description {len(desc)} 字元）")
PY

mkdir -p "$ROOT/dist"
rm -f "$OUT"
# zip 的根目錄必須是 skill 資料夾本身，不能把檔案散放在 zip 根目錄
(cd "$ROOT/skill" && zip -r -X -q "$OUT" "$NAME" -x '*.DS_Store')
echo "已產生 dist/$NAME.zip"
