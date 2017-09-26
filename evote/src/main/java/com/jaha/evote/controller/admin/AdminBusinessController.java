/**
 * Copyright (c) 2016 JAHA SMART CORP., LTD ALL RIGHT RESERVED
 *
 * 2016. 10. 24.
 */
package com.jaha.evote.controller.admin;

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

import com.jaha.evote.common.util.FileUploadUtil;
import com.jaha.evote.common.util.PagingHelper;
import com.jaha.evote.controller.common.BaseController;
import com.jaha.evote.domain.common.FileInfo;
import com.jaha.evote.domain.type.FileGrpType;
import com.jaha.evote.domain.type.FileType;
import com.jaha.evote.service.BusinessService;
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
 * 2016. 10. 24.        MyoungSeop       Generation
 * </pre>
 *
 * @author AAA
 * @since 2016. 10. 24.
 * @version 1.0
 */
@Controller
public class AdminBusinessController extends BaseController {

    @Autowired
    private BusinessService businessService;

    @Autowired
    private FileUploadUtil fileUploadUtil;

    @Autowired
    FileService fileService;


    //    private static final String LOGINPAGE = "/admin/login";

    /**
     * 사업현황 리스트화면
     * 
     * @param request
     * @param response
     * @param pagingHelper
     * @return
     */
    @RequestMapping(value = "/admin/biz/biz_list")
    public ModelAndView bizList(HttpServletRequest request, HttpServletResponse response, PagingHelper pagingHelper) {
        ModelAndView mav = new ModelAndView();
        mav.setViewName("/admin/biz/biz_list");

        HashMap<String, Object> param = new HashMap<String, Object>();

        // 검색 상태(ING,COMPLETE)
        String search_status = StringUtils.defaultString(request.getParameter("search_status"), "");
        param.put("search_status", search_status);

        // 검색 구분(TITLE,CONTENTS)
        String search_gubun = StringUtils.defaultString(request.getParameter("search_gubun"), "");
        param.put("search_gubun", search_gubun);

        // 검색어
        String search_string = StringUtils.defaultString(request.getParameter("search_string"), "");
        param.put("search_string", search_string);

        // 년도
        String search_year = StringUtils.defaultString(request.getParameter("search_year"), "");
        param.put("search_year", search_year);


        /** paging setting */
        pagingHelper.setTotalCnt(businessService.getBusinessListCount(param));
        param.put("startNum", pagingHelper.getStartRow() - 1);
        param.put("endNum", pagingHelper.getPagingRow());
        mav.addObject("pagingHelper", pagingHelper);

        // 사업리스트
        List<HashMap<String, Object>> businessList = businessService.getBusinessList(param);
        mav.addObject("businessList", businessList);
        mav.addObject("params", param);

        return mav;
    }

    /**
     * 사업현황 등록화면
     * 
     * @param request
     * @param response
     * @return
     */
    @RequestMapping(value = "/admin/biz/biz_writeForm")
    public ModelAndView writeBusinessForm(HttpServletRequest request, HttpServletResponse response) {
        ModelAndView mav = new ModelAndView();
        mav.setViewName("/admin/biz/biz_write");
        return mav;
    }

    /**
     * 사업현황 등록
     * 
     * @param request
     * @param imageFiles
     * @param attachFiles
     * @return
     */
    @RequestMapping(value = "/admin/biz/biz_write")
    public String writeBusiness(HttpServletRequest request, @RequestParam(value = "imageFile", required = false) MultipartFile[] imageFiles,
            @RequestParam(value = "attachFile", required = false) MultipartFile[] attachFiles) {
        HashMap<String, Object> param = new HashMap<String, Object>();

        String biz_year = StringUtils.defaultString(request.getParameter("biz_year"), ""); // 사업연도
        String biz_name = StringUtils.defaultString(request.getParameter("biz_name"), "");// 사업명
        String budget = StringUtils.defaultString(request.getParameter("budget"), ""); // 소요예산
        String state = StringUtils.defaultString(request.getParameter("state"), ""); // 진행상황
        String tmpprogress = StringUtils.defaultString(request.getParameter("progress"), "100"); // 진행률
        int progress = Integer.parseInt(tmpprogress);
        String summary = StringUtils.defaultString(request.getParameter("summary"), "");// 사업개요
        String plan = StringUtils.defaultString(request.getParameter("plan"), "");// 추진계획
        String result = StringUtils.defaultString(request.getParameter("result"), "");// 추진실적
        String schedule = StringUtils.defaultString(request.getParameter("schedule"), "");// 향후일정
        String dept = StringUtils.defaultString(request.getParameter("dept"), "");// 추진부서



        // 이미지 파일 처리
        if (imageFiles != null) {
            List<FileInfo> imageList = new ArrayList<>();
            for (MultipartFile imageFile : imageFiles) {
                if (StringUtils.isNotEmpty(imageFile.getOriginalFilename())) {
                    imageList.add(fileUploadUtil.getSavedFileInfo(imageFile, FileGrpType.BUSINESS, FileType.IMAGE));
                }
            }
            param.put("imageList", imageList);
        }

        // 첨부파일 처리
        if (attachFiles != null) {
            List<FileInfo> attachList = new ArrayList<>();
            for (MultipartFile attachFile : attachFiles) {
                if (StringUtils.isNotEmpty(attachFile.getOriginalFilename())) {
                    attachList.add(fileUploadUtil.getSavedFileInfo(attachFile, FileGrpType.BUSINESS, FileType.ATTACH));
                }
            }
            param.put("attachList", attachList);
        }

        param.put("biz_year", biz_year);
        param.put("biz_name", biz_name);
        param.put("budget", budget);
        param.put("state", state);
        param.put("progress", progress);
        param.put("summary", summary);
        param.put("plan", plan);
        param.put("result", result);
        param.put("schedule", schedule);
        param.put("dept", dept);
        businessService.insertBusiness(param);

        return "redirect:/admin/biz/biz_list";
    }

    /**
     * 사업현황 상세보기
     * 
     * @param request
     * @param biz_seq
     * @return
     */
    @RequestMapping(value = "/admin/biz/biz_view/{biz_seq}")
    public ModelAndView getBusiness(HttpServletRequest request, @PathVariable(value = "biz_seq") int biz_seq) {
        ModelAndView mav = new ModelAndView();
        mav.setViewName("/admin/biz/biz_view");
        HashMap<String, Object> param = new HashMap<String, Object>();
        param.put("biz_seq", biz_seq);
        HashMap<String, Object> bizItem = businessService.selectBusiness(param);
        mav.addObject("bizItem", bizItem);

        return mav;
    }


    /**
     * 사업현황 수정화면
     * 
     * @param request
     * @param response
     * @return
     */
    @RequestMapping(value = "/admin/biz/biz_modify/{biz_seq}")
    public ModelAndView modifyBusinessForm(HttpServletRequest request, @PathVariable(value = "biz_seq") int biz_seq) {
        ModelAndView mav = new ModelAndView();
        mav.setViewName("/admin/biz/biz_modify");
        HashMap<String, Object> param = new HashMap<String, Object>();
        param.put("biz_seq", biz_seq);
        HashMap<String, Object> bizItem = businessService.selectBusiness(param);
        mav.addObject("bizItem", bizItem);
        return mav;
    }

    /**
     * 사업현황 수정
     * 
     * @param request
     * @param imageFiles
     * @param attachFiles
     * @return
     */
    @RequestMapping(value = "/admin/biz/biz_modify")
    public String modifyBusiness(HttpServletRequest request, @RequestParam(value = "imageFile", required = false) MultipartFile[] imageFiles,
            @RequestParam(value = "attachFile", required = false) MultipartFile[] attachFiles) {
        HashMap<String, Object> param = new HashMap<String, Object>();

        String biz_year = StringUtils.defaultString(request.getParameter("biz_year"), ""); // 사업연도
        String biz_name = StringUtils.defaultString(request.getParameter("biz_name"), "");// 사업명
        String budget = StringUtils.defaultString(request.getParameter("budget"), ""); // 소요예산
        String state = StringUtils.defaultString(request.getParameter("state"), ""); // 진행상황
        String tmpprogress = StringUtils.defaultString(request.getParameter("progress"), "100"); // 진행률
        int progress = Integer.parseInt(tmpprogress);
        String summary = StringUtils.defaultString(request.getParameter("summary"), "");// 사업개요
        String plan = StringUtils.defaultString(request.getParameter("plan"), "");// 추진계획
        String result = StringUtils.defaultString(request.getParameter("result"), "");// 추진실적
        String schedule = StringUtils.defaultString(request.getParameter("schedule"), "");// 향후일정
        String dept = StringUtils.defaultString(request.getParameter("dept"), "");// 추진부서
        String tmpbiz_seq = StringUtils.defaultString(request.getParameter("biz_seq"), "");// 사업현황 일련번호
        long biz_seq = Long.parseLong(tmpbiz_seq);

        // 이미지 파일 처리
        if (imageFiles != null) {
            List<FileInfo> imageList = new ArrayList<>();
            for (MultipartFile imageFile : imageFiles) {
                if (StringUtils.isNotEmpty(imageFile.getOriginalFilename())) {
                    imageList.add(fileUploadUtil.getSavedFileInfo(imageFile, FileGrpType.BUSINESS, FileType.IMAGE));
                }
            }
            param.put("imageList", imageList);
        }
        // 첨부파일 처리
        if (attachFiles != null) {
            List<FileInfo> attachList = new ArrayList<>();
            for (MultipartFile attachFile : attachFiles) {
                if (StringUtils.isNotEmpty(attachFile.getOriginalFilename())) {
                    attachList.add(fileUploadUtil.getSavedFileInfo(attachFile, FileGrpType.BUSINESS, FileType.ATTACH));
                }
            }
            param.put("attachList", attachList);
        }
        param.put("biz_year", biz_year);
        param.put("biz_name", biz_name);
        param.put("budget", budget);
        param.put("state", state);
        param.put("progress", progress);
        param.put("summary", summary);
        param.put("plan", plan);
        param.put("result", result);
        param.put("schedule", schedule);
        param.put("dept", dept);
        param.put("biz_seq", biz_seq);
        businessService.updateBusiness(param);
        return "redirect:/admin/biz/biz_view/" + biz_seq;
    }


    /**
     * 어드민>사진미리보기 팝업
     * 
     * @param file_seq
     * @return
     */
    @RequestMapping("/admin/biz/biz_pop/{file_seq}")
    public ModelAndView bizPop(@PathVariable(value = "file_seq") long file_seq) {
        ModelAndView mav = new ModelAndView();
        mav.setViewName("/admin/biz/biz_preview_popup");
        mav.addObject("file_seq", file_seq);
        return mav;
    }


    /**
     * 첨부파일 삭제
     * 
     * @param request
     * @param file_seq
     * @return
     */
    @RequestMapping("/admin/biz/bizFileInfo_delete/{file_seq}")
    @ResponseBody
    public Boolean deleteFileIno(HttpServletRequest request, @PathVariable(value = "file_seq") long file_seq) {
        boolean result = false;
        int tmp = fileService.deleteFileInfo(file_seq);
        if (tmp > 0) {
            result = true;
        }
        return result;
    }

    /**
     * 사업현황 삭제
     * 
     * @param request
     * @param biz_seq
     * @return
     */
    @RequestMapping(value = "/admin/biz/biz_remove/{biz_seq}")
    public String removeBusiness(HttpServletRequest request, @PathVariable(value = "biz_seq") int biz_seq) {
        businessService.deleteBusiness(biz_seq);
        return "redirect:/admin/biz/biz_list";
    }



}
