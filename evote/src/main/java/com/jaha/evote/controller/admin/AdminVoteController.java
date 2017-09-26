package com.jaha.evote.controller.admin;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.JSONArray;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.springframework.web.servlet.view.RedirectView;

import com.jaha.evote.common.util.ExcelUploadUtil;
import com.jaha.evote.common.util.FileUploadUtil;
import com.jaha.evote.common.util.JsonUtil;
import com.jaha.evote.common.util.Messages;
import com.jaha.evote.common.util.PagingHelper;
import com.jaha.evote.common.util.RequestUtils;
import com.jaha.evote.common.util.SessionUtil;
import com.jaha.evote.common.util.StringUtils;
import com.jaha.evote.controller.common.BaseController;
import com.jaha.evote.domain.AdminUser;
import com.jaha.evote.domain.common.Address;
import com.jaha.evote.domain.common.FileInfo;
import com.jaha.evote.domain.type.FileGrpType;
import com.jaha.evote.domain.type.FileType;
import com.jaha.evote.service.AddressService;
import com.jaha.evote.service.FileService;
import com.jaha.evote.service.VoteService;

/**
 * <pre>
 * Class Name : AdminVoteController.java
 * Description : 관리자 투표 컨트롤러
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
public class AdminVoteController extends BaseController {

    @Autowired
    private VoteService voteService;

    @Autowired
    private FileService fileService;

    @Autowired
    private AddressService addressService;

    @Autowired
    private FileUploadUtil fileUploadUtil;

    @Autowired
    private Messages messages;

    private static final String LOGINPAGE = "/admin/login";

    private static final String VOTELISTPAGE = "/admin/vote/vote_list";
    private static final String VOTERESULTLISTPAGE = "/admin/vote/vote_result_list";
    private static final String VOTEREGPAGE = "/admin/vote/vote_reg_form";
    private static final String VOTEMODPAGE = "/admin/vote/vote_mod_form";

    private static final String REALMMSTPAGE = "/admin/vote/realm_mst";
    private static final String VOTEREALMPAGE = "/admin/vote/vote_realm";

    private static final String VOTEITEMLISTPAGE = "/admin/vote/vote_item_list";
    private static final String VOTEITEMREGPAGE = "/admin/vote/vote_item_reg_form";
    private static final String VOTEITEMMODPAGE = "/admin/vote/vote_item_mod_form";

    /**
     * 어드민 > 투표목록
     * 
     * @param req
     * @param res
     * @param pagingHelper
     * @return
     */
    @RequestMapping(value = "/admin/vote/vote_list")
    public ModelAndView adminVoteList(HttpServletRequest req, HttpServletResponse res, PagingHelper pagingHelper) {
        ModelAndView mav = new ModelAndView();
        mav.setViewName(VOTELISTPAGE);

        AdminUser av = SessionUtil.getAdminSessionInfo(req);
        if (av == null) {
            // 로그인 후 이용하실수 있습니다.
            String message = messages.getMessage("message.common.noLogin.001");
            RequestUtils.responseWriteException(req, res, message, LOGINPAGE);
            return null;
        }
        mav.addObject("av", av);

        HashMap<String, Object> param = new HashMap<String, Object>();

        // 검색 상태(START,WAIT,END)
        String search_status = StringUtils.defaultString(req.getParameter("search_status"), "START");
        param.put("search_status", search_status);

        // 검색어
        String seach_string = StringUtils.defaultString(req.getParameter("seach_string"), "");
        param.put("seach_string", seach_string);

        /** paging setting */
        pagingHelper.setTotalCnt(voteService.voteListCount(param));
        param.put("startNum", pagingHelper.getStartRow() - 1);
        param.put("endNum", pagingHelper.getPagingRow());
        mav.addObject("pagingHelper", pagingHelper);

        // 투표리스트
        List<HashMap<String, Object>> voteList = voteService.voteList(param); // 사업제안 리스트
        mav.addObject("voteList", voteList); // 투표 리스트
        mav.addObject("params", param); // 검색값

        // 얼럿메시지 등 스크립트 실행
        //        String script = StringUtils.defaultString(req.getParameter("script"), "");
        //        mav.addObject("script", script);
        logger.info("adminVoteList");
        return mav;
    }

    /**
     * 어드민 > 투표목록 > 결과 보기
     * 
     * @param req
     * @param res
     * @return
     */
    @RequestMapping(value = "/admin/vote/vote_result_list")
    public ModelAndView adminVoteResultList(HttpServletRequest req, HttpServletResponse res) {
        ModelAndView mav = new ModelAndView();
        mav.setViewName(VOTERESULTLISTPAGE);

        AdminUser av = SessionUtil.getAdminSessionInfo(req);
        if (av == null) {
            // 로그인 후 이용하실수 있습니다.
            String message = messages.getMessage("message.common.noLogin.001");
            RequestUtils.responseWriteException(req, res, message, LOGINPAGE);
            return null;
        }
        mav.addObject("av", av);

        HashMap<String, Object> param = new HashMap<String, Object>();
        // 투표ID
        String vote_seq = StringUtils.defaultString(req.getParameter("vote_seq"), "");
        param.put("vote_seq", vote_seq);

        // 투표정보
        HashMap<String, Object> voteInfo = voteService.getVoteInfo(param);
        if (voteInfo == null) {
            // 해당 투표정보가 없습니다. 확인후 다시 시도해주세요.
            String message = messages.getMessage("message.vote.007");
            RequestUtils.responseWriteException(req, res, message, VOTELISTPAGE);
            return null;
        }
        mav.addObject("voteInfo", voteInfo);

        // 결과 리스트
        List<HashMap<String, Object>> resultList = voteService.voteResultList(param);
        mav.addObject("resultList", resultList);

        SimpleDateFormat sdf = new SimpleDateFormat("yyyy.MM.dd");
        String nowDate = sdf.format(new Date());
        mav.addObject("nowDate", nowDate); // 오늘날짜
        mav.addObject("params", param); // 검색값
        logger.info("adminVoteResultList");

        return mav;
    }

    /**
     * 어드민 > 투표목록 > 투표결과 > 엑셀다운로드
     * 
     * @param req
     * @param res
     * @return
     */
    @RequestMapping(value = "/admin/vote/exceldownload")
    public ModelAndView adminVoteResultListExcel(HttpServletRequest req, HttpServletResponse res) {
        // start 리스트로 연결되는 페이지들 기본 설정
        ModelAndView mav = new ModelAndView();
        mav.setViewName("ExcelBuilder");
        // 투표ID
        String vote_seq = StringUtils.defaultString(req.getParameter("vote_seq"), "");
        // 구분
        String gubun = StringUtils.defaultString(req.getParameter("gubun"), "");

        // 투표정보
        HashMap<String, Object> param = new HashMap<String, Object>();
        param.put("vote_seq", vote_seq);
        param.put("choice_cnt", "yes");
        HashMap<String, Object> voteInfo = voteService.getVoteInfo(param);
        if (voteInfo == null) {
            // 해당 투표정보가 없습니다. 확인후 다시 시도해주세요.
            String message = messages.getMessage("message.vote.007");
            RequestUtils.responseWriteException(req, res, message, VOTELISTPAGE);
            return null;
        }
        mav.addObject("voteInfo", voteInfo);
        String fileName = StringUtils.defaultString((String) voteInfo.get("title"), ""); // 파일이름
        mav.addObject("fileName", fileName);
        mav.addObject("gubun", gubun);
        if (gubun.equals("voteResult")) { // 투표결과리스트
            List<HashMap<String, Object>> resultList = voteService.voteResultList(param);
            mav.addObject("resultList", resultList);
        } else if (gubun.equals("voterResult")) { // 투표자 결과리스트
            List<HashMap<String, Object>> resultList = voteService.voterResultList(param);
            mav.addObject("resultList", resultList);
        }
        logger.info("adminExcelList");
        return mav;

    }

    /**
     * 어드민 > 투표목록 > 투표등록폼
     * 
     * @param req
     * @param res
     * @return
     */
    @RequestMapping(value = "/admin/vote/vote_reg_form")
    public ModelAndView adminRegVoteForm(HttpServletRequest req, HttpServletResponse res) {
        ModelAndView mav = new ModelAndView();
        mav.setViewName(VOTEREGPAGE);
        // 관리자 정보
        AdminUser av = SessionUtil.getAdminSessionInfo(req);
        if (av == null) {
            // 로그인 후 이용하실수 있습니다.
            String message = messages.getMessage("message.common.noLogin.001");
            RequestUtils.responseWriteException(req, res, message, LOGINPAGE);
            return null;
        }
        mav.addObject("av", av);

        String vote_type = StringUtils.defaultString(req.getParameter("vote_type"), "ALL");
        mav.addObject("vote_type", vote_type);
        // 디폴트 날짜
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy.MM.dd");
        Calendar cal = Calendar.getInstance();//
        cal.setTime(new Date());
        cal.add(Calendar.DATE, +15); // 오늘 날짜를 기준 15일후
        String start_date = sdf.format(cal.getTime());
        cal.setTime(new Date());
        cal.add(Calendar.DATE, +30); // 오늘 날짜를 기준 15일후
        String end_date = sdf.format(cal.getTime());

        mav.addObject("start_date", start_date);
        mav.addObject("end_date", end_date);

        return mav;
    }

    /**
     * 어드민 > 투표목록 > 투표등록
     * 
     * @param req
     * @param res
     * @return
     */
    @RequestMapping(value = "/admin/vote/voteReg")
    public ModelAndView adminRegVote(HttpServletRequest req, HttpServletResponse res) {
        // start 리스트로 연결되는 페이지들 기본 설정
        ModelAndView mav = new ModelAndView();
        RedirectView redirectView = new RedirectView(); // redirect url 설정
        redirectView.setExposeModelAttributes(true);
        redirectView.setUrl(VOTEREGPAGE);

        AdminUser av = SessionUtil.getAdminSessionInfo(req);

        if (av == null) {
            // 로그인 후 이용하실수 있습니다.
            String message = messages.getMessage("message.common.noLogin.001");
            RequestUtils.responseWriteException(req, res, message, LOGINPAGE);
            return null;
        }
        // 사용자 ID
        String user_seq = String.valueOf(av.getMgrSeq());
        String title = StringUtils.defaultString(req.getParameter("title"), "");// 투표제목
        String biz_dp_type = StringUtils.defaultString(req.getParameter("biz_dp_type"), "LIST");// 출력형태(리스트,아이콘)
        String target_text = StringUtils.defaultString(req.getParameter("target_text"), "");// 투표대상자글씨
        String target = StringUtils.defaultString(req.getParameter("target"), "ALL");// 투표대상자(전체:ALL,성인ADULT,청소년:YOUNG)
        String vote_type = StringUtils.defaultString(req.getParameter("vote_type"), "ALL");// 투표방식(일괄:ALL,분야:PART)
        String result_dp_yn = StringUtils.defaultString(req.getParameter("result_dp_yn"), "N");// 현황출력(노출:Y,비노출:N)
        String vote_info = StringUtils.defaultString(req.getParameter("vote_info"), "");// 투표내용
        String vote_result = StringUtils.defaultString(req.getParameter("vote_result"), "");// 투표결과내용
        String start_date = StringUtils.defaultString(req.getParameter("start_date"), "");// 투표시작일
        if (start_date.equals("")) {
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy.MM.dd");
            Calendar cal = Calendar.getInstance();
            cal.setTime(new Date());
            cal.add(Calendar.DATE, +15);// 오늘 날짜를 기준 15일후
            start_date = sdf.format(cal.getTime());
        }
        String start_hour = StringUtils.defaultString(req.getParameter("start_hour"), "09");
        String end_date = StringUtils.defaultString(req.getParameter("end_date"), "");// 투표종료일
        if (end_date.equals("")) {
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy.MM.dd");
            Calendar cal = Calendar.getInstance();
            cal.setTime(new Date());
            cal.add(Calendar.DATE, +30);// 오늘 날짜를 기준 15일후
            end_date = sdf.format(cal.getTime());
        }
        String end_hour = StringUtils.defaultString(req.getParameter("end_hour"), "18");
        HashMap<String, Object> param = new HashMap<String, Object>();
        param.put("user_seq", user_seq);
        param.put("title", title);
        param.put("start_date", start_date + start_hour);
        param.put("end_date", end_date + end_hour);
        param.put("biz_dp_type", biz_dp_type);
        param.put("target_text", target_text);
        param.put("target", target);
        param.put("vote_type", vote_type);
        param.put("result_dp_yn", result_dp_yn);
        param.put("vote_info", vote_info);
        param.put("vote_result", vote_result);

        try {
            // 투표 정보저장
            HashMap<String, Object> VoteInfo = voteService.insertVoteMst(param);
            mav.addObject("vote_seq", VoteInfo.get("vote_seq"));
            redirectView.setUrl(VOTEREALMPAGE);
            // 얼럿메시지 등 스크립트 실행
            //            String script = "alert('" + messages.getMessage("message.admin.common.003", "투표") + "');";
            //            mav.addObject("script", script);
        } catch (Exception e) {
            e.printStackTrace();
            // 저장에 실패하였습니다. 확인 후 다시 시도하시거나 관리자에게 문의해주세요.
            String message = messages.getMessage("message.admin.vote.error.001");
            RequestUtils.responseWriteException(req, res, message, VOTELISTPAGE);
            return null;
        }
        mav.setView(redirectView);
        return mav;
    }

    /**
     * 어드민 > 투표목록 > 투표수정폼
     * 
     * @param req
     * @param res
     * @return
     */
    @RequestMapping(value = "/admin/vote/vote_mod_form")
    public ModelAndView adminModVoteForm(HttpServletRequest req, HttpServletResponse res) {
        ModelAndView mav = new ModelAndView();
        mav.setViewName(VOTEMODPAGE);
        // 관리자 정보
        AdminUser av = SessionUtil.getAdminSessionInfo(req);
        if (av == null) {
            // 로그인 후 이용하실수 있습니다.
            String message = messages.getMessage("message.common.noLogin.001");
            RequestUtils.responseWriteException(req, res, message, LOGINPAGE);
            return null;
        }
        mav.addObject("av", av);

        HashMap<String, Object> param = new HashMap<String, Object>();
        // 투표ID
        String vote_seq = StringUtils.defaultString(req.getParameter("vote_seq"), "");
        param.put("vote_seq", vote_seq);

        // 투표정보
        HashMap<String, Object> voteInfo = voteService.getVoteInfo(param);
        if (voteInfo == null) {
            // 해당 투표정보가 없습니다. 확인후 다시 시도해주세요.
            String message = messages.getMessage("message.vote.007");
            RequestUtils.responseWriteException(req, res, message, VOTELISTPAGE);
            return null;
        }
        mav.addObject("voteInfo", voteInfo);

        // 얼럿메시지 등 스크립트 실행
        //        String script = StringUtils.defaultString(req.getParameter("script"), "");
        //        mav.addObject("script", script);
        return mav;
    }

    /**
     * 어드민 > 투표목록 > 투표수정
     * 
     * @param req
     * @param res
     * @return
     */
    @RequestMapping(value = "/admin/vote/voteMod")
    public ModelAndView adminModVote(HttpServletRequest req, HttpServletResponse res) {
        // start 리스트로 연결되는 페이지들 기본 설정
        ModelAndView mav = new ModelAndView();
        RedirectView redirectView = new RedirectView(); // redirect url 설정
        redirectView.setUrl(VOTELISTPAGE);
        redirectView.setExposeModelAttributes(true);

        AdminUser av = SessionUtil.getAdminSessionInfo(req);
        if (av == null) {
            // 로그인 후 이용하실수 있습니다.
            String message = messages.getMessage("message.common.noLogin.001");
            RequestUtils.responseWriteException(req, res, message, LOGINPAGE);
            return null;
        }
        // 사용자 ID
        String user_seq = String.valueOf(av.getMgrSeq());
        // 투표ID
        String vote_seq = StringUtils.defaultString(req.getParameter("vote_seq"), "");
        if (vote_seq.equals("")) {
            // 해당 투표정보가 없습니다. 확인후 다시 시도해주세요.
            String message = messages.getMessage("message.vote.007");
            RequestUtils.responseWriteException(req, res, message, VOTELISTPAGE);
            return null;
        }


        String title = StringUtils.defaultString(req.getParameter("title"), "");// 투표제목
        String biz_dp_type = StringUtils.defaultString(req.getParameter("biz_dp_type"), "LIST");// 출력형태(리스트,아이콘)
        String target_text = StringUtils.defaultString(req.getParameter("target_text"), "");// 투표대상자
        String target = StringUtils.defaultString(req.getParameter("target"), "ALL");// 투표대상자(전체:ALL,성인ADULT,청소년:YOUNG)
        String vote_type = StringUtils.defaultString(req.getParameter("vote_type"), "ALL");// 투표방식(일괄:ALL,분야:PART)
        String result_dp_yn = StringUtils.defaultString(req.getParameter("result_dp_yn"), "N");// 현황출력(노출:Y,비노출:N)
        String vote_info = StringUtils.defaultString(req.getParameter("vote_info"), "");// 투표정보
        String vote_result = StringUtils.defaultString(req.getParameter("vote_result"), "");// 투표결과내용
        String start_date = StringUtils.defaultString(req.getParameter("start_date"), "");// 투표시작일
        if (start_date.equals("")) {
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy.MM.dd");
            Calendar cal = Calendar.getInstance();//
            cal.setTime(new Date());
            cal.add(Calendar.DATE, +15); // 오늘 날짜를 기준 15일후
            start_date = sdf.format(cal.getTime());
        }
        String start_hour = StringUtils.defaultString(req.getParameter("start_hour"), "09");
        String end_date = StringUtils.defaultString(req.getParameter("end_date"), ""); // 투표종료일
        if (end_date.equals("")) {
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy.MM.dd");
            Calendar cal = Calendar.getInstance();
            cal.setTime(new Date());
            cal.add(Calendar.DATE, +30); // 오늘 날짜를 기준 15일후
            end_date = sdf.format(cal.getTime());
        }
        String end_hour = StringUtils.defaultString(req.getParameter("end_hour"), "18");

        HashMap<String, Object> param = new HashMap<String, Object>();
        param.put("vote_seq", vote_seq);
        param.put("user_seq", user_seq);
        param.put("title", title);
        param.put("start_date", start_date + start_hour);
        param.put("end_date", end_date + end_hour);
        param.put("biz_dp_type", biz_dp_type);
        param.put("target_text", target_text);
        param.put("target", target);
        param.put("vote_type", vote_type);
        param.put("result_dp_yn", result_dp_yn);
        param.put("vote_info", vote_info);
        param.put("vote_result", vote_result);
        try {
            // 투표정보 업데이트
            voteService.updateVoteMst(param);
            // 얼럿메시지 등 스크립트 실행
            //            String script = "alert('" + messages.getMessage("message.admin.common.003", "투표") + "');";
            //            mav.addObject("script", script);
        } catch (Exception e) {
            e.printStackTrace();
            // 저장에 실패하였습니다. 확인 후 다시 시도하시거나 관리자에게 문의해주세요.
            //            String script = "alert('" + messages.getMessage("message.admin.vote.error.001") + "');";
            //            mav.addObject("script", script);
        }
        mav.addObject("vote_seq", vote_seq);
        mav.setView(redirectView);
        return mav;
    }

    /**
     * 어드민 > 투표목록 > 강제종료 or 삭제
     * 
     * @param req
     * @param res
     * @return
     */
    @RequestMapping(value = "/admin/vote/endVote")
    public ModelAndView adminEndVote(HttpServletRequest req, HttpServletResponse res) {
        ModelAndView mav = new ModelAndView();
        RedirectView redirectView = new RedirectView(); // redirect url 설정
        redirectView.setUrl(VOTELISTPAGE);
        redirectView.setExposeModelAttributes(true);
        HashMap<String, Object> param = new HashMap<String, Object>();
        AdminUser av = SessionUtil.getAdminSessionInfo(req);
        if (av == null) {
            // 로그인 후 이용하실수 있습니다.
            String message = messages.getMessage("message.common.noLogin.001");
            RequestUtils.responseWriteException(req, res, message, LOGINPAGE);
            return null;
        }
        // 사용자 ID
        String user_seq = String.valueOf(av.getMgrSeq());
        param.put("user_seq", user_seq);

        // 투표ID
        String vote_seq = StringUtils.defaultString(req.getParameter("vote_seq"), "");
        if (vote_seq.equals("")) {
            // 해당 투표정보가 없습니다. 확인후 다시 시도해주세요.
            String message = messages.getMessage("message.vote.007");
            RequestUtils.responseWriteException(req, res, message, VOTELISTPAGE);
            return null;
        }
        param.put("vote_seq", vote_seq);

        // 종료 상태 END: 강제종료, DEL:삭제
        String event_type = StringUtils.defaultString(req.getParameter("event_type"), "END");
        param.put("event_type", event_type);
        try {
            voteService.deleteVoteMst(param);
            // 얼럿메시지 등 스크립트 실행
            if (event_type.equals("DEL")) {
                //                String script = "alert('" + messages.getMessage("message.admin.common.004", "투표") + "');";
                //                mav.addObject("script", script);
            }
        } catch (Exception e) {
            e.printStackTrace();
            // 선택하신 정보 삭제에 실패하였습니다. 확인 후 다시 시도하시거나 관리자에게 문의해주세요.
            String message = messages.getMessage("message.admin.vote.error.002");
            RequestUtils.responseWriteException(req, res, message, VOTELISTPAGE);
            return null;
        }
        // 검색 상태(START,WAIT,END)
        String search_status = StringUtils.defaultString(req.getParameter("search_status"), "");
        mav.addObject("search_status", search_status);

        // 검색어
        String seach_string = StringUtils.defaultString(req.getParameter("seach_string"), "");
        mav.addObject("seach_string", seach_string);

        logger.info("adminEndVote");
        mav.setView(redirectView);
        return mav;
    }

    /**
     * 어드민 > 투표목록 > 분야 마스터
     * 
     * @param req
     * @param res
     * @return
     */
    @RequestMapping(value = "/admin/vote/realm_mst")
    public ModelAndView adminRealmMaster(HttpServletRequest req, HttpServletResponse res) {
        ModelAndView mav = new ModelAndView();
        mav.setViewName(REALMMSTPAGE);
        HashMap<String, Object> param = new HashMap<String, Object>();

        // 관리자 정보
        AdminUser av = SessionUtil.getAdminSessionInfo(req);
        if (av == null) {
            // 로그인 후 이용하실수 있습니다.
            String message = messages.getMessage("message.common.noLogin.001");
            RequestUtils.responseWriteException(req, res, message, LOGINPAGE);
            return null;
        }
        mav.addObject("av", av);

        List<HashMap<String, Object>> realmMastertList = voteService.realmMastertList(param);
        mav.addObject("realmMastertList", realmMastertList);

        // 얼럿메시지 등 스크립트 실행
        //        String script = StringUtils.defaultString(req.getParameter("script"), "");
        //        mav.addObject("script", script);
        logger.info("adminRealmMaster");
        return mav;
    }

    /**
     * 어드민 > 투표목록 > 분야 마스터 변경(저장, 수정, 삭제)
     * 
     * @param req
     * @param res
     * @return
     */
    @RequestMapping(value = "/admin/vote/setRealmMst")
    public ModelAndView adminSetRealmMaster(HttpServletRequest req, HttpServletResponse res) {
        ModelAndView mav = new ModelAndView();
        RedirectView redirectView = new RedirectView(); // redirect url 설정
        redirectView.setUrl(REALMMSTPAGE);
        redirectView.setExposeModelAttributes(true);

        AdminUser av = SessionUtil.getAdminSessionInfo(req);
        if (av == null) {
            // 로그인 후 이용하실수 있습니다.
            String message = messages.getMessage("message.common.noLogin.001");
            RequestUtils.responseWriteException(req, res, message, LOGINPAGE);
            return null;
        }
        // 사용자 ID
        String user_seq = String.valueOf(av.getMgrSeq());
        String realm_cd = StringUtils.defaultString(req.getParameter("realm_cd"), "");// 분야 코드
        String realm_nm = StringUtils.defaultString(req.getParameter("realm_nm"), "");// 이름
        String choice_cnt = StringUtils.defaultString(req.getParameter("choice_cnt"), "1");// 선택개수
        String youth_yn = StringUtils.defaultString(req.getParameter("youth_yn"), "N");// 청소년여부
        String adult_yn = StringUtils.defaultString(req.getParameter("adult_yn"), "N");// 성인여부
        String dp_target = StringUtils.defaultString(req.getParameter("dp_target"), "ALL");// 표시대상(ALL,ADULT,YOUNG)

        HashMap<String, Object> param = new HashMap<String, Object>();
        param.put("realm_cd", realm_cd);
        param.put("realm_nm", realm_nm);
        param.put("choice_cnt", choice_cnt);
        param.put("youth_yn", youth_yn);
        param.put("adult_yn", adult_yn);
        param.put("user_seq", user_seq);
        param.put("dp_target", dp_target);
        try {
            voteService.addRealmMaster(param);
            // 분야 순서 조정
            voteService.ChOrderRealmMaster(param);
            // 얼럿메시지 등 스크립트 실행
            //            String script = "alert('" + messages.getMessage("message.admin.common.003", "분야") + "');";
            //            mav.addObject("script", script);
        } catch (Exception e) {
            e.printStackTrace();
            // 입력하신 정보 저장에 실패하였습니다. 확인 후 다시 시도하시거나 관리자에게 문의해주세요.
            //            String script = "alert('" + messages.getMessage("message.admin.vote.error.001") + "');";
            //            mav.addObject("script", script);
            return null;
        }
        // 분야설정
        logger.info("adminSetRealmMaster");
        mav.setView(redirectView);
        return mav;
    }

    /**
     * 어드민 > 투표목록 > 분야 마스터삭제
     * 
     * @param req
     * @param res
     * @return
     */
    @RequestMapping(value = "/admin/vote/delRealmMst")
    public ModelAndView adminDelRealmMst(HttpServletRequest req, HttpServletResponse res) {
        ModelAndView mav = new ModelAndView();
        RedirectView redirectView = new RedirectView(); // redirect url 설정
        redirectView.setUrl(REALMMSTPAGE);
        redirectView.setExposeModelAttributes(true);
        mav.setView(redirectView);
        AdminUser av = SessionUtil.getAdminSessionInfo(req);
        if (av == null) {
            // 로그인 후 이용하실수 있습니다.
            String message = messages.getMessage("message.common.noLogin.001");
            RequestUtils.responseWriteException(req, res, message, LOGINPAGE);
            return null;
        }
        // 사용자 ID
        String user_seq = String.valueOf(av.getMgrSeq());
        // 투표ID

        String realm_cd = StringUtils.defaultString(req.getParameter("realm_cd"), "");// 분야코드
        HashMap<String, Object> param = new HashMap<String, Object>();

        param.put("realm_cd", realm_cd);
        param.put("user_seq", user_seq);
        try {
            voteService.deleteRealmMst(param);
            // 얼럿메시지 등 스크립트 실행
            //            String script = "alert('" + messages.getMessage("message.admin.common.004", "분야") + "');";
            //            mav.addObject("script", script);
            // 분야 순서 조정
            voteService.ChOrderRealmMaster(param);
        } catch (Exception e) {
            e.printStackTrace();
            // 선택하신 정보 삭제에 실패하였습니다. 확인 후 다시 시도하시거나 관리자에게 문의해주세요.
            //            String script = "alert('" + messages.getMessage("message.admin.vote.error.002") + "');";
            //            mav.addObject("script", script);
        }
        logger.info("adminSetVoteRealm");
        mav.setView(redirectView);
        return mav;
    }

    /**
     * 분야 정렬 순서변경
     * 
     * @param req
     * @param res
     * @return
     */
    @RequestMapping(value = "/admin/vote/chOrderRealmMst", method = RequestMethod.POST)
    public ModelAndView chOrderRealmMst(HttpServletRequest req, HttpServletResponse res) {
        ModelAndView mav = new ModelAndView();
        RedirectView redirectView = new RedirectView(); // redirect url 설정
        redirectView.setUrl(REALMMSTPAGE);
        redirectView.setExposeModelAttributes(true);

        AdminUser av = SessionUtil.getAdminSessionInfo(req);
        if (av == null) {
            // 로그인 후 이용하실수 있습니다.
            String message = messages.getMessage("message.common.noLogin.001");
            RequestUtils.responseWriteException(req, res, message, LOGINPAGE);
            return null;
        }
        String sort = StringUtils.defaultString(req.getParameter("sort"), "");

        String realm_cd = StringUtils.defaultString(req.getParameter("realm_cd"), "");// 분야코드
        HashMap<String, Object> param = new HashMap<String, Object>();
        param.put("realm_cd", realm_cd);
        double dp_ord = 0;
        if (sort.equals("firstup")) {
            // dp_ord값을 0.5로업데이트
            param.put("dp_ord", 0.5);
        } else if (sort.equals("up")) {
            dp_ord = Double.parseDouble(StringUtils.defaultString(req.getParameter("dp_ord"), "0"));// 분야코드
            // dp_ord값에 -1.5로업데이트
            param.put("dp_ord", dp_ord - 1.5);
        } else if (sort.equals("down")) {
            dp_ord = Double.parseDouble(StringUtils.defaultString(req.getParameter("dp_ord"), "0"));// 분야코드
            // dp_ord값에 +1.5로업데이트
            param.put("dp_ord", dp_ord + 1.5);
        } else if (sort.equals("lastdown")) {
            // dp_ord값에 +1.5로업데이트
            param.put("dp_ord", 100);
        }

        try {
            // 해당 분야 정렬순서 값 조정
            param.put("target", "One");
            voteService.ChOrderRealmMaster(param);
        } catch (Exception e) {
            logger.debug("분야 순서조정 오류" + e);
            // 선택하신 정보 삭제에 실패하였습니다. 확인 후 다시 시도하시거나 관리자에게 문의해주세요.
            //            String script = "alert('" + messages.getMessage("message.admin.vote.error.001") + "');";
            //            mav.addObject("script", script);
        }
        mav.setView(redirectView);
        return mav;
    }

    /**
     * 어드민 > 투표목록 > 분야 리스트
     * 
     * @param req
     * @param res
     * @return
     */
    @RequestMapping(value = "/admin/vote/vote_realm")
    public ModelAndView adminVoteRealmList(HttpServletRequest req, HttpServletResponse res) {
        ModelAndView mav = new ModelAndView();
        mav.setViewName(VOTEREALMPAGE);
        HashMap<String, Object> param = new HashMap<String, Object>();

        // 관리자 정보
        AdminUser av = SessionUtil.getAdminSessionInfo(req);
        if (av == null) {
            // 로그인 후 이용하실수 있습니다.
            String message = messages.getMessage("message.common.noLogin.001");
            RequestUtils.responseWriteException(req, res, message, LOGINPAGE);
            return null;
        }
        mav.addObject("av", av);

        // 투표ID
        String vote_seq = StringUtils.defaultString(req.getParameter("vote_seq"), "");
        if (vote_seq.equals("")) {
            // 해당 투표정보가 없습니다. 확인후 다시 시도해주세요.
            String message = messages.getMessage("message.vote.007");
            RequestUtils.responseWriteException(req, res, message, VOTELISTPAGE);
            return null;
        }
        param.put("vote_seq", vote_seq);

        // 투표정보
        HashMap<String, Object> voteInfo = voteService.getVoteInfo(param);
        mav.addObject("voteInfo", voteInfo);
        // 분야 리스트
        List<HashMap<String, Object>> voteRealmList = voteService.voteRealmList(param);
        mav.addObject("voteRealmList", voteRealmList);
        // 얼럿메시지 등 스크립트 실행
        //        String script = StringUtils.defaultString(req.getParameter("script"), "");
        //        mav.addObject("script", script);
        logger.info("adminVoteRealmList");
        return mav;
    }

    /**
     * 어드민 > 투표목록 > 분야 설정(등록, 수정)
     * 
     * @param req
     * @param res
     * @return
     */
    @RequestMapping(value = "/admin/vote/setVoteRealm")
    public ModelAndView adminSetVoteRealm(HttpServletRequest req, HttpServletResponse res) {
        ModelAndView mav = new ModelAndView();
        RedirectView redirectView = new RedirectView(); // redirect url 설정
        redirectView.setUrl(VOTEREALMPAGE);
        redirectView.setExposeModelAttributes(true);

        AdminUser av = SessionUtil.getAdminSessionInfo(req);
        if (av == null) {
            // 로그인 후 이용하실수 있습니다.
            String message = messages.getMessage("message.common.noLogin.001");
            RequestUtils.responseWriteException(req, res, message, LOGINPAGE);
            return null;
        }
        // 사용자 ID
        String user_seq = String.valueOf(av.getMgrSeq());
        // 투표ID
        String vote_seq = StringUtils.defaultString(req.getParameter("vote_seq"), "");
        if (vote_seq.equals("")) {
            // 해당 투표정보가 없습니다. 확인후 다시 시도해주세요.
            String message = messages.getMessage("message.vote.007");
            RequestUtils.responseWriteException(req, res, message, VOTELISTPAGE);
            return null;
        }

        String realm_cd = StringUtils.defaultString(req.getParameter("realm_cd"), "");// 분야코드
        String realm_nm = StringUtils.defaultString(req.getParameter("realm_nm"), "");// 분야명
        String choice_cnt = StringUtils.defaultString(req.getParameter("choice_cnt"), "0");// 선택개수
        String use_yn = StringUtils.defaultString(req.getParameter("use_yn"), "N");// 사용여부
        String youth_yn = StringUtils.defaultString(req.getParameter("youth_yn"), "N");// 청소년여부
        String adult_yn = StringUtils.defaultString(req.getParameter("adult_yn"), "N");// 성인여부
        String dp_target = StringUtils.defaultString(req.getParameter("dp_target"), "ALL");// 표시대상(ALL,ADULT,YOUNG)

        HashMap<String, Object> param = new HashMap<String, Object>();
        param.put("vote_seq", vote_seq);
        param.put("realm_cd", realm_cd);
        param.put("realm_nm", realm_nm);
        param.put("choice_cnt", choice_cnt);
        param.put("use_yn", use_yn);
        param.put("youth_yn", youth_yn);
        param.put("adult_yn", adult_yn);
        param.put("user_seq", user_seq);
        param.put("dp_target", dp_target);
        try {
            voteService.addVoteRealm(param);
            // 분야 순서 조정
            voteService.chOrderVoteRealm(param);
            // 얼럿메시지 등 스크립트 실행
            //            String script = "alert('" + messages.getMessage("message.admin.common.003", "분야") + "');";
            //            mav.addObject("script", script);
        } catch (Exception e) {
            e.printStackTrace();
            // 선택하신 정보 삭제에 실패하였습니다. 확인 후 다시 시도하시거나 관리자에게 문의해주세요.
            //            String script = "alert('" + messages.getMessage("message.admin.vote.error.001") + "');";
            //            mav.addObject("script", script);
        }
        mav.addObject("vote_seq", vote_seq);
        // 분야설정
        logger.info("adminSetVoteRealm");
        mav.setView(redirectView);
        return mav;
    }

    /**
     * 어드민 > 투표목록 > 분야 삭제
     * 
     * @param req
     * @param res
     * @return
     */
    @RequestMapping(value = "/admin/vote/delVoteRealm")
    public ModelAndView adminDelVoteRealm(HttpServletRequest req, HttpServletResponse res) {
        ModelAndView mav = new ModelAndView();
        RedirectView redirectView = new RedirectView(); // redirect url 설정
        redirectView.setUrl(VOTEREALMPAGE);
        redirectView.setExposeModelAttributes(true);

        AdminUser av = SessionUtil.getAdminSessionInfo(req);
        if (av == null) {
            // 로그인 후 이용하실수 있습니다.
            String message = messages.getMessage("message.common.noLogin.001");
            RequestUtils.responseWriteException(req, res, message, LOGINPAGE);
            return null;
        }

        // 투표ID
        String vote_seq = StringUtils.defaultString(req.getParameter("vote_seq"), "");
        if (vote_seq.equals("")) {
            // 해당 투표정보가 없습니다. 확인후 다시 시도해주세요.
            String message = messages.getMessage("message.vote.007");
            RequestUtils.responseWriteException(req, res, message, VOTELISTPAGE);
            return null;
        }

        String realm_cd = StringUtils.defaultString(req.getParameter("realm_cd"), "");// 분야코드

        HashMap<String, Object> param = new HashMap<String, Object>();
        param.put("vote_seq", vote_seq);
        param.put("realm_cd", realm_cd);
        try {
            voteService.deleteVoteRealm(param);
            // 분야 순서 조정
            voteService.chOrderVoteRealm(param);
            //            String script = "alert('" + messages.getMessage("message.admin.common.004", "분야") + "');";
            //            mav.addObject("script", script);
        } catch (Exception e) {
            e.printStackTrace();
            // 선택하신 정보 삭제에 실패하였습니다. 확인 후 다시 시도하시거나 관리자에게 문의해주세요.
            //            String script = "alert('" + messages.getMessage("message.admin.vote.error.002") + "');";
            //            mav.addObject("script", script);
        }
        // 분야설정
        logger.info("delVoteRealm");
        mav.addObject("vote_seq", vote_seq);

        mav.setView(redirectView);
        return mav;
    }

    /**
     * 분야 정렬 순서변경
     * 
     * @param req
     * @param res
     * @return
     */
    @RequestMapping(value = "/admin/vote/chOrderVoteRealm", method = RequestMethod.POST)
    public ModelAndView chOrderVoteRealm(HttpServletRequest req, HttpServletResponse res) {
        ModelAndView mav = new ModelAndView();
        RedirectView redirectView = new RedirectView(); // redirect url 설정
        redirectView.setUrl(VOTEREALMPAGE);
        redirectView.setExposeModelAttributes(true);

        String sort = StringUtils.defaultString(req.getParameter("sort"), "");
        String vote_seq = StringUtils.defaultString(req.getParameter("vote_seq"), "");
        String realm_cd = StringUtils.defaultString(req.getParameter("realm_cd"), "");// 분야코드

        HashMap<String, Object> param = new HashMap<String, Object>();
        param.put("vote_seq", vote_seq);
        param.put("realm_cd", realm_cd);

        double dp_ord = 0;
        if (sort.equals("firstup")) {
            // dp_ord값을 0.5로업데이트
            param.put("dp_ord", 0.5);
        } else if (sort.equals("up")) {
            dp_ord = Double.parseDouble(StringUtils.defaultString(req.getParameter("dp_ord"), "0"));// 분야코드
            // dp_ord값에 -1.5로업데이트
            param.put("dp_ord", dp_ord - 1.5);
        } else if (sort.equals("down")) {
            dp_ord = Double.parseDouble(StringUtils.defaultString(req.getParameter("dp_ord"), "0"));// 분야코드
            // dp_ord값에 +1.5로업데이트
            param.put("dp_ord", dp_ord + 1.5);
        } else if (sort.equals("lastdown")) {
            // dp_ord값에 +1.5로업데이트
            param.put("dp_ord", 100);
        }

        try {
            // 해당 분야 정렬순서 값 조정
            param.put("target", "One");
            voteService.chOrderVoteRealm(param);
        } catch (Exception e) {
            logger.debug("분야 순서조정 오류" + e);
            // 순서조정에 실패하였습니다.
            //            String script = "alert('" + messages.getMessage("message.admin.vote.error.003") + "');";
            //            mav.addObject("script", script);
        }

        mav.addObject("vote_seq", vote_seq);
        mav.setView(redirectView);
        return mav;
    }

    /**
     * 어드민 > 투표 사업 관리 > 투표사업 목록
     * 
     * @param req
     * @param res
     * @return
     */
    @RequestMapping(value = "/admin/vote/vote_item_list")
    public ModelAndView adminVoteItemList(HttpServletRequest req, HttpServletResponse res) {
        // start 리스트로 연결되는 페이지들 기본 설정
        ModelAndView mav = new ModelAndView();
        mav.setViewName(VOTEITEMLISTPAGE);

        HashMap<String, Object> param = new HashMap<String, Object>();

        // 관리자 정보
        AdminUser av = SessionUtil.getAdminSessionInfo(req);
        if (av == null) {
            // 로그인 후 이용하실수 있습니다.
            String message = messages.getMessage("message.common.noLogin.001");
            RequestUtils.responseWriteException(req, res, message, LOGINPAGE);
            return null;
        }
        mav.addObject("av", av);

        // 투표ID
        String vote_seq = StringUtils.defaultString(req.getParameter("vote_seq"), "");
        if (vote_seq.equals("")) {
            // 해당 투표정보가 없습니다. 확인후 다시 시도해주세요.
            String message = messages.getMessage("message.vote.007");
            RequestUtils.responseWriteException(req, res, message, VOTELISTPAGE);
            return null;
        }
        param.put("vote_seq", vote_seq);

        // 투표정보
        HashMap<String, Object> voteInfo = voteService.getVoteInfo(param);
        mav.addObject("voteInfo", voteInfo);

        param.put("chOrd", "yes"); // 사용 yes인것만.. 분야 리스트 가져오기 위해 사용하는값
        // 분야 리스트
        List<HashMap<String, Object>> voteRealmList = voteService.voteRealmList(param);
        mav.addObject("voteRealmList", voteRealmList); // 분야 리스트

        String search_realm_cd = StringUtils.defaultString(req.getParameter("search_realm_cd"), "");
        param.put("search_realm_cd", search_realm_cd);

        String seach_string = StringUtils.defaultString(req.getParameter("seach_string"), "");
        param.put("seach_string", seach_string);

        // 투표사업리스트
        List<HashMap<String, Object>> voteItemList = voteService.VoteItemWithRealmList(param);
        mav.addObject("voteItemList", voteItemList); // 투표 리스트
        mav.addObject("totalRecord", voteItemList.size());
        mav.addObject("params", param); // 검색값

        // 얼럿메시지 등 스크립트 실행
        //        String script = StringUtils.defaultString(req.getParameter("script"), "");
        //        mav.addObject("script", script);

        logger.info("adminVoteItemList");
        return mav;
    }

    /**
     * 어드민 > 투표 사업 관리 > 투표사업 등록폼
     * 
     * @param req
     * @param res
     * @return
     */
    @RequestMapping(value = "/admin/vote/vote_item_reg_form")
    public ModelAndView adminRegVoteItemForm(HttpServletRequest req, HttpServletResponse res) {
        ModelAndView mav = new ModelAndView();
        mav.setViewName(VOTEITEMREGPAGE);

        // 관리자 정보
        AdminUser av = SessionUtil.getAdminSessionInfo(req);
        if (av == null) {
            // 로그인 후 이용하실수 있습니다.
            String message = messages.getMessage("message.common.noLogin.001");
            RequestUtils.responseWriteException(req, res, message, LOGINPAGE);
            return null;
        }
        mav.addObject("av", av);

        // 동 리스트
        List<Address> dongList = addressService.selectEmdList(av.getRegionCd());
        mav.addObject("dongList", dongList);

        HashMap<String, Object> param = new HashMap<String, Object>();
        // 투표ID
        String vote_seq = StringUtils.defaultString(req.getParameter("vote_seq"), "");
        if (vote_seq.equals("")) {
            // 해당 투표정보가 없습니다. 확인후 다시 시도해주세요.
            String message = messages.getMessage("message.vote.007");
            RequestUtils.responseWriteException(req, res, message, VOTELISTPAGE);
            return null;
        }
        param.put("vote_seq", vote_seq);

        // 투표정보
        HashMap<String, Object> voteInfo = voteService.getVoteInfo(param);
        mav.addObject("voteInfo", voteInfo);

        param.put("chOrd", "yes"); // 사용 yes인것만.. 분야 리스트 가져오기 위해 사용하는값

        // 분야 리스트
        List<HashMap<String, Object>> voteRealmList = voteService.voteRealmList(param);
        mav.addObject("voteRealmList", voteRealmList); // 분야리스트

        mav.addObject("params", param);
        mav.addObject("voteRealmList", voteRealmList); // 분야리스트
        mav.addObject("dongList", dongList); // 동 리스트
        return mav;
    }

    /**
     * 어드민 > 투표 사업 관리 > 투표사업 등록
     * 
     * @param req
     * @param res
     * @param filereq
     * @return
     */
    @RequestMapping(value = "/admin/vote/voteItemReg")
    public ModelAndView adminRegVoteItem(HttpServletRequest req, HttpServletResponse res, MultipartHttpServletRequest filereq) {
        // start 리스트로 연결되는 페이지들 기본 설정
        ModelAndView mav = new ModelAndView();
        RedirectView redirectView = new RedirectView(); // redirect url 설정
        redirectView.setUrl(VOTEITEMLISTPAGE);
        redirectView.setExposeModelAttributes(true);

        // 관리자 정보
        AdminUser av = SessionUtil.getAdminSessionInfo(req);
        if (av == null) {
            // 로그인 후 이용하실수 있습니다.
            String message = messages.getMessage("message.common.noLogin.001");
            RequestUtils.responseWriteException(req, res, message, LOGINPAGE);
            return null;
        }

        String user_seq = String.valueOf(av.getMgrSeq());// 사용자ID
        String effect = StringUtils.defaultString(req.getParameter("effect"), "");// 기대효과
        String biz_cont = StringUtils.defaultString(req.getParameter("biz_cont"), "");// 사업내용
        String necessity = StringUtils.defaultString(req.getParameter("necessity"), "");// 필요성
        String location = StringUtils.defaultString(req.getParameter("location"), "");// 위치
        String budget = StringUtils.defaultString(req.getParameter("budget"), "");// 소요예산
        String biz_nm = StringUtils.defaultString(req.getParameter("biz_nm"), "");// 사업명
        String realm_cd = StringUtils.defaultString(req.getParameter("realm_cd"), "");// 분야코드
        String vote_seq = StringUtils.defaultString(req.getParameter("vote_seq"), "");// 투표일련번호

        String start_date = StringUtils.defaultString(req.getParameter("start_date"), "");// 사업기간시작일
        if (start_date.equals("")) {
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy.MM.dd");
            Calendar cal = Calendar.getInstance();
            cal.setTime(new Date());
            cal.add(Calendar.YEAR, +1);// 오늘 날짜를 1년 후
            start_date = sdf.format(cal.getTime());
        }

        String end_date = StringUtils.defaultString(req.getParameter("end_date"), "");// 사업기간종료일
        if (end_date.equals("")) {
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy.MM.dd");
            Calendar cal = Calendar.getInstance();
            cal.setTime(new Date());
            cal.add(Calendar.YEAR, +2);// 오늘 날짜를 기준 2년후
            end_date = sdf.format(cal.getTime());
        }
        HashMap<String, Object> param = new HashMap<String, Object>();
        param.put("user_seq", user_seq);
        param.put("effect", effect);
        param.put("biz_cont", biz_cont);
        param.put("necessity", necessity);
        param.put("location", location);
        param.put("budget", budget);
        param.put("biz_nm", biz_nm);
        param.put("end_date", end_date);
        param.put("start_date", start_date);
        param.put("realm_cd", realm_cd);
        param.put("vote_seq", vote_seq);

        try {
            // 정보저장
            Map<?, MultipartFile> fileMap = filereq.getFileMap();
            MultipartFile attach_file = fileMap.get("attach_file"); // 첨부파일
            MultipartFile image_file = fileMap.get("image_file"); // 이미지파일

            // 파일저장
            HashMap<String, Object> VoteItemInfo = voteService.saveVoteItem(param, image_file, attach_file);
            mav.addObject("vote_seq", vote_seq);
            mav.addObject("biz_seq", StringUtils.defaultString(VoteItemInfo.get("biz_seq") + "", ""));

            // 얼럿메시지 등 스크립트 실행
            //            String script = "alert('" + messages.getMessage("message.admin.common.003", "사업") + "');";
            //            mav.addObject("script", script);
        } catch (Exception e) {
            e.printStackTrace();
            // 저장에 실패하였습니다. 확인 후 다시 시도하시거나 관리자에게 문의해주세요.
            String message = messages.getMessage("message.admin.vote.error.001");
            RequestUtils.responseWriteException(req, res, message, VOTEITEMLISTPAGE + "?vote_seq=" + vote_seq);
            return null;
        }
        mav.setView(redirectView);
        return mav;
    }

    /**
     * 어드민 > 투표 사업 관리 > 투표사업 수정폼
     * 
     * @param req
     * @param res
     * @return
     */
    @RequestMapping(value = "/admin/vote/vote_item_mod_form")
    public ModelAndView adminModVoteItemForm(HttpServletRequest req, HttpServletResponse res) {
        ModelAndView mav = new ModelAndView();
        mav.setViewName(VOTEITEMMODPAGE);
        HashMap<String, Object> param = new HashMap<String, Object>();

        // 관리자 정보
        AdminUser av = SessionUtil.getAdminSessionInfo(req);
        if (av == null) {
            // 로그인 후 이용하실수 있습니다.
            String message = messages.getMessage("message.common.noLogin.001");
            RequestUtils.responseWriteException(req, res, message, LOGINPAGE);
            return null;
        }
        mav.addObject("av", av);

        // 투표ID
        String vote_seq = StringUtils.defaultString(req.getParameter("vote_seq"), "");
        if (vote_seq.equals("")) {
            // 해당 투표정보가 없습니다. 확인후 다시 시도해주세요.
            String message = messages.getMessage("message.vote.007");
            RequestUtils.responseWriteException(req, res, message, VOTELISTPAGE);
            return null;
        }
        param.put("vote_seq", vote_seq);

        // 투표정보
        HashMap<String, Object> voteInfo = voteService.getVoteInfo(param);
        mav.addObject("voteInfo", voteInfo);

        // 동 리스트
        List<Address> dongList = addressService.selectEmdList(av.getRegionCd());
        mav.addObject("dongList", dongList);

        param.put("chOrd", "yes"); // 사용 yes인것만.. 분야 리스트 가져오기 위해 사용하는값

        // 분야 리스트
        List<HashMap<String, Object>> voteRealmList = voteService.voteRealmList(param);
        mav.addObject("voteRealmList", voteRealmList); // 분야리스트

        String biz_seq = StringUtils.defaultString(req.getParameter("biz_seq"), "");// 사업제안일련번호
        param.put("biz_seq", biz_seq);
        param.put("result_dp_yn", "N");

        // 투표사업정보
        HashMap<String, Object> VoteItemInfo = voteService.getVoteItem(param);
        if (VoteItemInfo == null) {
            // 해당 사업정보가 없습니다. 확인후 다시 시도해주세요.
            String message = messages.getMessage("message.vote.008");
            RequestUtils.responseWriteException(req, res, message, VOTEITEMLISTPAGE + "?vote_seq=" + vote_seq);
            return null;
        }
        mav.addObject("VoteItemInfo", VoteItemInfo);
        // 파일 리스트
        List<FileInfo> image_file = fileService.selectFileInfoList(Long.parseLong(biz_seq), FileGrpType.VOTE, FileType.IMAGE);
        List<FileInfo> attach_file = fileService.selectFileInfoList(Long.parseLong(biz_seq), FileGrpType.VOTE, FileType.ATTACH);
        mav.addObject("image_file", image_file);
        mav.addObject("attach_file", attach_file);

        mav.addObject("params", param);
        // 얼럿메시지 등 스크립트 실행
        //        String script = StringUtils.defaultString(req.getParameter("script"), "");
        //        mav.addObject("script", script);
        return mav;
    }

    /**
     * 어드민 > 투표 사업 관리 > 투표사업 수정
     * 
     * @param req
     * @param res
     * @param filereq
     * @return
     */
    @RequestMapping(value = "/admin/vote/voteItemMod")
    public ModelAndView adminModVoteItem(HttpServletRequest req, HttpServletResponse res, MultipartHttpServletRequest filereq) {
        // start 리스트로 연결되는 페이지들 기본 설정
        ModelAndView mav = new ModelAndView();
        RedirectView redirectView = new RedirectView(); // redirect url 설정
        redirectView.setUrl(VOTEITEMLISTPAGE);
        redirectView.setExposeModelAttributes(true);

        AdminUser av = SessionUtil.getAdminSessionInfo(req);
        if (av == null) {
            // 로그인 후 이용하실수 있습니다.
            String message = messages.getMessage("message.common.noLogin.001");
            RequestUtils.responseWriteException(req, res, message, LOGINPAGE);
            return null;
        }
        HashMap<String, Object> param = new HashMap<String, Object>();

        // 사용자 ID
        String user_seq = String.valueOf(av.getMgrSeq());
        String biz_seq = StringUtils.defaultString(req.getParameter("biz_seq"), "");// 사업제안일련번호
        String effect = StringUtils.defaultString(req.getParameter("effect"), "");// 기대효과
        String biz_cont = StringUtils.defaultString(req.getParameter("biz_cont"), "");// 사업내용
        String necessity = StringUtils.defaultString(req.getParameter("necessity"), "");// 필요성
        String location = StringUtils.defaultString(req.getParameter("location"), "");// 위치
        String budget = StringUtils.defaultString(req.getParameter("budget"), "");// 소요예산
        String biz_nm = StringUtils.defaultString(req.getParameter("biz_nm"), "");// 사업명
        String realm_cd = StringUtils.defaultString(req.getParameter("realm_cd"), "");// 분야코드
        String vote_seq = StringUtils.defaultString(req.getParameter("vote_seq"), "");// 투표일련번호

        String start_date = StringUtils.defaultString(req.getParameter("start_date"), "");// 사업기간시작일
        if (start_date.equals("")) {
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy.MM.dd");
            Calendar cal = Calendar.getInstance();
            cal.setTime(new Date());
            cal.add(Calendar.YEAR, +1);// 오늘 날짜를 1년 후
            start_date = sdf.format(cal.getTime());
        }

        String end_date = StringUtils.defaultString(req.getParameter("end_date"), "");// 사업기간종료일
        if (end_date.equals("")) {
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy.MM.dd");
            Calendar cal = Calendar.getInstance();
            cal.setTime(new Date());
            cal.add(Calendar.YEAR, +2);// 오늘 날짜를 기준 2년후
            end_date = sdf.format(cal.getTime());
        }
        param.put("user_seq", user_seq);
        param.put("biz_seq", biz_seq);
        param.put("effect", effect);
        param.put("biz_cont", biz_cont);
        param.put("necessity", necessity);
        param.put("location", location);
        param.put("budget", budget);
        param.put("biz_nm", biz_nm);
        param.put("realm_cd", realm_cd);
        param.put("vote_seq", vote_seq);
        param.put("start_date", start_date);
        param.put("end_date", end_date);

        try {
            // 투표 정보저장
            Map<?, MultipartFile> fileMap = filereq.getFileMap();
            MultipartFile attach_file = fileMap.get("attach_file"); // 첨부파일
            MultipartFile image_file = fileMap.get("image_file"); // 이미지파일
            voteService.updateVoteItem(param, image_file, attach_file);

            // 얼럿메시지 등 스크립트 실행
            //            String script = "alert('" + messages.getMessage("message.admin.common.003", "사업") + "');";
            //            mav.addObject("script", script);

        } catch (Exception e) {
            e.printStackTrace();
            // 저장에 실패하였습니다. 확인 후 다시 시도하시거나 관리자에게 문의해주세요.
            String message = messages.getMessage("message.admin.vote.error.001");
            RequestUtils.responseWriteException(req, res, message, VOTEITEMLISTPAGE + "?vote_seq=" + vote_seq);
            return null;
        }
        mav.addObject("biz_seq", biz_seq);
        mav.addObject("vote_seq", vote_seq);
        mav.setView(redirectView);
        return mav;
    }

    /**
     * 어드민 > 투표 사업 관리 > 투표사업 삭제
     * 
     * @param req
     * @param res
     * @return
     */
    @RequestMapping(value = "/admin/vote/delVoteItem")
    public ModelAndView adminDelVoteItem(HttpServletRequest req, HttpServletResponse res) {
        ModelAndView mav = new ModelAndView();
        RedirectView redirectView = new RedirectView(); // redirect url 설정
        redirectView.setUrl(VOTEITEMLISTPAGE);
        redirectView.setExposeModelAttributes(true);
        HashMap<String, Object> param = new HashMap<String, Object>();
        // 투표ID
        String biz_seq = StringUtils.defaultString(req.getParameter("biz_seq"), "");// 사업제안일련번호
        String vote_seq = StringUtils.defaultString(req.getParameter("vote_seq"), "");// 투표아이디
        if (biz_seq.equals("")) {
            // 해당 사업정보가 없습니다. 확인후 다시 시도해주세요.
            String message = messages.getMessage("message.vote.008");
            RequestUtils.responseWriteException(req, res, message, VOTEITEMLISTPAGE + "?vote_seq=" + vote_seq);
            return null;
        }
        param.put("biz_seq", biz_seq);
        param.put("vote_seq", vote_seq);

        try {
            // 사업 삭제
            voteService.deleteVoteItem(param);

            // 빈 연번 없이 순서 조정
            voteService.ChOrderVoteItem(param);
            // 얼럿메시지 등 스크립트 실행
            //            String script = "alert('" + messages.getMessage("message.admin.common.004", "사업") + "');";
            //            mav.addObject("script", script);

        } catch (Exception e) {
            e.printStackTrace();
            // 삭제에 실패하였습니다. 확인 후 다시 시도하시거나 관리자에게 문의해주세요.
            String message = messages.getMessage("message.admin.vote.error.002");
            RequestUtils.responseWriteException(req, res, message, VOTEITEMLISTPAGE + "?vote_seq=" + vote_seq);
            return null;
        }
        logger.info("adminDelVoteItem");

        mav.addObject("vote_seq", vote_seq);
        // 검색분야
        String search_realm_cd = StringUtils.defaultString(req.getParameter("search_realm_cd"), "");
        mav.addObject("search_realm_cd", search_realm_cd);

        // 검색어
        String seach_string = StringUtils.defaultString(req.getParameter("seach_string"), "");
        mav.addObject("seach_string", seach_string);
        mav.setView(redirectView);
        return mav;
    }

    /**
     * 파일 삭제
     * 
     * @param request
     * @param delFileSeq
     * @return
     */
    @RequestMapping(value = "/admin/vote/file-delete/{delFileSeq}")
    @ResponseBody
    public boolean adminVoteFileDelete(HttpServletRequest request, @PathVariable(value = "delFileSeq") long delFileSeq) {
        boolean re = true;
        try {
            fileService.deleteFileInfo(delFileSeq);
        } catch (Exception e) {
            re = false;
        }
        return re;
    }

    /**
     * 투표 아이템 순서 조정
     * 
     * @param json
     * @return
     */
    @RequestMapping(value = "/admin/vote/modify-vote-order")
    @ResponseBody
    public boolean modifyVoteItemOrder(@RequestBody String json) {

        JSONArray items = new JSONArray(json);

        List<Object> list = JsonUtil.toList(items);
        if (list != null && !list.isEmpty()) {
            voteService.updateVoteOrder(list);
        }

        return true;
    }

    /**
     * 투표 순서 조정
     * 
     * @param json
     * @return
     */
    @RequestMapping(value = "/admin/vote/modify-vote-master-order")
    @ResponseBody
    public boolean modifyVoteMstOrder(@RequestBody String json) {

        JSONArray items = new JSONArray(json);

        List<Object> list = JsonUtil.toList(items);
        if (list != null && !list.isEmpty()) {
            voteService.updateVoteMstOrder(list);
        }

        return true;
    }

    @RequestMapping(value = "/admin/vote/item/excel-upload", method = RequestMethod.POST)
    public String excelUpload(RedirectAttributes redirectAttributes, @RequestParam(value = "vote_seq") String vote_seq, @RequestParam(value = "excelFile") MultipartFile excelFile) {

        FileInfo fileInfo = fileUploadUtil.getSavedFileInfo(excelFile, FileGrpType.TEMP, FileType.ATTACH);
        if (fileInfo != null) {
            String filePath = fileInfo.getFilePath() + "/" + fileInfo.getFileNm();
            List<String[]> excelData = ExcelUploadUtil.getExcelData(filePath, fileInfo.getFileSrcNm());

            logger.debug("### vote_seq [{}]", vote_seq);
            logger.debug("### excelData [{}]", excelData);

            voteService.insertExcelData(excelData, vote_seq);
        }

        //        ModelAndView mav = new ModelAndView();
        //        //        mav.addObject("notice", notice.getCurrNotice());
        //        //        mav.addObject("codeList", codeList);
        //        mav.addObject("vote_seq", vote_seq);
        //        mav.setViewName("/admin/vote/vote_item_list");

        redirectAttributes.addAttribute("vote_seq", vote_seq);
        return "redirect:/admin/vote/vote_item_list";


    }

}
