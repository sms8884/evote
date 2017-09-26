package com.jaha.evote.controller.admin;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.io.FilenameUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.view.RedirectView;

import com.jaha.evote.common.exception.EvoteBizException;
import com.jaha.evote.common.util.FileUploadUtil;
import com.jaha.evote.common.util.Messages;
import com.jaha.evote.common.util.PagingHelper;
import com.jaha.evote.common.util.RequestUtils;
import com.jaha.evote.common.util.SessionUtil;
import com.jaha.evote.common.util.StringUtils;
import com.jaha.evote.controller.common.BaseController;
import com.jaha.evote.domain.AdminUser;
import com.jaha.evote.domain.PropComment;
import com.jaha.evote.domain.Proposal;
import com.jaha.evote.domain.ProposalAudit;
import com.jaha.evote.domain.Pssrp;
import com.jaha.evote.domain.common.FileInfo;
import com.jaha.evote.domain.type.CodeType;
import com.jaha.evote.domain.type.FileGrpType;
import com.jaha.evote.domain.type.FileType;
import com.jaha.evote.service.CodeService;
import com.jaha.evote.service.FileService;
import com.jaha.evote.service.MemberService;
import com.jaha.evote.service.ProposalService;

/**
 * <pre>
 * Class Name : AdminProposalController.java
 * Description : Description
 *  
 * Modification Information
 * 
 * Mod Date         Modifier    Description
 * -----------      --------    ---------------------------
 * 2016. 7. 15.     shavrani      Generation
 * </pre>
 *
 * @author shavrani
 * @since 2016. 7. 15.
 * @version 1.0
 */
@Controller
public class AdminProposalController extends BaseController {

    private final Logger logger = LoggerFactory.getLogger(this.getClass());

    @Inject
    private ProposalService proposalService;
    @Inject
    private CodeService codeService;
    @Inject
    private FileService fileService;
    @Inject
    private MemberService memberService;
    @Inject
    private Messages messages;
    @Inject
    private FileUploadUtil fileUploadUtil;

    @Value("${common.paging.default.row}")
    private String pagingDefaultRow;

    @Value("${common.paging.default.col}")
    private String pagingDefaultCol;


    private static final String LOGINPAGE = "/admin/login";

    private static final String PROPOSALLISTPAGE = "/admin/proposal/proposal_list";
    private static final String PROPOSALREVIEWLIST = "/admin/proposal/proposal_review_list";
    private static final String PROPOSALDETAIL = "/admin/proposal/proposal_detail";

    private static final String CONTESTLISTPAGE = "/admin/proposal/contest_list";
    private static final String CONTESTPROPOSALLIST = "/admin/proposal/contest_proposal_list";
    private static final String CONTESTWRITEFORM = "/admin/proposal/contest_write_form";

    /**
     * 정책제안 리스트
     * 
     * @param request
     * @param response
     * @param params
     * @return
     */
    @RequestMapping(value = "/admin/proposal/proposal_list")
    public ModelAndView proposalList(HttpServletRequest req, HttpServletResponse res, @RequestParam Map<String, Object> params, PagingHelper pagingHelper) {

        ModelAndView mav = new ModelAndView(PROPOSALLISTPAGE);

        AdminUser av = SessionUtil.getAdminSessionInfo(req);
        if (av == null) {
            // 로그인 후 이용하실수 있습니다.
            String message = messages.getMessage("message.common.noLogin.001");
            RequestUtils.responseWriteException(req, res, message, LOGINPAGE);
            return null;
        }
        mav.addObject("av", av); // 로그인 정보
        params.put("deleteYn", "N"); // 삭제 안한 리스트만 보여줌

        /** paging setting */
        pagingHelper.setTotalCnt(proposalService.selectProposalListCount(params)); // 리스트 총 갯수
                                                                                  // 넘겨줌
        params.put("startNum", pagingHelper.getStartRow() - 1);
        params.put("endNum", pagingHelper.getPagingRow());
        mav.addObject("pagingHelper", pagingHelper);


        List<Proposal> proposalList = proposalService.selectProposalListAdmin(params);
        mav.addObject("codeList", codeService.getCodeList(CodeType.CODE_GROUP_PROPOSAL_STATUS.getCode()));
        mav.addObject("proposalList", proposalList);
        mav.addObject("params", params);

        return mav;
    }

    /**
     * 정책제안 리스트 > 엑셀다운로드
     * 
     * @param req
     * @param res
     * @param params
     * @return
     */
    @RequestMapping(value = "/admin/proposal/exceldownload")
    public ModelAndView adminProposalListExcel(HttpServletRequest req, HttpServletResponse res, @RequestParam Map<String, Object> params) {
        // start 리스트로 연결되는 페이지들 기본 설정
        ModelAndView mav = new ModelAndView();
        mav.setViewName("ExcelBuilder");

        // 구분
        String gubun = "ProposalList";
        String fileName = "정책제안"; // 파일이름

        mav.addObject("fileName", fileName);
        mav.addObject("gubun", gubun);

        List<HashMap<String, Object>> resultList = proposalService.selectProposalListExcel(params);
        mav.addObject("resultList", resultList);

        logger.info("adminExcelList");
        return mav;

    }


    /**
     * 제안 검토완료 리스트
     * 
     * @param request
     * @param response
     * @param params
     * @return
     */
    @RequestMapping(value = "/admin/proposal/proposal_review_list")
    public ModelAndView proposalReviewList(HttpServletRequest req, HttpServletResponse res, @RequestParam Map<String, Object> params, PagingHelper pagingHelper) {

        ModelAndView mav = new ModelAndView(PROPOSALREVIEWLIST);

        AdminUser av = SessionUtil.getAdminSessionInfo(req);
        if (av == null) {
            // 로그인 후 이용하실수 있습니다.
            String message = messages.getMessage("message.common.noLogin.001");
            RequestUtils.responseWriteException(req, res, message, LOGINPAGE);
            return null;
        }

        mav.addObject("av", av); // 로그인 정보
        params.put("deleteYn", "N"); // 삭제 안한 리스트만 보여줌
        params.put("status", "COMPLETE"); // 검토완료 상태로 된 글만 보이기

        /** paging setting */
        pagingHelper.setTotalCnt(proposalService.selectProposalListCount(params)); // 리스트 총 갯수
                                                                                  // 넘겨줌
        params.put("startNum", pagingHelper.getStartRow() - 1);
        params.put("endNum", pagingHelper.getPagingRow());
        mav.addObject("pagingHelper", pagingHelper);

        List<Proposal> proposalList = proposalService.selectProposalListAdmin(params);
        mav.addObject("codeList", codeService.getCodeList(CodeType.CODE_GROUP_PROPOSAL_STATUS.getCode()));
        mav.addObject("proposalList", proposalList);
        mav.addObject("params", params);

        return mav;
    }



    /**
     * 정책제안 상세페이지
     * 
     * @param request
     * @param response
     * @param params
     * @return
     */
    @RequestMapping(value = "/admin/proposal/proposal_detail")
    public ModelAndView proposalDetail(HttpServletRequest req, HttpServletResponse res, @RequestParam Map<String, Object> params) {

        ModelAndView mav = new ModelAndView(PROPOSALDETAIL);

        AdminUser av = SessionUtil.getAdminSessionInfo(req);
        if (av == null) {
            // 로그인 후 이용하실수 있습니다.
            String message = messages.getMessage("message.common.noLogin.001");
            RequestUtils.responseWriteException(req, res, message, LOGINPAGE);
            return null;
        }
        mav.addObject("av", av); // 로그인 정보

        params.put("deleteYn", "N");
        Proposal proposal = proposalService.selectProposalAdmin(params);

        if (proposal == null) {
            //            RequestUtils.htmlAlert(req, res, messages.getMessage("message.proposal.info.001"));
            //            return null;
            String message = messages.getMessage("message.proposal.info.001");
            throw new EvoteBizException(message);
        } else {

            mav.addObject("codeList", codeService.getCodeList(CodeType.CODE_GROUP_PROPOSAL_STATUS.getCode()));

            List<FileInfo> imageFileList = fileService.selectFileInfoList(proposal.getPropSeq(), FileGrpType.PROPOSAL, FileType.IMAGE);
            List<FileInfo> attachFileList = fileService.selectFileInfoList(proposal.getPropSeq(), FileGrpType.PROPOSAL, FileType.ATTACH);
            mav.addObject("imageFileList", imageFileList);
            mav.addObject("attachFileList", attachFileList);

            mav.addObject("proposal", proposal);
            mav.addObject("params", params);

            // 제안 검토 조회
            mav.addObject("proposalAudit", proposalService.selectProposalAudit(params));

            List<FileInfo> auditImageFileList = fileService.selectFileInfoList(proposal.getPropSeq(), FileGrpType.PROP_AUDIT, FileType.IMAGE);
            List<FileInfo> auditAttachFileList = fileService.selectFileInfoList(proposal.getPropSeq(), FileGrpType.PROP_AUDIT, FileType.ATTACH);
            mav.addObject("auditImageFileList", auditImageFileList);
            mav.addObject("auditAttachFileList", auditAttachFileList);

            // 제안 댓글 조회
            List<PropComment> commentList = proposalService.selectCommentListAdmin(params);
            mav.addObject("commentList", commentList);
            mav.addObject("commentListCount", commentList.size());

        }
        String listUrl = StringUtils.defaultString(req.getParameter("listUrl"), "");
        mav.addObject("listUrl", listUrl);

        return mav;
    }

    /**
     * 정책제안상세 댓글 숨김/숨김해제
     * 
     * @param request
     * @param response
     * @param params
     * @return
     */
    @RequestMapping(value = "/admin/proposal/detail/comment/hide")
    @ResponseBody
    public int proposalDetailCommentHide(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, Object> params) {

        // AdminUser member = SessionUtil.getAdminSessionInfo(request);
        int result = 0;

        String propSeq = StringUtils.nvl(params.get("propSeq"));
        if (!"".equals(propSeq)) {

            params.put("deleteYn", "N");
            Proposal proposal = proposalService.selectProposalAdmin(params);

            if (proposal == null) {
                result = -1;
            } else {
                result = proposalService.hideComment(params);
            }
        }

        return result;
    }

    /**
     * 댓글 숨김/숨김해제
     * 
     * @param request
     * @param response
     * @param params
     * @return
     */
    @RequestMapping(value = "/admin/proposal/detail/comment/auth")
    @ResponseBody
    public int proposalDetailCommentAuth(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, Object> params) {

        // AdminUser member = SessionUtil.getAdminSessionInfo(request);
        int result = 0;

        String propSeq = StringUtils.nvl(params.get("propSeq"));
        if (!"".equals(propSeq)) {

            params.put("deleteYn", "N");
            Proposal proposal = proposalService.selectProposalAdmin(params);

            if (proposal == null) {
                result = -1;
            } else {
                result = memberService.updateCommentAuth(params);
            }
        }

        return result;
    }

    /**
     * 정책제안검토 저장/수정
     * 
     * @param request
     * @param response
     * @param proposalAuditParam
     * @param imageFiles
     * @param attachFiles
     * @param deleteFileSeq
     * @return
     */
    @RequestMapping(value = "/admin/proposal/detail/save")
    public ModelAndView proposalSave(HttpServletRequest request, HttpServletResponse response, ProposalAudit proposalAuditParam,
            @RequestParam(value = "imageFile", required = false) MultipartFile[] imageFiles, @RequestParam(value = "attachFile", required = false) MultipartFile[] attachFiles,
            @RequestParam(value = "deleteFileSeq", required = false) Long[] deleteFileSeq) {

        AdminUser member = SessionUtil.getAdminSessionInfo(request);

        Integer propSeq = StringUtils.nvlInt(proposalAuditParam.getPropSeq());

        ModelAndView mav = new ModelAndView("redirect:" + PROPOSALDETAIL);
        mav.addObject("propSeq", propSeq);
        Map<String, Object> params = new HashMap<String, Object>();

        params.put("propSeq", propSeq);
        params.put("deleteYn", "N");
        Proposal proposal = proposalService.selectProposalAdmin(params);


        if (proposal == null) {
            RequestUtils.responseWriteMessage(request, response, messages.getMessage("message.proposal.info.001"), PROPOSALLISTPAGE);
            return null;
        }

        proposalAuditParam.setRegUser(member.getMgrSeq());
        proposalAuditParam.setModUser(member.getMgrSeq());
        int saveResult = proposalService.saveProposalAudit(proposalAuditParam);

        if (saveResult > 0) {

            // 검토저장성공후 proposal의 status update
            proposalService.saveProposalStatus(proposalAuditParam);

            if (deleteFileSeq != null) {
                int size = deleteFileSeq.length;
                for (int i = 0; i < size; i++) {
                    Long fileSeq = deleteFileSeq[i];
                    fileService.deleteFileInfo(fileSeq);
                }
            }

            if (imageFiles != null) {
                int size = imageFiles.length;
                for (int i = 0; i < size; i++) {
                    MultipartFile multiFile = imageFiles[i];
                    String fileName = multiFile.getOriginalFilename();
                    if (!"".equals(fileName)) {
                        String ext = FilenameUtils.getExtension(fileName);
                        List<String> extList = new ArrayList<String>();
                        extList.add("jpg");
                        extList.add("gif");
                        extList.add("jpeg");
                        extList.add("png");

                        if (!extList.contains(ext.toLowerCase())) {
                            // 파일 extention이 허용되지 않으면 skip처리.
                            continue;
                        }

                        Map<String, String> storeFileMap = fileUploadUtil.saveFile(multiFile, FileGrpType.PROP_AUDIT);

                        if (storeFileMap.isEmpty() == false) {
                            long fileGrpSeq = proposalAuditParam.getPropSeq(); // 원본 게시물 일련번호
                            int fileOrd = 1; // 파일 순서
                            String fileDesc = "proposal audit [ " + proposalAuditParam.getPropSeq() + " ]의 image file"; // 파일
                                                                                                                       // 설명

                            FileInfo fileVO = new FileInfo();
                            fileVO.setFileNm(storeFileMap.get("storeFileName"));
                            fileVO.setFilePath(storeFileMap.get("storeFilePath"));
                            fileVO.setFileExt(storeFileMap.get("storeFileExt"));

                            fileVO.setFileSrcNm(multiFile.getOriginalFilename());
                            fileVO.setFileGrpType(FileGrpType.PROP_AUDIT);
                            fileVO.setFileType(FileType.IMAGE);
                            fileVO.setFileSize(multiFile.getSize());

                            fileVO.setFileGrpSeq(fileGrpSeq);
                            fileVO.setFileOrd(fileOrd);
                            fileVO.setFileDesc(fileDesc);

                            fileService.insertFileInfo(fileVO);
                        }
                    }
                }
            }

            if (attachFiles != null) {
                int size = attachFiles.length;
                for (int i = 0; i < size; i++) {
                    MultipartFile multiFile = attachFiles[i];
                    String fileName = multiFile.getOriginalFilename();
                    if (!"".equals(fileName)) {
                        String ext = FilenameUtils.getExtension(fileName);
                        List<String> extList = new ArrayList<String>();
                        extList.add("hwp");

                        if (!extList.contains(ext.toLowerCase())) {
                            // 파일 extention이 허용되지 않으면 skip처리.
                            continue;
                        }

                        Map<String, String> storeFileMap = fileUploadUtil.saveFile(multiFile, FileGrpType.PROP_AUDIT);

                        if (storeFileMap.isEmpty() == false) {
                            long fileGrpSeq = proposalAuditParam.getPropSeq(); // 원본 게시물 일련번호
                            int fileOrd = 1; // 파일 순서
                            String fileDesc = "proposal audit [ " + proposalAuditParam.getPropSeq() + " ]의 attach file"; // 파일
                                                                                                                        // 설명

                            FileInfo fileVO = new FileInfo();
                            fileVO.setFileNm(storeFileMap.get("storeFileName"));
                            fileVO.setFilePath(storeFileMap.get("storeFilePath"));
                            fileVO.setFileExt(storeFileMap.get("storeFileExt"));

                            fileVO.setFileSrcNm(multiFile.getOriginalFilename());
                            fileVO.setFileGrpType(FileGrpType.PROP_AUDIT);
                            fileVO.setFileType(FileType.ATTACH);
                            fileVO.setFileSize(multiFile.getSize());

                            fileVO.setFileGrpSeq(fileGrpSeq);
                            fileVO.setFileOrd(fileOrd);
                            fileVO.setFileDesc(fileDesc);

                            fileService.insertFileInfo(fileVO);
                        }
                    }
                }
            }
        }
        String listUrl = StringUtils.defaultString(request.getParameter("listUrl"), "");
        mav.addObject("listUrl", listUrl);
        return mav;

    }

    /**
     * 공모관리 리스트
     * 
     * @param req
     * @param res
     * @param params
     * @param pagingHelper
     * @return
     */
    @RequestMapping(value = "/admin/proposal/contest_list")
    public ModelAndView contestList(HttpServletRequest req, HttpServletResponse res, @RequestParam Map<String, Object> params, PagingHelper pagingHelper) {

        ModelAndView mav = new ModelAndView(CONTESTLISTPAGE);

        AdminUser av = SessionUtil.getAdminSessionInfo(req);
        if (av == null) {
            // 로그인 후 이용하실수 있습니다.
            String message = messages.getMessage("message.common.noLogin.001");
            RequestUtils.responseWriteException(req, res, message, LOGINPAGE);
            return null;
        }
        mav.addObject("av", av); // 로그인 정보

        /** paging setting */
        pagingHelper.setTotalCnt(proposalService.selectPssrpListCount(params)); // 리스트 총 갯수
                                                                               // 넘겨줌
        params.put("startNum", pagingHelper.getStartRow() - 1);
        params.put("endNum", pagingHelper.getPagingRow());
        mav.addObject("pagingHelper", pagingHelper);

        List<Pssrp> pssrpList = proposalService.selectPssrpList(params);
        mav.addObject("pssrpList", pssrpList);
        mav.addObject("params", params);

        // 얼럿메시지 등 스크립트 실행
        //        String script = StringUtils.defaultString(req.getParameter("script"), "");
        //        mav.addObject("script", script);
        return mav;
    }

    /**
     * 공모관리 제안리스트
     * 
     * @param req
     * @param res
     * @param params
     * @param pagingHelper
     * @return
     */
    @RequestMapping(value = "/admin/proposal/contest_proposal_list")
    public ModelAndView contestProposalList(HttpServletRequest req, HttpServletResponse res, @RequestParam Map<String, Object> params, PagingHelper pagingHelper) {

        ModelAndView mav = new ModelAndView(CONTESTPROPOSALLIST);

        AdminUser av = SessionUtil.getAdminSessionInfo(req);
        if (av == null) {
            // 로그인 후 이용하실수 있습니다.
            String message = messages.getMessage("message.common.noLogin.001");
            RequestUtils.responseWriteException(req, res, message, LOGINPAGE);
            return null;
        }
        mav.addObject("av", av); // 로그인 정보
        params.put("deleteYn", "N"); // 삭제 안한 리스트만 보여줌
        Pssrp contest = proposalService.getPssrp(params);
        mav.addObject("contest", contest);
        // 여기에는 psSeq 공모 아이디 값이 검색 조건으로 추가 된다.
        /** paging setting */
        pagingHelper.setTotalCnt(proposalService.selectProposalListCount(params)); // 리스트 총 갯수 넘겨줌
        params.put("startNum", pagingHelper.getStartRow() - 1);
        params.put("endNum", pagingHelper.getPagingRow());
        mav.addObject("pagingHelper", pagingHelper);
        List<Proposal> proposalList = proposalService.selectProposalListAdmin(params);

        mav.addObject("codeList", codeService.getCodeList(CodeType.CODE_GROUP_PROPOSAL_STATUS.getCode()));
        mav.addObject("proposalList", proposalList);
        mav.addObject("proposalListCount", proposalService.selectProposalListCount(params));
        mav.addObject("params", params);

        return mav;
    }

    /**
     * 공모관리 등록,수정폼
     * 
     * @param request
     * @param response
     * @param params
     * @return
     */
    @RequestMapping(value = "/admin/proposal/contest_write_form")
    public ModelAndView contestWriteForm(HttpServletRequest req, HttpServletResponse res, @RequestParam Map<String, Object> params) {

        ModelAndView mav = new ModelAndView(CONTESTWRITEFORM);

        AdminUser av = SessionUtil.getAdminSessionInfo(req);
        if (av == null) {
            // 로그인 후 이용하실수 있습니다.
            String message = messages.getMessage("message.common.noLogin.001");
            RequestUtils.responseWriteException(req, res, message, LOGINPAGE);
            return null;
        }
        mav.addObject("av", av); // 로그인 정보

        String psSeq = StringUtils.defaultString(req.getParameter("psSeq"), "");
        if (!psSeq.equals("")) {
            Pssrp contest = proposalService.getPssrp(params);
            mav.addObject("contest", contest);
            // 파일
            List<FileInfo> realmfile = fileService.selectFileInfoList(contest.getPsSeq(), FileGrpType.PSSRP, FileType.REQ_REALM);
            List<FileInfo> methodfile = fileService.selectFileInfoList(contest.getPsSeq(), FileGrpType.PSSRP, FileType.REQ_METHOD);
            List<FileInfo> imgpcfile = fileService.selectFileInfoList(contest.getPsSeq(), FileGrpType.PSSRP, FileType.IMG_WEB);
            List<FileInfo> imgmobfile = fileService.selectFileInfoList(contest.getPsSeq(), FileGrpType.PSSRP, FileType.IMG_MOB);
            mav.addObject("realmfile", realmfile);
            mav.addObject("methodfile", methodfile);
            mav.addObject("imgpcfile", imgpcfile);
            mav.addObject("imgmobfile", imgmobfile);
        } else {
            Pssrp contest = new Pssrp();
            contest.setRealmfileYn("N");
            contest.setMethodfileYn("N");
            contest.setImgpcfileYn("N");
            contest.setImgmobfileYn("N");
            mav.addObject("contest", contest);
        }

        // 얼럿메시지 등 스크립트 실행
        //        String script = StringUtils.defaultString(req.getParameter("script"), "");
        //        mav.addObject("script", script);

        mav.addObject("params", params);
        return mav;
    }


    /**
     * 공모관리 등록, 수정
     * 
     * @param request
     * @param response
     * @param params
     * @return
     */
    @RequestMapping(value = "/admin/proposal/contest_write")
    public ModelAndView contestWrite(HttpServletRequest req, HttpServletResponse res, Pssrp params) {
        ModelAndView mav = new ModelAndView();
        RedirectView redirectView = new RedirectView(); // redirect url 설정
        redirectView.setUrl(CONTESTWRITEFORM);
        redirectView.setExposeModelAttributes(true);

        AdminUser av = SessionUtil.getAdminSessionInfo(req);
        if (av == null) {
            // 로그인 후 이용하실수 있습니다.
            String message = messages.getMessage("message.common.noLogin.001");
            RequestUtils.responseWriteException(req, res, message, LOGINPAGE);
            return null;
        }
        mav.addObject("av", av); // 로그인 정보
        params.setRegUser(av.getMgrSeq()); // 사용자 id

        // 시작일 종료일 날짜 변경
        String start_date = StringUtils.defaultString(req.getParameter("start_date"), "");// 시작일
        String start_hour = StringUtils.defaultString(req.getParameter("start_hour"), "09");
        String end_date = StringUtils.defaultString(req.getParameter("end_date"), ""); // 종료일
        String end_hour = StringUtils.defaultString(req.getParameter("end_hour"), "18");
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-ddHH");
        try {
            params.setStartDate(sdf.parse(start_date + start_hour));
            params.setEndDate(sdf.parse(end_date + end_hour));
        } catch (ParseException e1) {
            e1.printStackTrace();
        }
        try {
            // 정보저장
            String psSeq = StringUtils.defaultString(req.getParameter("psSeq"), "");
            if (psSeq.equals("")) {
                // 등록
                Pssrp contest = proposalService.insertPssrp(params);
                // 얼럿메시지 등 스크립트 실행
                //                String script = "alert('" + messages.getMessage("message.admin.common.003", "공모") + "');";
                //                mav.addObject("script", script);
                mav.addObject("psSeq", contest.getPsSeq());
            } else {
                // 업데이트
                proposalService.updatePssrp(params);
                // 얼럿메시지 등 스크립트 실행
                //                String script = "alert('" + messages.getMessage("message.admin.common.003", "공모") + "');";
                //                mav.addObject("script", script);
                mav.addObject("psSeq", params.getPsSeq());
            }

        } catch (Exception e) {
            e.printStackTrace();
            // 저장에 실패하였습니다. 확인 후 다시 시도하시거나 관리자에게 문의해주세요.
            String message = messages.getMessage("message.admin.vote.error.001");
            RequestUtils.responseWriteException(req, res, message, CONTESTWRITEFORM);
            return null;
        }

        mav.addObject("params", params);
        mav.setView(redirectView);
        return mav;
    }

    /**
     * 공모 강제종료 or 삭제
     * 
     * @param req
     * @param res
     * @param params
     * @return
     */
    @RequestMapping(value = "/admin/proposal/endContest")
    public ModelAndView endContest(HttpServletRequest req, HttpServletResponse res, @RequestParam Map<String, Object> params) {
        ModelAndView mav = new ModelAndView();
        RedirectView redirectView = new RedirectView(); // redirect url 설정
        redirectView.setUrl(CONTESTLISTPAGE);
        redirectView.setExposeModelAttributes(true);

        AdminUser av = SessionUtil.getAdminSessionInfo(req);
        if (av == null) {
            // 로그인 후 이용하실수 있습니다.
            String message = messages.getMessage("message.common.noLogin.001");
            RequestUtils.responseWriteException(req, res, message, LOGINPAGE);
            return null;
        }
        // 사용자 ID
        params.put("regUser", av.getMgrSeq());

        // 종료 상태 END: 강제종료, DEL:삭제
        String eventType = StringUtils.defaultString(req.getParameter("eventType"), "END");
        try {
            proposalService.endPssrp(params);
            // 얼럿메시지 등 스크립트 실행
            if (eventType.equals("DEL")) {
                //                String script = "alert('" + messages.getMessage("message.admin.common.004", "공모") + "');";
                //                mav.addObject("script", script);
            }
        } catch (Exception e) {
            e.printStackTrace();
            // 선택하신 정보 삭제에 실패하였습니다. 확인 후 다시 시도하시거나 관리자에게 문의해주세요.
            String message = messages.getMessage("message.admin.vote.error.002");
            RequestUtils.responseWriteException(req, res, message, CONTESTLISTPAGE);
            return null;
        }

        mav.addObject("startDate", params.get("startDate"));
        mav.addObject("endDate", params.get("endDate"));
        mav.addObject("searchKeyword", params.get("searchKeyword"));
        mav.addObject("pageNo", params.get("pageNo"));

        // mav.addObject("params", params);
        mav.setView(redirectView);
        logger.info("endContest");
        return mav;
    }

    /**
     * 공모 날짜로 해당 날짜에 글이 있는지 체크
     * 
     * @param req
     * @param res
     * @param params
     * @return
     */
    @RequestMapping(value = "/admin/proposal/checkContest")
    @ResponseBody
    public int proposalCheckContest(HttpServletRequest req, HttpServletResponse res, @RequestParam Map<String, Object> params) {
        return proposalService.selectPssrpListCount(params);
    }

    /**
     * 파일 삭제
     * 
     * @param request
     * @param delFileSeq
     * @return
     */
    @RequestMapping(value = "/admin/proposal/file-delete/{delFileSeq}")
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
}
