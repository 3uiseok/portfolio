#!/usr/bin/env bash
# 실행 중인 웹의 화면을 정적 파일로 내보낸다 (GitHub Pages 게시용).
#   사용: bash scripts/export-static.sh [출력폴더=_site]
#   BASE_URL  내보낼 웹 주소 (기본 http://localhost:8080/web)
#   BASE_PATH 게시될 경로 접두사. 예: /portfolio  (도메인 루트에 게시하면 빈 값)
set -euo pipefail

BASE_URL="${BASE_URL:-http://localhost:8080/web}"
BASE_PATH="${BASE_PATH:-}"
OUT="${1:-_site}"
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
# 컨텍스트 경로 (/web). 화면의 링크가 이 경로로 시작하므로 BASE_PATH 로 바꿔 준다.
CTX="/$(echo "$BASE_URL" | sed -E 's#^https?://[^/]+/?##')"
CTX="${CTX%/}"

rm -rf "$OUT"
mkdir -p "$OUT"
cp -r "$ROOT/WebContent/css" "$ROOT/WebContent/js" "$ROOT/WebContent/images" "$OUT/"

# fetch <요청 경로> <출력 파일> [curl 옵션]
# 요청할 때마다 달라지는 "서버 시각" 표시는 정적 페이지에서 뺀다.
fetch() {
	mkdir -p "$(dirname "$OUT/$2")"
	curl -sS ${3:-} "$BASE_URL$1" \
		| sed -e "s#\(href\|src\)=\"$CTX/#\1=\"$BASE_PATH/#g" -e '/서버 시각/d' > "$OUT/$2"
	echo "  $1 -> $OUT/$2"
}

fetch / index.html -f
for id in $(grep -o "href=\"$BASE_PATH/projects/[^\"]*\"" "$OUT/index.html" | sed 's#.*/projects/\([^"]*\)"#\1#' | sort -u); do
	fetch "/projects/$id" "projects/$id/index.html" -f
done
# 없는 주소를 요청해 404 화면을 받아 둔다 (GitHub Pages 가 404.html 을 사용)
fetch /__not_found__ 404.html

echo "exported to $OUT (base path: '${BASE_PATH:-/}')"
