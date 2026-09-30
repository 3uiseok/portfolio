<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fn" uri="jakarta.tags.functions"%>
<c:set var="pageTitle" value="Portfolio · 확인 코드"/>
<!DOCTYPE html>
<html lang="ko">
<head>
<%@ include file="/WEB-INF/views/fragments/head.jspf" %>
<meta name="robots" content="noindex">
<script>
	/* 정적 게시본에서 이미 코드를 입력한 탭이면 잠금 화면을 잠깐도 보이지 않게 한다 */
	try {
		if (sessionStorage.getItem('es-gate-code')) document.documentElement.classList.add('gate-auto');
	} catch (e) {}
</script>
</head>
<body>
<main class="gate">
	<form id="gate-form" class="card gate-card" method="post" action="${ctx}/unlock" autocomplete="off">
		<div class="gate-icon" aria-hidden="true">&#x1F512;</div>
		<h1>Portfolio</h1>
		<p class="muted">확인 코드를 입력해 주세요.</p>
		<p class="muted small gate-hint">힌트: birthday</p>
		<input type="hidden" name="next" value="<c:out value='${gateNext}'/>">
		<input id="gate-code" class="gate-input" type="password" name="code" inputmode="numeric"
			placeholder="확인 코드" aria-label="확인 코드" autocomplete="off" required autofocus>
		<button class="btn btn-primary" type="submit">확인</button>
		<p id="gate-error" class="gate-error" role="alert" <c:if test="${not gateError}">hidden</c:if>>코드가 올바르지 않습니다.</p>
	</form>
</main>
<%-- 정적 게시본(GitHub Pages)은 _scripts/export-static.sh 가 아래 표시 자리에 암호화된 화면을 넣는다 --%>
<!-- gate-payload -->
<script src="${ctx}/js/gate.js"></script>
</body>
</html>
