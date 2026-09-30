package com.es.web.gate;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import jakarta.servlet.http.HttpServletRequest;

@Controller
public class GateController {

	private final GateInterceptor gate;

	public GateController(GateInterceptor gate) {
		this.gate = gate;
	}

	/** 확인 코드 입력. 맞으면 세션을 열고 원래 보려던 주소로 돌려보낸다. */
	@PostMapping("/unlock")
	public String unlock(@RequestParam(required = false) String code,
			@RequestParam(required = false) String next, HttpServletRequest request) {
		String target = isLocalPath(next) ? next : "/";
		if (!gate.enabled()) {
			return "redirect:" + target;
		}
		if (gate.matches(code)) {
			request.getSession().setAttribute(GateInterceptor.UNLOCKED, Boolean.TRUE);
			request.changeSessionId();
			return "redirect:" + target;
		}
		request.setAttribute("gateNext", target);
		request.setAttribute("gateError", true);
		return "gate";
	}

	/** 외부 주소로 튕기지 않도록 앱 안의 경로만 허용한다 */
	private static boolean isLocalPath(String next) {
		return next != null && next.startsWith("/") && !next.startsWith("//") && !next.contains("\\");
	}
}
