/**
 * Copyright (c) 2016 by jahasmart.com. All rights reserved.
 */
package com.jaha.evote.controller.front;

import java.util.List;
import java.util.Map;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mobile.device.Device;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.util.WebUtils;

import com.jaha.evote.common.util.XecureUtil;
import com.jaha.evote.controller.common.BaseController;
import com.jaha.evote.domain.BannerPop;
import com.jaha.evote.domain.type.FileGrpType;
import com.jaha.evote.service.BannerPopService;
import com.jaha.evote.service.HomeService;

/**
 * <pre>
 * Class Name : HomeController.java
 * Description : 홈 컨트롤러
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
public class HomeController extends BaseController {

    private static final String REDIRECT_INDEX = "redirect:/index";

    @Autowired
    private HomeService homeService;

    @Autowired
    private BannerPopService bannerPopService;

    @Value("${board.name.notice}")
    private String defaultNoticeBoardName;

    /**
     * index
     * 
     * @param req
     * @param session
     * @return
     */
    @RequestMapping(value = {"/", "index"})
    public ModelAndView home(HttpServletRequest req, HttpSession session) {

        Map<String, Object> map = homeService.selectMainContents();

        ModelAndView mav = new ModelAndView();

        mav.addObject("noticeList", map.get("noticeList"));
        mav.addObject("proposalList", map.get("proposalList"));
        mav.addObject("cmitList", map.get("cmitList"));
        mav.addObject("popupList", map.get("popupList"));
        mav.addObject("bannerList", map.get("bannerList"));
        mav.addObject("bizList", map.get("bizList"));

        mav.setViewName("index");

        return mav;
    }

    /**
     * 팝업 정보 조회
     * 
     * @param bpSeq
     * @return
     */
    @RequestMapping(value = "/popup/{bpSeq}")
    public ModelAndView popup(@PathVariable(value = "bpSeq") long bpSeq) {

        ModelAndView mav = new ModelAndView();
        mav.setViewName("popup");

        List<BannerPop> popupList = bannerPopService.selectMainBannerList(FileGrpType.POPUP);
        if (popupList != null) {
            for (BannerPop bannerPop : popupList) {
                if (bannerPop.getBpSeq() == bpSeq) {
                    mav.addObject("bannerPop", bannerPop);
                    break;
                }
            }
        }

        return mav;
    }

    /**
     * app index
     * 
     * @param request
     * @param response
     * @param device
     * @param mtype
     * @return
     */
    @RequestMapping(value = "/app-index", method = RequestMethod.GET)
    public String appMain(HttpServletRequest request, HttpServletResponse response, Device device, @RequestParam(value = "mtype", required = false) String mtype,
            @RequestParam(value = "p", required = false) String p) {

        if (!device.isNormal() && "app".equalsIgnoreCase(mtype)) {
            logger.debug("### addCookie ::: [mtype={}]", mtype);
            logger.debug("### p ::: [p={}]", p);
            String enc = XecureUtil.encString(p);
            WebUtils.setSessionAttribute(request, "p", enc);
            response.addCookie(new Cookie("mtype", mtype));
        } else {
            logger.debug("### addCookie ::: [mtype={}]", "normal");
            response.addCookie(new Cookie("mtype", "normal"));
        }
        return REDIRECT_INDEX;
    }


    ///////////////////////////////////////////////////////////////////////////
    //
    // 삭제
    //
    //    /**
    //     * 비밀번호 초기화에 사용할 비밀번호 조회
    //     * 
    //     * @param request
    //     * @param response
    //     * @param password
    //     * @return
    //     */
    //    @RequestMapping(value = {"/visitor/init-password"}, method = RequestMethod.GET)
    //    public String initPassword(HttpServletRequest request, HttpServletResponse response, @RequestParam(value = "password") String password) {
    //        // localhost:8080/visitor/init-password?password=p21130386@
    //        logger.debug("############################################################################################");
    //        logger.debug("* 해싱안된 비밀번호: {}", password);
    //        logger.debug("* 해싱된 비밀번호: {}", XecureUtil.hash64(password));
    //        logger.debug("############################################################################################");
    //
    //        return null;
    //    }



}
