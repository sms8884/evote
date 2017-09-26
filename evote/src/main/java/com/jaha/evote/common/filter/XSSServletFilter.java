package com.jaha.evote.common.filter;

import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

import javax.servlet.FilterChain;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.util.Assert;
import org.springframework.web.multipart.MultipartException;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.multipart.commons.CommonsMultipartResolver;
import org.springframework.web.multipart.support.DefaultMultipartHttpServletRequest;
import org.springframework.web.multipart.support.MultipartFilter;

public class XSSServletFilter extends MultipartFilter {

    private final Logger logger = LoggerFactory.getLogger(getClass());

    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain) throws ServletException, IOException {

        ClassLoader classLoader = Thread.currentThread().getContextClassLoader();
        InputStream input = classLoader.getResourceAsStream("/properties/common/common.properties");

        Properties properties = new Properties();
        properties.load(input);

        long maxUploadSize = 0L;
        String strMaxUploadSize = properties.getProperty("mvc.upload.maxUploadSize");
        String xssfilterExcludeUrl = properties.getProperty("xssfilter.excludeurl", "/");
        try {
            maxUploadSize = Long.parseLong(strMaxUploadSize);
        } catch (NumberFormatException e) {
            logger.error(e.getMessage());
        }

        String[] reqWrapUrlPatterns = xssfilterExcludeUrl.split(",");

        // request의 wrapping가 필요한지 여부 확인
        final boolean needReqWrap = hasContains(request.getRequestURI(), reqWrapUrlPatterns);

        CommonsMultipartResolver multipartResolver = new org.springframework.web.multipart.commons.CommonsMultipartResolver() {

            @Override
            public MultipartHttpServletRequest resolveMultipart(HttpServletRequest request) throws MultipartException {
                Assert.notNull(request, "Request must not be null");
                MultipartParsingResult parsingResult = parseRequest(request);

                if (needReqWrap) {
                    return new RequestXSSWrapper(request, parsingResult.getMultipartFiles(), parsingResult.getMultipartParameters(), parsingResult.getMultipartParameterContentTypes());
                } else {
                    return new DefaultMultipartHttpServletRequest(request, parsingResult.getMultipartFiles(), parsingResult.getMultipartParameters(),
                            parsingResult.getMultipartParameterContentTypes());
                }
            }
        };

        multipartResolver.setMaxUploadSize(maxUploadSize);

        HttpServletRequest processedRequest = request;

        if (multipartResolver.isMultipart(processedRequest)) {
            if (logger.isDebugEnabled() && needReqWrap) {
                logger.debug("Resolving multipart request [" + processedRequest.getRequestURI() + "] with MultipartFilter");
            }
            processedRequest = multipartResolver.resolveMultipart(processedRequest);
        } else {
            if (logger.isDebugEnabled() && needReqWrap) {
                // health check 제외
                if (processedRequest.getRequestURI().indexOf("/health.jsp") == -1) {
                    logger.debug("Request [" + processedRequest.getRequestURI() + "] is NOT a multipart request");
                }
            }
            if (needReqWrap) {
                processedRequest = new NormalRequestXSSWrapper(processedRequest);
            }
        }

        try {
            filterChain.doFilter(processedRequest, response);
        } finally {
            if (processedRequest instanceof MultipartHttpServletRequest) {
                multipartResolver.cleanupMultipart((MultipartHttpServletRequest) processedRequest);
            }
        }
    }

    @Override
    public void destroy() {}

    private boolean hasContains(String url, String[] findStr) {
        for (String str : findStr) {
            if (url.contains(str)) {
                return false;
            }
        }
        return true;
    }
}
