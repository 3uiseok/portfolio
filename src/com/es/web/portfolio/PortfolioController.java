package com.es.web.portfolio;

import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.server.ResponseStatusException;

import com.es.web.portfolio.Portfolio.Project;

@Controller
public class PortfolioController {

	private final PortfolioService service;

	public PortfolioController(PortfolioService service) {
		this.service = service;
	}

	/** 프로젝트 상세 페이지 */
	@GetMapping("/projects/{id}")
	public String project(@PathVariable String id, Model model) {
		Project project = service.findProject(id)
				.orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "project not found: " + id));
		model.addAttribute("p", service.get());
		model.addAttribute("project", project);
		return "project";
	}

	/** 포트폴리오 전체 데이터 JSON */
	@GetMapping("/api/portfolio")
	@ResponseBody
	public Portfolio portfolio() {
		return service.get();
	}
}
