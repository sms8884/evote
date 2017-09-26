/**
 * Copyright (c) 2016 by jahasmart.com. All rights reserved.
 */
package com.jaha.evote.controller.front;

import java.io.File;
import java.io.FileInputStream;
import java.net.URLEncoder;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mobile.device.Device;
import org.springframework.stereotype.Controller;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.util.WebUtils;

import com.jaha.evote.common.util.DateUtils;
import com.jaha.evote.common.util.Messages;
import com.jaha.evote.common.util.RequestUtils;
import com.jaha.evote.common.util.SessionUtil;
import com.jaha.evote.common.util.XecureUtil;
import com.jaha.evote.controller.common.BaseController;
import com.jaha.evote.domain.EncryptedString;
import com.jaha.evote.domain.Member;
import com.jaha.evote.domain.Terms;
import com.jaha.evote.domain.VoteRealm;
import com.jaha.evote.domain.common.Address;
import com.jaha.evote.domain.common.FileInfo;
import com.jaha.evote.domain.type.AgeGroup;
import com.jaha.evote.domain.type.FileGrpType;
import com.jaha.evote.domain.type.FileType;
import com.jaha.evote.domain.type.RoleType;
import com.jaha.evote.domain.type.TermsType;
import com.jaha.evote.domain.type.UserType;
import com.jaha.evote.service.AddressService;
import com.jaha.evote.service.FileService;
import com.jaha.evote.service.MemberService;
import com.jaha.evote.service.TermsService;
import com.jaha.evote.service.VoteService;

/**
 * <pre>
 * Class Name : VoteController.java
 * Description : 투표 컨트롤러
 *  
 * Modification Information
 * 
 * Mod Date         Modifier    Description
 * -----------      --------    ---------------------------
 * 2016. 9. 29.     jjpark      Generation
 * 2016. 11. 14.    jjpark      사용자 투표 기준 변경 : 사용자 일련번호 > 휴대폰 번호
 * </pre>
 *
 * @author jjpark
 * @since 2016. 9. 29.
 * @version 1.0
 */
@Controller
public class VoteController extends BaseController {

    @Inject
    private VoteService voteService;

    @Inject
    private MemberService memberService;

    @Inject
    private FileService fileService;

    @Autowired
    private AddressService addressService;

    @Autowired
    private TermsService termsService;

    @Autowired
    private Messages messages;

    private static final String LOGINPAGE = "/login";
    private static final String VOTEMAINPAGE = "/vote/vote-main";
    private static final String VOTELISTPAGE = "/vote/vote-list";
    private static final String VOTECHOICELISTPAGE = "/vote/vote-choice-list";
    private static final String VOTEDETAILPAGE = "/vote/vote-detail";

    private static final String VOTERESULTLISTPAGE = "/vote/vote-result";
    private static final String VOTERESULTDETAILPAGE = "/vote/vote-result-detail";

    /**
     * 사용자 > 투표정보, 사업제안 리스트
     * 
     * @param req
     * @param res
     * @param device
     * @return
     */
    @RequestMapping(value = "/vote/vote-main")
    public ModelAndView memberVoteMain(HttpServletRequest req, HttpServletResponse res, Device device) {

        ModelAndView mav = new ModelAndView();
        mav.setViewName(VOTEMAINPAGE);

        HashMap<String, Object> param = new HashMap<String, Object>();
        Member member = SessionUtil.getSessionInfo(req);

        /*
         * 일반 사용자 세션, 투표 방문객 세션 이외에는 사용자 세션 리셋
         * 일반 방문객 세션 : 휴대폰 중복체크 하지 않음
         * 투표 방문객 세션 : 휴대폰 중복체크 함
         */
        //if (member != null && !RoleType.USER.equals(member.getRoleType()) && !UserType.VOTE.equals(member.getUserType())) {
        if (member != null && !member.hasRole(RoleType.USER) && !UserType.VOTE.equals(member.getUserType())) {
            logger.debug("### UserType [{}] -->> Session invalidate", member.getUserType());
            req.getSession().invalidate();
        } else {
            mav.addObject("mv", member); // 사용자정보
        }

        // 사용자 ID
        String user_seq = member != null ? String.valueOf(member.getUserSeq()) : "";
        param.put("user_seq", user_seq);
        param.put("forDay", "7"); // 투표마감 7일 후 까지의 투표 정보리스트 가져오기

        /*
         * [2016.11.14]
         * 사용자 투표 기준 변경 : 사용자 일련번호 > 휴대폰 번호
         */
        if (member != null) {
            EncryptedString phone = (EncryptedString) member.getPhone();
            param.put("phone", phone.getValue());
        }

        // 투표리스트
        List<HashMap<String, Object>> voteList = voteService.voteList(param);
        mav.addObject("voteList", voteList); // 투표리스트

        // 사용자의 성인,청소년 구분값 가져오기
        String ageGroup = String.valueOf(WebUtils.getSessionAttribute(req, "ageGroup"));
        mav.addObject("ageGroup", ageGroup);

        // 디바이스체크
        String vote_method = "PC";
        if (device.isNormal()) {
            vote_method = "PC";
        } else {
            vote_method = "MOBILE";
        }
        mav.addObject("vote_method", vote_method);

        // 얼럿메시지 등 스크립트 실행
        //        String script = StringUtils.defaultString(req.getParameter("script"), "");
        //        mav.addObject("script", script);
        logger.info("memberVoteMain");
        return mav;
    }

    /**
     * 사용자 > 투표 > 투표참여 리스트 화면
     * 
     * @param req
     * @param res
     * @param device
     * @return
     */
    @RequestMapping(value = "/vote/vote-list")
    public ModelAndView memberVoteItemList(HttpServletRequest req, HttpServletResponse res, Device device) {

        ModelAndView mav = new ModelAndView();
        mav.setViewName(VOTELISTPAGE);
        HashMap<String, Object> param = new HashMap<String, Object>();

        // 투표ID
        String vote_seq = StringUtils.defaultString(req.getParameter("vote_seq"), "");

        if (vote_seq.equals("")) {
            // 해당 투표정보가 없습니다. 확인후 다시 시도해주세요.
            String message = messages.getMessage("message.vote.007");
            RequestUtils.responseWriteException(req, res, message, VOTEMAINPAGE);
            return null;
        }
        param.put("vote_seq", vote_seq);
        Member mv = SessionUtil.getSessionInfo(req);


        if (mv == null) {
            // 로그인 또는 사용자 인증 후 이용하실수 있습니다.
            String message = messages.getMessage("message.common.noLogin.001");

            // 로그인 후 해당 URL로 리다이렉트 되게 세션에 해당 url 저장
            // String url = req.getScheme() + "://" + req.getServerName() + ":" +
            // req.getServerPort() + req.getRequestURI();
            WebUtils.setSessionAttribute(req, "requestURL", req.getRequestURI() + "?vote_seq=" + vote_seq);
            RequestUtils.responseWriteException(req, res, message, LOGINPAGE);
            return null;

        } else if (mv != null) {

            /*
             * 투표 금지 기간 추가
             * [2016.11.11 추가]
             */

            if ("N".equals(mv.getVoteStat())) {

                // 투표 금지
                // message.vote.015=회원님은 현재 투표가 금지되어 있는 상태입니다.\\n자세한 내용은 관리자에게 문의 주시기 바랍니다.
                String message = messages.getMessage("message.vote.015");
                RequestUtils.responseWriteException(req, res, message, VOTEMAINPAGE);
                return null;

            } else if ("P".equals(mv.getVoteStat())) {

                // 특정 기간 금지
                if (mv.getBanStartDate() != null && mv.getBanEndDate() != null) {
                    Date today = new Date();
                    if (today.compareTo(mv.getBanStartDate()) > 0 && today.compareTo(mv.getBanEndDate()) < 0) {
                        String banStartDate = DateUtils.convertDateFormat(mv.getBanStartDate(), "yyyy년 MM월 dd일");
                        String banEndDate = DateUtils.convertDateFormat(mv.getBanEndDate(), "yyyy년 MM월 dd일");
                        // message.vote.016=회원님은 {0} ~ {1} 까지 \\n투표가 금지되어 있는 상태입니다.\\n자세한 내용은 관리자에게 문의 주시기 바랍니다.
                        String message = messages.getMessage("message.vote.016", banStartDate, banEndDate);
                        RequestUtils.responseWriteException(req, res, message, VOTEMAINPAGE);
                        return null;
                    }
                }

            }
        }


        // 사용자 ID
        String user_seq = String.valueOf(mv.getUserSeq());
        param.put("user_seq", user_seq);

        // 사용자 휴대폰 번호
        EncryptedString phone = (EncryptedString) mv.getPhone();
        param.put("phone", phone.getValue());

        // 투표정보
        HashMap<String, Object> voteInfo = voteService.getVoteInfo(param);
        if (voteInfo == null) { // 투표 정보 없음
            // 해당 투표정보가 없습니다. 확인후 다시 시도해주세요.
            String message = messages.getMessage("message.vote.007");
            RequestUtils.responseWriteException(req, res, message, VOTEMAINPAGE);
            return null;
        }
        mav.addObject("voteInfo", voteInfo); // 투표정보

        // 사용자의 성인,청소년 구분값 가져오기
        String ageGroup = String.valueOf(WebUtils.getSessionAttribute(req, "ageGroup"));
        param.put("ageGroup", ageGroup);

        // 투표 대상 확인
        String target = voteInfo.get("target") != null ? voteInfo.get("target").toString() : "ALL";
        if (!target.equals("ALL")) {
            if (!target.equals(ageGroup)) {
                // 투표 대상이 아닙니다.
                String message = messages.getMessage("message.vote.002");
                RequestUtils.responseWriteException(req, res, message, VOTEMAINPAGE);
                return null;
            }
        }

        // 사용자 투표 완료 여부
        String finish_yn = voteInfo.get("finish_yn") != null ? voteInfo.get("finish_yn").toString() : "N";
        param.put("finish_yn", finish_yn); // 투표 버튼 표시할때도 해당 값 사용

        // 상단 탭에 들어갈 개수 제안목록(보여주기개수 total_cnt), 선택항목(사용자선택(user_choice_cnt)/필수선택(vital_cnt)
        HashMap<String, Object> voteTabCnt = voteService.getVoteTabCnt(param);
        mav.addObject("voteTabCnt", voteTabCnt);

        // 카테고리 정보 가져오기(user_seq,finish_yn,vote_seq, ageGroup)
        List<HashMap<String, Object>> voteRealmList = voteService.getUserVoteRealmList(param);
        mav.addObject("voteRealmList", voteRealmList);

        boolean selCheck = true;
        for (HashMap<String, Object> realm : voteRealmList) {
            // 해당 대상 필수여부 선택
            if (selCheck) {
                if (ageGroup.equals(AgeGroup.YOUNG.toString())) {
                    if (String.valueOf(realm.get("youth_yn")).equals("Y")) { // 청소년일때
                        int choice_cnt = Integer.parseInt(String.valueOf(realm.get("choice_cnt")));
                        int sel_cnt = Integer.parseInt(String.valueOf(realm.get("sel_cnt")));
                        if (choice_cnt == sel_cnt) {
                            selCheck = true;
                        } else {
                            selCheck = false;
                        }
                    }
                } else if (ageGroup.equals(AgeGroup.ADULT.toString())) {// 성인일때
                    if (String.valueOf(realm.get("adult_yn")).equals("Y")) {
                        int choice_cnt = Integer.parseInt(String.valueOf(realm.get("choice_cnt")));
                        int sel_cnt = Integer.parseInt(String.valueOf(realm.get("sel_cnt")));
                        if (choice_cnt == sel_cnt) {
                            selCheck = true;
                        } else {
                            selCheck = false;
                        }
                    }
                } else { // 기타일때 (성인, 청소년 상관없이 모두~
                    int choice_cnt = Integer.parseInt(String.valueOf(realm.get("choice_cnt")));
                    int sel_cnt = Integer.parseInt(String.valueOf(realm.get("sel_cnt")));
                    if (choice_cnt == sel_cnt) {
                        selCheck = true;
                    } else {
                        selCheck = false;
                    }
                }
            }
        }

        mav.addObject("btn_finish", selCheck); // 투표완료 버튼 활성, 비활성 체크하기 위해..

        // 득표 수치 표시 여부
        String result_dp_yn = voteInfo != null ? voteInfo.get("result_dp_yn").toString() : "";
        param.put("result_dp_yn", result_dp_yn);

        // 검색 분야(일괄일때는 (ALL), 분야일때는 각 분야 코드)
        String vote_type = String.valueOf(voteInfo.get("vote_type"));
        // 분야
        String search_realm_cd = StringUtils.defaultString(req.getParameter("search_realm_cd"), "");
        if (search_realm_cd.equals("")) {
            if (vote_type.equals("PART")) {
                search_realm_cd = String.valueOf(voteRealmList.get(0).get("realm_cd"));
            } else {
                search_realm_cd = "ALL";
            }
        }
        param.put("search_realm_cd", search_realm_cd);

        // 정렬조건
        String search_order = StringUtils.defaultString(req.getParameter("search_order"), "dp_ord");
        param.put("search_order", search_order);

        List<HashMap<String, Object>> voteItemList = voteService.voteItemList(param);
        mav.addObject("voteItemList", voteItemList);
        // 정렬조건 (선택항목에는 분야탭표시가 되지 않도록 구분하기 위해 해당 선택 탭코드 넘겨줌)
        mav.addObject("tab_menu", 0);// 제안목록(0),선택목록(1)구분

        mav.addObject("params", param); // 검색값

        // 디바이스체크
        String vote_method = "PC";
        if (device.isNormal()) {
            vote_method = "PC";
        } else {
            vote_method = "MOBILE";
        }
        mav.addObject("vote_method", vote_method);

        // 얼럿메시지 등 스크립트 실행
        //        String script = StringUtils.defaultString(req.getParameter("script"), "");
        //        mav.addObject("script", script);
        logger.info("memberVoteItemList");
        return mav;
    }

    /**
     * 사용자 > 투표 > 투표참여 리스트 화면 > 선택항목
     * 
     * @param req
     * @param res
     * @param device
     * @return
     */
    @RequestMapping(value = "/vote/vote-choice-list")
    public ModelAndView memberChoiceVoteList(HttpServletRequest req, HttpServletResponse res, Device device) {
        ModelAndView mav = new ModelAndView();
        mav.setViewName(VOTECHOICELISTPAGE);
        HashMap<String, Object> param = new HashMap<String, Object>();
        // 투표ID
        String vote_seq = StringUtils.defaultString(req.getParameter("vote_seq"), "");
        if (vote_seq.equals("")) {
            // 해당 투표정보가 없습니다. 확인후 다시 시도해주세요.
            String message = messages.getMessage("message.vote.007");
            RequestUtils.responseWriteException(req, res, message, VOTEMAINPAGE);
            return null;
        }
        param.put("vote_seq", vote_seq);

        Member mv = SessionUtil.getSessionInfo(req);
        if (mv == null) {
            // 로그인 또는 사용자 인증 후 이용하실수 있습니다.
            String message = messages.getMessage("message.common.noLogin.001");
            // 로그인 후 해당 URL로 리다이렉트 되게 세션에 해당 url 저장
            WebUtils.setSessionAttribute(req, "requestURL", req.getRequestURI() + "?vote_seq=" + vote_seq);
            RequestUtils.responseWriteException(req, res, message, LOGINPAGE);
            return null;
        }
        // 사용자 ID
        String user_seq = String.valueOf(mv.getUserSeq());
        param.put("user_seq", user_seq);

        // 사용자 휴대폰 번호
        EncryptedString phone = (EncryptedString) mv.getPhone();
        param.put("phone", phone.getValue());

        // 투표정보
        HashMap<String, Object> voteInfo = voteService.getVoteInfo(param);
        if (voteInfo == null) { // 투표 정보 없음
            // 해당 투표정보가 없습니다. 확인후 다시 시도해주세요.
            String message = messages.getMessage("message.vote.007");
            RequestUtils.responseWriteException(req, res, message, VOTEMAINPAGE);
            return null;
        }
        mav.addObject("voteInfo", voteInfo); // 투표정보

        // 사용자 투표 완료 여부
        String finish_yn = voteInfo.get("finish_yn") != null ? voteInfo.get("finish_yn").toString() : "N";
        param.put("finish_yn", finish_yn);

        // 사용자의 성인,청소년 구분값 가져오기
        String ageGroup = String.valueOf(WebUtils.getSessionAttribute(req, "ageGroup"));
        param.put("ageGroup", ageGroup);

        // 상단 탭에 들어갈 개수 제안목록(보여주기개수 total_cnt), 선택항목(사용자선택(user_choice_cnt)/필수선택(vital_cnt)
        HashMap<String, Object> voteTabCnt = voteService.getVoteTabCnt(param);
        mav.addObject("voteTabCnt", voteTabCnt);

        // 카테고리 정보 가져오기(user_seq,finish_yn,vote_seq, ageGroup)
        List<HashMap<String, Object>> voteRealmList = voteService.getUserVoteRealmList(param);
        mav.addObject("voteRealmList", voteRealmList);

        boolean selCheck = true;
        for (HashMap<String, Object> realm : voteRealmList) {
            // 해당 대상 필수여부 선택
            if (selCheck) {
                if (ageGroup.equals("YOUNG")) { // 청소년
                    if (String.valueOf(realm.get("youth_yn")).equals("Y")) {
                        int choice_cnt = Integer.parseInt(String.valueOf(realm.get("choice_cnt")));
                        int sel_cnt = Integer.parseInt(String.valueOf(realm.get("sel_cnt")));
                        if (choice_cnt == sel_cnt) {
                            selCheck = true;
                        } else {
                            selCheck = false;
                        }
                    }
                } else {
                    if (String.valueOf(realm.get("adult_yn")).equals("Y")) {
                        int choice_cnt = Integer.parseInt(String.valueOf(realm.get("choice_cnt")));
                        int sel_cnt = Integer.parseInt(String.valueOf(realm.get("sel_cnt")));
                        if (choice_cnt == sel_cnt) {
                            selCheck = true;
                        } else {
                            selCheck = false;
                        }
                    }
                }
            }
        }

        mav.addObject("btn_finish", selCheck); // 투표완료 버튼 활성, 비활성 체크하기 위해..

        // 득표 수치 표시 여부
        String result_dp_yn = voteInfo != null ? voteInfo.get("result_dp_yn").toString() : "";
        param.put("result_dp_yn", result_dp_yn);

        // 검색 분야(제안목록에서 선택 .. 제안목록으로 돌아갈때 넘겨줘야 함으로 해당 form에 보관)
        String search_realm_cd = StringUtils.defaultString(req.getParameter("search_realm_cd"), "ALL");
        param.put("search_realm_cd", search_realm_cd);

        // 정렬조건(제안목록에서 선택 .. 제안목록으로 돌아갈때 넘겨줘야 함으로 해당 form에 보관)
        String search_order = StringUtils.defaultString(req.getParameter("search_order"), "dp_ord");
        param.put("search_order", search_order);

        List<HashMap<String, Object>> voterChoiceList = voteService.voterChoiceList(param);
        mav.addObject("voterChoiceList", voterChoiceList);

        // 탭(선택항목에는 분야탭표시가 되지 않도록 구분하기 위해 해당 선택 탭코드 넘겨줌)
        mav.addObject("tab_menu", 1);// 제안목록(0),선택목록(1)구분

        mav.addObject("params", param); // 검색값

        // 디바이스체크
        String vote_method = "PC";
        if (device.isNormal()) {
            vote_method = "PC";
        } else {
            vote_method = "MOBILE";
        }
        mav.addObject("vote_method", vote_method);

        logger.info("memberChoiceVoteList");
        return mav;
    }

    /**
     * 사용자 > 투표정보, 사업제안 상세
     * 
     * @param req
     * @param res
     * @param device
     * @return
     */
    @RequestMapping(value = "/vote/vote-detail")
    public ModelAndView memberVoteDetail(HttpServletRequest req, HttpServletResponse res, Device device) {
        ModelAndView mav = new ModelAndView();
        mav.setViewName(VOTEDETAILPAGE);

        HashMap<String, Object> param = new HashMap<String, Object>();
        Member mv = SessionUtil.getSessionInfo(req);
        if (mv == null) {
            // 로그인 또는 사용자 인증 후 이용하실수 있습니다.
            String message = messages.getMessage("message.common.noLogin.001");
            RequestUtils.responseWriteException(req, res, message, LOGINPAGE);
            return null;
        }
        // 사용자 ID
        String user_seq = String.valueOf(mv.getUserSeq());
        param.put("user_seq", user_seq);

        // 사용자 휴대폰 번호
        EncryptedString phone = (EncryptedString) mv.getPhone();
        param.put("phone", phone.getValue());

        // 사용자 정보
        mv = memberService.getUserInfoById(param);
        mav.addObject("memberInfo", mv);

        // 투표ID
        String vote_seq = StringUtils.defaultString(req.getParameter("vote_seq"), "");
        if (vote_seq.equals("")) {
            // 해당 투표정보가 없습니다. 확인후 다시 시도해주세요.
            String message = messages.getMessage("message.vote.007");
            RequestUtils.responseWriteException(req, res, message, VOTEMAINPAGE);
            return null;
        }
        param.put("vote_seq", vote_seq);

        // 투표정보
        HashMap<String, Object> voteInfo = voteService.getVoteInfo(param);
        if (voteInfo == null) { // 투표 정보 없음
            // 해당 투표정보가 없습니다. 확인후 다시 시도해주세요.
            String message = messages.getMessage("message.vote.007");
            RequestUtils.responseWriteException(req, res, message, VOTEMAINPAGE);
            return null;
        }
        mav.addObject("voteInfo", voteInfo); // 투표정보
        // 수치 표시 여부
        String result_dp_yn = voteInfo != null ? voteInfo.get("result_dp_yn").toString() : "N";
        param.put("result_dp_yn", result_dp_yn);

        String finish_yn = voteInfo.get("finish_yn") != null ? voteInfo.get("finish_yn").toString() : "N";
        param.put("finish_yn", finish_yn);

        // 사업제안ID
        String biz_seq = StringUtils.defaultString(req.getParameter("biz_seq"), "");
        param.put("biz_seq", biz_seq);

        // 제안목록(0),선택목록(1)구분
        String tab_menu = StringUtils.defaultString(req.getParameter("tab_menu"), "0");
        mav.addObject("tab_menu", tab_menu);

        // 사업제안 내용
        HashMap<String, Object> voteItemInfo = new HashMap<String, Object>();
        if (tab_menu.equals("0")) { // 제안 목록이면 제안 목록에서 이전,다음
            voteItemInfo = voteService.getVoteItem(param);
        } else { // 선택 항목이면 선택 항목한것 중에서 이전, 다음
            voteItemInfo = voteService.getSelectVoteItem(param);
        }

        mav.addObject("voteItemInfo", voteItemInfo);
        // 파일 리스트
        List<FileInfo> image_file = fileService.selectFileInfoList(Long.parseLong(biz_seq), FileGrpType.VOTE, FileType.IMAGE);
        List<FileInfo> attach_file = fileService.selectFileInfoList(Long.parseLong(biz_seq), FileGrpType.VOTE, FileType.ATTACH);
        mav.addObject("image_file", image_file);
        mav.addObject("attach_file", attach_file);

        // 검색 분야 (상세는 무조건 제안 목록으로 된다.)
        String search_realm_cd = StringUtils.defaultString(String.valueOf(voteItemInfo.get("realm_cd")));
        param.put("search_realm_cd", search_realm_cd);

        // 해당 제안의 분야정보(사용자선택개수(sel_cnt), max선택개수(choice_cnt) )
        HashMap<String, Object> voteRealm = voteService.getUserVoteRealm(param);
        mav.addObject("voteRealm", voteRealm);

        // 사용자의 성인,청서년 구분값 가져오기
        String ageGroup = String.valueOf(WebUtils.getSessionAttribute(req, "ageGroup"));
        param.put("ageGroup", ageGroup);

        // 상단 탭에 들어갈 개수 제안목록(보여주기개수 total_cnt), 선택항목(사용자선택(user_choice_cnt)/필수선택(vital_cnt)
        HashMap<String, Object> voteTabCnt = voteService.getVoteTabCnt(param);
        mav.addObject("voteTabCnt", voteTabCnt);

        // 카테고리 정보 가져오기(user_seq,finish_yn,vote_seq, ageGroup)
        List<HashMap<String, Object>> voteRealmList = voteService.getUserVoteRealmList(param);
        mav.addObject("voteRealmList", voteRealmList);

        boolean selCheck = true;
        for (HashMap<String, Object> realm : voteRealmList) {
            // 해당 대상 필수여부 선택
            if (selCheck) {
                if (ageGroup.equals("YOUNG")) { // 청소년
                    if (String.valueOf(realm.get("youth_yn")).equals("Y")) {
                        int choice_cnt = Integer.parseInt(String.valueOf(realm.get("choice_cnt")));
                        int sel_cnt = Integer.parseInt(String.valueOf(realm.get("sel_cnt")));
                        if (choice_cnt == sel_cnt) {
                            selCheck = true;
                        } else {
                            selCheck = false;
                        }
                    }
                } else {
                    if (String.valueOf(realm.get("adult_yn")).equals("Y")) {
                        int choice_cnt = Integer.parseInt(String.valueOf(realm.get("choice_cnt")));
                        int sel_cnt = Integer.parseInt(String.valueOf(realm.get("sel_cnt")));
                        if (choice_cnt == sel_cnt) {
                            selCheck = true;
                        } else {
                            selCheck = false;
                        }
                    }
                }
            }
        }

        mav.addObject("btn_finish", selCheck); // 투표완료 버튼 활성, 비활성 체크하기 위해..

        // 정렬조건(제안목록에서 선택 .. 제안목록으로 돌아갈때 넘겨줘야 함으로 해당 form에 보관)
        String search_order = StringUtils.defaultString(req.getParameter("search_order"), "dp_ord");
        param.put("search_order", search_order);

        mav.addObject("params", param); // 검색값


        // 디바이스체크
        String vote_method = "PC";
        if (device.isNormal()) {
            vote_method = "PC";
        } else {
            vote_method = "MOBILE";
        }
        mav.addObject("vote_method", vote_method);

        // 얼럿메시지 등 스크립트 실행
        //        String script = StringUtils.defaultString(req.getParameter("script"), "");
        //        mav.addObject("script", script);
        logger.info("memberVoteDetail");
        return mav;
    }

    /**
     * 사용자 > 투표 > 투표 결과보기
     * 
     * @param req
     * @param res
     * @param device
     * @return
     */
    @RequestMapping(value = "/vote/vote-result")
    public ModelAndView memberVoteResultList(HttpServletRequest req, HttpServletResponse res, Device device) {

        ModelAndView mav = new ModelAndView();
        mav.setViewName(VOTERESULTLISTPAGE);
        HashMap<String, Object> param = new HashMap<String, Object>();

        // 투표ID
        String vote_seq = StringUtils.defaultString(req.getParameter("vote_seq"), "");

        if (vote_seq.equals("")) {
            // 해당 투표정보가 없습니다. 확인후 다시 시도해주세요.
            String message = messages.getMessage("message.vote.007");
            RequestUtils.responseWriteException(req, res, message, VOTEMAINPAGE);
            return null;
        }
        param.put("vote_seq", vote_seq);

        Member mv = SessionUtil.getSessionInfo(req);

        //        if (mv == null) {
        //            // 로그인 또는 사용자 인증 후 이용하실수 있습니다.
        //            String message = messages.getMessage("message.common.noLogin.001");
        //            WebUtils.setSessionAttribute(req, "requestURL", req.getRequestURI() + "?vote_seq=" + vote_seq);
        //            RequestUtils.responseWriteException(req, res, message, LOGINPAGE);
        //            return null;
        //        }

        if (mv != null) {
            // 사용자 ID
            String user_seq = String.valueOf(mv.getUserSeq());
            param.put("user_seq", user_seq);

            // 사용자 휴대폰 번호
            EncryptedString phone = (EncryptedString) mv.getPhone();
            param.put("phone", phone.getValue());
        }

        // 투표정보
        HashMap<String, Object> voteInfo = voteService.getVoteInfo(param);

        if (voteInfo == null) { // 투표 정보 없음

            // 해당 투표정보가 없습니다. 확인후 다시 시도해주세요.
            String message = messages.getMessage("message.vote.007");
            RequestUtils.responseWriteException(req, res, message, VOTEMAINPAGE);
            return null;

        } else {

            // 투표진행방식 : 일괄(ALL)/분야별(PART)
            String voteType = (String) voteInfo.get("vote_type");

            mav.addObject("voteInfo", voteInfo); // 투표정보

            if ("ALL".equals(voteType)) {

                // 일괄투표결과
                List<HashMap<String, Object>> voteResultList = voteService.getUserVoteResultList(param);
                mav.addObject("voteResultList", voteResultList); // 검색값

            } else if ("PART".equals(voteType)) {

                // 분야별 투표일 경우 분야 항목 조회

                AgeGroup ageGroup = (AgeGroup) WebUtils.getSessionAttribute(req, "ageGroup");

                List<VoteRealm> voteRealmList = voteService.selectVoteRealmList(vote_seq, ageGroup);

                if (voteRealmList != null) {
                    mav.addObject("voteRealmList", voteRealmList);

                    String realmCd = req.getParameter("realm_cd");

                    if (realmCd == null) {
                        realmCd = (String) (voteRealmList.get(0)).getRealmCd();
                    }
                    param.put("realm_cd", realmCd);

                    List<HashMap<String, Object>> voteResultList = voteService.getUserVoteResultList(param);

                    mav.addObject("voteResultList", voteResultList); // 검색값
                    mav.addObject("currRealmCd", realmCd);
                }
            }



        }

        mav.addObject("params", param); // 검색값

        // 디바이스체크
        String vote_method = "PC";
        if (device.isNormal()) {
            vote_method = "PC";
        } else {
            vote_method = "MOBILE";
        }
        mav.addObject("vote_method", vote_method);

        logger.info("memberVoteList");
        return mav;
    }

    /**
     * 사용자 > 투표정보, 사업제안 상세
     * 
     * @param req
     * @param res
     * @param device
     * @return
     */
    @RequestMapping(value = "/vote/vote-result-detail")
    public ModelAndView memberVoteResultDetail(HttpServletRequest req, HttpServletResponse res, Device device) {
        ModelAndView mav = new ModelAndView();
        mav.setViewName(VOTERESULTDETAILPAGE);

        HashMap<String, Object> param = new HashMap<String, Object>();
        Member mv = SessionUtil.getSessionInfo(req);

        //        if (mv == null) {
        //            // 로그인 또는 사용자 인증 후 이용하실수 있습니다.
        //            String message = messages.getMessage("message.common.noLogin.001");
        //            RequestUtils.responseWriteException(req, res, message, LOGINPAGE);
        //            return null;
        //        }

        // 비회원도 접근 가능하도록 수정 [2016.11.15]
        if (mv != null) {

            // 사용자 ID
            String user_seq = String.valueOf(mv.getUserSeq());
            param.put("user_seq", user_seq);

            // 사용자 휴대폰 번호
            EncryptedString phone = (EncryptedString) mv.getPhone();
            param.put("phone", phone.getValue());

            // 사용자 정보
            mv = memberService.getUserInfoById(param);
            mav.addObject("memberInfo", mv);
        }

        param.put("result_dp_yn", "Y");
        param.put("finish_yn", "Y");

        // 사업제안ID
        String biz_seq = StringUtils.defaultString(req.getParameter("biz_seq"), "");
        param.put("biz_seq", biz_seq);
        // 사업제안 내용
        HashMap<String, Object> voteItemInfo = new HashMap<String, Object>();
        voteItemInfo = voteService.getVoteItem(param);
        mav.addObject("voteItemInfo", voteItemInfo);
        // 파일 리스트
        List<FileInfo> image_file = fileService.selectFileInfoList(Long.parseLong(biz_seq), FileGrpType.VOTE, FileType.IMAGE);
        List<FileInfo> attach_file = fileService.selectFileInfoList(Long.parseLong(biz_seq), FileGrpType.VOTE, FileType.ATTACH);
        mav.addObject("image_file", image_file);
        mav.addObject("attach_file", attach_file);

        mav.addObject("params", param); // 검색값
        // 디바이스체크
        String vote_method = "PC";
        if (device.isNormal()) {
            vote_method = "PC";
        } else {
            vote_method = "MOBILE";
        }
        mav.addObject("vote_method", vote_method);

        logger.info("memberVoteResultDetail");
        return mav;
    }

    /**
     * 사용자 > 투표정보, 사업제안 임시저장
     * 
     * @param req
     * @param res
     * @return
     */
    @RequestMapping(value = "/vote/savetemp")
    public ModelAndView memberVoteSaveTemp(HttpServletRequest req, HttpServletResponse res) {
        ModelAndView mav = new ModelAndView();
        mav.setViewName("redirect:" + VOTEDETAILPAGE);

        Member mv = SessionUtil.getSessionInfo(req);
        if (mv == null) {
            // 로그인 또는 사용자 인증 후 이용하실수 있습니다.
            String message = messages.getMessage("message.common.noLogin.001");
            RequestUtils.responseWriteException(req, res, message, LOGINPAGE);
            return null;
        }
        HashMap<String, Object> param = new HashMap<String, Object>();

        // 사용자 ID
        String user_seq = String.valueOf(mv.getUserSeq());
        param.put("user_seq", user_seq);

        // 사용자 휴대폰 번호
        EncryptedString phone = (EncryptedString) mv.getPhone();
        param.put("phone", phone.getValue());

        // 투표ID
        String vote_seq = StringUtils.defaultString(req.getParameter("vote_seq"), "");
        if (vote_seq.equals("")) {
            // 해당 투표정보가 없습니다. 확인후 다시 시도해주세요.
            String message = messages.getMessage("message.vote.007");
            RequestUtils.responseWriteException(req, res, message, VOTEMAINPAGE);
            return null;
        }
        param.put("vote_seq", vote_seq);
        // 분야
        String search_realm_cd = StringUtils.defaultString(req.getParameter("search_realm_cd"), "");
        param.put("search_realm_cd", search_realm_cd);

        // 사용자가 투표참여했는지 여부확인
        HashMap<String, Object> voterInfo = voteService.getVoterInfo(param);

        String finish_yn = voterInfo != null ? voterInfo.get("finish_yn").toString() : "N";
        param.put("finish_yn", finish_yn);

        // 해당 제안의 분야정보(사용자선택개수(sel_cnt), max선택개수(choice_cnt) )
        HashMap<String, Object> voteRealm = voteService.getUserVoteRealm(param);

        // 필수선택개수
        int choice_cnt = Integer.parseInt(voteRealm.get("choice_cnt").toString());
        // 사용자 선택개수
        int select_cnt = Integer.parseInt(voteRealm.get("sel_cnt").toString());

        // 제안ID
        String biz_seq = StringUtils.defaultString(req.getParameter("biz_seq"), "");
        param.put("biz_seq", biz_seq);

        // 제안목록(0),선택목록(1)구분
        String tab_menu = StringUtils.defaultString(req.getParameter("tab_menu"), "0");

        // 체크인지 해제인지 여부
        String event = StringUtils.defaultString(req.getParameter("event"), "");

        if (event.equals("add")) {
            if (select_cnt >= choice_cnt) {
                String redirect_url = VOTEDETAILPAGE + "?vote_seq=" + vote_seq + "&biz_seq=" + biz_seq;
                // 선택가능 개수를 초과하였습니다.
                String message = messages.getMessage("message.vote.009");
                RequestUtils.responseWriteException(req, res, message, redirect_url);
                return null;
            } else {
                voteService.insertVoterChoiceTemp(param);
                // 선택하였습니다.
                //                String script = "alert('" + messages.getMessage("message.vote.013") + "');";
                //                mav.addObject("script", script);
            }
        } else if (event.equals("del")) {
            voteService.deleteVoterChoiceTemp(param);
            tab_menu = "0";
            // 선택하였습니다.
            //            String script = "alert('" + messages.getMessage("message.vote.014") + "');";
            //            mav.addObject("script", script);
        }

        mav.addObject("tab_menu", tab_menu); // 탭 메뉴
        mav.addObject("vote_seq", vote_seq);
        mav.addObject("biz_seq", biz_seq);

        return mav;
    }

    /**
     * 사용자 > 투표정보, 사업제안 저장
     * 
     * @param req
     * @param res
     * @param device
     * @return
     */
    @RequestMapping(value = "/vote/save")
    public ModelAndView memberVoteSave(HttpServletRequest req, HttpServletResponse res, Device device) {
        ModelAndView mav = new ModelAndView();
        mav.setViewName("redirect:" + VOTELISTPAGE); // 투표 결과 화면
        Member mv = SessionUtil.getSessionInfo(req);
        if (mv == null) {
            // 로그인 또는 사용자 인증 후 이용하실수 있습니다.
            String message = messages.getMessage("message.common.noLogin.001");
            RequestUtils.responseWriteException(req, res, message, LOGINPAGE);
            return null;
        }
        HashMap<String, Object> param = new HashMap<String, Object>();
        // 사용자 ID
        String user_seq = String.valueOf(mv.getUserSeq());
        param.put("user_seq", user_seq);

        // 사용자 휴대폰 번호
        EncryptedString phone = (EncryptedString) mv.getPhone();
        param.put("phone", phone.getValue());
        param.put("gender", mv.getGender());
        param.put("region_cd", mv.getRegionCd());
        param.put("sido_nm", mv.getSidoNm());
        param.put("sgg_nm", mv.getSggNm());
        param.put("emd_nm", mv.getEmdNm());
        param.put("birth_year", mv.getBirthYear());
        param.put("user_type", mv.getUserType());


        // 투표ID
        String vote_seq = StringUtils.defaultString(req.getParameter("vote_seq"), "");
        if (vote_seq.equals("")) {
            // 해당 투표정보가 없습니다. 확인후 다시 시도해주세요.
            String message = messages.getMessage("message.vote.007");
            RequestUtils.responseWriteException(req, res, message, VOTEMAINPAGE);
            return null;
        }
        param.put("vote_seq", vote_seq);

        String vote_method = "PC";
        // if (req.getHeader("User-Agent").indexOf("Mobile") != -1) {
        if (device.isNormal()) {
            vote_method = "PC";
        } else {
            vote_method = "MOBILE";
        }
        param.put("vote_method", vote_method);
        // 사용자가 투표참여했는지 여부 확인하기 위해 투표자 조회
        HashMap<String, Object> voterInfo = voteService.getVoterInfo(param);
        // 사용자 투표 완료 여부
        String finish_yn = voterInfo != null ? voterInfo.get("finish_yn").toString() : "N";
        // 이미 사용자가 참여 완료 했다면
        if (finish_yn.equals("Y")) {
            // 이미 해당 투표에 참여하셨습니다.
            String message = messages.getMessage("message.vote.010");
            RequestUtils.responseWriteException(req, res, message, VOTEMAINPAGE);
            return null;
        }
        param.put("finish_yn", finish_yn); // 투표 버튼 표시할때도 해당 값 사용

        // 사용자의 성인,청소년 구분값 가져오기
        String ageGroup = String.valueOf(WebUtils.getSessionAttribute(req, "ageGroup"));
        param.put("ageGroup", ageGroup);

        List<HashMap<String, Object>> voteRealmList = voteService.getUserVoteRealmList(param);
        mav.addObject("voteRealmList", voteRealmList);

        // 필수 분야에 체크 완료 했는지 확인
        boolean selCheck = true;
        for (HashMap<String, Object> realm : voteRealmList) {
            // 해당 대상 필수여부 선택
            if (selCheck) {
                if (ageGroup.equals(AgeGroup.YOUNG.toString())) { // 청소년
                    if (String.valueOf(realm.get("youth_yn")).equals("Y")) {
                        int choice_cnt = Integer.parseInt(String.valueOf(realm.get("choice_cnt")));
                        int sel_cnt = Integer.parseInt(String.valueOf(realm.get("sel_cnt")));
                        if (choice_cnt == sel_cnt) {
                            selCheck = true;
                        } else {
                            selCheck = false;
                        }
                    }
                } else if (ageGroup.equals(AgeGroup.ADULT.toString())) { // 성인
                    if (String.valueOf(realm.get("adult_yn")).equals("Y")) {
                        int choice_cnt = Integer.parseInt(String.valueOf(realm.get("choice_cnt")));
                        int sel_cnt = Integer.parseInt(String.valueOf(realm.get("sel_cnt")));
                        if (choice_cnt == sel_cnt) {
                            selCheck = true;
                        } else {
                            selCheck = false;
                        }
                    }
                } else { // 기타 (성인,청소년구분없이 전체
                    int choice_cnt = Integer.parseInt(String.valueOf(realm.get("choice_cnt")));
                    int sel_cnt = Integer.parseInt(String.valueOf(realm.get("sel_cnt")));
                    if (choice_cnt == sel_cnt) {
                        selCheck = true;
                    } else {
                        selCheck = false;
                    }
                }
            }
        } // end for

        if (selCheck) {
            try {
                // 투표참여자정보저장
                voteService.saveVoter(param);
                // 투표가 완료되었습니다. 참여해주셔서 감사합니다.
                //                String script = "alert('" + messages.getMessage("message.vote.006") + "');";
                //                mav.addObject("script", script);
            } catch (Exception e) {
                e.printStackTrace();
                String redirect_url = VOTELISTPAGE + "?vote_seq=" + vote_seq;
                // 참여정보 저장에 실패하였습니다. \n이전에 투표한 적이 있는지 관리자에게 확인해주세요.
                String message = messages.getMessage("message.vote.011");
                RequestUtils.responseWriteException(req, res, message, redirect_url);
                return null;
            }
        } else {
            String redirect_url = VOTELISTPAGE + "?vote_seq=" + vote_seq + "&tab_menu=1";
            // 선택하셔야 하는 개수가 미달됩니다. \n선택개수를 확인 후 다시 선택 시도해주세요.
            String message = messages.getMessage("message.vote.012");
            RequestUtils.responseWriteException(req, res, message, redirect_url);
            return null;
        }

        mav.addObject("vote_seq", vote_seq);
        return mav;
    }

    /**
     * 파일 다운로드
     * 
     * @param req
     * @param response
     * @throws Exception
     */
    @ResponseBody
    @RequestMapping(value = "/vote/download")
    public void voteDownload(HttpServletRequest req, HttpServletResponse response) throws Exception {
        // 투표ID
        String vote_seq = StringUtils.defaultString(req.getParameter("vote_seq"), "");

        // 제안ID
        String biz_seq = StringUtils.defaultString(req.getParameter("biz_seq"), "");
        HashMap<String, Object> param = new HashMap<String, Object>();
        param.put("vote_seq", vote_seq);
        param.put("biz_seq", biz_seq);
        String defaultfilepath = req.getSession().getServletContext().getRealPath("/");
        // 사업제안 내용
        HashMap<String, Object> voteItemInfo = voteService.getVoteItem(param);
        String file_full_path = voteItemInfo != null ? voteItemInfo.get("attach_url").toString() : "";
        String file_name = "";

        if (file_full_path != "") {
            int pos = file_full_path.lastIndexOf("/");
            file_name = file_full_path.substring(pos + 1);
            voteItemInfo.put("file_name", file_name);
            String browser = req.getHeader("User-Agent");
            try {
                // 파일 인코딩
                if (browser.contains("MSIE") || browser.contains("Trident") || browser.contains("Chrome")) {
                    file_name = URLEncoder.encode(file_name, "UTF-8").replaceAll("\\+", "%20");
                } else {
                    file_name = new String(file_name.getBytes("UTF-8"), "ISO-8859-1");
                }
                response.setContentType("application/octet-stream");
                response.setHeader("Content-Disposition", "attachment; filename=\"" + file_name + "\"");
                response.setHeader("Content-Transfer-Encoding", "binary");
                try {
                    FileCopyUtils.copy(new FileInputStream(new File(defaultfilepath + file_full_path)), response.getOutputStream());
                } catch (Exception e) {
                    // response.sendRedirect("/common/404");
                    logger.error(e.getMessage());
                }
            } catch (Exception ex) {
                logger.error(ex.getMessage());
            }
        }
    }


    //=========================================================================
    // 2차 추가
    //=========================================================================

    /**
     * 투표 > 비회원 휴대폰 인증
     * 
     * @return
     */
    @RequestMapping(value = "/vote/auth-phone")
    public ModelAndView voteAuthPhone() {

        List<Address> emdList = addressService.selectSiteEmdList();
        List<Terms> termsList = termsService.selectTermsList();

        ModelAndView mav = new ModelAndView();
        mav.setViewName("/vote/vote-auth-phone");

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
     * 투표 > 비회원 로그인
     * 
     * @param request
     * @param param
     * @return
     */
    @RequestMapping(value = "/vote/visitor/login-proc")
    public String voteVisitorLogin(HttpServletRequest request, @RequestParam Map<String, Object> param) {

        String regionCd = (String) param.get("regionCd");
        String phoneNumber = (String) param.get("phoneNumber");
        String birthYear = (String) param.get("birthYear");
        String birthDate = (String) param.get("birthMonth") + (String) param.get("birthDate");
        String gender = (String) param.get("gender");

        // visitor session 생성을 위해 member 객체 생성
        Member visitor = new Member();

        visitor.setUserType(UserType.VOTE);
        visitor.setSiteCd(getSiteCd(request));

        visitor.setUserSeq(0L);

        Address address = addressService.selectAddress(regionCd);
        if (address != null) {
            visitor.setSidoNm(address.getSidoNm()); // 시도명
            visitor.setSggNm(address.getSggNm()); // 시군구명
            visitor.setEmdNm(address.getEmdNm()); // 읍면동명
        }
        visitor.setRegionCd(regionCd);
        visitor.setPhone(new EncryptedString(XecureUtil.encString(phoneNumber)));

        visitor.setBirthYear(birthYear);
        visitor.setBirthDate(birthDate);
        visitor.setGender(gender);

        HttpSession session = request.getSession();
        if (session != null) {
            session.invalidate();
        }

        SessionUtil sessionUtil = new SessionUtil();

        // vote visitor session 생성
        sessionUtil.saveSessionInfo(request, visitor);

        return "redirect:/vote/vote-main";
    }
}
