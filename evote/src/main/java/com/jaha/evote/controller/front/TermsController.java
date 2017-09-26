/**
 * Copyright (c) 2016 by jahasmart.com. All rights reserved.
 */
package com.jaha.evote.controller.front;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com.jaha.evote.controller.common.BaseController;
import com.jaha.evote.domain.Terms;
import com.jaha.evote.domain.type.TermsType;
import com.jaha.evote.service.TermsService;

/**
 * <pre>
 * Class Name : TermsController.java
 * Description : 약관 컨트롤러
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
public class TermsController extends BaseController {

    @Autowired
    private TermsService termsService;

    /**
     * 사용자 > 이용약관 페이지
     * 
     * @param req
     * @param res
     * @return
     */
    @RequestMapping(value = "/terms/access_terms")
    public ModelAndView access_terms(HttpServletRequest req, HttpServletResponse res) {

        Terms terms = termsService.selectTerms(TermsType.SERVICE);

        ModelAndView mav = new ModelAndView();
        mav.addObject("terms", terms);
        mav.setViewName("terms/access_terms");

        return mav;
    }

    /**
     * 사용자 > 개인정보취급약관
     * 
     * @param req
     * @param res
     * @return
     */
    @RequestMapping(value = "/terms/personal_terms")
    public ModelAndView personal_terms(HttpServletRequest req, HttpServletResponse res) {

        Terms terms = termsService.selectTerms(TermsType.PRIVACY1);

        ModelAndView mav = new ModelAndView();
        mav.addObject("terms", terms);
        mav.setViewName("terms/personal_terms");

        return mav;
    }


}
