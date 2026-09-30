# ES Web 포트폴리오

Spring Framework 6 + JSP 로 만든 포트폴리오 웹입니다.

- 사이트: https://3uiseok.github.io/portfolio/ (확인 코드를 입력해야 열립니다)
- 내용 수정: `src/portfolio.json` 한 파일만 고치면 됩니다.

## 실행

```
docker compose up --build -d    # http://localhost:8080/web/
```

Docker 없이 로컬 Tomcat 11 로 띄우려면 `run.cmd` 를 실행합니다 (도구 경로는 `setenv.cmd`).

## 확인 코드 잠금

환경 변수 `GATE_CODE` 를 지정하면 코드를 입력한 뒤에만 화면이 열립니다. 지정하지 않으면 잠금 없이 동작합니다.

- 로컬: 프로젝트 폴더의 `.env` 파일에 `GATE_CODE=코드` 를 적습니다 (커밋하지 않는 파일).
- GitHub Pages: 저장소 Settings > Secrets and variables > Actions 의 `GATE_CODE` secret 을 씁니다.

서버에서는 세션으로 잠금을 확인하고, 정적 게시본은 각 화면을 코드로 암호화해 올린 뒤
브라우저에서 입력한 코드로 풀어 보여 줍니다 (`WebContent/js/gate.js`).

## GitHub Pages 게시

`main` 에 push 하면 `.github/workflows/pages.yml` 이 웹을 Docker 로 띄운 뒤
`_scripts/export-static.sh` 로 화면을 정적 페이지로 내보내 GitHub Pages 에 게시합니다.

로컬에서 내보내기만 확인하려면 웹을 띄운 상태에서 실행합니다.

```
GATE_CODE=코드 BASE_PATH=/portfolio bash _scripts/export-static.sh _site
```
