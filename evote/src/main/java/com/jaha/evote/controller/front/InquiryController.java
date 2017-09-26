/**
 * Copyright (c) 2016 by jahasmart.com. All rights reserved.
 */
package com.jaha.evote.controller.front;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.jaha.evote.common.util.Messages;
import com.jaha.evote.controller.common.BaseController;
import com.jaha.evote.domain.Member;
import com.jaha.evote.service.MemberService;
import com.jaha.evote.service.SmsService;

/**
 * <pre>
 * Class Name : InquiryController.java
 * Description : 아이디/비밀번호 찾기
 *  
 * Modification Information
 * 
 * Mod Date         Modifier    Description
 * -----------      --------    ---------------------------
 * 2016. 9. 12.     jjpark      Generation
 * </pre>
 *
 * @author jjpark
 * @since 2016. 9. 12.
 * @version 1.0
 */
@Controller
public class InquiryController extends BaseController {

    @Autowired
    private MemberService memberService;

    @Autowired
    private SmsService smsService;

    @Autowired
    private Messages messages;

    private static final String LOGINPAGE = "/login";
    //    private static final String REDIRECT_INDEX = "redirect:/index";


    //=========================================================================
    // 아이디 찾기
    //=========================================================================

    /**
     * 아이디 찾기
     * 
     * @param request
     * @return
     */
    @RequestMapping(value = "/inquiry/userid")
    public String inquiryUserid(HttpServletRequest request) {
        return "inquiry/userid";
    }

    /**
     * 아이디 찾기 인증번호 발송
     * 
     * @param request
     * @param response
     * @param phoneNumber
     * @param userNm
     * @return
     */
    @RequestMapping(value = "/inquiry/userid-req", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, Object> inquiryUseridReq(HttpServletRequest request, HttpServletResponse response, @RequestParam(value = "phoneNumber") String phoneNumber,
            @RequestParam(value = "userNm") String userNm) {

        Map<String, Object> map = new HashMap<>();

        Member member = memberService.selectInquiryUser(phoneNumber, userNm, null);

        if (member == null) {
            // message.inquiry.userid.003=일치하는 회원정보가 없습니다. 입력한 정보를 확인해주세요.
            String message = messages.getMessage("message.inquiry.userid.003");
            map.put("result", "N");
            map.put("message", message);
            return map;
        }

        // 인증번호 발송
        String key = smsService.sendMessage(phoneNumber);

        if (StringUtils.isNotEmpty(key)) {
            map.put("result", "Y");
            map.put("key", key);
        } else {
            map.put("result", "N");
        }

        return map;
    }

    /**
     * 아이디 찾기 인증번호 검증
     * 
     * @param request
     * @param response
     * @param phone
     * @param code
     * @param key
     * @return
     */
    @RequestMapping(value = "/inquiry/userid-auth-check", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, Object> useridAuthCheck(HttpServletRequest request, HttpServletResponse response, @RequestParam(value = "phone") String phone, @RequestParam(value = "code") String code,
            @RequestParam(value = "key") String key) {

        Map<String, Object> map = new HashMap<>();

        if (smsService.checkAuth(code, key, phone)) {
            Member member = memberService.getUserInfoByPhone(phone);
            map.put("email", member.getEmail());
            map.put("result", true);

        } else {
            map.put("result", false);
        }

        return map;
    }


    //=========================================================================
    // 비밀번호 찾기
    //=========================================================================

    /**
     * 비밀번호 찾기
     * 
     * @param request
     * @return
     */
    @RequestMapping(value = "/inquiry/userpw")
    public String inquiryUserpw(HttpServletRequest request) {
        return "inquiry/userpw";
    }

    /**
     * 비밀번호 찾기 인증번호 발송
     * 
     * @param request
     * @param response
     * @param phoneNumber
     * @param email
     * @return
     */
    @RequestMapping(value = "/inquiry/userpw-req", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, Object> inquiryUserpwReq(HttpServletRequest request, HttpServletResponse response, @RequestParam(value = "phoneNumber") String phoneNumber,
            @RequestParam(value = "email") String email) {

        Map<String, Object> map = new HashMap<>();

        Member member = memberService.selectInquiryUser(phoneNumber, null, email);

        if (member == null) {
            // message.inquiry.userid.003=일치하는 회원정보가 없습니다. 입력한 정보를 확인해주세요.
            String message = messages.getMessage("message.inquiry.userid.003");
            map.put("result", "N");
            map.put("message", message);
            return map;
        }

        // 인증번호 발송
        String key = smsService.sendMessage(phoneNumber);

        if (StringUtils.isNotEmpty(key)) {
            map.put("result", "Y");
            map.put("key", key);
        } else {
            map.put("result", "N");
        }

        return map;
    }

    /**
     * 비밀번호 찾기 인증번호 검증
     * 
     * @param request
     * @param response
     * @param phone
     * @param code
     * @param key
     * @return
     */
    @RequestMapping(value = "/inquiry/userpw-auth-check", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, Object> userpwAuthCheck(HttpServletRequest request, HttpServletResponse response, @RequestParam(value = "phone") String phone, @RequestParam(value = "code") String code,
            @RequestParam(value = "key") String key) {

        Map<String, Object> map = new HashMap<>();

        if (smsService.checkAuth(code, key, phone)) {
            map.put("result", true);
        } else {
            map.put("result", false);
        }

        return map;
    }

    /**
     * 비밀번호 재설정
     * 
     * @param request
     * @param response
     * @param phone
     * @param code
     * @param key
     * @param email
     * @param userPw
     * @return
     */
    @RequestMapping(value = "/inquiry/reset-userpw", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, Object> resetUserpw(HttpServletRequest request, HttpServletResponse response, @RequestParam(value = "phone") String phone, @RequestParam(value = "code") String code,
            @RequestParam(value = "key") String key, @RequestParam(value = "email") String email, @RequestParam(value = "userPw") String userPw) {

        Map<String, Object> map = new HashMap<>();

        if (memberService.resetUserPw(phone, code, key, email, userPw)) {
            map.put("result", true);
            map.put("loginUrl", LOGINPAGE);
        } else {
            map.put("result", false);
        }

        return map;
    }

}
