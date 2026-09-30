package com.es.web.gate;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;

import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * 확인 코드 잠금.
 *
 * 시스템 속성 -Dgate.code=코드 또는 환경 변수 GATE_CODE 를 지정하면
 * 코드를 입력한 세션에서만 화면을 볼 수 있다. 지정하지 않으면 잠금 없이 동작한다.
 */
@Component
public class GateInterceptor implements HandlerInterceptor {

	static final String UNLOCKED = "gate.unlocked";

	private final String code;

	public GateInterceptor() {
		String c = System.getProperty("gate.code", System.getenv("GATE_CODE"));
		this.code = (c == null || c.isBlank()) ? null : c.trim();
	}

	boolean enabled() {
		return code != null;
	}

	boolean matches(String input) {
		return code != null && input != null && MessageDigest.isEqual(
				code.getBytes(StandardCharsets.UTF_8), input.trim().getBytes(StandardCharsets.UTF_8));
	}

	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
			throws Exception {
		if (code == null) {
			return true;
		}
		HttpSession session = request.getSession(false);
		if (session != null && session.getAttribute(UNLOCKED) != null) {
			return true;
		}

		response.setHeader("Cache-Control", "no-store");
		String path = request.getRequestURI().substring(request.getContextPath().length());
		if (path.startsWith("/api/")) {
			response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
			response.setContentType("application/json;charset=UTF-8");
			response.getWriter().write("{\"error\":\"locked\"}");
			return false;
		}
		// 코드를 입력하면 원래 보려던 주소로 돌아가도록 넘겨 준다
		String query = request.getQueryString();
		request.setAttribute("gateNext", query == null ? path : path + "?" + query);
		request.getRequestDispatcher("/WEB-INF/views/gate.jsp").forward(request, response);
		return false;
	}
}
