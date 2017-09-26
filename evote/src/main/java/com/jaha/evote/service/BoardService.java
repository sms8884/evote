/**
 * Copyright (c) 2016 JAHA SMART CORP., LTD ALL RIGHT RESERVED
 */
package com.jaha.evote.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.jaha.evote.common.exception.EvoteBizException;
import com.jaha.evote.common.exception.EvoteException;
import com.jaha.evote.common.exception.PageNotFoundException;
import com.jaha.evote.common.util.DateUtils;
import com.jaha.evote.common.util.Messages;
import com.jaha.evote.common.util.NumberUtils;
import com.jaha.evote.common.util.XecureUtil;
import com.jaha.evote.domain.Account;
import com.jaha.evote.domain.AdminUser;
import com.jaha.evote.domain.Board;
import com.jaha.evote.domain.BoardCategory;
import com.jaha.evote.domain.BoardInfo;
import com.jaha.evote.domain.BoardPost;
import com.jaha.evote.domain.Config;
import com.jaha.evote.domain.Email;
import com.jaha.evote.domain.GcmInfo;
import com.jaha.evote.domain.Member;
import com.jaha.evote.domain.common.FileInfo;
import com.jaha.evote.domain.type.BoardType;
import com.jaha.evote.domain.type.CodeType;
import com.jaha.evote.domain.type.ConfigType;
import com.jaha.evote.domain.type.FileGrpType;
import com.jaha.evote.domain.type.FileType;
import com.jaha.evote.domain.type.GcmType;
import com.jaha.evote.domain.type.RoleType;
import com.jaha.evote.domain.type.UserStatus;
import com.jaha.evote.domain.type.UserType;
import com.jaha.evote.mapper.AdminMapper;
import com.jaha.evote.mapper.BoardMapper;
import com.jaha.evote.mapper.ConfigMapper;
import com.jaha.evote.mapper.common.FileMapper;

/**
 * <pre>
 * Class Name : BoardService.java
 * Description : 게시판 서비스
 *  
 * Modification Information
 * 
 * Mod Date         Modifier    Description
 * -----------      --------    ---------------------------
 * 2016. 10. 5.     jjpark      Generation
 * </pre>
 *
 * @author jjpark
 * @since 2016. 10. 5.
 * @version 1.0
 */
@Service
public class BoardService extends BaseService {

    @Autowired
    private GcmService gcmService;

    @Autowired
    private MailService mailService;

    @Autowired
    private BoardMapper boardMapper;

    @Autowired
    private FileMapper fileMapper;

    @Autowired
    private ConfigMapper configMapper;

    @Autowired
    private AdminMapper adminMapper;

    @Autowired
    private Messages messages;

    @Value("${service.site.url}")
    private String serviceSiteUrl;

    /**
     * 최근 게시물 조회
     * 
     * @param boardName
     * @return
     */
    public List<BoardPost> selectRecentBoardPostList(String boardName, int postCount) {

        // 게시판 정보 조회
        Board board = boardMapper.selectBoardByName(boardName);
        if (board == null) {
            throw new PageNotFoundException("### 게시판 정보 없음 ::: boardName [" + boardName + "]");
        }

        Map<String, Object> param = new HashMap<>();
        param.put("siteCd", getSiteCd());
        param.put("boardSeq", board.getBoardSeq());
        if (postCount > 0) {
            param.put("postCount", postCount);
        } else {
            param.put("postCount", 4);
        }

        List<BoardPost> postList = boardMapper.selectRecentBoardPostList(param);

        if (postList != null) {
            for (BoardPost boardPost : postList) {
                boardPost.setImageList(fileMapper.selectFileInfoList(boardPost.getPostSeq(), FileGrpType.BOARD, FileType.IMAGE));
            }
        }
        return postList;
    }

    /**
     * 게시판 정보 조회
     * 
     * @param boardName
     * @return
     */
    public BoardInfo selectBoardInfo(String boardName) {

        // 게시판 정보 조회
        Board board = boardMapper.selectBoardByName(boardName);
        if (board == null) {
            throw new PageNotFoundException("### 게시판 정보 없음 ::: boardName [" + boardName + "]");
        }

        BoardInfo boardInfo = new BoardInfo();

        boardInfo.setBoard(board);

        // 카테고리 사용 여부
        if ("Y".equalsIgnoreCase(board.getCateUseYn())) {
            List<BoardCategory> boardCategoryList = boardMapper.selectBoardCategoryList(board.getBoardSeq());
            boardInfo.setBoardCategoryList(boardCategoryList);
        }

        return boardInfo;
    }

    /**
     * 게시판 타입 조회
     * 
     * @param boardName
     * @return
     */
    public BoardType selectBoardType(String boardName) {

        // 게시판 정보 조회
        Board board = boardMapper.selectBoardByName(boardName);
        if (board == null) {
            throw new PageNotFoundException("### 게시판 정보 없음 ::: boardName [" + boardName + "]");
        }

        return board.getBoardType();
    }

    /**
     * 게시물 목록 조회
     * 
     * @param boardName
     * @param searchParam
     * @return
     */
    public BoardInfo selectBoardPostList(String boardName, BoardPost searchParam) {

        // 게시판 정보 조회
        Board board = boardMapper.selectBoardByName(boardName);
        if (board == null) {
            throw new PageNotFoundException("### 게시판 정보 없음 ::: boardName [" + boardName + "]");
        }

        initSiteInfo(searchParam);

        searchParam.setBoardSeq(board.getBoardSeq());
        searchParam.setRegUser(getUserSeq());

        int totalCount = boardMapper.selectBoardPostListCount(searchParam);

        BoardInfo boardInfo = new BoardInfo();

        boardInfo.setBoard(board);
        boardInfo.setTotalCount(totalCount);

        // 카테고리 사용 여부
        if ("Y".equalsIgnoreCase(board.getCateUseYn())) {
            List<BoardCategory> boardCategoryList = boardMapper.selectBoardCategoryList(board.getBoardSeq());
            boardInfo.setBoardCategoryList(boardCategoryList);
        }

        // 상단 고정 사용 여부
        if ("Y".equalsIgnoreCase(board.getTopUseYn())) {
            List<BoardPost> boardTopList = boardMapper.selectBoardTopList(searchParam);
            boardInfo.setBoardTopList(boardTopList);
        }

        if (totalCount > 0) {

            List<BoardPost> boardPostList = boardMapper.selectBoardPostList(searchParam);

            // 이미지 게시판 여부
            if (BoardType.GALLERY.equals(board.getBoardType())) {

                // 이미지 게시판 썸네일 조회
                List<FileInfo> fileInfo = null;
                for (BoardPost boardPost : boardPostList) {
                    fileInfo = fileMapper.selectFileInfoList(boardPost.getPostSeq(), FileGrpType.BOARD, FileType.IMAGE);
                    if (fileInfo != null && fileInfo.size() > 0) {
                        boardPost.setThumbnail(fileInfo.get(0));
                    }
                }

            } else if (BoardType.QNA.equals(board.getBoardType())) {

                // 복호화
                for (BoardPost boardPost : boardPostList) {
                    decBoardPost(boardPost);
                }
            }

            boardInfo.setBoardPostList(boardPostList);

        }

        return boardInfo;
    }

    /**
     * 게시물 상세 조회
     * 
     * @param boardName
     * @param postSeq
     * @param searchParam
     * @return
     */
    public Map<String, Object> selectBoardPost(String boardName, long postSeq, BoardPost searchParam) {

        // 게시판 정보 조회
        Board board = boardMapper.selectBoardByName(boardName);
        if (board == null) {
            throw new PageNotFoundException("### 게시판 정보 없음 ::: boardName [" + boardName + "]");
        }

        // set site info
        initSiteInfo(searchParam);

        searchParam.setBoardSeq(board.getBoardSeq());
        searchParam.setPostSeq(postSeq);
        searchParam.setRegUser(getUserSeq());

        BoardPost boardPost = boardMapper.selectBoardPost(searchParam);

        if (boardPost == null) {
            throw new PageNotFoundException("### 게시물 정보 없음 ::: boardName [" + boardName + "], postSeq [" + postSeq + "]");
        }

        // 게시판 비밀글 기능 사용 여부
        if (!isAdminSite() && "Y".equals(board.getSecUseYn())) {

            // 비밀글 여부
            if ("Y".equals(boardPost.getSecYn())) {

                // 본인이 작성한 글 여부 OR 비회원 작성 시 등록한 비밀번호 체크
                if (!isOwner(boardPost, searchParam.getPassword())) {
                    throw new EvoteBizException("게시물 보기 권한이 없습니다.");
                }

            }

            // 숨김글 여부
            if ("Y".equals(boardPost.getHideYn())) {
                // message.notice.009=숨김 처리된 글입니다.
                String message = messages.getMessage("message.notice.009");
                throw new EvoteBizException(message);
            }

        }

        // 이미지 사용 여부 
        if ("Y".equalsIgnoreCase(board.getImageUseYn())) {
            boardPost.setImageList(fileMapper.selectFileInfoList(postSeq, FileGrpType.BOARD, FileType.IMAGE));
        }

        // 첨부파일 사용 여부
        if ("Y".equalsIgnoreCase(board.getAttachUseYn())) {
            boardPost.setAttachList(fileMapper.selectFileInfoList(postSeq, FileGrpType.BOARD, FileType.ATTACH));
        }

        // 카테고리 사용 여부
        List<BoardCategory> boardCategoryList = null;
        if ("Y".equalsIgnoreCase(board.getCateUseYn())) {
            boardCategoryList = boardMapper.selectBoardCategoryList(board.getBoardSeq());
        }

        // 게시판 PUSH 발송 대상 카운트
        int boardPushDestCount = -1;
        if ("Y".equalsIgnoreCase(board.getPushUseYn())) {

            Config config = new Config();
            config.setSiteCd(getSiteCd());
            config.setUserStat(UserStatus.AVAILABLE);
            config.setConfigGroup(ConfigType.CONFIG_GROUP_PUSH.getCode());  // 푸시설정그룹
            config.setConfigCode(ConfigType.CONFIG_PUSH_NEW.getCode());     // 새글알림

            // 유효한 회원 중 PUSH 설정이 Y 인 회원 목록
            boardPushDestCount = configMapper.selectPushKeyListCount(config);
        }

        BoardPost prevPost = boardMapper.selectPrevBoardPost(searchParam);  // 이전 게시물
        BoardPost nextPost = boardMapper.selectNextBoardPost(searchParam);  // 다음 게시물

        if (BoardType.GALLERY.equals(board.getBoardType())) {

            // 갤러리 게시판은 이전글, 다음글에 이미지를 추가함

            // 이미지 게시판 썸네일 조회
            List<FileInfo> fileInfo = null;

            if (prevPost != null) {
                fileInfo = fileMapper.selectFileInfoList(prevPost.getPostSeq(), FileGrpType.BOARD, FileType.IMAGE);
                if (fileInfo != null && fileInfo.size() > 0) {
                    prevPost.setThumbnail(fileInfo.get(0));
                }
            }

            if (nextPost != null) {
                fileInfo = fileMapper.selectFileInfoList(nextPost.getPostSeq(), FileGrpType.BOARD, FileType.IMAGE);
                if (fileInfo != null && fileInfo.size() > 0) {
                    nextPost.setThumbnail(fileInfo.get(0));
                }
            }

        } else if (BoardType.QNA.equals(board.getBoardType())) {
            // 질문 게시판 : 비회원 정보 복호화
            decBoardPost(boardPost);
        }

        Map<String, Object> result = new HashMap<>();

        result.put("board", board);
        result.put("boardCategoryList", boardCategoryList);
        result.put("boardPost", boardPost);
        result.put("prevPost", prevPost);
        result.put("nextPost", nextPost);

        // push 발송 대상 인원수 : -1 일 경우 push 대상 없음
        if (boardPushDestCount >= 0) {
            result.put("boardPushDestCount", boardPushDestCount);
        }

        return result;
    }

    /**
     * 조회수 증가
     * 
     * @param boardPost
     * @return
     */
    @Transactional
    public int updateBoardPostReadCount(BoardPost boardPost) {
        return boardMapper.updateBoardPostReadCount(boardPost);
    }

    /**
     * 게시물 등록
     * 
     * @param boardName
     * @param boardPost
     * @return
     */
    @Transactional
    public int insertBoardPost(String boardName, BoardPost boardPost) {

        // 게시판 정보 조회
        Board board = boardMapper.selectBoardByName(boardName);
        if (board == null) {
            throw new PageNotFoundException("### 게시판 정보 없음 :: boardName [" + boardName + "]");
        }

        initSiteInfo(boardPost);

        // 게시판 쓰기 권한 체크
        if (!isAdminSite()) {
            if (RoleType.ADMIN.equals(board.getWriteRole())) {
                // message.notice.007=게시판 쓰기 권한이 없습니다.
                String message = messages.getMessage("message.notice.007");
                throw new EvoteBizException(message);
            }
        }

        // 등록자 정보 셋팅
        boardPost.setRegUser(getUserSeq());

        // 게시판 일련번호 셋팅
        boardPost.setBoardSeq(board.getBoardSeq());


        //=====================================================================
        // 게시물 등록 전 게시판 별 예외사항
        //=====================================================================

        // 문의하기 게시판 예외사항
        if (CodeType.BOARD_NAME_QNA.getCode().equals(board.getBoardName())) {

            /*
             * append1 - 작성자
             * append2 - 휴대폰번호
             * append3 - 이메일
             * append4 - 답변여부(Y/N)
             * append5 - 답변내용
             */

            if (!isAdminSite()) {
                //                if (UserType.VISITOR.equals(getUserType())) {
                if (UserType.QNA.equals(getUserType())) {
                    Member member = getLoginMember();
                    boardPost.setAppend1(boardPost.getAppend1());       // 작성자명
                    boardPost.setAppend2(member.getPhone().getDecValue()); // 휴대폰번호
                    boardPost.setAppend3(boardPost.getAppend3());       // 이메일
                    boardPost.setAppend4("N");  // 답변완료여부
                    encBoardPost(boardPost); // 암호화
                } else {
                    Member member = getLoginMember();
                    boardPost.setAppend1(member.getUserNm().getValue());
                    boardPost.setAppend2(member.getPhone().getValue());
                    boardPost.setAppend3(member.getEmail().getValue());
                    boardPost.setAppend4("N");  // 답변완료여부
                }
            }
        }

        // 게시물 등록
        int result = boardMapper.insertBoardPost(boardPost);

        if (result > 0) {

            // 이미지 파일 등록
            if (boardPost.getImageList() != null && !boardPost.getImageList().isEmpty()) {
                for (FileInfo fileInfo : boardPost.getImageList()) {
                    fileInfo.setFileGrpSeq(boardPost.getPostSeq());
                    fileInfo.setRegUser(getUserSeq());
                    fileMapper.insertFileInfo(fileInfo);
                }
            }

            // 첨부파일 등록
            if (boardPost.getAttachList() != null && !boardPost.getAttachList().isEmpty()) {
                for (FileInfo fileInfo : boardPost.getAttachList()) {
                    fileInfo.setFileGrpSeq(boardPost.getPostSeq());
                    fileInfo.setRegUser(getUserSeq());
                    fileMapper.insertFileInfo(fileInfo);
                }
            }


            //=================================================================
            // SEND GCM
            //=================================================================

            // 게시판 PUSH 사용 여부
            if ("Y".equalsIgnoreCase(board.getPushUseYn())) {

                // 게시물 등록 시 즉시발송이 체크 되어 있을 경우
                // 게시여부가 N 이 아닐 경우
                if ("Y".equalsIgnoreCase(boardPost.getPushYn()) && !"N".equalsIgnoreCase(boardPost.getDpYn())) {

                    GcmInfo gcmInfo = this.getBoardGcmInfo(board, boardPost);

                    if (gcmInfo != null) {

                        Config config = new Config();
                        config.setSiteCd(getSiteCd());
                        config.setUserStat(UserStatus.AVAILABLE);
                        config.setConfigGroup(ConfigType.CONFIG_GROUP_PUSH.getCode());  // 푸시설정그룹
                        config.setConfigCode(ConfigType.CONFIG_PUSH_NEW.getCode());     // 새글알림

                        // 유효한 회원 중 PUSH 설정이 Y 인 회원 목록
                        List<String> pushKeyList = configMapper.selectPushKeyList(config);

                        // PUSH 전송
                        gcmService.send(gcmInfo, pushKeyList, ConfigType.CONFIG_PUSH_NEW.getCode());

                        // PUSH 플래그, PUSH 전송일시 수정
                        boardMapper.updatePushSendResult(boardPost);
                    }

                }

            }


            //=================================================================
            // SEND MAIL
            //=================================================================

            // QNA 타입 게시판은 작성 후 관리자에게 메일 발송
            if (!isAdminSite() && BoardType.QNA.equals(board.getBoardType())) {

                Member loginMember = getLoginMember();

                String regUserNm = "";
                if (loginMember != null && !UserType.QNA.equals(getUserType())) {
                    regUserNm = loginMember.getUserNm().getValue();
                } else {
                    regUserNm = boardPost.getAppend1();
                }

                String regDate = DateUtils.getDate("yyyy.MM.dd");
                String title = boardPost.getTitle();
                String cont = boardPost.getCont();

                List<AdminUser> adminList = adminMapper.selectMailReceiveManagerList(getSiteCd());

                if (adminList != null) {
                    Email email = null;
                    for (AdminUser adminUser : adminList) {
                        email = new Email();
                        email.setSubject(title);
                        email.setReciver(adminUser.getMgrEmail().getDecValue());
                        email.setContent(getWriteMailContents(XecureUtil.decString(regUserNm), regDate, title, cont));
                        mailService.sendEmail(email);
                    }
                }

            }

        }

        return result;
    }

    /**
     * 게시물 수정
     * 
     * @param boardName
     * @param boardPost
     * @param deleteFile
     * @return
     */
    @Transactional
    public int updateBoardPost(String boardName, BoardPost boardPost, String deleteFile) {

        // 게시판 정보 조회
        Board board = boardMapper.selectBoardByName(boardName);
        if (board == null) {
            throw new PageNotFoundException("### 게시판 정보 없음 ::: boardName [" + boardName + "]");
        }

        initSiteInfo(boardPost);

        // 수정자 정보 셋팅
        boardPost.setModUser(getUserSeq());
        boardPost.setRegUser(getUserSeq());

        // 게시판 일련번호 셋팅
        boardPost.setBoardSeq(board.getBoardSeq());

        // 기존 게시물 조회
        BoardPost orgBoardPost = boardMapper.selectBoardPost(boardPost);

        if (orgBoardPost == null) {
            throw new PageNotFoundException("### 게시물 정보 없음 ::: boardName [" + boardName + "], postSeq [" + boardPost.getPostSeq() + "]");
        }

        // 게시물 수정 권한 체크
        if (!isOwner(orgBoardPost, boardPost.getPassword())) {
            throw new EvoteBizException("게시물 수정 권한이 없습니다.");
        }


        //=====================================================================
        // 게시물 수정 전 게시판 별 예외사항
        //=====================================================================

        if (CodeType.BOARD_NAME_QNA.getCode().equals(board.getBoardName())) {

            // 문의하기 관리자 수정 시 타이틀, 내용이 없기 때문에 기존 게시물 정보를 셋팅
            if (isAdminSite()) {
                boardPost.setTitle(orgBoardPost.getTitle());
                boardPost.setCont(orgBoardPost.getCont());
                boardPost.setCategoryCd(orgBoardPost.getCategoryCd());
                boardPost.setAppend4("Y");  // 답변완료여부
            }

            encBoardPost(boardPost); // 암호화
        }


        int result = boardMapper.updateBoardPost(boardPost);

        if (result > 0) {

            // 파일 삭제
            if (StringUtils.isNotEmpty(deleteFile)) {

                String[] deleteFiles = deleteFile.split("[|]");
                FileInfo fileInfo = null;
                long tmpFileSeq = 0L;

                for (String delFileSeq : deleteFiles) {
                    tmpFileSeq = NumberUtils.toLong(delFileSeq, 0L);
                    fileInfo = new FileInfo();
                    fileInfo.setFileSeq(NumberUtils.toLong(delFileSeq, 0L));
                    fileInfo.setModUser(getUserSeq());
                    if (tmpFileSeq > 0) {
                        fileMapper.deleteFileInfo(fileInfo);
                    }
                }

            }

            // 이미지 파일 등록
            if (boardPost.getImageList() != null && !boardPost.getImageList().isEmpty()) {
                for (FileInfo fileInfo : boardPost.getImageList()) {
                    fileInfo.setFileGrpSeq(boardPost.getPostSeq());
                    fileInfo.setRegUser(getUserSeq());
                    fileMapper.insertFileInfo(fileInfo);
                }
            }

            // 첨부파일 등록
            if (boardPost.getAttachList() != null && !boardPost.getAttachList().isEmpty()) {
                for (FileInfo fileInfo : boardPost.getAttachList()) {
                    fileInfo.setFileGrpSeq(boardPost.getPostSeq());
                    fileInfo.setRegUser(getUserSeq());
                    fileMapper.insertFileInfo(fileInfo);
                }
            }

            //=================================================================
            // SEND GCM
            //=================================================================

            // 게시판 PUSH 사용 여부
            if ("Y".equalsIgnoreCase(board.getPushUseYn())) {

                // 원본 게시물에 PUSH가 발송되지 않았고, 
                // 게시물 수정 시 PUSH 즉시발송이 체크되어 있는 경우
                // 게시여부가 N 이 아닐 경우
                if (!"Y".equalsIgnoreCase(orgBoardPost.getPushSendYn()) && "Y".equalsIgnoreCase(boardPost.getPushYn()) && !"N".equalsIgnoreCase(boardPost.getDpYn())) {

                    GcmInfo gcmInfo = this.getBoardGcmInfo(board, boardPost);

                    if (gcmInfo != null) {

                        Config config = new Config();
                        config.setSiteCd(getSiteCd());
                        config.setUserStat(UserStatus.AVAILABLE);
                        config.setConfigGroup(ConfigType.CONFIG_GROUP_PUSH.getCode());  // 푸시설정그룹
                        config.setConfigCode(ConfigType.CONFIG_PUSH_NEW.getCode());     // 새글알림

                        // 유효한 회원 중 PUSH 설정이 Y 인 회원 목록
                        List<String> pushKeyList = configMapper.selectPushKeyList(config);

                        // PUSH 전송
                        gcmService.send(gcmInfo, pushKeyList, ConfigType.CONFIG_PUSH_NEW.getCode());

                        // PUSH 플래그, PUSH 전송일시 수정
                        boardMapper.updatePushSendResult(boardPost);
                    }

                }

            }


            //=================================================================
            // SEND MAIL
            //=================================================================

            // QNA 타입 게시판은 관리자가 답변 작성 후 작성자에게 메일 발송
            if (isAdminSite() && BoardType.QNA.equals(board.getBoardType()) && !"Y".equals(orgBoardPost.getAppend4())) {

                String regUserNm = XecureUtil.decString(orgBoardPost.getAppend1());
                String regDate = DateUtils.convertDateFormat(orgBoardPost.getRegDate(), "yyyy.MM.dd");
                String regDate2 = DateUtils.convertDateFormat(orgBoardPost.getRegDate(), "yyyy년 MM월 dd일");
                String title = orgBoardPost.getTitle();
                String cont = orgBoardPost.getCont();
                String replyDate = DateUtils.getDate("yyyy.MM.dd");
                String replyCont = boardPost.getAppend5();

                String desReciver = XecureUtil.decString(orgBoardPost.getAppend3());

                Email email = new Email();
                email.setSubject("문의하기 답변이 등록되었습니다.");
                email.setReciver(desReciver);
                email.setContent(getReplyMailContents(regUserNm, regDate, regDate2, title, cont, replyDate, replyCont));
                mailService.sendEmail(email);
            }

        }

        return result;
    }

    /**
     * 게시물 삭제
     * 
     * @param boardName
     * @param boardPost
     * @return
     */
    @Transactional
    public int deleteBoardPost(String boardName, BoardPost boardPost) {

        // 게시판 정보 조회
        Board board = boardMapper.selectBoardByName(boardName);
        if (board == null) {
            throw new PageNotFoundException("### 게시판 정보 없음 ::: boardName [" + boardName + "]");
        }

        initSiteInfo(boardPost);

        // 기존 게시물 조회
        boardPost.setBoardSeq(board.getBoardSeq());
        BoardPost orgBoardPost = boardMapper.selectBoardPost(boardPost);

        if (orgBoardPost == null) {
            throw new PageNotFoundException("### 게시물 정보 없음 ::: boardName [" + boardName + "], postSeq [" + boardPost.getPostSeq() + "]");
        }

        // 게시물 삭제 권한 체크
        if (!isOwner(orgBoardPost, boardPost.getPassword())) {
            throw new EvoteBizException("게시물 삭제 권한이 없습니다.");
        }

        boardPost.setModUser(getUserSeq());

        return boardMapper.deleteBoardPost(boardPost);

    }

    /**
     * 게시물 PUSH 전송
     * 
     * @param boardName
     * @param postSeq
     * @return
     */
    @Transactional
    public BoardPost sendBoardGcm(String boardName, long postSeq) {

        // 게시판 정보 조회
        Board board = boardMapper.selectBoardByName(boardName);
        if (board == null) {
            throw new PageNotFoundException("### 게시판 정보 없음 ::: boardName [" + boardName + "]");
        }

        BoardPost boardPost = new BoardPost();

        initSiteInfo(boardPost);

        // 게시물 번호 셋팅
        boardPost.setPostSeq(postSeq);

        // 수정자 정보 셋팅
        boardPost.setModUser(getUserSeq());

        // 게시판 일련번호 셋팅
        boardPost.setBoardSeq(board.getBoardSeq());

        // 기존 게시물 조회
        BoardPost orgBoardPost = boardMapper.selectBoardPost(boardPost);

        if (orgBoardPost == null) {
            throw new PageNotFoundException("### 게시물 정보 없음 ::: boardName [" + boardName + "], postSeq [" + boardPost.getPostSeq() + "]");
        }

        //=================================================================
        // SEND GCM
        //=================================================================

        // 게시판 PUSH 사용 여부
        if ("Y".equalsIgnoreCase(board.getPushUseYn())) {

            // 원본 게시물에 PUSH가 발송되지 않았고, 
            // 게시물 수정 시 PUSH 즉시발송이 체크되어 있는 경우
            // 게시여부가 N 이 아닐 경우
            if (!"Y".equalsIgnoreCase(orgBoardPost.getPushSendYn()) && !"N".equalsIgnoreCase(orgBoardPost.getDpYn())) {

                GcmInfo gcmInfo = this.getBoardGcmInfo(board, orgBoardPost);

                if (gcmInfo != null) {

                    Config config = new Config();
                    config.setSiteCd(getSiteCd());
                    config.setUserStat(UserStatus.AVAILABLE);
                    config.setConfigGroup(ConfigType.CONFIG_GROUP_PUSH.getCode());  // 푸시설정그룹
                    config.setConfigCode(ConfigType.CONFIG_PUSH_NEW.getCode());     // 새글알림

                    // 유효한 회원 중 PUSH 설정이 Y 인 회원 목록
                    List<String> pushKeyList = configMapper.selectPushKeyList(config);

                    // PUSH 전송
                    gcmService.send(gcmInfo, pushKeyList, ConfigType.CONFIG_PUSH_NEW.getCode());

                    // PUSH 플래그, PUSH 전송일시 수정
                    boardMapper.updatePushSendResult(boardPost);

                    BoardPost newBoardPost = boardMapper.selectBoardPost(boardPost);

                    logger.debug("### PushSendDate :: [{}]", newBoardPost.getPushSendDate());

                    return newBoardPost;
                }

            }

        } else {
            logger.info("### Push Not Used :: [{}], [{}]", board.getBoardName(), board.getPushUseYn());
        }

        return null;

    }

    /**
     * 게시물 차단/해제
     * 
     * @param postSeq
     * @param hideYn
     * @return
     */
    public int updateBoardPostHideYn(long postSeq, String hideYn) {
        Account account = getAccount();
        if (account != null && account.isAdmin()) {
            Map<String, Object> param = new HashMap<>();
            param.put("postSeq", postSeq);
            param.put("hideYn", hideYn);
            param.put("modUser", getUserSeq());

            return boardMapper.updateBoardPostHideYn(param);
        }
        return -1;
    }

    /**
     * 심플 게시판 정보 조회
     * 
     * @param boardName
     * @return
     */
    public Board selectSimpleBoard(String boardName) {
        return boardMapper.selectBoardByName(boardName);
    }

    /**
     * 심플 게시물 정보 조회
     * 
     * @param boardName
     * @param postSeq
     * @return
     */
    public BoardPost selectSimpleBoardPost(String boardName, long postSeq) {

        // 게시판 정보 조회
        Board board = boardMapper.selectBoardByName(boardName);

        if (board == null) {
            return null;
        }

        BoardPost searchParam = new BoardPost();

        // set site info
        initSiteInfo(searchParam);

        searchParam.setBoardSeq(board.getBoardSeq());
        searchParam.setPostSeq(postSeq);

        return boardMapper.selectBoardPost(searchParam);

    }


    //=========================================================================
    // PRIVATE METHOD
    //=========================================================================

    /**
     * GCM 정보 생성
     * 
     * @param board
     * @param boardPost
     * @return
     */
    private GcmInfo getBoardGcmInfo(Board board, BoardPost boardPost) {

        GcmInfo gcmInfo = null;

        if (board != null && boardPost != null && "Y".equalsIgnoreCase(board.getPushUseYn())) {
            gcmInfo = new GcmInfo();
            gcmInfo.setGcmType(GcmType.BOARD);
            gcmInfo.setPushMessage(messages.getMessage("push.post.new", board.getBoardTitle(), boardPost.getTitle()));
            //gcmInfo.setReturnUrl(serviceSiteUrl + "/board" + "/" + board.getBoardName() + "/" + boardPost.getPostSeq());
            gcmInfo.setArgs(new String[] {board.getBoardName(), String.valueOf(boardPost.getPostSeq())});
        }

        return gcmInfo;
    }

    /**
     * 게시물 권한 체크
     * 
     * @param orgBoardPost
     * @param visitorPassword
     * @return
     */
    private boolean isOwner(BoardPost orgBoardPost, String visitorPassword) {
        if (!isAdminSite()) {
            if (orgBoardPost.getRegUser() > 0 && !"Y".equals(orgBoardPost.getOwnerYn())) {
                return false;
                //            } else if (orgBoardPost.getPassword() != null && !orgBoardPost.getPassword().equals(visitorPassword)) {
            } else if (orgBoardPost.getPassword() != null && !XecureUtil.verifyHash64(visitorPassword, orgBoardPost.getPassword())) {
                return false;
            }
        }
        return true;
    }

    /**
     * Admin 권한, site_cd 셋팅
     * 
     * @param boardPost
     */
    private void initSiteInfo(BoardPost boardPost) {

        Account account = getAccount();

        boolean isAdminSite = isAdminSite();

        if (isAdminSite) {
            if (account == null || !account.isAdmin()) {
                throw new EvoteException("### 관리자 권한 오류");
            }
        }

        if (boardPost == null) {
            boardPost = new BoardPost();
        }

        // set site code
        boardPost.setSiteCd(getSiteCd());

        // set admin site
        if (isAdminSite) {
            boardPost.setAdminYn("Y");
        } else {
            boardPost.setAdminYn("N");
        }

    }

    /**
     * 문의하기 등록 메일 템플릿
     * 
     * @param regUserNm
     * @param regDate
     * @param title
     * @param cont
     * @return
     */
    private String getWriteMailContents(String regUserNm, String regDate, String title, String cont) {

        /* @formatter:off */
        String mailContents = "<div class='wrapper' style='background-color:#fff; width:100%;'><div class='containerWrap'><div class='email_table2'>"
                            + "<div class='email_top' style='width:760px; height:65px; margin:20px auto; text-align:center; '><a href='#' style='display:inline-block;'>"
                            + "<img src='http://e-gov.co.kr/resources/img/logo_email.png' alt='로고이미지'/></a></div>"
                            + "<table style='width:760px; height:80px; margin:10px auto; border:6px solid #00ce3e; padding:15px 60px; text-align:center;'>"
                            + "<tbody><tr><td><p class='txt1' style='display:inline-block; font-size:30px; font-weight:bold; height:80px; line-height:80px; margin:0;'>"
                            + "<span style='font-size:30px; font-weight:bold; color:#00ce3e;'>문의</span>가 등록되었습니다.</p></td></tr></tbody></table>"
                            + "<table cellpadding='0' cellspacing='0' summary='' style='width:760px; margin:0 auto; border:6px solid #e1e1e1; margin-bottom:50px;'>"
                            + "<colgroup><col width='15%'/><col width='*'/></colgroup><tbody>"
                            + "<tr><th style='padding:18px; background:#f9f9f9; border-bottom:1px solid #e1e1e1; border-right:1px solid #e1e1e1; font-size:15px; text-align:center; color:#a0a0a0; font-weight:normal;'>"
                            + "문의자</th><td style='padding:10px; border-bottom:1px solid #e6e6e6; border-right:1px solid #e6e6e6; font-size:14px; line-height:150%;'>" 
                            + regUserNm 
                            + "</td></tr>"
                            + "<tr><th style='padding:18px; background:#f9f9f9; border-bottom:1px solid #e1e1e1; border-right:1px solid #e1e1e1; font-size:15px; text-align:center; color:#a0a0a0; font-weight:normal;'>"
                            + "등록일<td style='padding:10px; border-bottom:1px solid #e6e6e6; border-right:1px solid #e6e6e6; font-size:14px; line-height:150%;'>" 
                            + regDate 
                            + "</td></tr>"
                            + "<tr><th style='padding:18px; background:#f9f9f9; border-bottom:1px solid #e1e1e1; border-right:1px solid #e1e1e1; font-size:15px; text-align:center; color:#a0a0a0; font-weight:normal;'>"
                            + "제목</th><td style='padding:10px; border-bottom:1px solid #e6e6e6; border-right:1px solid #e6e6e6; font-size:14px; line-height:150%; '>"
                            + title
                            + "</td></tr>"
                            + "<tr><th style='padding:18px; background:#f9f9f9; border-bottom:1px solid #e1e1e1; border-right:1px solid #e1e1e1; font-size:15px; text-align:center; color:#a0a0a0; font-weight:normal;'>"
                            + "문의내용</th><td style='padding:10px; border-bottom:1px solid #e6e6e6; border-right:1px solid #e6e6e6; font-size:14px; line-height:150%;'>"
                            + cont.replace("\n", "<br/>")
                            + "</td></tr>"
                            + "<tr><td colspan='2' class='blue_txt' style='font-size:14px; color:#6d6d6d; height:30px; padding:10px;'>"
                            + "<span style='font-size:14px; color:#1278e1;'>※'관리자 홈페이지 > 주민알림 > 문의하기'</span>에서도 문의내용을 확인하실 수 있습니다.</td></tr></tbody></table></div>"
                            + "<div class='email_noti' style='width:760px; margin:0 auto; height:50px; text-align:center;'>"
                            + "<p style='width:500px; height:50px; display:inline-block; font-size:15px;  color:#6d6d6d; line-height:50px; letter-spacing:2px;'>본 메일은 발신전용 메일이므로 회신되지 않습니다.</p>"
                            + "</div></div></div>";
        /* @formatter:on */

        return mailContents;
    }

    /**
     * 문의하기 답변 메일 템플릿
     * 
     * @param regUserNm
     * @param regDate
     * @param regDate2
     * @param title
     * @param cont
     * @param replyDate
     * @param replyCont
     * @return
     */
    private String getReplyMailContents(String regUserNm, String regDate, String regDate2, String title, String cont, String replyDate, String replyCont) {

        /* @formatter:off */
        String mailContents = "<div class='wrapper' style='background-color:#fff; width:100%;'><div class='containerWrap'><div class='email_table' style='width:760px; margin:0 auto; '>"
                            + "<div class='email_top' style='width:760px; height:65px; margin:20px auto; text-align:center; '><a href='#' style='display:inline-block;'>"
                            + "<img src='http://e-gov.co.kr/resources/img/logo_email.png' alt='로고이미지'/></a></div>"
                            + "<table  style='width:760px; height:150px; margin:10px auto; border:6px solid #00ce3e; padding:15px 60px; text-align:center;'>"
                            + "<tbody><tr><td><p class='txt1' style='display:inline-block; font-size:30px; font-weight:bold; height:50px; line-height:30px; margin:0;'>"
                            + "<span style='font-size:30px; font-weight:bold; color:#00ce3e;'>문의하기</span> 답변이 등록되었습니다.</p>"
                            + "<p class='txt2' style='display:inline-block; font-size:16px; font-weight:bold; color:#6d6d6d; height:20px; line-height:20px; margin:0 auto;'>"
                            + regUserNm + "님&nbsp;"
                            + regDate2 + " 문의하신 내용에 대한 답변을 보내드립니다."
                            + "</p></td></tr></tbody></table><table cellpadding='0' cellspacing='0'  summary='' style='border:6px solid #e1e1e1; width:760px;' >"
                            + "<colgroup><col width='15%'/><col width='*'/></colgroup><tbody><tr>"
                            + "<th style=' padding:18px; background:#f9f9f9; border-bottom:1px solid #e1e1e1; border-right:1px solid #e1e1e1; font-size:15px; text-align:center; color:#a0a0a0; font-weight:normal;'>"
                            + "등록일</th><td style='padding:10px; border-bottom:1px solid #e6e6e6; border-right:1px solid #e6e6e6; font-size:14px; line-height:150%;'>"
                            + regDate
                            + "</td></tr><tr>"
                            + "<th style=' padding:18px; background:#f9f9f9; border-bottom:1px solid #e1e1e1; border-right:1px solid #e1e1e1; font-size:15px; text-align:center; color:#a0a0a0; font-weight:normal;'>"
                            + "제목</th><td style='padding:10px; border-bottom:1px solid #e6e6e6; border-right:1px solid #e6e6e6; font-size:14px; line-height:150%;'>"
                            + title
                            + "</td></tr><tr><th style=' padding:18px; background:#f9f9f9; border-bottom:1px solid #e1e1e1; border-right:1px solid #e1e1e1; font-size:15px; text-align:center; color:#a0a0a0; font-weight:normal;'>"
                            + "문의내용</th><td style='padding:10px; border-bottom:1px solid #e6e6e6; border-right:1px solid #e6e6e6; font-size:14px; line-height:150%;'>"
                            + cont.replace("\n", "<br/>")
                            + "</td></tr><tr><th style=' padding:18px; background:#f9f9f9; border-bottom:1px solid #e1e1e1; border-right:1px solid #e1e1e1; font-size:15px; text-align:center; color:#a0a0a0; font-weight:normal;'>"
                            + "답변일</th><td style='padding:10px; border-bottom:1px solid #e6e6e6; border-right:1px solid #e6e6e6; font-size:14px; line-height:150%;'>"
                            + replyDate
                            + "</td></tr><tr><th style=' padding:18px; background:#f9f9f9; border-bottom:1px solid #e1e1e1; border-right:1px solid #e1e1e1; font-size:15px; text-align:center; color:#a0a0a0; font-weight:normal;'>"
                            + "답변내용</th><td style='padding:10px; border-bottom:1px solid #e6e6e6; border-right:1px solid #e6e6e6; font-size:14px; line-height:150%;'>"
                            + replyCont.replace("\n", "<br/>")
                            + "</td></tr></tbody></table></div><div class='inquiry_move' style='width:760px; margin:50px auto 30px; text-align:center;'>"
                          //  + "<a href='#' class='im' style='width:200px; height:40px; padding:13px 30px; color:#fff; background: #1278e1; font-size: 18px; display: inline-block; line-height:40px; text-decoration:none;'>문의하기 이동</a>"
                            + "</div><div class='email_noti' style='width:760px; margin:0 auto; height:50px; text-align:center;'>"
                            + "<p style='width:500px; height:50px; display:inline-block; font-size:15px; color:#6d6d6d; line-height:50px; letter-spacing:2px;'>본 메일은 발신전용 메일이므로 회신되지 않습니다.</p></div></div></div>";
        /* @formatter:on */

        return mailContents;
    }

    private void decBoardPost(final BoardPost boardPost) {
        if (boardPost != null) {
            boardPost.setAppend1(XecureUtil.decString(boardPost.getAppend1()));
            boardPost.setAppend2(XecureUtil.decString(boardPost.getAppend2()));
            boardPost.setAppend3(XecureUtil.decString(boardPost.getAppend3()));
        }
    }

    private void encBoardPost(BoardPost boardPost) {
        if (boardPost != null) {
            boardPost.setAppend1(XecureUtil.encString(boardPost.getAppend1()));  // 암호화
            boardPost.setAppend2(XecureUtil.encString(boardPost.getAppend2()));  // 암호화
            boardPost.setAppend3(XecureUtil.encString(boardPost.getAppend3()));  // 암호화
            boardPost.setPassword(XecureUtil.hash64(boardPost.getPassword()));   // 암호화
        }
    }
}
