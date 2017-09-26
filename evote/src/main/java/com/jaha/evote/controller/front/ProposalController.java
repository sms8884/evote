/**
 * Copyright (c) 2016 by jahasmart.com. All rights reserved.
 */
package com.jaha.evote.controller.front;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mobile.device.Device;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.springframework.web.util.WebUtils;

import com.jaha.evote.common.exception.EvoteBizException;
import com.jaha.evote.common.util.FileUploadUtil;
import com.jaha.evote.common.util.Messages;
import com.jaha.evote.common.util.PagingHelper;
import com.jaha.evote.common.util.RequestUtils;
import com.jaha.evote.common.util.SessionUtil;
import com.jaha.evote.common.util.StringUtils;
import com.jaha.evote.common.util.XecureUtil;
import com.jaha.evote.controller.common.BaseController;
import com.jaha.evote.domain.EncryptedString;
import com.jaha.evote.domain.Member;
import com.jaha.evote.domain.PropComment;
import com.jaha.evote.domain.Proposal;
import com.jaha.evote.domain.ProposalAudit;
import com.jaha.evote.domain.PublicSubscription;
import com.jaha.evote.domain.Terms;
import com.jaha.evote.domain.common.FileInfo;
import com.jaha.evote.domain.type.CodeType;
import com.jaha.evote.domain.type.FileGrpType;
import com.jaha.evote.domain.type.FileType;
import com.jaha.evote.domain.type.ProposalStatus;
import com.jaha.evote.domain.type.RoleType;
import com.jaha.evote.domain.type.TermsType;
import com.jaha.evote.domain.type.UserType;
import com.jaha.evote.service.AddressService;
import com.jaha.evote.service.CodeService;
import com.jaha.evote.service.FileService;
import com.jaha.evote.service.MemberService;
import com.jaha.evote.service.ProposalService;
import com.jaha.evote.service.RealmService;
import com.jaha.evote.service.SmsService;
import com.jaha.evote.service.TermsService;

/**
 * <pre>
 * Class Name : ProposalController.java
 * Description : 사업제안 컨트롤러
 *  
 * Modification Information
 * 
 * Mod Date         Modifier    Description
 * -----------      --------    ---------------------------
 * 2016. 7. 13.     shavrani    Generation
 * 2016. 10. 26.    jjpark      RequestUtils.htmlAlert -> EvoteBizException 변경
 * </pre>
 *
 * @author shavrani
 * @since 2016. 7. 13.
 * @version 1.0
 */
@Controller
public class ProposalController extends BaseController {

    private final Logger logger = LoggerFactory.getLogger(this.getClass());

    private static final int ERROR_NOT_LOGIN = -10;
    private static final int ERROR_NOT_EMAIL_MEMBER = -20;
    private static final int ERROR_BLOCK_COMMENT = -30;
    private static final int ERROR_NOT_FOUND = -99;

    private static final String REDIRECT_PROPOSAL_LIST = "redirect:/proposal/list";

    @Inject
    private ProposalService proposalService;
    @Inject
    private RealmService realmService;
    @Inject
    private AddressService addressService;
    @Inject
    private FileUploadUtil fileUploadUtil;
    @Inject
    private FileService fileService;
    @Inject
    private CodeService codeService;
    @Inject
    private Messages messages;

    @Autowired
    private MemberService memberService;

    @Autowired
    private SmsService smsService;

    @Autowired
    private TermsService termsService;

    @Value("${common.paging.default.row}")
    private String pagingDefaultRow;

    @Value("${common.paging.default.col}")
    private String pagingDefaultCol;

    /**
     * 주민참여예산제 > 소개
     * 
     * @param request
     * @param response
     * @param params
     * @return
     */
    @RequestMapping(value = "/proposal/intro")
    public String intro(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, Object> params) {
        return "proposal/proposal-intro";
    }

    /**
     * 주민참여예산제 > 운영계획
     * 
     * @param request
     * @param response
     * @param params
     * @return
     */
    @RequestMapping(value = "/proposal/plan")
    public String plan(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, Object> params) {
        return "proposal/proposal-plan";
    }

    /**
     * 주민참여예산제 > 정책제안
     * 
     * @param request
     * @param response
     * @param params
     * @return
     */
    @RequestMapping(value = {"/proposal/guide", "/proposal/login"})
    public ModelAndView guide(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, Object> params) {

        PublicSubscription publicSubscription = proposalService.selectCurrentPublicSubscription();

        List<Proposal> proposalList = proposalService.selectMainProposalList();

        ModelAndView mav = new ModelAndView();

        if (publicSubscription != null) {
            mav.setViewName("proposal/proposal-pssrp");
        } else {
            mav.setViewName("proposal/proposal-guide");
        }

        String requestUri = request.getRequestURI();
        if (requestUri.indexOf("/proposal/login") >= 0) {
            // 로그인 후 제안 등록 페이지로 이동
            WebUtils.setSessionAttribute(request, "requestURL", "/proposal/write");
            mav.addObject("proposalLoginYn", "Y");
        }

        mav.addObject("proposalList", proposalList);
        mav.addObject("pssrp", publicSubscription);

        return mav;
    }

    @RequestMapping(value = "/proposal/sample")
    public String proposalSample(HttpServletRequest request, HttpServletResponse response) {
        return "proposal/proposal-sample";
    }

    /**
     * 휴대폰 인증
     * 
     * @param request
     * @param response
     * @param params
     * @return
     */
    @RequestMapping(value = "/proposal/auth-phone")
    public ModelAndView authPhone(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, Object> params) {

        ModelAndView mav = new ModelAndView();
        mav.setViewName("proposal/proposal-auth-phone");

        List<Terms> termsList = termsService.selectTermsList();

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
    @RequestMapping(value = {"/proposal/phone-auth-req"}, method = RequestMethod.POST)
    @ResponseBody
    public Map<String, Object> phoneAuthReq(HttpServletRequest request, HttpServletResponse response, @RequestParam(value = "phoneNumber") String phoneNumber) {

        Map<String, Object> map = new HashMap<>();

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
    @RequestMapping(value = {"/proposal/phone-auth-check"}, method = RequestMethod.POST)
    @ResponseBody
    public Map<String, Object> phoneAuthCode(HttpServletRequest request, HttpServletResponse response, @RequestParam(value = "phone") String phone, @RequestParam(value = "code") String code,
            @RequestParam(value = "key") String key) {

        Map<String, Object> map = new HashMap<>();

        if (smsService.checkAuth(code, key, phone)) {

            // 휴대폰 인증 완료 후 방문객 세션 생성
            SessionUtil sessionUtil = new SessionUtil();
            sessionUtil.invalidateAndSaveVisitorSession(request, phone, UserType.PROPOSAL);

            map.put("result", true);
        } else {
            map.put("result", false);
        }
        return map;
    }

    /**
     * 정책제안 목록
     * 
     * @param request
     * @param response
     * @param params
     * @param pagingHelper
     * @return
     */
    @RequestMapping(value = {"/proposal/list", "/proposal/complete-list"})
    public ModelAndView proposalList(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, Object> params, PagingHelper pagingHelper) {

        ModelAndView mav = new ModelAndView();

        String requestUri = request.getRequestURI();
        if (requestUri.indexOf("complete-list") >= 0) {
            params.put("status", ProposalStatus.COMPLETE.toString());
            mav.setViewName("proposal/proposal-complete-list");
        } else {
            mav.setViewName("proposal/proposal-list");
        }

        int listCount = proposalService.selectProposalListCount(params);

        pagingHelper.setTotalCnt(listCount);

        /** paging setting */
        // CommonUtil.setPagingParams(params);
        params.put("deleteYn", "N");

        // PagingHelper 변수로 변환
        params.put("startNum", pagingHelper.getStartRow() - 1);
        params.put("endNum", pagingHelper.getPagingRow());

        List<Proposal> proposalList = proposalService.selectProposalList(params);

        mav.addObject("codeList", codeService.getCodeList(CodeType.CODE_GROUP_PROPOSAL_STATUS.getCode()));
        mav.addObject("proposalList", proposalList);
        mav.addObject("pagingHelper", pagingHelper);
        mav.addObject("params", params);

        return mav;
    }

    /**
     * 정책제안 더보기
     * 
     * @param request
     * @param response
     * @param params
     * @param pagingHelper
     * @return
     */
    @RequestMapping(value = {"/proposal/list/more", "/proposal/complete-list/more"})
    @ResponseBody
    public Map<String, Object> proposalListMore(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, Object> params, PagingHelper pagingHelper) {

        ModelAndView mav = new ModelAndView();

        String requestUri = request.getRequestURI();
        if (requestUri.indexOf("complete-list-more") >= 0) {
            params.put("status", ProposalStatus.COMPLETE.toString());
            mav.setViewName("proposal/proposal-complete-list");
        } else {
            mav.setViewName("proposal/proposal-list");
        }

        int listCount = proposalService.selectProposalListCount(params);

        pagingHelper.setTotalCnt(listCount);

        /** paging setting */
        // CommonUtil.setPagingParams(params);
        params.put("deleteYn", "N");

        // PagingHelper 변수로 변환
        params.put("startNum", pagingHelper.getStartRow() - 1);
        params.put("endNum", pagingHelper.getPagingRow());

        List<Proposal> proposalList = proposalService.selectProposalList(params);

        List<Map<String, Object>> proposalMapList = new ArrayList<>();
        Map<String, Object> proposalMap = null;

        if (proposalList != null) {
            for (Proposal proposal : proposalList) {
                proposalMap = new HashMap<>();
                proposalMap.put("propSeq", proposal.getPropSeq());
                proposalMap.put("bizNm", proposal.getBizNm());
                proposalMap.put("regDateText", proposal.getRegDateText());
                proposalMap.put("readCnt", StringUtils.formatNumber(String.valueOf(proposal.getReadCnt())));
                proposalMap.put("symYn", proposal.getSymYn());
                proposalMap.put("symCnt", StringUtils.formatNumber(String.valueOf(proposal.getSymCnt())));
                proposalMap.put("commentCnt", StringUtils.formatNumber(String.valueOf(proposal.getCommentCnt())));
                proposalMapList.add(proposalMap);
            }
        }

        Map<String, Object> map = new HashMap<>();
        map.put("pagingHelper", pagingHelper);
        map.put("proposalList", proposalMapList);

        return map;
    }

    /**
     * 정책제안 상세보기
     * 
     * @param request
     * @param response
     * @param propSeq
     * @param params
     * @param pagingHelper
     * @param device
     * @return
     */
    @RequestMapping(value = {"/proposal/detail/{propSeq}", "/proposal/complete-detail/{propSeq}"})
    public ModelAndView proposalDetail(HttpServletRequest request, HttpServletResponse response, @PathVariable(value = "propSeq") long propSeq, @RequestParam Map<String, Object> params,
            PagingHelper pagingHelper, Device device) {

        ModelAndView mav = new ModelAndView();

        String requestUri = request.getRequestURI();
        if (requestUri.indexOf("complete-detail") >= 0) {
            params.put("status", ProposalStatus.COMPLETE.toString());
            mav.setViewName("proposal/proposal-complete-detail");
        } else {
            mav.setViewName("proposal/proposal-detail");
        }

        params.put("propSeq", propSeq);

        params.put("deleteYn", "N");
        Proposal proposal = proposalService.selectProposal(params);

        if (proposal == null) {
            // 해당 제안이 존재하지않습니다.
            //            RequestUtils.htmlAlert(request, response, messages.getMessage("message.proposal.info.001"));
            //            return null;
            String message = messages.getMessage("message.proposal.info.001");
            throw new EvoteBizException(message);
        } else {
            List<FileInfo> imageFileList = fileService.selectFileInfoList(proposal.getPropSeq(), FileGrpType.PROPOSAL, FileType.IMAGE);
            List<FileInfo> attachFileList = fileService.selectFileInfoList(proposal.getPropSeq(), FileGrpType.PROPOSAL, FileType.ATTACH);

            List<FileInfo> auditImageFileList = fileService.selectFileInfoList(proposal.getPropSeq(), FileGrpType.PROP_AUDIT, FileType.IMAGE);
            List<FileInfo> auditAttachFileList = fileService.selectFileInfoList(proposal.getPropSeq(), FileGrpType.PROP_AUDIT, FileType.ATTACH);

            // 제안검토 조회
            Map<String, Object> map = new HashMap<>();
            map.put("propSeq", proposal.getPropSeq());
            ProposalAudit proposalAudit = proposalService.selectProposalAudit(map);
            mav.addObject("proposalAudit", proposalAudit);

            // 조회수 +1
            proposal.setReadCnt(StringUtils.nvlInt(proposal.getReadCnt()) + 1);
            params.put("_column", "read_cnt");
            params.put("_data", proposal.getReadCnt());
            proposalService.updateReadCount(params);

            mav.addObject("imageFileList", imageFileList);
            mav.addObject("attachFileList", attachFileList);
            mav.addObject("auditImageFileList", auditImageFileList);
            mav.addObject("auditAttachFileList", auditAttachFileList);

            mav.addObject("proposal", proposal);
            mav.addObject("params", params);

            List<PropComment> commentList = proposalService.selectCommentList(params);
            mav.addObject("commentList", commentList);
            mav.addObject("commentListCount", commentList.size());

            mav.addObject("pagingHelper", pagingHelper);

            // 디바이스체크
            String vote_method = "PC";
            if (device.isNormal()) {
                vote_method = "PC";
            } else {
                vote_method = "MOBILE";
            }
            mav.addObject("vote_method", vote_method);

        }

        return mav;
    }

    /**
     * 정책제안 등록 폼
     * 
     * @param request
     * @param response
     * @param redirectAttributes
     * @param params
     * @param pagingHelper
     * @return
     */
    @RequestMapping(value = "/proposal/write")
    public ModelAndView proposalWrite(HttpServletRequest request, HttpServletResponse response, RedirectAttributes redirectAttributes, @RequestParam Map<String, Object> params,
            PagingHelper pagingHelper) {

        logger.debug("# /proposal/write");

        Member member = SessionUtil.getSessionInfo(request);
        UserType userType = (UserType) WebUtils.getSessionAttribute(request, "userType");

        ModelAndView mav = new ModelAndView();

        if (member == null && userType == null) {

            redirectAttributes.addFlashAttribute("proposalLoginYn", "Y");
            mav.setViewName("redirect:/proposal/login");
            return mav;

            // // 휴대폰인증 또는 로그인 후 제안할 수 있습니다
            // request.setAttribute("proposalLoginYn", "Y");
            // RequestUtils.responseWriteMessage(request, response,
            // messages.getMessage("message.proposal.018"), "/proposal/login");
            // return null;
        }

        mav.setViewName("proposal/proposal-write");
        mav.addObject("userInfo", member);

        params.put("deleteYn", "N");

        if (StringUtils.isNull(params.get("propSeq")) == false) {
            Proposal proposal = proposalService.selectProposal(params);
            if (proposal == null) {
                // 해당 제안이 존재하지않습니다.
                //                RequestUtils.htmlAlert(request, response, messages.getMessage("message.proposal.info.001"));
                //                return null;
                String message = messages.getMessage("message.proposal.info.001");
                throw new EvoteBizException(message);
            } else {
                mav.setViewName("proposal/proposal-modify");// id가 있으면 view 변경

                if (!member.getUserSeq().equals(proposal.getRegUser())) {
                    // 수정권한이 없습니다.
                    //                    RequestUtils.htmlAlert(request, response, messages.getMessage("message.proposal.021"));
                    //                    return null;
                    String message = messages.getMessage("message.proposal.021");
                    throw new EvoteBizException(message);
                }

                List<FileInfo> imageFileList = fileService.selectFileInfoList(proposal.getPropSeq(), FileGrpType.PROPOSAL, FileType.IMAGE);
                List<FileInfo> attachFileList = fileService.selectFileInfoList(proposal.getPropSeq(), FileGrpType.PROPOSAL, FileType.ATTACH);

                mav.addObject("imageFileList", imageFileList);
                mav.addObject("attachFileList", attachFileList);

                mav.addObject("proposal", proposal);
            }
        }

        // 현재 진행중인 공모 조회
        PublicSubscription publicSubscription = proposalService.selectCurrentPublicSubscription();
        if (publicSubscription != null) {
            mav.addObject("pssrp", publicSubscription);
        }

        params.put("inItemAll", "N");// 'ALL' 항목은 제외한 리스트 조회
        mav.addObject("realmList", realmService.selectRealmListAll(params));

        mav.addObject("sggNm", CodeType.ADDR_SGG_EP_CODE.getName());
        mav.addObject("emdList", addressService.selectEmdList(CodeType.ADDR_SGG_EP_CODE.getCode()));

        mav.addObject("params", params);
        mav.addObject("pagingHelper", pagingHelper);

        return mav;
    }

    /**
     * 회원 > 정책제안 수정화면
     * 
     * @param request
     * @param response
     * @param propSeq
     * @param params
     * @param pagingHelper
     * @return
     */
    @RequestMapping(value = "/proposal/modify/{propSeq}")
    public ModelAndView proposalModify(HttpServletRequest request, HttpServletResponse response, @PathVariable(value = "propSeq") long propSeq, @RequestParam Map<String, Object> params,
            PagingHelper pagingHelper) {

        Member member = SessionUtil.getSessionInfo(request);
        UserType userType = (UserType) WebUtils.getSessionAttribute(request, "userType");

        if (member == null && userType == null) {
            // 휴대폰인증 또는 로그인 후 제안할 수 있습니다
            request.setAttribute("proposalLoginYn", "Y");
            RequestUtils.responseWriteMessage(request, response, messages.getMessage("message.proposal.018"), "/proposal/login");
            return null;
        }

        params.put("propSeq", propSeq);
        Proposal proposal = proposalService.selectProposal(params);

        if (proposal == null) {
            // 해당 제안이 존재하지않습니다.
            //            RequestUtils.htmlAlert(request, response, messages.getMessage("message.proposal.info.001"));
            //            return null;
            String message = messages.getMessage("message.proposal.info.001");
            throw new EvoteBizException(message);
        } else if (!"Y".equals(proposal.getOwnerYn())) {
            // 수정권한이 없습니다.
            //            RequestUtils.htmlAlert(request, response, messages.getMessage("message.proposal.021"));
            //            return null;
            String message = messages.getMessage("message.proposal.021");
            throw new EvoteBizException(message);
        } else if (!ProposalStatus.PENDING.equals(proposal.getStatus())) {
            // 수정권한이 없습니다.
            //            RequestUtils.htmlAlert(request, response, messages.getMessage("message.proposal.021"));
            //            return null;
            String message = messages.getMessage("message.proposal.021");
            throw new EvoteBizException(message);
        }

        ModelAndView mav = new ModelAndView();
        mav.setViewName("proposal/proposal-modify");

        List<FileInfo> imageFileList = fileService.selectFileInfoList(proposal.getPropSeq(), FileGrpType.PROPOSAL, FileType.IMAGE);
        List<FileInfo> attachFileList = fileService.selectFileInfoList(proposal.getPropSeq(), FileGrpType.PROPOSAL, FileType.ATTACH);

        // 현재 진행중인 공모 조회
        PublicSubscription publicSubscription = proposalService.selectCurrentPublicSubscription();
        if (publicSubscription != null) {
            mav.addObject("pssrp", publicSubscription);
        }

        mav.addObject("imageFileList", imageFileList);
        mav.addObject("attachFileList", attachFileList);

        mav.addObject("userInfo", member);
        mav.addObject("proposal", proposal);

        params.put("inItemAll", "N");// 'ALL' 항목은 제외한 리스트 조회
        mav.addObject("realmList", realmService.selectRealmListAll(params));

        mav.addObject("sggNm", CodeType.ADDR_SGG_EP_CODE.getName());
        mav.addObject("emdList", addressService.selectEmdList(CodeType.ADDR_SGG_EP_CODE.getCode()));

        mav.addObject("params", params);
        mav.addObject("pagingHelper", pagingHelper);

        return mav;
    }

    /**
     * 정책제안 등록/수정 저장
     * 
     * @param request
     * @param response
     * @param proposalParam
     * @param imageFiles
     * @param attachFiles
     * @param deleteFileSeq
     * @return
     */
    @RequestMapping(value = "/proposal/save")
    public ModelAndView proposalSave(HttpServletRequest request, HttpServletResponse response, Proposal proposalParam, @RequestParam(value = "imageFile", required = false) MultipartFile[] imageFiles,
            @RequestParam(value = "attachFile", required = false) MultipartFile[] attachFiles, @RequestParam(value = "deleteFile", required = false) String deleteFile) {

        Member member = SessionUtil.getSessionInfo(request);

        UserType userType = null;

        if (member != null) {
            userType = member.getUserType();
        } else {
            userType = UserType.PROPOSAL;
        }

        ModelAndView mav = new ModelAndView(REDIRECT_PROPOSAL_LIST);

        boolean isUpdate = !StringUtils.isNull(proposalParam.getPropSeq());
        Proposal proposal = null;
        if (isUpdate == true) {
            Map<String, Object> params = new HashMap<String, Object>();
            params.put("propSeq", proposalParam.getPropSeq());
            params.put("deleteYn", "N");
            proposal = proposalService.selectProposal(params);

            // 업데이트인데 조회한 id의 데이터가 없을경우 redirect & flag값 전달.
            if (proposal == null) {
                // 해당 제안이 존재하지않습니다.
                //                RequestUtils.htmlAlert(request, response, messages.getMessage("message.proposal.info.001"));
                //                return null;
                String message = messages.getMessage("message.proposal.info.001");
                throw new EvoteBizException(message);
            } else if (!member.getUserSeq().equals(proposal.getRegUser())) {
                // 본인글이 아니면 수정불가
                // 수정권한이 없습니다.
                //                RequestUtils.htmlAlert(request, response, messages.getMessage("message.proposal.021"));
                //                return null;
                String message = messages.getMessage("message.proposal.021");
                throw new EvoteBizException(message);
            } else if (!ProposalStatus.PENDING.equals(proposal.getStatus())) {
                // 수정권한이 없습니다.
                //                RequestUtils.htmlAlert(request, response, messages.getMessage("message.proposal.021"));
                //                return null;
                String message = messages.getMessage("message.proposal.021");
                throw new EvoteBizException(message);
            }
        } else {
            proposal = new Proposal();
        }

        proposal.setSiteCd(getSiteCd(request));

        // memberYn은 새등록시에만 입력하고 기존에 존재하면 변경안되게 처리.
        if (StringUtils.isNull(proposal.getMemberYn())) {
            // proposal.setMemberYn(member.getUserType());

            //if (UserType.EMAIL.equals(userType) || UserType.CMIT.equals(userType)) {
            //if (RoleType.USER.equals(roleType)) {
            if (member.hasRole(RoleType.USER)) {
                proposal.setMemberYn("Y");
            } else if (UserType.PROPOSAL.equals(userType)) {
                proposal.setMemberYn("N");
            }

        }

        // 공모번호는 새등록시에만 입력하고 기존에 존재하면 변경안되게 처리.
        if (StringUtils.isNull(proposal.getPsSeq())) {
            proposal.setPsSeq(proposalParam.getPsSeq());
        }

        // 상태는 새등록시에만 입력하고 기존에 존재하면 변경안되게 처리.
        if (StringUtils.isNull(proposal.getStatus())) {
            // proposal.setStatus("1");// 검토대기상태
            proposal.setStatus(ProposalStatus.PENDING);// 검토대기상태
        }

        //if (UserType.EMAIL.equals(userType)) {
        if (member.hasRole(RoleType.USER)) {

            // 이메일 회원
            proposal.setRegUser(member.getUserSeq());
            proposal.setModUser(member.getUserSeq());

            //        } else if (UserType.PHONE.equals(userType)) {
            //
            //            // 휴대폰 회원
            //            proposal.setRegUser(member.getUserSeq());
            //            proposal.setModUser(member.getUserSeq());
            //
            //            proposal.setReqNm(proposalParam.getReqNm()); // 신청인
            //            proposal.setReqEmail(proposalParam.getReqEmail()); // 이메일

        } else {

            // 비회원

            /* 비회원이면 비번입력이 없으면 신규/수정 상관없이 stop */
            if (StringUtils.isNull(proposalParam.getReqPw()) == true) {
                //                RequestUtils.htmlAlert(request, response, "비밀번호가 입력되지않았습니다.");
                //                return null;
                String message = "비밀번호가 입력되지않았습니다.";
                throw new EvoteBizException(message);
            }

            /* 수정일경우 기존비번과 일치하지않으면 stop */
            if (isUpdate) {
                if (!proposal.getReqPw().equals(proposalParam.getReqPw())) {
                    //                    RequestUtils.htmlAlert(request, response, "글 비밀번호가 일치하지않습니다.");
                    //                    return null;
                    String message = "글 비밀번호가 일치하지않습니다.";
                    throw new EvoteBizException(message);
                }
            }

            EncryptedString encReqNm = new EncryptedString(XecureUtil.encString(proposalParam.getReqNm().getValue()));
            //EncryptedString encReqPhone = new EncryptedString(XecureUtil.encString(visitorPhone));
            EncryptedString encReqPhone = member.getPhone();
            EncryptedString encReqEmail = new EncryptedString(XecureUtil.encString(proposalParam.getReqEmail().getValue()));
            EncryptedString encReqPw = new EncryptedString(XecureUtil.hash64(proposalParam.getReqPw().getValue()));

            proposal.setReqNm(encReqNm);
            proposal.setReqPhone(encReqPhone);
            proposal.setReqAddr(proposalParam.getReqAddr());
            proposal.setReqEmail(encReqEmail);
            proposal.setReqPw(encReqPw);
        }

        proposal.setRealmCd(proposalParam.getRealmCd());
        proposal.setBizNm(proposalParam.getBizNm());
        proposal.setCnslYn(proposalParam.getCnslYn());
        proposal.setBudget(proposalParam.getBudget());
        proposal.setStartDate(proposalParam.getStartDate());
        proposal.setEndDate(proposalParam.getEndDate());
        proposal.setLocation(proposalParam.getLocation());
        proposal.setNecessity(proposalParam.getNecessity());
        proposal.setBizCont(proposalParam.getBizCont());
        proposal.setEffect(proposalParam.getEffect());

        List<FileInfo> imageList = new ArrayList<>();
        if (imageFiles != null) {
            for (MultipartFile imageFile : imageFiles) {
                if (StringUtils.isNotEmpty(imageFile.getOriginalFilename())) {
                    imageList.add(fileUploadUtil.getSavedFileInfo(imageFile, FileGrpType.PROPOSAL, FileType.IMAGE));
                }
            }
        }

        List<FileInfo> attachList = new ArrayList<>();
        if (attachFiles != null) {

            for (MultipartFile attachFile : attachFiles) {
                if (StringUtils.isNotEmpty(attachFile.getOriginalFilename())) {
                    attachList.add(fileUploadUtil.getSavedFileInfo(attachFile, FileGrpType.PROPOSAL, FileType.ATTACH));
                }
            }
        }

        int result = proposalService.saveProposal(proposal, imageList, attachList, deleteFile);

        // 비회원 제안 등록 후 세션 만료 처리
        // if (RoleType.GUEST.equals(roleType) || UserType.PROPOSAL.equals(userType)) {
        if (UserType.PROPOSAL.equals(userType)) {
            request.getSession().invalidate();
        }

        logger.debug("### 정책제안 등록 result [{}]", result);

        return mav;

    }

    /**
     * 정책제안 삭제처리
     * 
     * @param request
     * @param response
     * @param propSeq
     * @return
     */
    @RequestMapping(value = "/proposal/remove/{propSeq}")
    public ModelAndView proposalDelete(HttpServletRequest request, HttpServletResponse response, @PathVariable(value = "propSeq") long propSeq) {

        Member member = SessionUtil.getSessionInfo(request);
        UserType userType = (UserType) WebUtils.getSessionAttribute(request, "userType");

        if (member == null && userType == null) {
            // 삭제권한이 없습니다.
            String message = messages.getMessage("message.proposal.022");
            //RequestUtils.htmlAlert(request, response, messages.getMessage("message.proposal.022"));
            //return null;
            throw new EvoteBizException(message);
        }

        proposalService.deleteProposal(propSeq);// 실제delete하지않고 삭제여부만 변경처리

        return new ModelAndView(REDIRECT_PROPOSAL_LIST);

    }

    /**
     * 정책제안 공감 등록/삭제
     * 
     * @param request
     * @param response
     * @param params
     * @return
     */
    @RequestMapping(value = "/proposal/detail/sympathy")
    @ResponseBody
    public int proposalDetailSympathy(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, Object> params) {

        Member member = SessionUtil.getSessionInfo(request);

        if (member == null) {
            // 비로그인
            return ERROR_NOT_LOGIN;
            //} else if (!UserType.EMAIL.equals(member.getUserType())) {
            //} else if (!RoleType.USER.equals(member.getRoleType())) {
        } else if (!member.hasRole(RoleType.USER)) {
            // 이메일 회원이 아님
            return ERROR_NOT_EMAIL_MEMBER;
        }

        String propSeq = StringUtils.nvl(params.get("propSeq"));
        if (!"".equals(propSeq)) {

            params.put("deleteYn", "N");
            Proposal proposal = proposalService.selectProposal(params);

            if (proposal == null) {
                return ERROR_NOT_FOUND;
            } else if (!ProposalStatus.PENDING.equals(proposal.getStatus())) {
                return ERROR_NOT_FOUND;
            } else {
                params.put("userSeq", member.getUserSeq());
                Map<String, Object> sympathy = proposalService.selectSympathy(params);

                if (sympathy == null) {
                    // 현재 user가 등록한 공감이 없으면 등록
                    proposalService.insertSympathy(params);
                } else {
                    // 현재 user가 등록한 공감이 있으면 삭제
                    proposalService.deleteSympathy(params);
                }
            }
        }

        params.remove("userSeq");
        return proposalService.selectSympathyCount(params);

    }

    /**
     * 댓글 저장
     * 
     * @param request
     * @param response
     * @param propComment
     * @return
     */
    @RequestMapping(value = "/proposal/detail/comment/save")
    @ResponseBody
    public int proposalDetailCommentSave(HttpServletRequest request, HttpServletResponse response, PropComment propComment) {

        Member member = SessionUtil.getSessionInfo(request);

        if (member == null) {
            // 비로그인
            return ERROR_NOT_LOGIN;
            //} else if (!UserType.EMAIL.equals(member.getUserType())) {
            //} else if (!RoleType.USER.equals(member.getRoleType())) {
        } else if (!member.hasRole(RoleType.USER)) {
            // 이메일 회원이 아님
            return ERROR_NOT_EMAIL_MEMBER;
        } else {
            // 댓글 권한 체크
            Member tmpMember = memberService.getUserInfoByEmail(member.getEmail().getDecValue());
            if ("N".equals(tmpMember.getCmtYn())) {
                // 세션 정보의 댓글 권한 업데이트
                WebUtils.setSessionAttribute(request, "cmtYn", "N");
                return ERROR_BLOCK_COMMENT;
            }
        }

        int result = 0;
        int propSeq = StringUtils.nvlInt(propComment.getPropSeq());
        String comment = StringUtils.nvl(propComment.getCont());
        if (propSeq != 0 && !"".equals(comment)) {

            Map<String, Object> params = new HashMap<String, Object>();
            params.put("propSeq", propSeq);
            params.put("deleteYn", "N");
            Proposal proposal = proposalService.selectProposal(params);

            if (proposal == null) {
                result = ERROR_NOT_FOUND;
            } else if (!ProposalStatus.PENDING.equals(proposal.getStatus())) {

            } else {
                propComment.setRegUser(member.getUserSeq());
                propComment.setModUser(member.getUserSeq());
                result = proposalService.saveComment(propComment);
            }
        }

        return result;
    }

    /**
     * 댓글 삭제
     * 
     * @param request
     * @param response
     * @param params
     * @return
     */
    @RequestMapping(value = "/proposal/detail/comment/delete")
    @ResponseBody
    public int proposalDetailCommentDelete(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, Object> params) {

        Member member = SessionUtil.getSessionInfo(request);

        if (member == null) {
            // 비로그인
            return ERROR_NOT_LOGIN;
            //} else if (!UserType.EMAIL.equals(member.getUserType())) {
            //} else if (!RoleType.USER.equals(member.getRoleType())) {
        } else if (!member.hasRole(RoleType.USER)) {
            // 이메일 회원이 아님
            return ERROR_NOT_EMAIL_MEMBER;
        } else {
            // 댓글 권한 체크
            Member tmpMember = memberService.getUserInfoByEmail(member.getEmail().getDecValue());
            if ("N".equals(tmpMember.getCmtYn())) {
                // 세션 정보의 댓글 권한 업데이트
                WebUtils.setSessionAttribute(request, "cmtYn", "N");
                return ERROR_BLOCK_COMMENT;
            }
        }


        int result = 0;
        int propSeq = StringUtils.nvlInt(params.get("propSeq"));
        int cmtSeq = StringUtils.nvlInt(params.get("cmtSeq"));
        if (propSeq != 0 && cmtSeq != 0) {
            params.put("deleteYn", "N");
            Proposal proposal = proposalService.selectProposal(params);
            if (proposal == null) {
                return ERROR_NOT_FOUND;
            } else {
                PropComment propComment = proposalService.selectComment(params);
                if (propComment != null) {
                    if (propComment.getRegUser().equals(member.getUserSeq())) {
                        result = proposalService.deleteComment(params);
                    }
                }
            }
        }

        return result;
    }

    /**
     * 댓글 동의/비동의 저장
     * 
     * @param request
     * @param response
     * @param params
     * @return
     */
    @RequestMapping(value = "/proposal/detail/comment/agree")
    @ResponseBody
    public int proposalDetailCommentAgreeSave(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, Object> params) {

        Member member = SessionUtil.getSessionInfo(request);

        if (member == null) {
            // 비로그인
            return ERROR_NOT_LOGIN;
            //} else if (!UserType.EMAIL.equals(member.getUserType())) {
            //} else if (!RoleType.USER.equals(member.getRoleType())) {
        } else if (!member.hasRole(RoleType.USER)) {
            // 이메일 회원이 아님
            return ERROR_NOT_EMAIL_MEMBER;
        }

        int result = 0;
        int propSeq = StringUtils.nvlInt(params.get("propSeq"));
        int cmtSeq = StringUtils.nvlInt(params.get("cmtSeq"));
        String agreeYn = StringUtils.nvl(params.get("agreeYn"));
        if (propSeq != 0 && cmtSeq != 0 && !"".equals(agreeYn)) {
            params.put("deleteYn", "N");
            Proposal proposal = proposalService.selectProposal(params);
            if (proposal == null) {
                result = ERROR_NOT_FOUND;
            } else {
                params.put("userSeq", member.getUserSeq());
                result = proposalService.saveCommentAgree(params);
            }
        }

        return result;
    }

    /**
     * 댓글 신고
     * 
     * @param request
     * @param response
     * @param params
     * @return
     */
    @RequestMapping(value = "/proposal/detail/comment/report")
    @ResponseBody
    public int proposalDetailCommentReportSave(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, Object> params) {

        Member member = SessionUtil.getSessionInfo(request);

        if (member == null) {
            // 비로그인
            return ERROR_NOT_LOGIN;
            //} else if (!UserType.EMAIL.equals(member.getUserType())) {
            //} else if (!RoleType.USER.equals(member.getRoleType())) {
        } else if (!member.hasRole(RoleType.USER)) {
            // 이메일 회원이 아님
            return ERROR_NOT_EMAIL_MEMBER;
        }

        int result = 0;
        int propSeq = StringUtils.nvlInt(params.get("propSeq"));
        int cmtSeq = StringUtils.nvlInt(params.get("cmtSeq"));
        if (propSeq != 0 && cmtSeq != 0) {
            params.put("deleteYn", "N");
            Proposal proposal = proposalService.selectProposal(params);
            if (proposal == null) {
                result = ERROR_NOT_FOUND;
            } else {
                params.put("userSeq", member.getUserSeq());
                Map<String, Object> commentReport = proposalService.selectCommentReport(params);
                if (commentReport == null) {
                    result = proposalService.insertCommentReport(params);
                }
            }
        }

        return result;
    }


    /**
     * 방문객 정책제안 수정 form
     * 
     * @param request
     * @param response
     * @param propSeq
     * @param params
     * @param pagingHelper
     * @return
     */
    @RequestMapping(value = "/proposal/visitor/modify/{propSeq}")
    public ModelAndView proposalVisotorModify(HttpServletRequest request, HttpServletResponse response, @PathVariable(value = "propSeq") long propSeq, @RequestParam Map<String, Object> params,
            PagingHelper pagingHelper) {

        String visitorPw = (String) params.get("visitorPw");

        if (StringUtils.isEmpty(visitorPw)) {
            // 비밀번호가 일치하지 않습니다.
            //            RequestUtils.htmlAlert(request, response, messages.getMessage("message.proposal.020"));
            //            return null;
            String message = messages.getMessage("message.proposal.020");
            throw new EvoteBizException(message);
        }

        // 제안 조회
        Proposal proposal = proposalService.selectVisitorProposal(propSeq, visitorPw);

        // 방문객 수정화면 진입 시 기존 세션 만료 후 방문객 세션 생성
        // 세션 꼬이는 현상이 발생하므로 방문객 세션 생성하지 않음
        //        SessionUtil sessionUtil = new SessionUtil();
        //        sessionUtil.invalidateAndSaveVisitorSession(request, proposal.getReqPhone().getDecValue(), UserType.PROPOSAL);

        ModelAndView mav = new ModelAndView();

        mav.setViewName("proposal/proposal-modify");

        List<FileInfo> imageFileList = fileService.selectFileInfoList(proposal.getPropSeq(), FileGrpType.PROPOSAL, FileType.IMAGE);
        List<FileInfo> attachFileList = fileService.selectFileInfoList(proposal.getPropSeq(), FileGrpType.PROPOSAL, FileType.ATTACH);

        // 현재 진행중인 공모 조회
        PublicSubscription publicSubscription = proposalService.selectCurrentPublicSubscription();
        if (publicSubscription != null) {
            mav.addObject("pssrp", publicSubscription);
        }

        mav.addObject("imageFileList", imageFileList);
        mav.addObject("attachFileList", attachFileList);

        mav.addObject("proposal", proposal);

        params.put("inItemAll", "N");// 'ALL' 항목은 제외한 리스트 조회
        mav.addObject("realmList", realmService.selectRealmListAll(params));

        mav.addObject("sggNm", CodeType.ADDR_SGG_EP_CODE.getName());
        mav.addObject("emdList", addressService.selectEmdList(CodeType.ADDR_SGG_EP_CODE.getCode()));

        mav.addObject("params", params);
        mav.addObject("pagingHelper", pagingHelper);

        return mav;
    }

    /**
     * 방문객 정책제안 수정
     * 
     * @param request
     * @param response
     * @param proposal
     * @param imageFiles
     * @param attachFiles
     * @param deleteFile
     * @return
     */
    @RequestMapping(value = "/proposal/visitor/save")
    public ModelAndView proposalVisitorSave(HttpServletRequest request, HttpServletResponse response, Proposal proposal,
            @RequestParam(value = "imageFile", required = false) MultipartFile[] imageFiles, @RequestParam(value = "attachFile", required = false) MultipartFile[] attachFiles,
            @RequestParam(value = "deleteFile", required = false) String deleteFile) {

        List<FileInfo> imageList = new ArrayList<>();
        if (imageFiles != null) {
            for (MultipartFile imageFile : imageFiles) {
                if (StringUtils.isNotEmpty(imageFile.getOriginalFilename())) {
                    imageList.add(fileUploadUtil.getSavedFileInfo(imageFile, FileGrpType.PROPOSAL, FileType.IMAGE));
                }
            }
        }

        List<FileInfo> attachList = new ArrayList<>();
        if (attachFiles != null) {

            for (MultipartFile attachFile : attachFiles) {
                if (StringUtils.isNotEmpty(attachFile.getOriginalFilename())) {
                    attachList.add(fileUploadUtil.getSavedFileInfo(attachFile, FileGrpType.PROPOSAL, FileType.ATTACH));
                }
            }
        }

        int result = proposalService.saveVisitorProposal(proposal, imageList, attachList, deleteFile);

        // 비회원 제안 등록 후 세션 만료 처리
        request.getSession().invalidate();

        logger.debug("### 정책제안 비회원 수정 result [{}]", result);

        return new ModelAndView(REDIRECT_PROPOSAL_LIST);

    }

    /**
     * 방문객 정책제안 삭제
     * 
     * @param request
     * @param response
     * @param propSeq
     * @param params
     * @param pagingHelper
     * @return
     */
    @RequestMapping(value = "/proposal/visitor/remove/{propSeq}")
    public ModelAndView proposalVisotorRemove(HttpServletRequest request, HttpServletResponse response, @PathVariable(value = "propSeq") long propSeq, @RequestParam Map<String, Object> params,
            PagingHelper pagingHelper) {

        String visitorPw = (String) params.get("visitorPw");

        if (StringUtils.isEmpty(visitorPw)) {
            // 비밀번호가 일치하지 않습니다.
            //            RequestUtils.htmlAlert(request, response, messages.getMessage("message.proposal.020"));
            //            return null;
            String message = messages.getMessage("message.proposal.020");
            throw new EvoteBizException(message);
        }

        if (proposalService.deleteVisitorProposal(propSeq, visitorPw) > 0) {
            return new ModelAndView(REDIRECT_PROPOSAL_LIST);
        }

        return null;

    }

}
