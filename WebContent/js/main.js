/* 포트폴리오 화면 동작: 테마 전환, 현재 섹션 표시, 프로젝트 필터, 맨 위로, 모바일 메뉴 */
(function () {
	'use strict';

	var root = document.documentElement;
	var THEME_KEY = 'es-theme';

	/* ---- 테마 전환 ---- */
	function isDark() {
		var t = root.getAttribute('data-theme');
		if (t) return t === 'dark';
		return window.matchMedia && window.matchMedia('(prefers-color-scheme: dark)').matches;
	}
	var themeBtn = document.getElementById('theme-toggle');
	if (themeBtn) {
		themeBtn.addEventListener('click', function () {
			var next = isDark() ? 'light' : 'dark';
			root.setAttribute('data-theme', next);
			try { localStorage.setItem(THEME_KEY, next); } catch (e) { /* 저장 불가 환경 */ }
		});
	}

	/* ---- 현재 보고 있는 섹션을 내비게이션에 표시 (메인 페이지에서만 동작) ---- */
	var navLinks = Array.prototype.slice.call(document.querySelectorAll('.nav-links a'));
	var sections = navLinks
		.map(function (a) {
			var i = a.getAttribute('href').indexOf('#');
			return i >= 0 ? document.getElementById(a.getAttribute('href').slice(i + 1)) : null;
		})
		.filter(Boolean);
	if (sections.length && 'IntersectionObserver' in window) {
		var io = new IntersectionObserver(function (entries) {
			entries.forEach(function (e) {
				if (!e.isIntersecting) return;
				navLinks.forEach(function (a) {
					a.classList.toggle('active', a.getAttribute('href').slice(-(e.target.id.length + 1)) === '#' + e.target.id);
				});
			});
		}, { rootMargin: '-40% 0px -55% 0px' });
		sections.forEach(function (s) { io.observe(s); });
	}

	/* ---- 프로젝트를 기술로 걸러 보기 ---- */
	var filter = document.getElementById('project-filter');
	var cards = Array.prototype.slice.call(document.querySelectorAll('.project-card'));
	if (filter && cards.length) {
		var techs = {};
		cards.forEach(function (c) {
			(c.getAttribute('data-tech') || '').split('|').forEach(function (t) { if (t) techs[t] = true; });
		});
		var makeChip = function (label, value) {
			var b = document.createElement('button');
			b.type = 'button';
			b.className = 'chip chip-btn';
			b.textContent = label;
			b.setAttribute('data-value', value);
			return b;
		};
		var all = makeChip('전체', '');
		all.classList.add('active');
		filter.appendChild(all);
		Object.keys(techs).sort(function (a, b) { return a.localeCompare(b, 'ko'); })
			.forEach(function (t) { filter.appendChild(makeChip(t, t)); });

		filter.addEventListener('click', function (e) {
			var b = e.target.closest('button');
			if (!b) return;
			filter.querySelectorAll('button').forEach(function (x) { x.classList.toggle('active', x === b); });
			var v = b.getAttribute('data-value');
			var shown = 0;
			cards.forEach(function (c) {
				var show = !v || (c.getAttribute('data-tech') || '').split('|').indexOf(v) >= 0;
				c.hidden = !show;
				if (show) shown++;
			});
			var empty = document.getElementById('project-empty');
			if (empty) empty.hidden = shown > 0;
		});
	}

	/* ---- 맨 위로 ---- */
	var toTop = document.getElementById('to-top');
	if (toTop) {
		window.addEventListener('scroll', function () {
			toTop.classList.toggle('show', window.scrollY > 600);
		}, { passive: true });
		toTop.addEventListener('click', function () {
			window.scrollTo({ top: 0, behavior: 'smooth' });
		});
	}

	/* ---- 모바일 메뉴 ---- */
	var menuBtn = document.getElementById('nav-menu');
	var navList = document.querySelector('.nav-links');
	if (menuBtn && navList) {
		menuBtn.addEventListener('click', function () { navList.classList.toggle('open'); });
		navList.addEventListener('click', function (e) {
			if (e.target.tagName === 'A') navList.classList.remove('open');
		});
	}
})();
