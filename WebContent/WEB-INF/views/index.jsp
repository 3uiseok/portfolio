<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fn" uri="jakarta.tags.functions"%>
<c:set var="pageTitle" value="${p.profile.name} · ${p.profile.title}"/>
<!DOCTYPE html>
<html lang="ko">
<head>
<%@ include file="/WEB-INF/views/fragments/head.jspf" %>
</head>
<body>
<%@ include file="/WEB-INF/views/fragments/nav.jspf" %>

<main>
	<%-- 히어로 --%>
	<section class="hero" id="top">
		<div class="wrap hero-inner">
			<c:choose>
				<c:when test="${not empty p.profile.photo}">
					<img class="avatar" src="<c:out value='${p.profile.photo}'/>" alt="<c:out value='${p.profile.name}'/> 프로필 사진" width="120" height="120">
				</c:when>
				<c:otherwise>
					<div class="avatar" aria-hidden="true"><c:out value="${fn:substring(p.profile.name, 0, 1)}"/></div>
				</c:otherwise>
			</c:choose>
			<div class="hero-text">
				<p class="eyebrow"><c:out value="${p.profile.title}"/></p>
				<h1><c:out value="${p.profile.name}"/></h1>
				<p class="tagline"><c:out value="${p.profile.tagline}"/></p>
				<div class="hero-actions">
					<c:if test="${not empty p.profile.email}">
						<a class="btn btn-primary" href="mailto:<c:out value='${p.profile.email}'/>">이메일 보내기</a>
					</c:if>
					<c:forEach var="l" items="${p.profile.links}">
						<a class="btn" href="<c:out value='${l.url}'/>" target="_blank" rel="noopener"><c:out value="${l.label}"/></a>
					</c:forEach>
				</div>
				<c:if test="${not empty p.profile.location}">
					<p class="muted small">&#x1F4CD; <c:out value="${p.profile.location}"/></p>
				</c:if>
			</div>
		</div>
	</section>

	<%-- 소개 --%>
	<c:if test="${not empty p.profile.intro}">
	<section class="section" id="about">
		<div class="wrap">
			<h2 class="section-title">소개</h2>
			<div class="prose">
				<c:forEach var="line" items="${p.profile.intro}">
					<p><c:out value="${line}"/></p>
				</c:forEach>
			</div>
		</div>
	</section>
	</c:if>

	<%-- 기술 --%>
	<c:if test="${not empty p.skills}">
	<section class="section alt" id="skills">
		<div class="wrap">
			<h2 class="section-title">기술</h2>
			<div class="skill-grid">
				<c:forEach var="g" items="${p.skills}">
					<div class="card">
						<h3 class="card-title"><c:out value="${g.category}"/></h3>
						<div class="chips">
							<c:forEach var="s" items="${g.items}"><span class="chip"><c:out value="${s}"/></span></c:forEach>
						</div>
					</div>
				</c:forEach>
			</div>
		</div>
	</section>
	</c:if>

	<%-- 경력 --%>
	<c:if test="${not empty p.experiences}">
	<section class="section" id="experience">
		<div class="wrap">
			<h2 class="section-title">경력</h2>
			<ol class="timeline">
				<c:forEach var="e" items="${p.experiences}">
					<li class="timeline-item">
						<div class="timeline-period"><c:out value="${e.period}"/></div>
						<div class="timeline-body">
							<h3><c:out value="${e.company}"/> <span class="muted role">&middot; <c:out value="${e.role}"/></span></h3>
							<c:if test="${not empty e.summary}"><p><c:out value="${e.summary}"/></p></c:if>
							<c:if test="${not empty e.highlights}">
								<ul class="bullets">
									<c:forEach var="h" items="${e.highlights}"><li><c:out value="${h}"/></li></c:forEach>
								</ul>
							</c:if>
						</div>
					</li>
				</c:forEach>
			</ol>
		</div>
	</section>
	</c:if>

	<%-- 프로젝트 --%>
	<c:if test="${not empty p.projects}">
	<section class="section alt" id="projects">
		<div class="wrap">
			<div class="section-head">
				<h2 class="section-title">프로젝트</h2>
				<div id="project-filter" class="chips filter" aria-label="기술로 걸러 보기"></div>
			</div>
			<div class="project-grid">
				<c:forEach var="pr" items="${p.projects}">
					<article class="card project-card"
						data-tech="<c:forEach var='t' items='${pr.tech}' varStatus='s'><c:out value='${t}'/><c:if test='${!s.last}'>|</c:if></c:forEach>">
						<div class="card-meta">
							<span class="muted small"><c:out value="${pr.period}"/></span>
							<c:if test="${pr.featured}"><span class="badge">주요</span></c:if>
						</div>
						<h3 class="card-title"><a href="${ctx}/projects/<c:out value='${pr.id}'/>"><c:out value="${pr.name}"/></a></h3>
						<c:if test="${not empty pr.role}"><p class="muted small"><c:out value="${pr.role}"/></p></c:if>
						<p class="card-summary"><c:out value="${pr.summary}"/></p>
						<div class="chips">
							<c:forEach var="t" items="${pr.tech}"><span class="chip"><c:out value="${t}"/></span></c:forEach>
						</div>
						<a class="card-link" href="${ctx}/projects/<c:out value='${pr.id}'/>">자세히 보기 &rarr;</a>
					</article>
				</c:forEach>
			</div>
			<p id="project-empty" class="muted" hidden>선택한 기술을 사용한 프로젝트가 없습니다.</p>
		</div>
	</section>
	</c:if>

	<%-- 학력 · 자격 --%>
	<c:if test="${not empty p.educations or not empty p.certificates}">
	<section class="section" id="education">
		<div class="wrap two-col">
			<c:if test="${not empty p.educations}">
			<div>
				<h2 class="section-title">학력</h2>
				<ul class="plain-list">
					<c:forEach var="ed" items="${p.educations}">
						<li>
							<strong><c:out value="${ed.school}"/></strong>
							<span class="muted"> <c:out value="${ed.major}"/><c:if test="${not empty ed.note}"> &middot; <c:out value="${ed.note}"/></c:if></span>
							<div class="muted small"><c:out value="${ed.period}"/></div>
						</li>
					</c:forEach>
				</ul>
			</div>
			</c:if>
			<c:if test="${not empty p.certificates}">
			<div>
				<h2 class="section-title">자격증</h2>
				<ul class="plain-list">
					<c:forEach var="ce" items="${p.certificates}">
						<li>
							<strong><c:out value="${ce.name}"/></strong>
							<c:if test="${not empty ce.issuer}"><span class="muted"> <c:out value="${ce.issuer}"/></span></c:if>
							<c:if test="${not empty ce.date}"><div class="muted small"><c:out value="${ce.date}"/></div></c:if>
						</li>
					</c:forEach>
				</ul>
			</div>
			</c:if>
		</div>
	</section>
	</c:if>

	<%-- 연락 --%>
	<section class="section alt" id="contact">
		<div class="wrap contact">
			<h2 class="section-title">연락</h2>
			<p>프로젝트 제안이나 궁금한 점이 있으면 편하게 연락 주세요.</p>
			<div class="hero-actions">
				<c:if test="${not empty p.profile.email}">
					<a class="btn btn-primary" href="mailto:<c:out value='${p.profile.email}'/>"><c:out value="${p.profile.email}"/></a>
				</c:if>
				<c:forEach var="l" items="${p.profile.links}">
					<a class="btn" href="<c:out value='${l.url}'/>" target="_blank" rel="noopener"><c:out value="${l.label}"/></a>
				</c:forEach>
			</div>
		</div>
	</section>
</main>

<%@ include file="/WEB-INF/views/fragments/footer.jspf" %>
</body>
</html>
