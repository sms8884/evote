/**
 * Copyright (c) 2016 by jahasmart.com. All rights reserved.
 */
package com.jaha.evote.controller.front;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.jaha.evote.common.exception.EvoteBizException;
import com.jaha.evote.common.util.Messages;
import com.jaha.evote.common.util.RequestUtils;
import com.jaha.evote.common.util.SessionUtil;
import com.jaha.evote.common.util.StringUtils;
import com.jaha.evote.controller.common.BaseController;
import com.jaha.evote.domain.Member;
import com.jaha.evote.domain.Terms;
import com.jaha.evote.domain.common.Address;
import com.jaha.evote.domain.type.TermsType;
import com.jaha.evote.domain.type.UserType;
import com.jaha.evote.service.AddressService;
import com.jaha.evote.service.LoginService;
import com.jaha.evote.service.MemberService;
import com.jaha.evote.service.SmsService;
import com.jaha.evote.service.TermsService;

/**
 * <pre>
 * Class Name : MemberController.java
 * Description : 멤버 컨트롤러
 *  
 * Modification Information
 * 
 * Mod Date         Modifier    Description
 * -----------      --------    ---------------------------
 * 2016. 9. 29.     jjpark      Generation
 * </pre>
 *
 * @author jjpark
 * @since 2016. 9. 29.
 * @version 1.0
 */
@Controller
public class MemberController extends BaseController {

    @Autowired
    private MemberService memberService;

    @Autowired
    private TermsService termsService;

    @Autowired
    private SmsService smsService;

    @Autowired
    private AddressService addressService;

    @Autowired
    private LoginService loginService;

    @Autowired
    private Messages messages;

    private static final String REDIRECT_LOGIN = "redirect:/login";

    //    private static final String REDIRECT_INDEX = "redirect:/index";

    /**
     * 회원 정보 조회
     * 
     * @param request
     * @param response
     * @return
     */
    @RequestMapping(value = {"/member/info"}, method = RequestMethod.GET)
    public ModelAndView memberInfo(HttpServletRequest request, HttpServletResponse response) {

        Member sessionMember = SessionUtil.getSessionInfo(request);

        if (sessionMember == null) {
            // 로그인  후 이용하실수 있습니다.
            RequestUtils.responseWriteMessage(request, response, messages.getMessage("message.common.noLogin.001"), "/login");
            return null;
        }

        List<Terms> termsList = termsService.selectTermsList();

        Map<String, Object> param = new HashMap<>();

        param.put("user_seq", sessionMember.getUserSeq());
        Member member = memberService.getUserInfoById(param);

        ModelAndView mav = new ModelAndView();
        mav.addObject("userInfo", member);
        mav.setViewName("/member/member-info");

        if (termsList != null && termsList.size() > 0) {
            for (Terms terms : termsList) {
                if (TermsType.SERVICE.equals(terms.getTermsType())) {
                    mav.addObject("termsService", terms);
                } else if (TermsType.PRIVACY2.equals(terms.getTermsType())) {
                    mav.addObject("termsPrivacy2", terms);
                } else if (TermsType.PRIVACY3.equals(terms.getTermsType())) {
                    mav.addObject("termsPrivacy3", terms);
                }
            }
        }

        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if (cookie.getName().equals("mtype")) {
                    if ("app".equals(cookie.getValue())) {
                        mav.addObject("isApp", true);
                    }
                }
            }
        }

        return mav;
    }

    ///////////////////////////////////////////////////////////////////////////
    //
    // 삭제 [2016-09-29]
    // 
    //    /**
    //     * 회원 가입 화면
    //     * 
    //     * @param request
    //     * @param response
    //     * @return
    //     */
    //    @RequestMapping(value = {"/member/join"}, method = RequestMethod.GET)
    //    public String memberJoin(HttpServletRequest request, HttpServletResponse response) {
    //
    //        // 기존 세션 invalidate
    //        request.getSession().invalidate();
    //        request.getSession(true);
    //
    //        return "/member/join";
    //    }
    //
    //    /**
    //     * 휴대폰번호 가입 화면
    //     * 
    //     * @param request
    //     * @param response
    //     * @return
    //     */
    //    @RequestMapping(value = {"/member/join-phone"}, method = RequestMethod.GET)
    //    public ModelAndView memberJoinPhone(HttpServletRequest request, HttpServletResponse response) {
    //
    //        // 기존 세션 invalidate
    //        //request.getSession().invalidate();
    //        //request.getSession(true);
    //
    //        List<Address> emdList = addressService.selectSiteEmdList();
    //        List<Terms> termsList = termsService.selectTermsList();
    //
    //        ModelAndView mav = new ModelAndView();
    //        mav.setViewName("/member/join-phone");
    //        mav.addObject("emdList", emdList);
    //
    //        if (termsList != null && termsList.size() > 0) {
    //            for (Terms terms : termsList) {
    //                if (TermsType.SERVICE.equals(terms.getTermsType())) {
    //                    mav.addObject("termsService", terms);
    //                } else if (TermsType.PRIVACY2.equals(terms.getTermsType())) {
    //                    mav.addObject("termsPrivacy2", terms);
    //                } else if (TermsType.PRIVACY3.equals(terms.getTermsType())) {
    //                    mav.addObject("termsPrivacy3", terms);
    //                }
    //            }
    //        }
    //
    //        return mav;
    //    }

    /**
     * 이메일 가입 화면
     * 
     * @param request
     * @param response
     * @return
     */
    @RequestMapping(value = {"/member/join"}, method = RequestMethod.GET)
    public ModelAndView memberJoinEmail(HttpServletRequest request, HttpServletResponse response) {

        // 기존 세션 invalidate
        //request.getSession().invalidate();
        //request.getSession(true);

        List<Address> emdList = addressService.selectSiteEmdList();
        List<Terms> termsList = termsService.selectTermsList();

        ModelAndView mav = new ModelAndView();
        mav.setViewName("/member/join-email");
        mav.addObject("emdList", emdList);

        // 시군구명
        if (emdList != null && !emdList.isEmpty()) {
            mav.addObject("sidoNm", emdList.get(0).getSidoNm());
            mav.addObject("sggNm", emdList.get(0).getSggNm());
        }

        if (termsList != null && termsList.size() > 0) {
            for (Terms terms : termsList) {
                if (TermsType.SERVICE.equals(terms.getTermsType())) {
                    mav.addObject("termsService", terms);
                } else if (TermsType.PRIVACY2.equals(terms.getTermsType())) {
                    mav.addObject("termsPrivacy2", terms);
                } else if (TermsType.PRIVACY3.equals(terms.getTermsType())) {
                    mav.addObject("termsPrivacy3", terms);
                }
            }
        }

        return mav;
    }

    /**
     * 인증번호 전송
     * 
     * @param phoneNumber
     * @return
     */
    @RequestMapping(value = {"/member/phone-auth-req"}, method = RequestMethod.POST)
    @ResponseBody
    public Map<String, Object> phoneAuthReq(HttpServletRequest request, HttpServletResponse response, @RequestParam(value = "birthdate", required = false) String birthdate,
            @RequestParam(value = "phoneNumber") String phoneNumber) {

        Map<String, Object> map = new HashMap<>();

        // 휴대폰 번호 조회
        if (memberService.existPhoneNumber(phoneNumber)) {
            map.put("result", "N");
            // 이미 등록된 휴대폰번호입니다
            map.put("message", messages.getMessage("message.member.join.004"));
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
     * 인증번호 검증
     * 
     * @param request
     * @param response
     * @param code
     * @param key
     * @return
     */
    @RequestMapping(value = {"/member/phone-auth-check"}, method = RequestMethod.POST)
    @ResponseBody
    public Map<String, Object> phoneAuthCode(HttpServletRequest request, HttpServletResponse response, @RequestParam(value = "phone") String phone, @RequestParam(value = "code") String code,
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
     * 이메일 체크
     * 
     * @param request
     * @param email
     * @return
     */
    @ResponseBody
    @RequestMapping(value = "/member/check-email", method = RequestMethod.POST)
    public boolean checkEmail(HttpServletRequest request, @RequestParam(value = "email") String email) {

        logger.debug("### email ::: [{}]", email);

        return memberService.getUserInfoByEmail(email) == null ? true : false;
    }

    /**
     * 닉네임 체크
     * 
     * @param request
     * @param nickname
     * @return
     */
    @ResponseBody
    @RequestMapping(value = "/member/check-nickname", method = RequestMethod.POST)
    public boolean checkNickname(HttpServletRequest request, @RequestParam(value = "nickname") String nickname) {

        logger.debug("### nickname ::: [{}]", nickname);

        return !memberService.existNickname(nickname);
    }

    /**
     * 이메일 회원 가입
     * 
     * @param request
     * @param response
     * @param param
     * @return
     */
    @RequestMapping(value = {"/member/join-email-proc"}, method = RequestMethod.POST)
    public String joinEmailProc(RedirectAttributes redirectAttributes, HttpServletRequest request, HttpServletResponse response, @RequestParam HashMap<String, String> param) {

        logger.debug("### joinEmailProc");

        memberService.insertMember(param, UserType.EMAIL);

        redirectAttributes.addFlashAttribute("type", "email");

        return REDIRECT_LOGIN;

    }

    ///////////////////////////////////////////////////////////////////////////
    // 
    // 삭제 [2016-09-29]
    //    /**
    //     * 휴대폰 회원 가입
    //     * 
    //     * @param request
    //     * @param response
    //     * @param param
    //     * @return
    //     */
    //    @RequestMapping(value = {"/member/join-phone-proc"}, method = RequestMethod.POST)
    //    public String joinPhoneProc(RedirectAttributes redirectAttributes, HttpServletRequest request, HttpServletResponse response, @RequestParam HashMap<String, String> param) {
    //
    //        logger.debug("### joinPhoneProc");
    //
    //        if (memberService.insertMember(param, UserType.PHONE) > 0) {
    //
    //            String phoneNumber = param.get("phoneNumber");
    //            Member member = memberService.selectSiteUserInfoByPhone(phoneNumber);
    //
    //            SessionUtil sessionUtil = new SessionUtil();
    //
    //            // 로그인 이전 요청됐던 URL 정보 저장 후 session invalidate
    //            String requestURL = null;
    //            HttpSession session = request.getSession();
    //            if (session != null) {
    //                requestURL = (String) session.getAttribute("requestURL");
    //                session.invalidate();
    //            }
    //
    //            // 사용자 정보 세션 저장
    //            sessionUtil.saveSessionInfo(request, member);
    //
    //            // 최종접속일시 등록
    //            loginService.updateLastLoginDate(member.getUserSeq());
    //
    //            if (StringUtils.isNotEmpty(requestURL)) {
    //                return "redirect:" + (StringUtils.isNotEmpty(request.getContextPath()) ? StringUtils.substringAfter(requestURL, request.getContextPath()) : requestURL);
    //            } else {
    //                return REDIRECT_INDEX;
    //            }
    //
    //        }
    //
    //        redirectAttributes.addFlashAttribute("type", "phone");
    //
    //        return REDIRECT_LOGIN;
    //
    //    }
    //
    //    /**
    //     * 회원 전환 화면
    //     * 
    //     * @param request
    //     * @param response
    //     * @param param
    //     * @return
    //     */
    //    @RequestMapping(value = "/member/upgrade")
    //    public String memberUpgrade(HttpServletRequest request, HttpServletResponse response) {
    //
    //        return "member/member-upgrade";
    //
    //    }
    //
    //    /**
    //     * 회원 타입 전환
    //     * 
    //     * @param request
    //     * @param response
    //     * @param param
    //     * @return
    //     */
    //    @RequestMapping(value = "/member/upgrade-proc")
    //    public String memberUpgradeProc(HttpServletRequest request, HttpServletResponse response, @RequestParam HashMap<String, String> param) {
    //
    //        memberService.updateMemberType(param, UserType.EMAIL);
    //
    //        request.getSession().invalidate();
    //
    //        // 등록되었습니다. 이메일 주소로 다시 로그인해주세요.
    //        RequestUtils.responseWriteMessage(request, response, messages.getMessage("message.member.join.025"), "/login");
    //
    //        return null;
    //
    //    }

    /**
     * 선택약관 동의/해제
     * 
     * @param req
     * @param res
     * @return
     */
    @RequestMapping(value = "/member/terms-agree")
    @ResponseBody
    public Map<String, Object> termsAgree(HttpServletRequest req, HttpServletResponse res, @RequestParam(value = "termsAgreeYn") String termsAgreeYn) {

        Map<String, Object> resultMap = new HashMap<>();

        int result = memberService.updateTerms(termsAgreeYn);

        if (result > 0) {
            resultMap.put("result", true);
        } else {
            resultMap.put("result", false);
        }

        return resultMap;
    }

    /**
     * 회원 정보 수정 화면
     * 
     * @param request
     * @param response
     * @param userPw
     * @return
     */
    @RequestMapping(value = "/member/modify")
    public ModelAndView modifyMember(HttpServletRequest request, HttpServletResponse response, @RequestParam(value = "userPw") String userPw) {

        //        Member sessionMember = SessionUtil.getSessionInfo(request);
        //
        //        if (sessionMember == null) {
        //            // message.member.join.011=비밀번호가 일치하지 않습니다
        //            String message = messages.getMessage("message.member.join.011");
        //            RequestUtils.htmlAlert(request, response, message);
        //            return null;
        //        }

        Member sessionMember = SessionUtil.getSessionInfo(request);

        Member member = null;

        if (sessionMember == null) {

            // message.common.noLogin.001=로그인  후 이용하실수 있습니다.
            String message = messages.getMessage("message.common.noLogin.001");
            //RequestUtils.htmlAlert(request, response, message);
            //return null;
            throw new EvoteBizException(message);


        } else {

            member = loginService.getLoginMemberInfo(sessionMember.getEmail().getDecValue(), userPw);

            if (member == null) {
                // message.member.join.011=비밀번호가 일치하지 않습니다
                String message = messages.getMessage("message.member.join.011");
                //RequestUtils.htmlAlert(request, response, message);
                //return null;
                throw new EvoteBizException(message);
            }
        }

        List<Address> emdList = addressService.selectSiteEmdList();

        ModelAndView mav = new ModelAndView();
        mav.addObject("userInfo", member);
        mav.addObject("emdList", emdList);
        mav.setViewName("/member/modify");

        return mav;

    }

    /**
     * 회원 정보 수정
     * 
     * @param request
     * @param response
     * @param param
     * @return
     */
    @RequestMapping(value = "/member/modify-proc")
    public String modifyMemberProc(HttpServletRequest request, HttpServletResponse response, @RequestParam HashMap<String, String> param) {

        int result = memberService.updateMember(param);

        logger.debug("### modifyMemberProc result :: [{}]", result);

        return "redirect:/member/info";

    }

    /**
     * 비밀번호 수정 화면
     * 
     * @param request
     * @return
     */
    @RequestMapping(value = "/member/modify-passwd")
    public String modifyPasswd(HttpServletRequest request) {
        return "/member/modify-passwd";
    }

    /**
     * 비밀번호 수정
     * 
     * @param request
     * @param response
     * @param param
     * @return
     */
    @RequestMapping(value = "/member/modify-passwd-proc", method = RequestMethod.POST)
    public String modifyPasswdProc(HttpServletRequest request, HttpServletResponse response, @RequestParam HashMap<String, String> param) {

        int result = memberService.updateMemberPassword(param);

        if (result == -1) {
            // message.member.join.011=비밀번호가 일치하지 않습니다
            String message = messages.getMessage("message.member.join.011");
            //RequestUtils.htmlAlert(request, response, message);
            //return null;
            throw new EvoteBizException(message);
        }

        return "redirect:/member/info";
    }

    /**
     * 비밀번호 수정(mobile)
     * 
     * @param request
     * @param response
     * @param param
     * @return
     */
    @RequestMapping(value = "/member/modify-passwd-proc", method = RequestMethod.PUT, produces = "application/json")
    @ResponseBody
    public Map<String, Object> modifyPasswdProcPut(HttpServletRequest request, HttpServletResponse response, @RequestBody HashMap<String, String> param) {

        int result = memberService.updateMemberPassword(param);

        Map<String, Object> resultMap = new HashMap<>();

        if (result > 0) {
            resultMap.put("result", true);
        } else if (result == -1) {
            // message.member.join.011=비밀번호가 일치하지 않습니다
            String message = messages.getMessage("message.member.join.011");
            resultMap.put("result", false);
            resultMap.put("message", message);
        } else {
            resultMap.put("result", false);
            resultMap.put("message", "비밀번호 변경에 실패했습니다. 다시 시도해 주세요.");
        }

        return resultMap;
    }

    //    /**
    //     * 회원 탈퇴 화면
    //     * 
    //     * @param request
    //     * @return
    //     */
    //    @RequestMapping(value = "/member/withdrawal")
    //    public String withdrawal(HttpServletRequest request) {
    //        return "/member/withdrawal";
    //    }

    /**
     * 회원 탈퇴
     * 
     * @param request
     * @param response
     * @return
     */
    @RequestMapping(value = "/member/withdrawal-proc", method = RequestMethod.POST)
    public String withdrawalProc(HttpServletRequest request, HttpServletResponse response) {

        int result = memberService.updateMemberWithdrawal();

        if (result > 0) {
            request.getSession().invalidate();
        }

        String message = "탈퇴가 정상적으로 처리 되었습니다.";
        RequestUtils.responseWriteMessage(request, response, message, "/");
        return null;

    }

}
