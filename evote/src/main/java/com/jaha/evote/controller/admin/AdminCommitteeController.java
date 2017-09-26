/**
 * Copyright (c) 2016 JAHA SMART CORP., LTD ALL RIGHT RESERVED
 *
 * 2016. 10. 24.
 */
package com.jaha.evote.controller.admin;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import com.jaha.evote.common.util.FileUploadUtil;
import com.jaha.evote.common.util.PagingHelper;
import com.jaha.evote.common.util.XecureUtil;
import com.jaha.evote.controller.common.BaseController;
import com.jaha.evote.domain.common.FileInfo;
import com.jaha.evote.domain.type.FileGrpType;
import com.jaha.evote.domain.type.FileType;
import com.jaha.evote.service.CommitteeService;
import com.jaha.evote.service.FileService;

/**
 * <pre>
 * Class Name : AdminBusinessController.java
 * Description : Description
 *  
 * Modification Information
 * 
 * Mod Date     Modifier    		  Description
 * -----------      -----------       ---------------------
 * 2016. 11. 0..        MyoungSeop       Generation
 * </pre>
 *
 * @author AAA
 * @since 2016. 11. 03.
 * @version 1.0
 */
@Controller
public class AdminCommitteeController extends BaseController {

    @Autowired
    private CommitteeService committeeService;

    @Autowired
    private FileUploadUtil fileUploadUtil;

    @Autowired
    FileService fileService;


    /**
     * 관리자>주민참여위원 공모 리스트화면
     * 
     * @param request
     * @param response
     * @param pagingHelper
     * @return
     */
    @RequestMapping(value = "/admin/cmit/cmit_contest_list")
    public ModelAndView cmitContestList(HttpServletRequest request, HttpServletResponse response, PagingHelper pagingHelper) {
        ModelAndView mav = new ModelAndView();
        mav.setViewName("/admin/cmit/cmit_contest_list");

        HashMap<String, Object> param = new HashMap<String, Object>();


        /** paging setting */
        pagingHelper.setTotalCnt(committeeService.getCmitContestCount());
        param.put("startNum", pagingHelper.getStartRow() - 1);
        param.put("endNum", pagingHelper.getPagingRow());
        mav.addObject("pagingHelper", pagingHelper);
        // 주민참여위원 공모 리스트
        List<HashMap<String, Object>> cmitContestList = committeeService.getCmitContestList(param);
        mav.addObject("cmitContestList", cmitContestList);
        mav.addObject("params", param);

        return mav;
    }

    /**
     * 관리자> 주민참여위원회 공모 등록화면
     * 
     * @param response
     * @return
     */
    @RequestMapping(value = "/admin/cmit/cmit_contest_writeForm")
    public ModelAndView cmitContestWriteForm(HttpServletRequest request) {
        ModelAndView mav = new ModelAndView();
        mav.setViewName("/admin/cmit/cmit_contest_write");
        return mav;
    }

    /**
     * 관리자> 주민참여위원회 공모 등록
     * 
     * @param request
     * @param attachFiles
     * @return
     * @throws ParseException
     */
    @RequestMapping(value = "/admin/cmit/cmit_contest_write")
    public String writeCmitContest(HttpServletRequest request, @RequestParam(value = "attachFile", required = false) MultipartFile[] attachFiles) throws ParseException {
        HashMap<String, Object> param = new HashMap<String, Object>();
        String title = StringUtils.defaultString(request.getParameter("title"), ""); // 제목
        String startDate = StringUtils.defaultString(request.getParameter("startDate"), "");// 시작기간
        String startTime = StringUtils.defaultString(request.getParameter("startTime"), "");// 시작시간
        String endDate = StringUtils.defaultString(request.getParameter("endDate"), "");// 마감기간
        String endTime = StringUtils.defaultString(request.getParameter("endTime"), "");// 마감시간

        SimpleDateFormat transFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        String startTmp = startDate + " " + startTime + ":00:00";
        String endTmp = endDate + " " + endTime + ":00:00";
        Date start_date = transFormat.parse(startTmp);
        Date end_date = transFormat.parse(endTmp);

        // 첨부파일 처리
        if (attachFiles != null) {
            List<FileInfo> attachList = new ArrayList<>();
            for (MultipartFile attachFile : attachFiles) {
                if (StringUtils.isNotEmpty(attachFile.getOriginalFilename())) {
                    attachList.add(fileUploadUtil.getSavedFileInfo(attachFile, FileGrpType.CMIT, FileType.ATTACH));
                }
            }
            param.put("attachList", attachList);
        }

        param.put("title", title);
        param.put("start_date", start_date);
        param.put("end_date", end_date);

        committeeService.insertCmitContest(param);

        return "redirect:/admin/cmit/cmit_contest_list";
    }

    /**
     * 관리자>주민참여위원회 공모 수정화면
     * 
     * @param request
     * @param ps_seq
     * @return
     */
    @RequestMapping(value = "/admin/cmit/cmit_contest_modify/{ps_seq}")
    public ModelAndView modifyCmitContest(HttpServletRequest request, @PathVariable(value = "ps_seq") int ps_seq) {
        ModelAndView mav = new ModelAndView();
        mav.addObject("cmitItem", committeeService.selectCmitContest(ps_seq));
        mav.setViewName("/admin/cmit/cmit_contest_modify");

        return mav;
    }

    /**
     * 관리자>주민참여위원회 공모 수정
     * 
     * @param request
     * @param attachFiles
     * @return
     * @throws ParseException
     */
    @RequestMapping(value = "/admin/cmit/cmit_contest_modify")
    public String modifyCmitContest(HttpServletRequest request, @RequestParam(value = "attachFile", required = false) MultipartFile[] attachFiles) throws ParseException {
        HashMap<String, Object> param = new HashMap<String, Object>();
        String title = StringUtils.defaultString(request.getParameter("title"), ""); // 제목
        String startDate = StringUtils.defaultString(request.getParameter("startDate"), "");// 시작기간
        String startTime = StringUtils.defaultString(request.getParameter("startTime"), "");// 시작시간
        String endDate = StringUtils.defaultString(request.getParameter("endDate"), "");// 마감기간
        String endTime = StringUtils.defaultString(request.getParameter("endTime"), "");// 마감시간
        String psSeqTmp = StringUtils.defaultString(request.getParameter("ps_seq"), "");// 마감시간
        long ps_seq = Long.parseLong(psSeqTmp);
        String startTmp = startDate + " " + startTime + ":00:00";
        String endTmp = endDate + " " + endTime + ":00:00";

        // 첨부파일 처리
        if (attachFiles != null) {
            List<FileInfo> attachList = new ArrayList<>();
            for (MultipartFile attachFile : attachFiles) {
                if (StringUtils.isNotEmpty(attachFile.getOriginalFilename())) {
                    attachList.add(fileUploadUtil.getSavedFileInfo(attachFile, FileGrpType.CMIT, FileType.ATTACH));
                }
            }
            param.put("attachList", attachList);
        }

        param.put("title", title);
        param.put("start_date", startTmp);
        param.put("end_date", endTmp);
        param.put("ps_seq", ps_seq);

        committeeService.updateCmitContest(param);

        return "redirect:/admin/cmit/cmit_contest_list";
    }


    /**
     * 관리자>첨부파일 삭제
     * 
     * @param request
     * @param file_seq
     * @return
     */
    @RequestMapping("/admin/cmit/cmitFileInfo_delete/{file_seq}")
    @ResponseBody
    public Boolean deleteFileIno(HttpServletRequest request, @PathVariable(value = "file_seq") long file_seq) {
        boolean result = false;
        int tmp = fileService.deleteFileGroup(file_seq, FileGrpType.CMIT);
        if (tmp > 0) {
            result = true;
        }
        return result;
    }

    /**
     * 관리자> 주민참여위원회 공모 삭제
     * 
     * @param request
     * @param ps_seq
     * @return
     */
    @RequestMapping(value = "/admin/cmit/cmit_contest_remove/{ps_seq}")
    @ResponseBody
    public Boolean removeCmitContest(HttpServletRequest request, @PathVariable(value = "ps_seq") int ps_seq) {
        boolean result = false;
        int tmp = committeeService.deleteCmitContest(ps_seq);
        if (tmp > 0) {
            result = true;
        }
        return result;
    }

    /**
     * 관리자>주민참여위원회 공모 강제종료
     * 
     * @param request
     * @param ps_seq
     * @return
     */
    @RequestMapping(value = "/admin/cmit/cmit_contest_stop/{ps_seq}")
    @ResponseBody
    public Boolean stopCmitContest(HttpServletRequest request, @PathVariable(value = "ps_seq") int ps_seq) {
        boolean result = false;
        int tmp = committeeService.stopCmitContest(ps_seq);
        if (tmp > 0) {
            result = true;
        }
        return result;
    }

    /**
     * 주민참여위원회> 신청서 리스트화면
     * 
     * @param request
     * @param response
     * @param pagingHelper
     * @return
     */
    @RequestMapping(value = "/admin/cmit/cmit_contest_reqList")
    public ModelAndView cmitContestReqList(HttpServletRequest request, HttpServletResponse response, PagingHelper pagingHelper) {
        ModelAndView mav = new ModelAndView();
        mav.setViewName("/admin/cmit/cmit_contest_reqList");

        HashMap<String, Object> param = new HashMap<String, Object>();

        String tmpSeq = StringUtils.defaultString(request.getParameter("ps_seq"), "");
        int ps_seq = Integer.parseInt(tmpSeq);
        param.put("ps_seq", ps_seq);

        // 회원 상태(AVAILABLE(회원),WITHDRAWAL(탈퇴))
        String user_stat = StringUtils.defaultString(request.getParameter("user_stat"), "");
        param.put("user_stat", user_stat);

        // 희망 분과(코드값)
        String sub_cmit = StringUtils.defaultString(request.getParameter("subCmit1"), "");
        param.put("sub_cmit", sub_cmit);

        // 검색조건
        String search_condition = StringUtils.defaultString(request.getParameter("search_condition"), "");
        param.put("search_condition", search_condition);

        // 검색어
        String searchStringTmp = StringUtils.defaultString(request.getParameter("search_string"), "");
        String search_string = XecureUtil.encString(searchStringTmp);
        param.put("search_string", search_string);
        /** paging setting */
        pagingHelper.setTotalCnt(committeeService.getAdmCmitReqCount(param));
        param.put("startNum", pagingHelper.getStartRow() - 1);
        param.put("endNum", pagingHelper.getPagingRow());
        mav.addObject("pagingHelper", pagingHelper);

        // 위원공모 정보 조회
        Map<String, Object> cmitPssrp = committeeService.selectCmitPssrp(tmpSeq);
        mav.addObject("cmitPssrp", cmitPssrp);

        // 사업리스트
        List<HashMap<String, Object>> cmitReqList = committeeService.getAdmCmitContestReqList(param);
        mav.addObject("cmitReqList", cmitReqList);
        mav.addObject("params", param);

        return mav;
    }

    /**
     * 신청목록 엑셀다운로드
     * 
     * @param request
     * @return
     */
    @RequestMapping(value = "/admin/cmit/cmit_contest_reqExcel")
    public ModelAndView cmitContesteReqMemberListExcel(HttpServletRequest request) {
        ModelAndView mav = new ModelAndView();
        HashMap<String, Object> param = new HashMap<String, Object>();

        String tmpSeq = StringUtils.defaultString(request.getParameter("ps_seq"), "");
        int ps_seq = Integer.parseInt(tmpSeq);
        param.put("ps_seq", ps_seq);

        List<HashMap<String, Object>> list = committeeService.selectCmitReqMemberListExcel(param);

        mav.setViewName("/admin/cmit/cmit_req_excel");
        mav.addObject("list", list);

        return mav;
    }


    /**
     * 신청서 상세보기
     * 
     * @param request
     * @param req_seq
     * @return
     */
    @RequestMapping(value = "/admin/cmit/cmit_contest_reqView/{req_seq}")
    public ModelAndView AdmcmitContestReqView(HttpServletRequest request, @PathVariable(value = "req_seq") int req_seq) {
        ModelAndView mav = new ModelAndView();
        mav.setViewName("/admin/cmit/cmit_contest_reqView");
        HashMap<String, Object> cmitContestReq = committeeService.getAdmCmitContestReq(req_seq);
        mav.addObject("cmitContestReq", cmitContestReq);
        return mav;
    }

    /**
     * 관리자> 주민참여위원회 신청서 삭제
     * 
     * @param request
     * @param req_seq
     * @return
     */
    @RequestMapping(value = "/admin/cmit/cmit_contest_reqRemove/{req_seq}")
    @ResponseBody
    public Boolean cmitContestReqRemove(HttpServletRequest request, @PathVariable(value = "req_seq") int req_seq) {
        boolean result = false;
        int tmp = committeeService.removeCmitContestReq(req_seq);
        if (tmp > 0) {
            result = true;
        }
        return result;
    }

}
