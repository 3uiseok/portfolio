<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fn" uri="jakarta.tags.functions"%>
<c:set var="pageTitle" value="404 · 페이지를 찾을 수 없습니다"/>
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
			<p class="eyebrow">404</p>
			<h1>페이지를 찾을 수 없습니다</h1>
			<p class="muted">주소가 바뀌었거나 삭제된 페이지입니다.</p>
			<a class="btn btn-primary" href="${ctx}/">메인으로</a>
		</div>
	</section>
</main>
<%@ include file="/WEB-INF/views/fragments/footer.jspf" %>
</body>
</html>
