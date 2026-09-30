package com.es.web.portfolio;

import java.util.List;

/**
 * 포트폴리오 전체 데이터. src/portfolio.json 의 구조와 1:1 로 대응한다.
 * 목록 항목이 JSON 에 없으면 null 이 될 수 있으므로 화면에서는 empty 검사를 한다.
 */
public record Portfolio(
		Profile profile,
		List<SkillGroup> skills,
		List<Experience> experiences,
		List<Project> projects,
		List<Education> educations,
		List<Certificate> certificates) {

	public record Link(String label, String url) {}

	public record Profile(
			String name,
			String photo,
			String title,
			String tagline,
			List<String> intro,
			String email,
			String location,
			List<Link> links) {}

	public record SkillGroup(String category, List<String> items) {}

	public record Experience(
			String company,
			String role,
			String period,
			String summary,
			List<String> highlights) {}

	public record Project(
			String id,
			String name,
			String period,
			String role,
			String summary,
			List<String> description,
			List<String> tech,
			List<Link> links,
			boolean featured) {}

	public record Education(String school, String major, String period, String note) {}

	public record Certificate(String name, String issuer, String date) {}
}
