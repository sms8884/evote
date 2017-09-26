/**
 * Copyright (c) 2016 JAHA SMART CORP., LTD ALL RIGHT RESERVED
 */
package com.jaha.evote.controller.common;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.springframework.web.util.WebUtils;

import com.jaha.evote.common.exception.EvoteBizException;
import com.jaha.evote.common.util.DateUtils;
import com.jaha.evote.common.util.FileUploadUtil;
import com.jaha.evote.common.util.Messages;
import com.jaha.evote.common.util.PagingHelper;
import com.jaha.evote.common.util.RequestUtils;
import com.jaha.evote.common.util.SessionUtil;
import com.jaha.evote.common.util.XecureUtil;
import com.jaha.evote.domain.Board;
import com.jaha.evote.domain.BoardInfo;
import com.jaha.evote.domain.BoardPost;
import com.jaha.evote.domain.Member;
import com.jaha.evote.domain.Terms;
import com.jaha.evote.domain.common.FileInfo;
import com.jaha.evote.domain.type.BoardType;
import com.jaha.evote.domain.type.CodeType;
import com.jaha.evote.domain.type.FileGrpType;
import com.jaha.evote.domain.type.FileType;
import com.jaha.evote.domain.type.RoleType;
import com.jaha.evote.domain.type.TermsType;
import com.jaha.evote.domain.type.UserType;
import com.jaha.evote.service.BoardService;
import com.jaha.evote.service.MemberService;
import com.jaha.evote.service.SmsService;
import com.jaha.evote.service.TermsService;

/**
 * <pre>
 * Class Name : BoardController.java
 * Description : Description
 *  
 * Modification Information
 * 
 * Mod Date         Modifier    Description
 * -----------      --------    ---------------------------
 * 2016. 10. 6.     jjpark      Generation
 * 2016. 10. 25.    jjpark      admin, front 통합
 * </pre>
 *
 * @author jjpark
 * @since 2016. 10. 6.
 * @version 1.0
 */
@Controller
public class BoardController extends BaseController {

    @Autowired
    private BoardService boardService;

    @Autowired
    private MemberService memberService;

    @Autowired
    private SmsService smsService;

    @Autowired
    private TermsService termsService;

    @Autowired
    private FileUploadUtil fileUploadUtil;

    @Autowired
    private Messages messages;

    /**
     * 게시물 목록 조회
     * 
     * @param searchParam
     * @param boardName
     * @param pagingHelper
     * @return
     */
    @RequestMapping(value = {"/admin/board/{boardName}/list", "/board/{boardName}/list"})
    public ModelAndView getBoardPostList(HttpServletRequest request, BoardPost searchParam, @PathVariable(value = "boardName") String boardName, PagingHelper pagingHelper) {

        BoardInfo boardInfo = boardService.selectBoardPostList(boardName, searchParam);

        pagingHelper.setTotalCnt(boardInfo.getTotalCount());

        ModelAndView mav = new ModelAndView();

        mav.addObject("board", boardInfo.getBoard());
        mav.addObject("boardCategoryList", boardInfo.getBoardCategoryList());
        mav.addObject("boardPostList", boardInfo.getBoardPostList());
        mav.addObject("boardTopList", boardInfo.getBoardTopList());

        mav.addObject("pagingHelper", pagingHelper);
        mav.addObject("searchParam", searchParam);

        String boardPath = getBoardPath(boardInfo.getBoard().getBoardType());

        mav.setViewName(getSitePrefix(request) + "board/" + boardPath + "/list");

        return mav;
    }

    /**
     * 게시물 상세
     * 
     * @param searchParam
     * @param boardName
     * @param postSeq
     * @return
     */
    @RequestMapping(value = {"/admin/board/{boardName}/{postSeq}", "/board/{boardName}/{postSeq}"})
    public ModelAndView getBoardPost(HttpServletRequest request, BoardPost searchParam, @PathVariable(value = "boardName") String boardName, @PathVariable(value = "postSeq") long postSeq) {

        // 조회수 증가
        boardService.updateBoardPostReadCount(searchParam);

        Map<String, Object> result = boardService.selectBoardPost(boardName, postSeq, searchParam);

        ModelAndView mav = new ModelAndView();

        String boardPath = "";

        if (result != null) {
            mav.addObject("board", result.get("board"));
            mav.addObject("boardPost", result.get("boardPost"));
            mav.addObject("prevPost", result.get("prevPost"));
            mav.addObject("nextPost", result.get("nextPost"));
            mav.addObject("boardPushDestCount", result.get("boardPushDestCount"));
            boardPath = getBoardPath(((Board) result.get("board")).getBoardType());
        }

        mav.addObject("searchParam", searchParam);

        mav.setViewName(getSitePrefix(request) + "board/" + boardPath + "/detail");

        return mav;

    }

    /**
     * 게시물 작성 화면
     * 
     * @param searchParam
     * @param boardName
     * @return
     */
    @RequestMapping(value = {"/admin/board/{boardName}/write", "/board/{boardName}/write"})
    public ModelAndView writeBoardPost(HttpServletRequest request, HttpServletResponse response, BoardPost searchParam, @PathVariable(value = "boardName") String boardName) {

        BoardInfo boardInfo = boardService.selectBoardInfo(boardName);

        if (!isAdminSite(request)) {
            // 게시판 권한 체크
            if (boardInfo != null) {

                Board board = boardInfo.getBoard();

                if (RoleType.ADMIN.equals(board.getWriteRole())) {
                    // message.notice.007=게시판 쓰기 권한이 없습니다.
                    String message = messages.getMessage("message.notice.007");
                    throw new EvoteBizException(message);
                }

                /*
                 * 문의하기 게시판 예외사항 로그인 또는 휴대폰 인증을 받지 않고 비정상적으로 QNA 등록 화면으로 들어왔을 경우 로그인 페이지로 이동
                 */
                if (CodeType.BOARD_NAME_QNA.getCode().equals(board.getBoardName())) {
                    Member member = SessionUtil.getSessionInfo(request);
                    if (member == null) {
                        UserType userType = (UserType) WebUtils.getSessionAttribute(request, "userType");
                        if (userType == null || !UserType.QNA.equals(userType)) {
                            String message = messages.getMessage("message.common.noLogin.001");
                            RequestUtils.responseWriteMessage(request, response, message, "/login");
                            return null;
                        }
                    }
                }

            }

        }

        ModelAndView mav = new ModelAndView();
        mav.addObject("board", boardInfo.getBoard());
        mav.addObject("boardCategoryList", boardInfo.getBoardCategoryList());
        mav.addObject("searchParam", searchParam);

        String boardPath = getBoardPath(boardInfo.getBoard().getBoardType());

        mav.setViewName(getSitePrefix(request) + "board/" + boardPath + "/write");

        return mav;
    }

    /**
     * 게시물 작성
     * 
     * @param boardPost
     * @param boardName
     * @param imageFile
     * @param attachFiles
     * @return
     */
    @RequestMapping(value = {"/admin/board/{boardName}/write-proc", "/board/{boardName}/write-proc"})
    public String writeBoardPostProc(HttpServletRequest request, @ModelAttribute BoardPost boardPost, @PathVariable(value = "boardName") String boardName,
            @RequestParam(value = "imageFile", required = false) MultipartFile[] imageFiles, @RequestParam(value = "attachFile", required = false) MultipartFile[] attachFiles) {

        // 이미지 파일 처리
        if (imageFiles != null) {
            List<FileInfo> imageList = new ArrayList<>();
            for (MultipartFile imageFile : imageFiles) {
                if (StringUtils.isNotEmpty(imageFile.getOriginalFilename())) {
                    imageList.add(fileUploadUtil.getSavedFileInfo(imageFile, FileGrpType.BOARD, FileType.IMAGE));
                }
            }
            boardPost.setImageList(imageList);
        }

        // 첨부파일 처리
        if (attachFiles != null) {
            List<FileInfo> attachList = new ArrayList<>();
            for (MultipartFile attachFile : attachFiles) {
                if (StringUtils.isNotEmpty(attachFile.getOriginalFilename())) {
                    attachList.add(fileUploadUtil.getSavedFileInfo(attachFile, FileGrpType.BOARD, FileType.ATTACH));
                }
            }
            boardPost.setAttachList(attachList);
        }

        boardService.insertBoardPost(boardName, boardPost);

        return "redirect:/" + getSitePrefix(request) + "board/" + boardName + "/list";
    }

    /**
     * 게시물 수정 화면
     * 
     * @param boardName
     * @param postSeq
     * @param searchParam
     * @return
     */
    @RequestMapping(value = {"/admin/board/{boardName}/modify/{postSeq}", "/board/{boardName}/modify/{postSeq}"})
    public ModelAndView modifyBoardPost(HttpServletRequest request, HttpServletResponse response, @PathVariable(value = "boardName") String boardName, @PathVariable(value = "postSeq") long postSeq,
            BoardPost searchParam) {

        Map<String, Object> result = boardService.selectBoardPost(boardName, postSeq, searchParam);

        ModelAndView mav = new ModelAndView();

        if (result != null) {

            Board board = null;
            BoardPost boardPost = null;

            // 게시판 권한 체크
            if (!isAdminSite(request)) {

                board = (Board) result.get("board");

                if (board != null) {
                    if (RoleType.ADMIN.equals(board.getWriteRole())) {
                        // message.notice.007=게시판 쓰기 권한이 없습니다.
                        String message = messages.getMessage("message.notice.007");
                        throw new EvoteBizException(message);
                    }
                }

                boardPost = (BoardPost) result.get("boardPost");

                if (boardPost != null) {

                    if (boardPost.getRegUser() > 0 && !"Y".equals(boardPost.getOwnerYn())) {
                        throw new EvoteBizException("게시물 수정 권한이 없습니다.");
                        //} else if (boardPost.getPassword() != null && !boardPost.getPassword().equals(searchParam.getPassword())) {
                    } else if (boardPost.getPassword() != null && !XecureUtil.verifyHash64(searchParam.getPassword(), boardPost.getPassword())) {
                        throw new EvoteBizException("게시물 수정 권한이 없습니다.");
                    }

                }

            }

            mav.addObject("board", result.get("board"));
            mav.addObject("boardCategoryList", result.get("boardCategoryList"));
            mav.addObject("boardPost", result.get("boardPost"));

            String boardPath = getBoardPath(((Board) result.get("board")).getBoardType());
            mav.setViewName(getSitePrefix(request) + "board/" + boardPath + "/modify");
        }

        mav.addObject("searchParam", searchParam);

        return mav;
    }

    /**
     * 게시물 수정
     * 
     * @param redirectAttributes
     * @param boardPost
     * @param boardName
     * @param imageFile
     * @param attachFiles
     * @param deleteFile
     * @return
     */
    @RequestMapping(value = {"/admin/board/{boardName}/modify-proc", "/board/{boardName}/modify-proc"})
    public String modifyBoardPostProc(HttpServletRequest request, RedirectAttributes redirectAttributes, @ModelAttribute BoardPost boardPost, @PathVariable(value = "boardName") String boardName,
            @RequestParam(value = "imageFile", required = false) MultipartFile[] imageFiles, @RequestParam(value = "attachFile", required = false) MultipartFile[] attachFiles,
            @RequestParam(value = "deleteFile", required = false) String deleteFile) {

        // 이미지 파일 처리
        if (imageFiles != null) {
            List<FileInfo> imageList = new ArrayList<>();
            for (MultipartFile imageFile : imageFiles) {
                if (StringUtils.isNotEmpty(imageFile.getOriginalFilename())) {
                    imageList.add(fileUploadUtil.getSavedFileInfo(imageFile, FileGrpType.BOARD, FileType.IMAGE));
                }
            }
            boardPost.setImageList(imageList);
        }

        // 첨부파일 처리
        if (attachFiles != null) {
            List<FileInfo> attachList = new ArrayList<>();
            for (MultipartFile attachFile : attachFiles) {
                if (StringUtils.isNotEmpty(attachFile.getOriginalFilename())) {
                    attachList.add(fileUploadUtil.getSavedFileInfo(attachFile, FileGrpType.BOARD, FileType.ATTACH));
                }
            }
            boardPost.setAttachList(attachList);
        }

        // 방문객 비밀번호 > 수정 완료 후 redirect 를 위해 임시 저장
        String visitorPw = boardPost.getPassword();

        boardService.updateBoardPost(boardName, boardPost, deleteFile);

        BoardPost searchParam = new BoardPost();

        searchParam.setSearchStartDate(boardPost.getSearchStartDate());
        searchParam.setSearchEndDate(boardPost.getSearchEndDate());
        searchParam.setSearchCategoryCd(boardPost.getSearchCategoryCd());
        searchParam.setSearchTarget(boardPost.getSearchTarget());
        searchParam.setSearchText(boardPost.getSearchText());
        searchParam.setSearchMyPostYn(boardPost.getSearchMyPostYn());

        logger.debug("### searchParam ::: [{}]", searchParam);

        Board board = boardService.selectSimpleBoard(boardName);
        if (BoardType.QNA.equals(board.getBoardType())) {
            searchParam.setPassword(visitorPw);
        }

        redirectAttributes.addAttribute("postSeq", boardPost.getPostSeq()).addFlashAttribute(searchParam);
        return "redirect:/" + getSitePrefix(request) + "board/" + boardName + "/{postSeq}";

    }

    /**
     * 게시물 삭제
     * 
     * @param boardPost
     * @param boardName
     * @param postSeq
     * @return
     */
    @RequestMapping(value = {"/admin/board/{boardName}/remove/{postSeq}", "/board/{boardName}/remove/{postSeq}"})
    public String removeBoardPost(HttpServletRequest request, @ModelAttribute BoardPost boardPost, @PathVariable(value = "boardName") String boardName, @PathVariable(value = "postSeq") long postSeq) {

        boardPost.setPostSeq(postSeq);

        int result = boardService.deleteBoardPost(boardName, boardPost);

        logger.debug("### Delete BoardPost ::: [{}] , result [{}]", postSeq, result);

        return "redirect:/" + getSitePrefix(request) + "board/" + boardName + "/list";
    }


    // =========================================================================
    // ADMIN ONLY
    // =========================================================================

    /**
     * push 전송
     * 
     * @param boardName
     * @param postSeq
     * @return
     */
    @RequestMapping(value = "/admin/board/{boardName}/send-gcm/{postSeq}")
    @ResponseBody
    public Map<String, Object> sendBoardGcm(@PathVariable(value = "boardName") String boardName, @PathVariable(value = "postSeq") long postSeq) {

        BoardPost newBoardPost = boardService.sendBoardGcm(boardName, postSeq);

        Map<String, Object> map = new HashMap<>();

        if (newBoardPost != null) {
            String strPushSendDate = DateUtils.convertDateFormat(newBoardPost.getPushSendDate(), "yyyy.MM.dd HH:mm:ss");
            map.put("result", true);
            map.put("pushSendDate", strPushSendDate);
        } else {
            map.put("result", false);
        }

        return map;
    }

    /**
     * 게시물 숨김 처리
     * 
     * @param boardName
     * @param postSeq
     * @param hideYn
     * @return
     */
    @RequestMapping(value = "/admin/board/{boardName}/hidden/{postSeq}")
    @ResponseBody
    public Map<String, Object> modifyBoardPostHideYn(@PathVariable(value = "boardName") String boardName, @PathVariable(value = "postSeq") long postSeq, @RequestParam("hideYn") String hideYn) {

        logger.debug("postSeq :: [{}]", postSeq);
        logger.debug("hideYn :: [{}]", hideYn);

        int result = boardService.updateBoardPostHideYn(postSeq, hideYn);

        Map<String, Object> map = new HashMap<>();

        if (result > 0) {
            map.put("result", "Y");
            map.put("hideYn", hideYn);
        } else {
            map.put("result", "N");
        }

        return map;
    }

    // =========================================================================
    // FRONT ONLY
    // =========================================================================

    /**
     * 비회원 등록 글 패스워드 확인
     * 
     * @param boardName
     * @param postSeq
     * @param visitorPw
     * @return
     */
    @RequestMapping(value = "/board/{boardName}/checkPassword")
    @ResponseBody
    public Map<String, Object> checkVisitorPassword(@PathVariable(value = "boardName") String boardName, @RequestParam(value = "seq") long postSeq, @RequestParam(value = "vpw") String visitorPw) {

        logger.debug("### checkVisitorPassword ::: postSeq [{}], visitorPw [{}]", postSeq, visitorPw);

        BoardPost boardPost = boardService.selectSimpleBoardPost(boardName, postSeq);

        Map<String, Object> map = new HashMap<>();

        // 비회원 등록글, 비회원 패스워드 확인
        //        if (boardPost != null && boardPost.getRegUser() <= 0 && visitorPw.equals(boardPost.getPassword())) {
        if (boardPost != null && boardPost.getRegUser() <= 0 && XecureUtil.verifyHash64(visitorPw, boardPost.getPassword())) {
            map.put("result", true);
        } else {
            map.put("result", false);
            // message.notice.008=비밀번호가 일치하지 않습니다
            map.put("message", messages.getMessage("message.notice.008"));
        }

        return map;

    }

    /**
     * 휴대폰 인증 화면
     * 
     * @param boardName
     * @return
     */
    @RequestMapping(value = "/board/{boardName}/auth-phone")
    public ModelAndView boardAuthPhone(@PathVariable(value = "boardName") String boardName) {

        String boardPath = getBoardPath(boardService.selectBoardType(boardName));

        List<Terms> termsList = termsService.selectTermsList();

        ModelAndView mav = new ModelAndView();

        mav.setViewName("/board/" + boardPath + "/auth-phone");

        mav.addObject("boardName", boardName);

        if (termsList != null && termsList.size() > 0) {
            for (Terms terms : termsList) {
                if (TermsType.SERVICE.equals(terms.getTermsType())) {
                    mav.addObject("termsService", terms);
                } else if (TermsType.PRIVACY2.equals(terms.getTermsType())) {
                    mav.addObject("termsPrivacy2", terms);
                } else if (TermsType.PRIVACY3.equals(terms.getTermsType())) {
                    mav.addObject("termsPrivacy3", terms);
                }
            }
        }

        return mav;

    }

    /**
     * 인증번호 전송
     * 
     * @param phoneNumber
     * @return
     */
    @RequestMapping(value = {"/board/{boardName}/auth-req"}, method = RequestMethod.POST)
    @ResponseBody
    public Map<String, Object> phoneAuthReq(HttpServletRequest request, HttpServletResponse response, @PathVariable(value = "boardName") String boardName,
            @RequestParam(value = "birthdate", required = false) String birthdate, @RequestParam(value = "phoneNumber") String phoneNumber) {

        Map<String, Object> map = new HashMap<>();

        // 휴대폰 번호 조회
        if (memberService.existPhoneNumber(phoneNumber)) {
            map.put("result", "N");
            // 이미 등록된 휴대폰번호입니다
            map.put("message", messages.getMessage("message.member.join.004"));
            return map;
        }

        // 인증번호 발송
        String key = smsService.sendMessage(phoneNumber);

        if (StringUtils.isNotEmpty(key)) {
            map.put("result", "Y");
            map.put("key", key);
        } else {
            map.put("result", "N");
        }

        return map;
    }


    /**
     * 인증번호 검증
     * 
     * @param request
     * @param response
     * @param code
     * @param key
     * @return
     */
    @RequestMapping(value = {"/board/{boardName}/auth-check"}, method = RequestMethod.POST)
    @ResponseBody
    public Map<String, Object> phoneAuthCode(HttpServletRequest request, HttpServletResponse response, @PathVariable(value = "boardName") String boardName, @RequestParam(value = "phone") String phone,
            @RequestParam(value = "code") String code, @RequestParam(value = "key") String key) {

        Map<String, Object> map = new HashMap<>();

        if (smsService.checkAuth(code, key, phone)) {

            // 휴대폰 인증 완료 후 방문객 세션 생성
            SessionUtil sessionUtil = new SessionUtil();
            sessionUtil.invalidateAndSaveVisitorSession(request, phone, UserType.QNA);

            String boardPath = getBoardPath(boardService.selectBoardType(boardName));

            String redirectUrl = "/board/" + boardPath + "/write";

            map.put("result", true);
            map.put("redirectUrl", redirectUrl);

        } else {
            map.put("result", false);
        }
        return map;
    }

    /**
     * mobile 더보기
     * 
     * @param searchParam
     * @param boardName
     * @return
     */
    @RequestMapping(value = "/board/{boardName}/list/more")
    @ResponseBody
    public Map<String, Object> boardListMore(BoardPost searchParam, @PathVariable(value = "boardName") String boardName) {

        BoardInfo boardInfo = boardService.selectBoardPostList(boardName, searchParam);

        Map<String, Object> resultMap = new HashMap<>();

        Board board = boardInfo.getBoard();

        List<Map<String, Object>> boardPostList = new ArrayList<>();
        Map<String, Object> map = null;

        if (boardInfo != null && boardInfo.getBoardPostList() != null) {
            for (BoardPost boardPost : boardInfo.getBoardPostList()) {
                map = new HashMap<>();
                map.put("postSeq", boardPost.getPostSeq());
                map.put("categoryNm", boardPost.getCategoryNm());
                if (boardPost.getThumbnail() != null) {
                    map.put("thumbnailSeq", boardPost.getThumbnail().getFileSeq());
                }
                map.put("title", boardPost.getTitle());
                map.put("readCnt", boardPost.getReadCnt());
                map.put("strRegDate", DateUtils.convertDateFormat(boardPost.getRegDate(), "yyyy-MM-dd"));

                // QNA 게시판에서 사용
                if (BoardType.QNA.equals(board.getBoardType())) {
                    map.put("delYn", boardPost.getDelYn());
                    map.put("secYn", boardPost.getSecYn());
                    map.put("hideYn", boardPost.getHideYn());
                    map.put("replyYn", boardPost.getAppend4());
                    map.put("ownerYn", boardPost.getOwnerYn());
                }

                boardPostList.add(map);
            }
        }

        resultMap.put("boardPostList", boardPostList);

        return resultMap;

    }


    // =========================================================================
    // PRIVATE METHOD
    // =========================================================================

    /**
     * 게시판 경로
     * 
     * @param boardType
     * @return
     */
    private String getBoardPath(BoardType boardType) {
        if (boardType != null) {
            return boardType.name().toLowerCase();
        }
        return null;
    }

    /**
     * site prefix
     * 
     * @param request
     * @return
     */
    private String getSitePrefix(HttpServletRequest request) {
        if (isAdminSite(request)) {
            return "admin/";
        } else {
            return "";
        }
    }
}
