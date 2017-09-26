package com.jaha.evote.common.util;

import java.io.PrintWriter;
import java.util.Enumeration;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class RequestUtils {

    private static final Logger logger = LoggerFactory.getLogger(RequestUtils.class);

    public static String getParameterInfo(HttpServletRequest request) {
        StringBuilder sb = new StringBuilder();

        Enumeration<?> enumParamNames = request.getParameterNames();
        while (enumParamNames.hasMoreElements()) {
            String paramName = (String) enumParamNames.nextElement();

            sb.append("\n").append(paramName).append(" = ").append(request.getParameter(paramName));
        }

        return sb.toString();
    }

    public static String forwardUrl(HttpServletRequest request, String contentUrl) {
        String contentPath = request.getContextPath();
        if (contentPath != null && contentPath.length() > 0) {
            contentUrl = contentUrl.substring(contentPath.length());
        }

        return contentUrl;
    }

    public static String removeParam(String contentUrl, String paramName) {
        if (contentUrl == null || paramName == null || paramName.length() < 1)
            return contentUrl;

        int beginIndex = contentUrl.indexOf(paramName + "=");
        if (beginIndex < 0)
            return contentUrl;

        int endIndex = contentUrl.indexOf('&', beginIndex + paramName.length() + 1);
        if (endIndex < 0) {
            endIndex = contentUrl.length();
            if (beginIndex > 0) {
                beginIndex--;
            }
        } else {
            endIndex++;
        }

        return contentUrl.substring(0, beginIndex) + contentUrl.substring(endIndex);
    }

    public static String removePageNoParam(String contentUrl) {
        return removeParam(contentUrl, "pageNo");
    }

    /**
     * JSP 에 메시지 출력
     * 
     * @param response
     * @param message
     */
    public static void responseWriteException(HttpServletRequest request, HttpServletResponse response, String message, String returnUrl) {

        //response.reset();

        returnUrl = request.getContextPath() + returnUrl;

        try {
            StringBuffer html = new StringBuffer();
            html.append("<html><head>");
            html.append("<title>은평 참여예산정책제안</title>");
            html.append("<script type='text/javascript'>");
            html.append(" alert(\"");
            html.append(message);
            html.append(" \"); ");

            html.append("try {eventKeyCode = 116;parent.eventKeyCode = 116;} catch(e){}");

            html.append("location.href='" + returnUrl + "';");
            html.append("</script></head>");
            html.append("<body></body></html>");

            response.setContentType("text/html;charset=UTF-8");
            response.setCharacterEncoding("UTF-8");
            response.getOutputStream().write(html.toString().getBytes("UTF-8"));

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * JSP 에 메시지 출력
     * 
     * @param response
     * @param message
     */
    public static void responseWriteExceptionPop(HttpServletRequest request, HttpServletResponse response, String message, String returnUrl) {

        //response.reset();

        returnUrl = request.getContextPath() + returnUrl;

        try {
            StringBuffer html = new StringBuffer();
            html.append("<html><head>");
            html.append("<title>은평 참여예산정책제안</title>");
            html.append("<script type='text/javascript'>");
            html.append(" alert(\"");
            html.append(message);
            html.append(" \"); ");
            html.append("self.close();");
            html.append("</script></head>");
            html.append("<body></body></html>");

            response.setContentType("text/html;charset=UTF-8");
            response.setCharacterEncoding("UTF-8");
            response.getOutputStream().write(html.toString().getBytes("UTF-8"));

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static void responseWriteMessage(HttpServletRequest request, HttpServletResponse response, String message, String returnUrl) {

        returnUrl = request.getContextPath() + returnUrl;

        try {
            StringBuffer html = new StringBuffer();
            html.append("<html><head>");
            html.append("<title>은평 참여예산정책제안</title>");
            html.append("<script type='text/javascript'>");
            html.append(" alert(\"");
            html.append(message);
            html.append(" \"); ");
            html.append("location.href='" + returnUrl + "';");
            html.append("</script></head>");
            html.append("<body></body></html>");

            response.setContentType("text/html;charset=UTF-8");
            response.setCharacterEncoding("UTF-8");
            response.getOutputStream().write(html.toString().getBytes("UTF-8"));

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * view단에 alert 찍고 hostory.back 시키기
     * -> EvoteBizException 으로 대체
     * 
     * @param request
     * @param response
     * @param message
     */
    public static void htmlAlert(HttpServletRequest request, HttpServletResponse response, String message) {
        try {
            response.setContentType("text/html;charset=UTF-8");
            PrintWriter out = response.getWriter();
            String alertStr = "<script>alert('" + message + "');history.back();</script>";
            out.println(alertStr);

        } catch (Exception e) {
            logger.error("에러발생 :" + e.getMessage(), e);
        }

    }

}
