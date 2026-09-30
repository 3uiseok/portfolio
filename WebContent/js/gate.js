/* 확인 코드 잠금 화면.
   서버(Spring)에서는 폼이 그대로 /unlock 으로 전송된다.
   정적 게시본에는 #gate-payload 에 암호화된 화면이 들어 있어, 입력한 코드로 풀어서 보여 준다. */
(function () {
	'use strict';

	var root = document.documentElement;
	var form = document.getElementById('gate-form');
	var payload = document.getElementById('gate-payload');
	if (!form || !payload) {
		root.classList.remove('gate-auto');
		return;
	}

	var CODE_KEY = 'es-gate-code';
	var input = document.getElementById('gate-code');
	var error = document.getElementById('gate-error');
	var button = form.querySelector('button[type="submit"]');
	var iterations = Number(payload.getAttribute('data-iter'));

	function fromBase64(text) {
		var bin = atob(text);
		var bytes = new Uint8Array(bin.length);
		for (var i = 0; i < bin.length; i++) bytes[i] = bin.charCodeAt(i);
		return bytes;
	}

	/* openssl enc -aes-256-cbc -pbkdf2 형식: "Salted__"(8) + salt(8) + 암호문.
	   키(32바이트)와 IV(16바이트)는 PBKDF2-SHA256 결과 48바이트를 나눠 쓴다. */
	function decrypt(code) {
		var data = fromBase64(payload.textContent.trim());
		var salt = data.slice(8, 16);
		var body = data.slice(16);
		return Promise.resolve()
			.then(function () {
				return crypto.subtle.importKey('raw', new TextEncoder().encode(code), 'PBKDF2', false, ['deriveBits']);
			})
			.then(function (material) {
				return crypto.subtle.deriveBits(
					{ name: 'PBKDF2', hash: 'SHA-256', salt: salt, iterations: iterations }, material, 384);
			})
			.then(function (bits) {
				var derived = new Uint8Array(bits);
				return crypto.subtle.importKey('raw', derived.slice(0, 32), 'AES-CBC', false, ['decrypt'])
					.then(function (key) {
						return crypto.subtle.decrypt({ name: 'AES-CBC', iv: derived.slice(32, 48) }, key, body);
					});
			})
			.then(function (plain) {
				var html = new TextDecoder('utf-8', { fatal: true }).decode(plain);
				if (!/^\s*<!DOCTYPE html>/i.test(html)) throw new Error('wrong code');
				return html;
			});
	}

	/* 풀린 화면으로 문서 전체를 바꾼다. 주소에 #섹션 이 있으면 그 위치로 이동한다. */
	function show(html) {
		var id = decodeURIComponent(location.hash.slice(1));
		document.open();
		document.write(html);
		document.close();
		if (id) {
			window.addEventListener('load', function () {
				var target = document.getElementById(id);
				if (target) target.scrollIntoView();
			});
		}
	}

	function remember(code) {
		try { sessionStorage.setItem(CODE_KEY, code); } catch (e) { /* 저장 불가 환경 */ }
	}
	function forget() {
		try { sessionStorage.removeItem(CODE_KEY); } catch (e) { /* 저장 불가 환경 */ }
	}

	form.addEventListener('submit', function (e) {
		e.preventDefault();
		var code = input.value.trim();
		if (!code) return;
		error.hidden = true;
		button.disabled = true;
		decrypt(code).then(function (html) {
			remember(code);
			show(html);
		}).catch(function () {
			button.disabled = false;
			error.hidden = false;
			input.select();
		});
	});

	/* 같은 탭에서 이미 코드를 입력했으면 다른 페이지로 옮겨도 다시 묻지 않는다 */
	var saved = null;
	try { saved = sessionStorage.getItem(CODE_KEY); } catch (e) { /* 저장 불가 환경 */ }
	if (saved) {
		decrypt(saved).then(show).catch(function () {
			forget();
			root.classList.remove('gate-auto');
		});
	}
})();
