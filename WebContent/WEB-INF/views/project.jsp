<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fn" uri="jakarta.tags.functions"%>
<c:set var="pageTitle" value="${project.name} · ${p.profile.name}"/>
<!DOCTYPE html>
<html lang="ko">
<head>
<%@ include file="/WEB-INF/views/fragments/head.jspf" %>
</head>
<body>
<%@ include file="/WEB-INF/views/fragments/nav.jspf" %>

<main>
	<section class="section detail">
		<div class="wrap narrow">
			<a class="back-link" href="${ctx}/#projects">&larr; 프로젝트 목록</a>

			<header class="detail-head">
				<div class="card-meta">
					<span class="muted"><c:out value="${project.period}"/></span>
					<c:if test="${project.featured}"><span class="badge">주요</span></c:if>
				</div>
				<h1><c:out value="${project.name}"/></h1>
				<c:if test="${not empty project.role}"><p class="muted"><c:out value="${project.role}"/></p></c:if>
				<p class="lead"><c:out value="${project.summary}"/></p>
			</header>

			<c:if test="${not empty project.description}">
				<h2 class="section-title">상세</h2>
				<ul class="bullets">
					<c:forEach var="d" items="${project.description}"><li><c:out value="${d}"/></li></c:forEach>
				</ul>
			</c:if>

			<c:if test="${not empty project.tech}">
				<h2 class="section-title">사용 기술</h2>
				<div class="chips">
					<c:forEach var="t" items="${project.tech}"><span class="chip"><c:out value="${t}"/></span></c:forEach>
				</div>
			</c:if>

			<c:if test="${not empty project.links}">
				<h2 class="section-title">링크</h2>
				<div class="hero-actions">
					<c:forEach var="l" items="${project.links}">
						<a class="btn" href="<c:out value='${l.url}'/>" target="_blank" rel="noopener"><c:out value="${l.label}"/> &nearr;</a>
					</c:forEach>
				</div>
			</c:if>

			<c:if test="${fn:length(p.projects) > 1}">
				<h2 class="section-title">다른 프로젝트</h2>
				<ul class="plain-list other-projects">
					<c:forEach var="o" items="${p.projects}">
						<c:if test="${o.id != project.id}">
							<li>
								<a href="${ctx}/projects/<c:out value='${o.id}'/>"><c:out value="${o.name}"/></a>
								<span class="muted small"> &middot; <c:out value="${o.period}"/></span>
							</li>
						</c:if>
					</c:forEach>
				</ul>
			</c:if>
		</div>
	</section>
</main>

<%@ include file="/WEB-INF/views/fragments/footer.jspf" %>
</body>
</html>
