/**
 * Copyright (c) 2016 by jahasmart.com. All rights reserved.
 *
 * 2016. 7. 11.
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
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.jaha.evote.common.util.JsonUtil;
import com.jaha.evote.common.util.Messages;
import com.jaha.evote.common.util.PagingHelper;
import com.jaha.evote.controller.common.BaseController;
import com.jaha.evote.domain.AdminUser;
import com.jaha.evote.service.ManagerService;


/**
 * <pre>
 * Class Name : ManagerController.java
 * Description : 관리자 컨트롤러
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
public class ManagerController extends BaseController {

    @Autowired
    private ManagerService managerService;

    @Autowired
    private Messages messages;

    /**
     * 관리자 목록
     * 
     * @param request
     * @param pagingHelper
     * @return
     */
    @RequestMapping(value = "/admin/manager/list")
    public ModelAndView managerList(HttpServletRequest request, PagingHelper pagingHelper) {

        List<AdminUser> list = managerService.selectManagerList();

        pagingHelper.setTotalCnt(list.size());

        ModelAndView mav = new ModelAndView();
        mav.setViewName("admin/manager/list");
        mav.addObject("managerList", list);
        mav.addObject("pagingHelper", pagingHelper);

        return mav;
    }

    //    /**
    //     * 관리자 등록 화면
    //     * 
    //     * @param request
    //     * @return
    //     */
    //    @RequestMapping(value = "/admin/manager/write")
    //    public ModelAndView managerWrite(HttpServletRequest request) {
    //
    //        ModelAndView mav = new ModelAndView();
    //        mav.setViewName("admin/manager/write");
    //
    //        return mav;
    //    }
    //
    //    /**
    //     * 관리자 등록
    //     * 
    //     * @param request
    //     * @param adminUser
    //     * @return
    //     */
    //    @RequestMapping(value = "/admin/manager/write-proc")
    //    public String managerWriteProc(HttpServletRequest request, AdminUser adminUser) {
    //        managerService.insertManager(adminUser);
    //        return "redirect:/admin/manager/list";
    //    }

    /**
     * 관리자 상세
     * 
     * @param request
     * @param mgrSeq
     * @return
     */
    @RequestMapping(value = "/admin/manager/detail/{mgrSeq}")
    public ModelAndView managerModify(HttpServletRequest request, @PathVariable(value = "mgrSeq") long mgrSeq, PagingHelper pagingHelper) {

        AdminUser adminUser = managerService.selectManager(mgrSeq);

        ModelAndView mav = new ModelAndView();
        mav.addObject("manager", adminUser);
        mav.addObject("pagingHelper", pagingHelper);
        mav.setViewName("admin/manager/detail");

        return mav;
    }

    /**
     * 관리자 수정
     * 
     * @param request
     * @param adminUser
     * @return
     */
    @RequestMapping(value = "/admin/manager/modify-proc")
    public String managerModifyProc(HttpServletRequest request, AdminUser adminUser) {
        managerService.updateManager(adminUser);
        return "redirect:/admin/manager/list";
    }

    /**
     * 관리자 비밀번호 변경
     * 
     * @param json
     * @return
     */
    @RequestMapping(value = "/admin/manager/modify-passwd")
    @ResponseBody
    public Map<String, Object> changePassword(@RequestBody String json) {

        JSONObject item = new JSONObject(json);

        Map<String, Object> param = JsonUtil.toMap(item);

        int result = managerService.updateManagerPasswd(param);

        Map<String, Object> resultMap = new HashMap<>();

        if (result > 0) {
            resultMap.put("result", true);

        } else if (result == -1) {
            resultMap.put("result", false);
            // message.member.info.009=현재 비밀번호가 일치하지 않습니다
            String message = messages.getMessage("message.member.info.009");
            resultMap.put("message", message);
        } else {
            resultMap.put("result", false);
            resultMap.put("message", "비밀번호 변경에 실패했습니다.");
        }

        return resultMap;

    }

    //    /**
    //     * 관리자 삭제
    //     * 
    //     * @param request
    //     * @param mgrSeq
    //     * @return
    //     */
    //    @RequestMapping(value = "/admin/manager/remove/{mgrSeq}")
    //    public String ManagerRemove(HttpServletRequest request, @PathVariable(value = "mgrSeq") long mgrSeq) {
    //        managerService.removeManager(mgrSeq);
    //        return "redirect:/admin/manager/list";
    //    }

}
