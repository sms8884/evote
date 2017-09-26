/**
 * Copyright (c) 2016 JAHA SMART CORP., LTD ALL RIGHT RESERVED
 *
 * 2016. 7. 15.
 */
package com.jaha.evote.common.filter;

import java.io.IOException;

import javax.servlet.FilterChain;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.filter.OncePerRequestFilter;
import org.springframework.web.multipart.MaxUploadSizeExceededException;

import com.jaha.evote.common.util.RequestUtils;

/**
 * <pre>
 * Class Name : MultipartExceptionHandler.java
 * Description : Description
 *  
 * Modification Information
 * 
 * Mod Date         Modifier    Description
 * -----------      --------    ---------------------------
 * 2016. 7. 15.     jjpark      Generation
 * </pre>
 *
 * @author jjpark
 * @since 2016. 7. 15.
 * @version 1.0
 */
public class MultipartExceptionHandler extends OncePerRequestFilter {

    @Override
    protected void doFilterInternal(HttpServletRequest req, HttpServletResponse res, FilterChain filterChain) throws ServletException, IOException {

        try {
            filterChain.doFilter(req, res);
        } catch (MaxUploadSizeExceededException me) {
            handle(req, res, me);
        } catch (ServletException se) {
            if (se.getRootCause() instanceof MaxUploadSizeExceededException) {
                handle(req, res, (MaxUploadSizeExceededException) se.getRootCause());
            } else {
                throw se;
            }
        }

    }

    private void handle(HttpServletRequest req, HttpServletResponse res, MaxUploadSizeExceededException me) throws ServletException, IOException {
        logger.info("MaxUploadSizeExceededException is handled in custom filter");
        RequestUtils.htmlAlert(req, res, "파일 업로드 최대 용량은 2MB 입니다.");
    }

}
