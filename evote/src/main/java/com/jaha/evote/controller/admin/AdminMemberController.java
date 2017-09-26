/**
 * Copyright (c) 2016 JAHA SMART CORP., LTD ALL RIGHT RESERVED
 */
package com.jaha.evote.controller.admin;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.jaha.evote.common.util.DateUtils;
import com.jaha.evote.common.util.JsonUtil;
import com.jaha.evote.common.util.NumberUtils;
import com.jaha.evote.common.util.PagingHelper;
import com.jaha.evote.controller.common.BaseController;
import com.jaha.evote.domain.Member;
import com.jaha.evote.domain.SearchList;
import com.jaha.evote.service.MemberService;
import com.jaha.evote.service.ProposalService;

/**
 * <pre>
 * Class Name : AdminMemberController.java
 * Description : Description
 *  
 * Modification Information
 * 
 * Mod Date         Modifier    Description
 * -----------      --------    ---------------------------
 * 2016. 11. 3.     jjpark      Generation
 * </pre>
 *
 * @author jjpark
 * @since 2016. 11. 3.
 * @version 1.0
 */
@Controller
public class AdminMemberController extends BaseController {

    @Autowired
    private MemberService memberService;

    @Autowired
    private ProposalService proposalService;

    /**
     * 사용자 관리 > 선택 동의자 목록
     * 
     * @return
     */
    @RequestMapping(value = "/admin/member/agree/list")
    public ModelAndView agreeList() {

        int agreeCount = memberService.selectMemberAgreeListCount();

        ModelAndView mav = new ModelAndView();
        mav.setViewName("admin/member/agree-list");
        mav.addObject("agreeCount", agreeCount);

        return mav;
    }

    /**
     * 사용자 관리 > 선택 동의자 엑셀 다운로드
     * 
     * @return
     */
    @RequestMapping(value = "/admin/member/agree/excel")
    public ModelAndView agreeExcel() {

        List<Member> list = memberService.selectMemberAgreeList();

        ModelAndView mav = new ModelAndView();
        mav.setViewName("admin/member/agree-excel");
        mav.addObject("list", list);

        return mav;
    }

    /**
     * 사용자 관리 > 회원 목록
     * 
     * @param searchParam
     * @param pagingHelper
     * @return
     */
    @RequestMapping(value = "/admin/member/list")
    public ModelAndView memberList(@RequestParam Map<String, Object> searchParam, PagingHelper pagingHelper) {

        // paging setting
        searchParam.put("startRow", (pagingHelper.getPageNo() - 1) * pagingHelper.getPagingRow());
        searchParam.put("pagingRow", pagingHelper.getPagingRow());

        SearchList<Member> list = memberService.selectMemberList(searchParam);

        pagingHelper.setTotalCnt(list.getTotalCnt());

        searchParam.put("pageNo", pagingHelper.getPageNo());


        ModelAndView mav = new ModelAndView();
        mav.setViewName("admin/member/list");

        mav.addObject("list", list);
        mav.addObject("pagingHelper", pagingHelper);
        mav.addObject("searchParam", searchParam);

        return mav;

    }

    /**
     * 사용자 목록 엑셀 다운로드
     * 
     * @param searchParam
     * @return
     */
    @RequestMapping(value = "/admin/member/list/excel")
    public ModelAndView memberListExcel(@RequestParam Map<String, Object> searchParam) {

        List<Member> list = memberService.selectMemberListExcel();

        ModelAndView mav = new ModelAndView();
        mav.setViewName("admin/member/excel");
        mav.addObject("list", list);

        return mav;
    }

    /**
     * 사용자 관리 > 회원 상세
     * 
     * @param userSeq
     * @param searchParam
     * @param pagingHelper
     * @return
     */
    @RequestMapping(value = "/admin/member/view/{userSeq}")
    public ModelAndView memberView(HttpServletRequest request, @PathVariable(value = "userSeq") long userSeq, @RequestParam Map<String, Object> searchParam, PagingHelper pagingHelper) {

        Map<String, Object> param = new HashMap<>();
        param.put("user_seq", userSeq);

        Member member = memberService.getUserInfoById(param);

        ModelAndView mav = new ModelAndView();

        mav.addObject("member", member);
        mav.addObject("pagingHelper", pagingHelper);
        mav.addObject("searchParam", searchParam);

        mav.setViewName("admin/member/view");

        return mav;

    }

    /**
     * 사용자 관리 > 회원 상세 > 투표권한 수정
     * 
     * @param json
     * @return
     */
    @RequestMapping(value = "/admin/member/modify/vote-stat")
    @ResponseBody
    public boolean modifyVoteStat(@RequestBody String json) {

        JSONObject item = new JSONObject(json);

        Map<String, Object> param = JsonUtil.toMap(item);
        logger.debug("### param [{}]", param);

        int result = memberService.updateVoteStat(param);

        if (result > 0) {
            return true;
        }

        return false;
    }

    /**
     * 사용자 관리 > 회원 상세 > 댓글 상태 수정
     * 
     * @param json
     * @return
     */
    @RequestMapping(value = "/admin/member/modify/cmt-stat")
    @ResponseBody
    public Map<String, Object> modifyCommentStat(@RequestBody String json) {

        JSONObject item = new JSONObject(json);

        Map<String, Object> param = JsonUtil.toMap(item);
        param.put("user_seq", param.get("userSeq"));

        logger.debug("### param [{}]", param);

        int result = memberService.updateCommentAuth(param);

        Map<String, Object> resultMap = new HashMap<>();

        if (result > 0) {

            Member member = memberService.getUserInfoById(param);
            resultMap.put("result", true);
            resultMap.put("cmtYn", member.getCmtYn());
            resultMap.put("reportCnt", member.getReportCnt());
            if ("N".equals(member.getCmtYn())) {
                resultMap.put("cmtBanDate", DateUtils.convertDateFormat(member.getCmtBanDate(), "yyyy-MM-dd"));
                resultMap.put("cmtBanUserNm", member.getCmtBanUserNm().getDecValue());
            }

        } else {
            resultMap.put("result", false);
        }

        return resultMap;
    }

    /**
     * 사용자 관리 > 회원 상세 > 댓글 목록 조회
     * 
     * @param request
     * @param json
     * @return
     */
    @RequestMapping(value = "/admin/member/view/comment/get")
    @ResponseBody
    public Map<String, Object> getCommentStat(HttpServletRequest request, @RequestBody String json) {

        JSONObject item = new JSONObject(json);

        Map<String, Object> param = JsonUtil.toMap(item);

        logger.debug("### param [{}]", param);

        int pageNo = NumberUtils.parseInt(String.valueOf(param.get("pageNo")), 1);
        int pagingRow = 5;
        int startRow = (pageNo - 1) * pagingRow;

        // 페이징 셋팅
        param.put("startRow", startRow);
        param.put("pagingRow", pagingRow);

        SearchList<Map<String, Object>> searchList = memberService.selectUserCommentList(param);

        Map<String, Object> result = new HashMap<>();

        int totalCnt = searchList.getTotalCnt();

        PagingHelper pagingHelper = new PagingHelper(request, 5, 10);
        pagingHelper.setCurrentPageAndTotalRow(String.valueOf(pageNo), String.valueOf(totalCnt));

        result.put("result", true);
        result.put("pagingHelper", pagingHelper);
        result.put("list", searchList);

        return result;

    }

    /**
     * 사용자 관리 > 회원 상세 > 댓글 숨김/해제 처리
     * 
     * @param json
     * @return
     */
    @RequestMapping(value = "/admin/member/view/comment/hide")
    @ResponseBody
    public boolean hideComment(@RequestBody String json) {

        JSONObject item = new JSONObject(json);

        Map<String, Object> param = JsonUtil.toMap(item);

        logger.debug("### param [{}]", param);

        int result = proposalService.hideComment(param);

        if (result > 0) {
            return true;
        }

        return false;

    }

    /**
     * 주민참여위원권한 설정
     * 
     * @param json
     * @return
     */
    @RequestMapping(value = "/admin/member/subcmit/grant")
    @ResponseBody
    public boolean grantSubcmit(@RequestBody String json) {

        JSONObject item = new JSONObject(json);

        Map<String, Object> param = JsonUtil.toMap(item);

        logger.debug("### param [{}]", param);

        long reqSeq = NumberUtils.parseLong((String) param.get("reqSeq"));
        long userSeq = NumberUtils.parseLong((String) param.get("userSeq"));

        int result = memberService.updateGrantSubcmit(reqSeq, userSeq);

        if (result > 0) {
            return true;
        }

        return false;

    }

    /**
     * 주민참여위원권한 해제
     * 
     * @param json
     * @return
     */
    @RequestMapping(value = "/admin/member/subcmit/revoke")
    @ResponseBody
    public boolean revokeSubcmit(@RequestBody String json) {

        JSONObject item = new JSONObject(json);

        Map<String, Object> param = JsonUtil.toMap(item);

        logger.debug("### param [{}]", param);

        long userSeq = NumberUtils.parseLong((String) param.get("userSeq"));

        int result = memberService.updateRevokeSubcmit(userSeq);

        if (result > 0) {
            return true;
        }

        return false;

    }

}
