/**
 * Copyright (c) 2016 by jahasmart.com. All rights reserved.
 */
package com.jaha.evote.controller.front;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mobile.device.Device;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.jaha.evote.common.util.Messages;
import com.jaha.evote.common.util.RequestUtils;
import com.jaha.evote.common.util.SessionUtil;
import com.jaha.evote.common.util.XecureUtil;
import com.jaha.evote.controller.common.BaseController;
import com.jaha.evote.domain.Member;
import com.jaha.evote.service.LoginService;

/**
 * <pre>
 * Class Name : LoginController.java
 * Description : 로그인 컨트롤러
 *  
 * Modification Information
 * 
 * Mod Date         Modifier    Description
 * -----------      --------    ---------------------------
 * 2016. 9. 29.     jjpark      Generation
 * 2016. 9. 29.     jjpark      휴대폰 로그인 삭제
 * </pre>
 *
 * @author jjpark
 * @since 2016. 9. 29.
 * @version 1.0
 */
@Controller
public class LoginController extends BaseController {

    //    @Autowired
    //    private MemberService memberService;

    @Autowired
    private LoginService loginService;

    //    @Autowired
    //    private SmsService smsService;

    @Autowired
    private Messages messages;

    private static final String LOGINPAGE = "/login";
    private static final String REDIRECT_INDEX = "redirect:/index";


    /**
     * 로그인 화면
     * 
     * @param req
     * @param session
     * @return
     */
    @RequestMapping(value = "/login")
    public String home(HttpServletRequest req, HttpSession session) {
        return LOGINPAGE;
    }

    /**
     * 이메일 회원 로그인
     * 
     * @param request
     * @param res
     * @param email
     * @param userPw
     * @return
     */
    @RequestMapping(value = "/email-login-proc", method = RequestMethod.POST)
    public String emailLogin(HttpServletRequest request, HttpServletResponse response, @RequestParam(value = "email") String email, @RequestParam(value = "userPw") String userPw, Device device) {

        logger.debug("### login ::: [{}]", email);

        Member member = loginService.getLoginMemberInfo(email, userPw);

        if (member == null) {
            // 아이디나 비밀번호가 일치하지 않습니다
            String message = messages.getMessage("message.login.email.003");
            RequestUtils.responseWriteException(request, response, message, LOGINPAGE);
            return null;
        }

        SessionUtil sessionUtil = new SessionUtil();

        // push key
        String pushKey = null;

        // 로그인 이전 요청됐던 URL 정보 저장 후 session invalidate
        String requestURL = null;
        HttpSession session = request.getSession();
        if (session != null) {

            String encPushKey = (String) session.getAttribute("p");
            if (StringUtils.isNotEmpty(encPushKey)) {
                pushKey = XecureUtil.decString(encPushKey);
                logger.debug("### pushKey : [{}]", pushKey);
            }

            requestURL = (String) session.getAttribute("requestURL");
            session.invalidate();
        }

        // 사용자 정보 세션 저장
        sessionUtil.saveSessionInfo(request, member);

        // 로그인 아이피
        String loginIp = request.getHeader("X-FORWARDED-FOR");
        if (loginIp == null) {
            loginIp = request.getRemoteAddr();
        }

        // 최종접속일시 등록
        loginService.updateLastLoginDate(member.getUserSeq(), pushKey, loginIp);

        if (StringUtils.isNotEmpty(requestURL)) {
            return "redirect:" + (StringUtils.isNotEmpty(request.getContextPath()) ? StringUtils.substringAfter(requestURL, request.getContextPath()) : requestURL);
        } else {
            return REDIRECT_INDEX;
        }

    }

    ///////////////////////////////////////////////////////////////////////////
    // 
    // 삭제 [2016-09-29]
    //
    //    /**
    //     * 휴대폰 회원 로그인
    //     * 
    //     * @param request
    //     * @param res
    //     * @param phone
    //     * @param code
    //     * @param key
    //     * @return
    //     */
    //    @RequestMapping(value = "/phone-login-proc", method = RequestMethod.POST)
    //    public String phoneLogin(HttpServletRequest request, HttpServletResponse res, @RequestParam(value = "phoneNumber") String phone, @RequestParam(value = "phoneAuthCode") String code,
    //            @RequestParam(value = "phoneKey") String key) {
    //
    //        logger.debug("### phone ::: [{}]", phone);
    //        logger.debug("### code ::: [{}]", code);
    //        logger.debug("### key ::: [{}]", key);
    //
    //        Map<String, String> map = smsService.checkAuthWithDestPhone(code, key, phone);
    //
    //        if (map == null || !phone.equals(map.get("DEST_PHONE"))) {
    //            // 등록되지 않은 휴대폰번호입니다. 휴대폰번호를 확인한 다음 다시 시도해주세요.
    //            String message = messages.getMessage("message.login.phone.003");
    //            RequestUtils.responseWriteException(request, res, message, LOGINPAGE);
    //            return null;
    //        }
    //
    //        Member member = memberService.selectSiteUserInfoByPhone(phone);
    //
    //        SessionUtil sessionUtil = new SessionUtil();
    //
    //        // 로그인 이전 요청됐던 URL 정보 저장 후 session invalidate
    //        String requestURL = null;
    //        HttpSession session = request.getSession();
    //        if (session != null) {
    //            requestURL = (String) session.getAttribute("requestURL");
    //            session.invalidate();
    //        }
    //
    //        // 사용자 정보 세션 저장
    //        sessionUtil.saveSessionInfo(request, member);
    //
    //        // 최종접속일시 등록
    //        loginService.updateLastLoginDate(member.getUserSeq());
    //
    //        if (StringUtils.isNotEmpty(requestURL)) {
    //            return "redirect:" + (StringUtils.isNotEmpty(request.getContextPath()) ? StringUtils.substringAfter(requestURL, request.getContextPath()) : requestURL);
    //        } else {
    //            return REDIRECT_INDEX;
    //        }
    //
    //    }
    //
    //    /**
    //     * 휴대폰 인증
    //     * 
    //     * @param request
    //     * @param response
    //     * @param phoneNumber
    //     * @return
    //     */
    //    @RequestMapping(value = "/phone-auth-req", method = RequestMethod.POST)
    //    @ResponseBody
    //    public Map<String, Object> phoneAuthReq(HttpServletRequest request, HttpServletResponse response, @RequestParam(value = "phoneNumber") String phoneNumber) {
    //
    //        Map<String, Object> map = new HashMap<>();
    //
    //        Member member = memberService.selectSiteUserInfoByPhone(phoneNumber);
    //
    //        if (member == null) {
    //            // 등록되지 않은 휴대폰번호입니다. 휴대폰번호를 확인한 다음 다시 시도해주세요.
    //            String message = messages.getMessage("message.login.phone.003");
    //            map.put("result", "N");
    //            map.put("message", message);
    //            return map;
    //        } else if (UserType.EMAIL.equals(member.getUserType())) {
    //            // 이메일 로그인을 이용해주세요.
    //            String message = messages.getMessage("message.login.phone.004");
    //            map.put("result", "N");
    //            map.put("message", message);
    //            return map;
    //        }
    //
    //        String code = String.format("%06d", (int) (Math.random() * 1000000));
    //        String key = RandomKeys.make(32);
    //
    //        // [참여예산정책제안] 본인확인 인증번호는 [{0}]입니다.
    //        String msg = messages.getMessage("message.common.sms.001", code);
    //        smsService.sendMsgNow(phoneNumber, msg, code, key);
    //
    //        map.put("result", "Y");
    //        map.put("key", key);
    //
    //        return map;
    //    }
    //
    //    /**
    //     * 인증번호 검증
    //     * 
    //     * @param request
    //     * @param response
    //     * @param code
    //     * @param key
    //     * @return
    //     */
    //    @RequestMapping(value = "/phone-auth-check", method = RequestMethod.POST)
    //    @ResponseBody
    //    public Map<String, Object> phoneAuthCode(HttpServletRequest request, HttpServletResponse response, @RequestParam(value = "phone") String phone, @RequestParam(value = "code") String code,
    //            @RequestParam(value = "key") String key) {
    //
    //        Map<String, Object> map = new HashMap<>();
    //
    //        if (smsService.checkAuth(code, key, phone)) {
    //            map.put("result", true);
    //        } else {
    //            map.put("result", false);
    //        }
    //
    //        return map;
    //    }

    /**
     * 로그아웃
     * 
     * @param request
     * @return
     */
    @RequestMapping(value = "/logout")
    public String logout(HttpServletRequest request) {
        request.getSession().invalidate();
        return REDIRECT_INDEX;
    }

    // 삭제 [2016-09-29]
    //
    //    /**
    //     * login & 회원가입 유도 팝업
    //     */
    //    @RequestMapping(value = "/memberLoginPopup")
    //    public String memberLogin(HttpServletRequest request) {
    //        return "/member-login-popup";
    //    }

    private boolean isApp(HttpServletRequest request) {
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if (cookie.getName().equals("mtype")) {
                    if ("app".equals(cookie.getValue())) {
                        return true;
                    }
                }
            }
        }
        return false;
    }

}
