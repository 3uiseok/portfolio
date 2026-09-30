# ES Web 포트폴리오

Spring Framework 6 + JSP 로 만든 포트폴리오 웹입니다.

- 사이트: https://3uiseok.github.io/portfolio/
- 내용 수정: `src/portfolio.json` 한 파일만 고치면 됩니다.

## 실행

```
docker compose up --build -d    # http://localhost:8080/web/
```

Docker 없이 로컬 Tomcat 11 로 띄우려면 `run.cmd` 를 실행합니다 (도구 경로는 `setenv.cmd`).

## GitHub Pages 게시

`main` 에 push 하면 `.github/workflows/pages.yml` 이 웹을 Docker 로 띄운 뒤
`scripts/export-static.sh` 로 화면을 정적 페이지로 내보내 GitHub Pages 에 게시합니다.

로컬에서 내보내기만 확인하려면 웹을 띄운 상태에서 실행합니다.

```
BASE_PATH=/portfolio bash scripts/export-static.sh _site
```
