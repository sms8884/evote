/**
 * Copyright (c) 2016 by jahasmart.com. All rights reserved.
 *
 * 2016. 7. 11.
 */
package com.jaha.evote.controller.admin;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.jaha.evote.common.util.Messages;
import com.jaha.evote.common.util.RequestUtils;
import com.jaha.evote.common.util.SessionUtil;
import com.jaha.evote.controller.common.BaseController;
import com.jaha.evote.domain.AdminUser;
import com.jaha.evote.service.LoginService;

/**
 * <pre>
 * Class Name : AdminLoginController.java
 * Description : Description
 *  
 * Modification Information
 * 
 * Mod Date         Modifier    Description
 * -----------      --------    ---------------------------
 * 2016. 7. 14.     jjpark      Generation
 * </pre>
 *
 * @author jjpark
 * @since 2016. 7. 14.
 * @version 1.0
 */
@Controller
public class AdminLoginController extends BaseController {

    @Autowired
    private LoginService loginService;

    @Autowired
    private Messages messages;

    private static final String REDIRECT_MAINPAGE = "redirect:/admin/proposal/proposal_list";
    private static final String LOGINPAGE = "/admin/login";
    private static final String REDIRECT_LOGINPAGE = "redirect:" + LOGINPAGE;

    /**
     * 로그인 화면
     * 
     * @param req
     * @param session
     * @return
     */
    @RequestMapping(value = "/admin/login")
    public String login(HttpServletRequest req, HttpSession session) {

        AdminUser adminUser = SessionUtil.getAdminSessionInfo(req);
        if (adminUser == null) {
            // admin session 이 없을 경우 로그인 페이지로 이동
            return LOGINPAGE;
        } else {
            // admin session 이 있을 경우 메인 페이지로 이동
            return REDIRECT_MAINPAGE;
        }
    }

    /**
     * 관리자 로그인
     * 
     * @param req
     * @param res
     * @param mgrId
     * @param mgrPw
     * @return
     */
    @RequestMapping(value = "/admin/login-proc", method = RequestMethod.POST)
    public String login(HttpServletRequest req, HttpServletResponse res, @RequestParam(value = "mgrId") String mgrId, @RequestParam(value = "mgrPw") String mgrPw) {

        logger.debug("### mgrId ::: [{}]", mgrId);

        AdminUser adminUser = loginService.getLoginAdminInfo(mgrId, mgrPw);

        if (adminUser == null) {
            // message.login.email.003=아이디나 비밀번호가 일치하지 않습니다
            String message = messages.getMessage("message.login.email.003");
            RequestUtils.responseWriteException(req, res, message, LOGINPAGE);
            return null;
        }

        SessionUtil sessionUtil = new SessionUtil();

        // 로그인 이전 요청됐던 URL 정보 저장 후 session invalidate
        String requestURL = null;
        HttpSession session = req.getSession();
        if (session != null) {
            requestURL = (String) session.getAttribute("requestURL");
            if (requestURL != null && requestURL.indexOf("/admin") < 0) {
                // front 에서 admin site로 이동 시 이전 URL 제거
                requestURL = null;
            }
            session.invalidate();
        }

        // 사용자 정보 세션 저장
        sessionUtil.saveAdminSessionInfo(req, adminUser);

        // 로그인 아이피
        String loginIp = req.getHeader("X-FORWARDED-FOR");
        if (loginIp == null) {
            loginIp = req.getRemoteAddr();
        }

        // 최종접속일시 등록
        loginService.updateLastLoginDate(adminUser.getMgrSeq(), null, loginIp);

        if (StringUtils.isNotEmpty(requestURL)) {
            return "redirect:" + (StringUtils.isNotEmpty(req.getContextPath()) ? StringUtils.substringAfter(requestURL, req.getContextPath()) : requestURL);
        } else {
            return REDIRECT_MAINPAGE;
        }

    }

    //    @RequestMapping(value = "/admin/main")
    //    public String home(HttpServletRequest req, HttpSession session) {
    //        return "main";
    //    }

    /**
     * 로그아웃
     * 
     * @param request
     * @return
     */
    @RequestMapping(value = "/admin/logout")
    public String logout(HttpServletRequest request) {
        request.getSession().invalidate();
        return REDIRECT_LOGINPAGE;
    }

}
