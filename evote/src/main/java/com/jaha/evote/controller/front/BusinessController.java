/**
 * Copyright (c) 2016 JAHA SMART CORP., LTD ALL RIGHT RESERVED
 *
 * 2016. 10. 24.
 */
package com.jaha.evote.controller.front;

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
import org.springframework.web.servlet.ModelAndView;

import com.jaha.evote.common.util.PagingHelper;
import com.jaha.evote.controller.common.BaseController;
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
public class BusinessController extends BaseController {

    @Autowired
    private BusinessService businessService;

    @Autowired
    FileService fileService;

    /**
     * 사업현황 리스트화면
     * 
     * @param request
     * @param response
     * @param pagingHelper
     * @return
     */
    @RequestMapping(value = "/biz/biz_list")
    public ModelAndView bizList(HttpServletRequest request, HttpServletResponse response, PagingHelper pagingHelper) {
        ModelAndView mav = new ModelAndView();
        mav.setViewName("/biz/biz_list");

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
     * 사업현황 상세보기
     * 
     * @param request
     * @param biz_seq
     * @return
     */
    @RequestMapping(value = "/biz/biz_view/{biz_seq}")
    public ModelAndView getBusiness(HttpServletRequest request, @PathVariable(value = "biz_seq") int biz_seq, @RequestParam Map<String, Object> searchParam) {
        ModelAndView mav = new ModelAndView();
        mav.setViewName("/biz/biz_view");
        HashMap<String, Object> param = new HashMap<String, Object>();
        param.put("biz_seq", biz_seq);
        HashMap<String, Object> bizItem = businessService.selectBusiness(param);
        mav.addObject("bizItem", bizItem);
        mav.addObject("searchParam", searchParam);

        return mav;
    }

    /**
     * 사업현황 공감 추가
     * 
     * @param request
     * @param biz_seq
     * @return
     */
    @RequestMapping(value = "/biz/add_sympathy/{biz_seq}")
    @ResponseBody
    public long addSympathy(HttpServletRequest request, @PathVariable(value = "biz_seq") int biz_seq) {
        return businessService.insertSympathy(biz_seq);
    }

    /**
     * 사업현황 공감 삭제
     * 
     * @param request
     * @param biz_seq
     * @return
     */
    @RequestMapping(value = "/biz/remove_sympathy/{biz_seq}")
    @ResponseBody
    public long removeSympathy(HttpServletRequest request, @PathVariable(value = "biz_seq") int biz_seq) {
        return businessService.deleteSympathy(biz_seq);
    }

    /**
     * 모바일 >사업현황 리스트 더보기
     * 
     * @param request
     * @param response
     * @param pagingHelper
     * @return
     */
    @RequestMapping(value = "/biz/biz_list/more")
    @ResponseBody
    public HashMap<String, Object> bizListMoreData(HttpServletRequest request, HttpServletResponse response, PagingHelper pagingHelper) {
        //ModelAndView mav = new ModelAndView();
        HashMap<String, Object> param = new HashMap<String, Object>();
        HashMap<String, Object> result = new HashMap<String, Object>();
        // 검색 구분(TITLE,CONTENTS)
        String search_gubun = "TITLE";
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
        result.put("pagingHelper", pagingHelper);
        // 사업리스트
        List<HashMap<String, Object>> businessList = businessService.getBusinessList(param);
        result.put("businessList", businessList);
        result.put("params", param);

        return result;
    }
}
