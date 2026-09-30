<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fn" uri="jakarta.tags.functions"%>
<c:set var="pageTitle" value="오류가 발생했습니다"/>
<!DOCTYPE html>
<html lang="ko">
<head>
<%@ include file="/WEB-INF/views/fragments/head.jspf" %>
</head>
<body>
<%@ include file="/WEB-INF/views/fragments/nav.jspf" %>
<main>
	<section class="section">
		<div class="wrap narrow error-box">
			<p class="eyebrow">오류</p>
			<h1>요청을 처리하지 못했습니다</h1>
			<p class="muted">잠시 후 다시 시도해 주세요.</p>
			<a class="btn btn-primary" href="${ctx}/">메인으로</a>
		</div>
	</section>
</main>
<%@ include file="/WEB-INF/views/fragments/footer.jspf" %>
</body>
</html>
