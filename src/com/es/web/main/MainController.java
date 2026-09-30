package com.es.web.main;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.es.web.portfolio.PortfolioService;

@Controller
public class MainController {

	private static final Logger logger = LoggerFactory.getLogger(MainController.class);

	private static final DateTimeFormatter TIME_FORMAT = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");

	private final PortfolioService portfolioService;

	public MainController(PortfolioService portfolioService) {
		this.portfolioService = portfolioService;
	}

	/** 포트폴리오 메인 (한 페이지 구성) */
	@GetMapping("/")
	public String index(Model model) {
		logger.debug("index");
		model.addAttribute("p", portfolioService.get());
		model.addAttribute("serverTime", LocalDateTime.now().format(TIME_FORMAT));
		return "index";
	}

	@GetMapping("/api/health")
	@ResponseBody
	public Map<String, String> health() {
		return Map.of("status", "UP");
	}
}
