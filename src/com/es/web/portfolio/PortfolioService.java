package com.es.web.portfolio;

import java.io.IOException;
import java.io.InputStream;
import java.io.UncheckedIOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.List;
import java.util.Optional;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.core.io.ClassPathResource;
import org.springframework.stereotype.Service;

import com.es.web.portfolio.Portfolio.Project;
import com.fasterxml.jackson.databind.DeserializationFeature;
import com.fasterxml.jackson.databind.ObjectMapper;

/**
 * 포트폴리오 데이터를 읽어 제공한다.
 *
 * 기본은 클래스패스의 portfolio.json (빌드에 포함) 을 기동 시 한 번 읽는다.
 * 시스템 속성 -Dportfolio.file=경로 또는 환경 변수 PORTFOLIO_FILE 로 외부 파일을 지정하면
 * 그 파일을 사용하며, 파일이 바뀔 때마다 다시 읽으므로 재빌드 없이 내용을 수정할 수 있다.
 */
@Service
public class PortfolioService {

	private static final Logger logger = LoggerFactory.getLogger(PortfolioService.class);
	private static final String CLASSPATH_FILE = "portfolio.json";

	private final ObjectMapper mapper = new ObjectMapper()
			.configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false);

	private final Path externalFile;
	private volatile Portfolio cached;
	private volatile long cachedModified = -1;

	public PortfolioService() {
		String path = System.getProperty("portfolio.file", System.getenv("PORTFOLIO_FILE"));
		this.externalFile = (path == null || path.isBlank()) ? null : Path.of(path);
		this.cached = load();
	}

	public Portfolio get() {
		if (externalFile != null && isExternalFileChanged()) {
			cached = load();
		}
		return cached;
	}

	public List<Project> projects() {
		List<Project> list = get().projects();
		return list == null ? List.of() : list;
	}

	public Optional<Project> findProject(String id) {
		return projects().stream().filter(p -> id.equals(p.id())).findFirst();
	}

	private boolean isExternalFileChanged() {
		try {
			return Files.getLastModifiedTime(externalFile).toMillis() != cachedModified;
		} catch (IOException e) {
			return false;
		}
	}

	private Portfolio load() {
		try {
			if (externalFile != null && Files.isRegularFile(externalFile)) {
				cachedModified = Files.getLastModifiedTime(externalFile).toMillis();
				logger.info("portfolio data: {}", externalFile.toAbsolutePath());
				try (InputStream in = Files.newInputStream(externalFile)) {
					return mapper.readValue(in, Portfolio.class);
				}
			}
			if (externalFile != null) {
				logger.warn("portfolio file not found, fallback to classpath: {}", externalFile);
			}
			logger.info("portfolio data: classpath:{}", CLASSPATH_FILE);
			try (InputStream in = new ClassPathResource(CLASSPATH_FILE).getInputStream()) {
				return mapper.readValue(in, Portfolio.class);
			}
		} catch (IOException e) {
			throw new UncheckedIOException("cannot read portfolio.json", e);
		}
	}
}
