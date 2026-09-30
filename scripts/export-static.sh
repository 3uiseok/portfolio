#!/usr/bin/env bash
# 실행 중인 웹의 화면을 정적 파일로 내보낸다 (GitHub Pages 게시용).
#   사용: bash scripts/export-static.sh [출력폴더=_site]
#   BASE_URL  내보낼 웹 주소 (기본 http://localhost:8080/web)
#   BASE_PATH 게시될 경로 접두사. 예: /portfolio  (도메인 루트에 게시하면 빈 값)
#   GATE_CODE 확인 코드. 웹에 지정한 것과 같은 값을 주면 각 화면을 이 코드로 암호화해
#             잠금 화면에 담아 내보낸다. 웹에 잠금이 없으면 비워 둔다.
set -euo pipefail

BASE_URL="${BASE_URL:-http://localhost:8080/web}"
BASE_PATH="${BASE_PATH:-}"
GATE_CODE="${GATE_CODE:-}"
OUT="${1:-_site}"
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
# 컨텍스트 경로 (/web). 화면의 링크가 이 경로로 시작하므로 BASE_PATH 로 바꿔 준다.
CTX="/$(echo "$BASE_URL" | sed -E 's#^https?://[^/]+/?##')"
CTX="${CTX%/}"
# 코드에서 암호화 키를 만드는 PBKDF2 반복 횟수 (js/gate.js 가 data-iter 로 읽는다)
ITER=250000

TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT
JAR="$TMP/cookies"
GATE_TPL="$TMP/gate.html"
: > "$JAR"

rm -rf "$OUT"
mkdir -p "$OUT"
cp -r "$ROOT/WebContent/css" "$ROOT/WebContent/js" "$ROOT/WebContent/images" "$OUT/"

# 요청할 때마다 달라지는 "서버 시각" 표시는 정적 페이지에서 뺀다.
rewrite() {
	sed -e "s#\(href\|src\|action\)=\"$CTX/#\1=\"$BASE_PATH/#g" -e '/서버 시각/d'
}
is_gate() {
	grep -q 'id="gate-form"' "$1"
}

if [ -n "$GATE_CODE" ]; then
	export GATE_CODE
	# 코드를 넣어 세션을 열어 두고, 잠금 화면은 세션 없이 받아 틀로 쓴다
	curl -sS -f -o /dev/null -c "$JAR" --data-urlencode "code=$GATE_CODE" "$BASE_URL/unlock"
	curl -sS -f "$BASE_URL/" | rewrite > "$GATE_TPL"
	is_gate "$GATE_TPL" || { echo "웹에 잠금이 걸려 있지 않습니다. 웹에도 GATE_CODE 를 지정하세요." >&2; exit 1; }
fi

# lock <평문 화면> <출력 파일> : 화면을 암호화해 잠금 화면 틀의 표시 자리에 넣는다
lock() {
	{
		sed '/<!-- gate-payload -->/,$d' "$GATE_TPL"
		printf '<script type="text/plain" id="gate-payload" data-iter="%s">' "$ITER"
		openssl enc -aes-256-cbc -pbkdf2 -md sha256 -iter "$ITER" -salt -pass env:GATE_CODE -base64 -A -in "$1"
		printf '</script>\n'
		sed '1,/<!-- gate-payload -->/d' "$GATE_TPL"
	} > "$2"
}

# fetch <요청 경로> <출력 파일>
fetch() {
	local plain="$TMP/plain/$2"
	mkdir -p "$(dirname "$plain")" "$(dirname "$OUT/$2")"
	curl -sS -f -b "$JAR" "$BASE_URL$1" | rewrite > "$plain"
	if is_gate "$plain"; then
		echo "잠금 화면이 내려왔습니다. GATE_CODE 가 웹에 지정한 코드와 같은지 확인하세요." >&2
		exit 1
	fi
	if [ -n "$GATE_CODE" ]; then
		lock "$plain" "$OUT/$2"
	else
		cp "$plain" "$OUT/$2"
	fi
	echo "  $1 -> $OUT/$2"
}

fetch / index.html
for id in $(grep -o "href=\"$BASE_PATH/projects/[^\"]*\"" "$TMP/plain/index.html" | sed 's#.*/projects/\([^"]*\)"#\1#' | sort -u); do
	fetch "/projects/$id" "projects/$id/index.html"
done
# 없는 주소를 요청해 404 화면을 받아 둔다 (GitHub Pages 가 404.html 을 사용). 개인 정보가 없어 암호화하지 않는다.
curl -sS -b "$JAR" "$BASE_URL/__not_found__" | rewrite > "$OUT/404.html"
echo "  /__not_found__ -> $OUT/404.html"

if [ -n "$GATE_CODE" ]; then
	echo "exported to $OUT (base path: '${BASE_PATH:-/}', 확인 코드로 암호화)"
else
	echo "exported to $OUT (base path: '${BASE_PATH:-/}', 잠금 없음)"
fi
