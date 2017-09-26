/**
 * Copyright (c) 2016 JAHA SMART CORP., LTD ALL RIGHT RESERVED
 */
package com.jaha.evote.controller.admin;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import com.jaha.evote.common.util.FileUploadUtil;
import com.jaha.evote.common.util.PagingHelper;
import com.jaha.evote.common.util.StringUtils;
import com.jaha.evote.controller.common.BaseController;
import com.jaha.evote.domain.BannerPop;
import com.jaha.evote.domain.SearchList;
import com.jaha.evote.domain.common.FileInfo;
import com.jaha.evote.domain.type.FileGrpType;
import com.jaha.evote.domain.type.FileType;
import com.jaha.evote.service.BannerPopService;
import com.jaha.evote.service.ProposalService;
import com.jaha.evote.service.VoteService;

/**
 * <pre>
 * Class Name : BannerPopController.java
 * Description : 배너/팝업 관리 컨트롤러
 *  
 * Modification Information
 * 
 * Mod Date         Modifier    Description
 * -----------      --------    ---------------------------
 * 2016. 10. 28.     jjpark      Generation
 * </pre>
 *
 * @author jjpark
 * @since 2016. 10. 28.
 * @version 1.0
 */
@Controller
public class BannerPopController extends BaseController {

    @Autowired
    private BannerPopService bannerPopService;

    @Autowired
    private VoteService voteService;

    @Autowired
    private ProposalService proposalService;

    @Autowired
    private FileUploadUtil fileUploadUtil;

    /**
     * 주민알림 > 팝업/배너관리 목록 조회
     * 
     * @param request
     * @param mgmtType
     * @param searchParam
     * @param pagingHelper
     * @return
     */
    @RequestMapping(value = "/admin/mgmt/{mgmtType}/list")
    public ModelAndView getBannerList(HttpServletRequest request, @PathVariable(value = "mgmtType") String mgmtType, BannerPop searchParam, PagingHelper pagingHelper) {

        // 팝업/배너 구분
        if ("POPUP".equalsIgnoreCase(mgmtType)) {
            searchParam.setType("POPUP");
        } else if ("BANNER".equalsIgnoreCase(mgmtType)) {
            searchParam.setType("BANNER");
        }

        SearchList<BannerPop> list = bannerPopService.selectBannerPopList(searchParam);

        pagingHelper.setTotalCnt(list.getTotalCnt());

        ModelAndView mav = new ModelAndView();

        mav.addObject("list", list);
        mav.addObject("mgmtType", mgmtType);

        mav.addObject("searchParam", searchParam);
        mav.addObject("pagingHelper", pagingHelper);

        mav.setViewName("admin/mgmt/list");

        return mav;
    }

    /**
     * 주민알림 > 팝업/배너관리 등록화면
     * 
     * @param request
     * @param searchParam
     * @param mgmtType
     * @return
     */
    @RequestMapping(value = "/admin/mgmt/{mgmtType}/write")
    public ModelAndView writeBanner(HttpServletRequest request, BannerPop searchParam, @PathVariable(value = "mgmtType") String mgmtType) {

        ModelAndView mav = new ModelAndView();

        mav.addObject("mgmtType", mgmtType);

        mav.addObject("searchParam", searchParam);

        mav.setViewName("admin/mgmt/write");

        return mav;
    }

    /**
     * 주민알림 > 팝업/배너관리 등록
     * 
     * @param request
     * @param bannerPop
     * @param mgmtType
     * @param mobImageFile
     * @param webImageFile
     * @return
     */
    @RequestMapping(value = "/admin/mgmt/{mgmtType}/write-proc")
    public String writeBannerProc(HttpServletRequest request, BannerPop bannerPop, @PathVariable(value = "mgmtType") String mgmtType,
            @RequestParam(value = "mobImageFile", required = false) MultipartFile mobImageFile, @RequestParam(value = "webImageFile", required = false) MultipartFile webImageFile) {

        FileGrpType fileGrpType = null;

        // 팝업/배너 구분
        if ("POPUP".equalsIgnoreCase(mgmtType)) {
            bannerPop.setType("POPUP");
            fileGrpType = FileGrpType.POPUP;
        } else if ("BANNER".equalsIgnoreCase(mgmtType)) {
            bannerPop.setType("BANNER");
            fileGrpType = FileGrpType.BANNER;
        }

        // 이미지 파일 처리
        List<FileInfo> mobImageList = new ArrayList<>();
        List<FileInfo> webImageList = new ArrayList<>();

        // 모바일 이미지 처리
        if (StringUtils.isNotEmpty(mobImageFile.getOriginalFilename())) {
            mobImageList.add(fileUploadUtil.getSavedFileInfo(mobImageFile, fileGrpType, FileType.IMG_MOB));
        }

        // 웹 이미지 처리
        if (StringUtils.isNotEmpty(webImageFile.getOriginalFilename())) {
            webImageList.add(fileUploadUtil.getSavedFileInfo(webImageFile, fileGrpType, FileType.IMG_WEB));
        }

        bannerPop.setMobImageList(mobImageList);
        bannerPop.setWebImageList(webImageList);

        int result = bannerPopService.insertBannerPop(bannerPop);

        logger.debug("### result :: [{}]", result);

        return "redirect:/admin/mgmt/" + mgmtType + "/list";
    }

    /**
     * 주민알림 > 팝업/배너관리 수정화면
     * 
     * @param request
     * @param searchParam
     * @param mgmtType
     * @param bpSeq
     * @return
     */
    @RequestMapping(value = "/admin/mgmt/{mgmtType}/modify/{bpSeq}")
    public ModelAndView modifyBanner(HttpServletRequest request, BannerPop searchParam, @PathVariable(value = "mgmtType") String mgmtType, @PathVariable(value = "bpSeq") long bpSeq) {

        //        WHERE site_cd = #{siteCd}
        //        AND type = #{type}
        //        AND bp_seq = #{bpSeq}

        //        Map<String, Object> param = new HashMap<>();
        //        param.put("type", mgmtType.toUpperCase());
        //        param.put("bpSeq", searchParam.getBpSeq());

        BannerPop bannerPop = bannerPopService.selectBannerPop(mgmtType, bpSeq);

        ModelAndView mav = new ModelAndView();

        mav.addObject("bannerPop", bannerPop);
        mav.addObject("searchParam", searchParam);

        mav.setViewName("admin/mgmt/modify");

        return mav;
    }

    /**
     * 주민알림 > 팝업/배너관리 수정
     * 
     * @param request
     * @param bannerPop
     * @param mgmtType
     * @param mobImageFile
     * @param webImageFile
     * @param deleteFile
     * @return
     */
    @RequestMapping(value = "/admin/mgmt/{mgmtType}/modify-proc")
    public String modifyBannerProc(HttpServletRequest request, BannerPop bannerPop, @PathVariable(value = "mgmtType") String mgmtType,
            @RequestParam(value = "mobImageFile", required = false) MultipartFile mobImageFile, @RequestParam(value = "webImageFile", required = false) MultipartFile webImageFile,
            @RequestParam(value = "deleteFile", required = false) String deleteFile) {

        FileGrpType fileGrpType = null;

        // 팝업/배너 구분
        if ("POPUP".equalsIgnoreCase(mgmtType)) {
            bannerPop.setType("POPUP");
            fileGrpType = FileGrpType.POPUP;
        } else if ("BANNER".equalsIgnoreCase(mgmtType)) {
            bannerPop.setType("BANNER");
            fileGrpType = FileGrpType.BANNER;
        }

        // 이미지 파일 처리
        List<FileInfo> mobImageList = new ArrayList<>();
        List<FileInfo> webImageList = new ArrayList<>();

        // 모바일 이미지 처리
        if (StringUtils.isNotEmpty(mobImageFile.getOriginalFilename())) {
            mobImageList.add(fileUploadUtil.getSavedFileInfo(mobImageFile, fileGrpType, FileType.IMG_MOB));
        }

        // 웹 이미지 처리
        if (StringUtils.isNotEmpty(webImageFile.getOriginalFilename())) {
            webImageList.add(fileUploadUtil.getSavedFileInfo(webImageFile, fileGrpType, FileType.IMG_WEB));
        }

        bannerPop.setMobImageList(mobImageList);
        bannerPop.setWebImageList(webImageList);

        int result = bannerPopService.updateBannerPop(bannerPop, deleteFile);

        logger.debug("### result :: [{}]", result);

        return "redirect:/admin/mgmt/" + mgmtType + "/list";
    }

    /**
     * 주민알림 > 팝업/배너관리 검색
     * 
     * @param request
     * @param mgmtType
     * @param searchParam
     * @return
     */
    @RequestMapping(value = "/admin/mgmt/{mgmtType}/search")
    public ModelAndView openPopup(HttpServletRequest request, @PathVariable(value = "mgmtType") String mgmtType, @RequestParam HashMap<String, Object> searchParam) {

        ModelAndView mav = new ModelAndView();

        logger.debug("### searchParam : [{}]", searchParam);

        // 검색 대상(VOTE:투표, PSSRP:공모)
        String searchDest = (String) searchParam.get("searchDest");

        // 검색 대상이 없을 경우 기본 투표로 설정
        if (StringUtils.isEmpty(searchDest)) {
            searchDest = "V";
            searchParam.put("searchDest", searchDest);
        }

        List<?> list = null;


        if ("V".equalsIgnoreCase(searchDest) || "VOTE".equalsIgnoreCase(searchDest)) {

            // 투표 목록 조회

            HashMap<String, Object> params = new HashMap<String, Object>();

            params.put("seach_string", searchParam.get("seachString"));
            params.put("mgmtStartDate", searchParam.get("searchStartDate"));
            params.put("mgmtEndDate", searchParam.get("searchEndDate"));

            params.put("withoutDpOrd", "Y");

            list = voteService.voteList(params);

        } else if ("P".equalsIgnoreCase(searchDest) || "PSSRP".equalsIgnoreCase(searchDest)) {

            // 공모 목록 조회
            Map<String, Object> params = new HashMap<>();

            params.put("searchKeyword", searchParam.get("seachString"));
            params.put("startDate", searchParam.get("searchStartDate"));
            params.put("endDate", searchParam.get("searchEndDate"));
            params.put("startNum", 0);
            params.put("endNum", 100);

            params.put("popupOrderBy", "Y");

            list = proposalService.selectPssrpList(params);
        }


        mav.addObject("mgmtType", mgmtType);
        mav.addObject("searchParam", searchParam);
        mav.addObject("list", list);

        mav.setViewName("admin/mgmt/search");

        return mav;
    }

}
