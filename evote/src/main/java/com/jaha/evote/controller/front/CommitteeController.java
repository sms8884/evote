/**
 * Copyright (c) 2016 JAHA SMART CORP., LTD ALL RIGHT RESERVED
 */
package com.jaha.evote.controller.front;

import java.text.ParseException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

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

import com.jaha.evote.common.exception.EvoteBizException;
import com.jaha.evote.common.util.FileUploadUtil;
import com.jaha.evote.common.util.PagingHelper;
import com.jaha.evote.controller.common.BaseController;
import com.jaha.evote.domain.common.Address;
import com.jaha.evote.domain.common.FileInfo;
import com.jaha.evote.domain.type.FileGrpType;
import com.jaha.evote.domain.type.FileType;
import com.jaha.evote.service.AddressService;
import com.jaha.evote.service.CommitteeService;

/**
 * <pre>
 * Class Name : CommitteeController.java
 * Description : 주민참여위원회 컨트롤러
 *  
 * Modification Information
 * 
 * Mod Date         Modifier    Description
 * -----------      --------    ---------------------------
 * 2016. 10. 24.     jjpark      Generation
 * </pre>
 *
 * @author jjpark
 * @since 2016. 10. 24.
 * @version 1.0
 */
@Controller
public class CommitteeController extends BaseController {

    @Autowired
    private CommitteeService committeeService;

    @Autowired
    private AddressService addressService;

    @Autowired
    private FileUploadUtil fileUploadUtil;

    /**
     * 주민참여위원회 > 위원회역할
     * 
     * @param request
     * @param response
     * @param params
     * @return
     */
    @RequestMapping(value = "/cmit/part")
    public String getPart(HttpServletRequest request, HttpServletResponse response) {
        return "cmit/part";
    }

    /**
     * 사용자>주민참여위원 공모 신청하기
     * 
     * @param request
     * @return
     */
    @RequestMapping(value = "/cmit/cmit_contest_req")
    public ModelAndView cmitContestReq(HttpServletRequest request) {
        ModelAndView mav = new ModelAndView();
        // committeeService;
        mav.setViewName("/cmit/cmit_contest_req");
        HashMap<String, Object> cmitReqItem = committeeService.selectCmitContest();
        mav.addObject("cmitReqItem", cmitReqItem);
        if (cmitReqItem == null) {
            throw new EvoteBizException("진행중인 공모가 없습니다");
        }
        return mav;
    }

    /**
     * 사용자>주민참여위원회 공모 신청서 등록화면
     * 
     * @param response
     * @return
     */
    @RequestMapping(value = "/cmit/cmit_contest_wrtieForm/{psSeq}")
    public ModelAndView cmitContestWriteFormReq(HttpServletRequest request, @PathVariable(value = "psSeq") int ps_seq) {
        ModelAndView mav = new ModelAndView();
        mav.setViewName("/cmit/cmit_contest_write");

        HashMap<String, Object> formInfo = committeeService.selectFormInfo(ps_seq);
        mav.addObject("formInfo", formInfo);

        List<Address> emdList = addressService.selectSiteEmdList();
        mav.addObject("emdList", emdList);

        return mav;
    }

    /**
     * 사용자 > 주민참여위원회 공모 신청서 등록
     * 
     * @param request
     * @param attachFiles
     * @param imageFiles
     * @return
     * @throws ParseException
     */
    @RequestMapping(value = "/cmit/cmit_contest_write")
    public String writeFrontCmitContest(HttpServletRequest request, @RequestParam(value = "attachFile", required = false) MultipartFile[] attachFiles,
            @RequestParam(value = "imageFile", required = false) MultipartFile[] imageFiles) throws ParseException {
        HashMap<String, Object> param = new HashMap<String, Object>();
        String phone = StringUtils.defaultString(request.getParameter("phone"), ""); // 연락처
        String addr1 = StringUtils.defaultString(request.getParameter("addr1"), "");// 주소1
        String addr2 = StringUtils.defaultString(request.getParameter("addr2"), "");// 주소2
        String subCmit1 = StringUtils.defaultString(request.getParameter("subCmit1"), "");// 희망분과1
        String subCmit2 = StringUtils.defaultString(request.getParameter("subCmit2"), "");// 희망분과2
        String intro = StringUtils.defaultString(request.getParameter("intro"), "");// 자기소개
        String job = StringUtils.defaultString(request.getParameter("job"), "");// 직업
        String psSeq = StringUtils.defaultString(request.getParameter("ps_seq"), "");// 공모 번호
        int ps_seq = Integer.parseInt(psSeq);

        // 첨부파일 처리
        if (attachFiles != null) {
            List<FileInfo> attachList = new ArrayList<>();
            for (MultipartFile attachFile : attachFiles) {
                if (StringUtils.isNotEmpty(attachFile.getOriginalFilename())) {
                    attachList.add(fileUploadUtil.getSavedFileInfo(attachFile, FileGrpType.CMIT_REQ, FileType.ATTACH));
                }
            }
            param.put("attachList", attachList);
        }
        // 이미지 파일 처리
        if (imageFiles != null) {
            List<FileInfo> imageList = new ArrayList<>();
            for (MultipartFile imageFile : imageFiles) {
                if (StringUtils.isNotEmpty(imageFile.getOriginalFilename())) {
                    imageList.add(fileUploadUtil.getSavedFileInfo(imageFile, FileGrpType.CMIT_REQ, FileType.IMAGE));
                }
            }
            param.put("imageList", imageList);
        }

        param.put("phone", phone);
        param.put("addr1", addr1);
        param.put("addr2", addr2);
        param.put("subCmit1", subCmit1);
        param.put("subCmit2", subCmit2);
        param.put("intro", intro);
        param.put("job", job);
        param.put("ps_seq", ps_seq);

        committeeService.inserCmitContestReq(param);

        return "redirect:/cmit/cmit_contest_req";
    }

    /**
     * 사용자>주민참여위원시 신청서 목록화면
     * 
     * @param request
     * @return
     */
    @RequestMapping(value = "/cmit/cmit_contest_reqList")
    public ModelAndView cmitContestReqList(HttpServletRequest request) {
        ModelAndView mav = new ModelAndView();
        mav.setViewName("/cmit/cmit_contest_list");
        HashMap<String, Object> param = new HashMap<String, Object>();
        List<HashMap<String, Object>> cmitReqList = committeeService.getCmitContestReqList(param);
        mav.addObject("cmitReqList", cmitReqList);

        return mav;
    }

    /**
     * 사용자 > 주민참여위원회 신청서 상세보기
     * 
     * @param request
     * @param req_seq
     * @return
     */
    @RequestMapping(value = "/cmit/cmit_contest_reqView/{req_seq}")
    public ModelAndView cmitContestReqView(HttpServletRequest request, @PathVariable(value = "req_seq") int req_seq) {
        ModelAndView mav = new ModelAndView();
        mav.setViewName("/cmit/cmit_contest_view");
        HashMap<String, Object> cmitContestReq = committeeService.getCmitContestReq(req_seq);
        mav.addObject("cmitContestReq", cmitContestReq);
        return mav;
    }

    /**
     * 사용자> 주민참여위원회 신청서 삭제
     * 
     * @param request
     * @param req_seq
     * @return
     */
    @RequestMapping(value = "/cmit/cmit_contest_reqRemove/{req_seq}")
    public String cmitContestReqRemove(HttpServletRequest request, @PathVariable(value = "req_seq") int req_seq) {
        committeeService.removeCmitContestReq(req_seq);
        return "redirect:/cmit/cmit_contest_req";
    }

    /**
     * 모바일>주민참여위원회 신청서 더보기
     * 
     * @param request
     * @param response
     * @param pagingHelper
     * @return
     */
    @RequestMapping(value = "/cmit/cmit_contest_listMore")
    @ResponseBody
    public HashMap<String, Object> cmitContestListReqMore(HttpServletRequest request, HttpServletResponse response, PagingHelper pagingHelper) {
        HashMap<String, Object> param = new HashMap<String, Object>();
        HashMap<String, Object> result = new HashMap<String, Object>();
        /** paging setting */
        pagingHelper.setTotalCnt(committeeService.getCmitContestCount());
        param.put("startNum", pagingHelper.getStartRow() - 1);
        param.put("endNum", pagingHelper.getPagingRow());
        result.put("pagingHelper", pagingHelper);
        // 주민참여위원 공모 리스트
        List<HashMap<String, Object>> cmitReqList = committeeService.getCmitContestReqList(param);
        result.put("cmitReqList", cmitReqList);
        result.put("params", param);
        return result;
    }

}
