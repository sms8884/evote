package com.jaha.evote.common.advice;

import java.io.PrintWriter;

import javax.lang.model.type.NullType;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.ss.formula.functions.T;
import org.codehaus.jackson.map.ObjectMapper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.HttpRequestMethodNotSupportedException;
import org.springframework.web.bind.MissingServletRequestParameterException;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MaxUploadSizeExceededException;
import org.springframework.web.servlet.ModelAndView;

import com.jaha.evote.common.exception.EvoteBizException;
import com.jaha.evote.common.exception.EvoteException;
import com.jaha.evote.common.exception.EvoteFileNotFoundException;
import com.jaha.evote.common.exception.PageNotFoundException;
import com.jaha.evote.common.exception.RestException;
import com.jaha.evote.common.util.Messages;
import com.jaha.evote.domain.ApiResponse;

/**
 * <pre>
 * Class Name : DefaultExceptionHandler.java
 * Description : 에러 핸들러
 *  
 * Modification Information
 * 
 * Mod Date         Modifier    Description
 * -----------      --------    ---------------------------
 * 2016. 10. 12.     jjpark      Generation
 * </pre>
 *
 * @author jjpark
 * @since 2016. 10. 12.
 * @version 1.0
 */
@ControllerAdvice
public class DefaultExceptionHandler {

    private static final Logger LOGGER = LoggerFactory.getLogger(DefaultExceptionHandler.class);

    public static final String DEFAULT_ERROR_VIEW = "error/error";
    public static final String PAGE_NOT_FOUND_VIEW = "error/404";
    public static final String FILE_NOT_FOUND_VIEW = "error/fileNotFound";
    public static final String DEFAULT_ENCODING = "UTF-8";

    @Autowired
    private Messages messages;

    @ExceptionHandler(value = EvoteException.class)
    public ModelAndView handleEvoteException(HttpServletRequest request, EvoteException e) throws Exception {

        printErrorLog(e);

        ModelAndView mav = new ModelAndView();
        mav.addObject("exception", e);
        mav.addObject("url", request.getRequestURL());
        mav.setViewName(getSitePrefix(request) + DEFAULT_ERROR_VIEW);

        return mav;
    }

    @ExceptionHandler(EvoteBizException.class)
    public void handleEvoteBizException(HttpServletRequest request, HttpServletResponse response, EvoteBizException e) {

        printErrorLog(e);

        try {
            response.setContentType("text/html;charset=UTF-8");
            PrintWriter out = response.getWriter();
            String alertStr = "<script>alert('" + e.getMessage() + "');history.back();</script>";
            out.println(alertStr);

        } catch (Exception ex) {
            LOGGER.error("Error EvoteBizException", ex);
        }

    }

    @ExceptionHandler(EvoteFileNotFoundException.class)
    public ModelAndView handleEvoteFileNotFoundException(HttpServletRequest request, EvoteFileNotFoundException e) {

        printErrorLog(e);

        ModelAndView mav = new ModelAndView();
        mav.addObject("exception", e);
        mav.setViewName(getSitePrefix(request) + FILE_NOT_FOUND_VIEW);

        return mav;
    }

    @ExceptionHandler(value = PageNotFoundException.class)
    public ModelAndView handleErrorPageNotFound(HttpServletRequest request, PageNotFoundException e) throws Exception {

        printErrorLog(e);

        ModelAndView mav = new ModelAndView();
        mav.addObject("exception", e);
        mav.addObject("url", request.getRequestURL());
        mav.setViewName(getSitePrefix(request) + PAGE_NOT_FOUND_VIEW);

        return mav;
    }

    @ExceptionHandler(MissingServletRequestParameterException.class)
    public ModelAndView handleMissingServletRequestParameterException(HttpServletRequest request, MissingServletRequestParameterException e) {

        printErrorLog(e);

        ModelAndView mav = new ModelAndView();
        mav.addObject("exception", e);
        mav.addObject("url", request.getRequestURL());
        mav.setViewName(getSitePrefix(request) + PAGE_NOT_FOUND_VIEW);

        return mav;
    }

    @ExceptionHandler(HttpRequestMethodNotSupportedException.class)
    public ModelAndView handleHttpRequestMethodNotSupportedException(HttpServletRequest request, HttpServletResponse response, HttpRequestMethodNotSupportedException e) {

        printErrorLog(e);

        if (request.getRequestURI().startsWith("/api")) {
            try {
                ApiResponse<NullType> apiResponse = new ApiResponse<>("99", "FAILURE : HttpRequestMethodNotSupportedException");
                ObjectMapper objectMapper = new ObjectMapper();
                response.getWriter().print(objectMapper.writeValueAsString(apiResponse));
                return null;
            } catch (Exception ex) {
                LOGGER.error("### handleHttpRequestMethodNotSupportedException : {}", ex.getMessage());
            }
        }

        ModelAndView mav = new ModelAndView();
        mav.addObject("exception", e);
        mav.addObject("url", request.getRequestURL());
        mav.setViewName(getSitePrefix(request) + PAGE_NOT_FOUND_VIEW);
        return mav;

    }

    @ExceptionHandler(Exception.class)
    public ModelAndView handleException(HttpServletRequest request, Exception e) {

        printErrorLog(e);
        LOGGER.error("### PrintStackTrace : ", e);

        ModelAndView mav = new ModelAndView();
        mav.addObject("exception", e);
        mav.setViewName(getSitePrefix(request) + DEFAULT_ERROR_VIEW);

        return mav;
    }

    @ExceptionHandler(RestException.class)
    @ResponseBody
    public ApiResponse<T> handleRestException(HttpServletRequest request, HttpServletResponse response, RestException e) {

        printErrorLog(e);

        try {
            return new ApiResponse<T>(e.getErrroCode(), e.getErrorMessage());
        } catch (Exception ex) {
            LOGGER.error("Error RestException", ex);
        }
        return new ApiResponse<T>("99", "FAILURE");
    }

    @ExceptionHandler(MaxUploadSizeExceededException.class)
    public void handleMaxUploadSizeExceededException(HttpServletRequest request, HttpServletResponse response, MaxUploadSizeExceededException e) {

        printErrorLog(e);

        try {
            response.setContentType("text/html;charset=UTF-8");
            PrintWriter out = response.getWriter();
            // 2MB이하의 파일을 첨부할 수 있습니다
            String message = messages.getMessage("message.common.file.size.exceed");
            String alertStr = "<script>alert('" + message + "');history.back();</script>";
            out.println(alertStr);

        } catch (Exception ex) {
            LOGGER.error("Error MaxUploadSizeExceededException", ex);
        }

    }

    @ExceptionHandler(SecurityException.class)
    public void handleSecurityException(HttpServletRequest request, HttpServletResponse response, SecurityException e) {

        printErrorLog(e);

        try {
            response.setContentType("text/html;charset=UTF-8");
            PrintWriter out = response.getWriter();
            // 업로드할 수 없는 확장자 입니다.
            String message = messages.getMessage("message.common.file.ext.error");
            String alertStr = "<script>alert('" + message + "');history.back();</script>";
            out.println(alertStr);

        } catch (Exception ex) {
            LOGGER.error("Error SecurityException", ex);
        }

    }

    private void printErrorLog(Exception e) {
        LOGGER.error("================================================================================");
        LOGGER.error("### Exception : {}", e.getClass().getName());
        LOGGER.error("### Exception caught: {}", e.getMessage());
        LOGGER.error("================================================================================");
    }

    private String getSitePrefix(HttpServletRequest request) {
        String requestURI = request.getRequestURI().trim();
        if (requestURI.indexOf("/admin") > -1) {
            return "admin/";
        } else {
            return "";
        }
    }
}
