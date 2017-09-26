/**
 * Copyright (c) 2016 JAHA SMART CORP., LTD ALL RIGHT RESERVED
 */
package com.jaha.evote.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.jaha.evote.domain.Board;
import com.jaha.evote.domain.BoardCategory;
import com.jaha.evote.domain.BoardPost;

/**
 * <pre>
 * Class Name : BoardMapper.java
 * Description : Description
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
@Mapper
public interface BoardMapper {

    /**
     * 게시판 정보 조회 : 게시판 일련번호
     * 
     * @param boardSeq
     * @return
     */
    public Board selectBoardBySeq(long boardSeq);

    /**
     * 게시판 정보 조회 : 게시판 이름
     * 
     * @param boardName
     * @return
     */
    public Board selectBoardByName(String boardName);

    /**
     * 게시판 카테고리 목록 조회
     * 
     * @param boardSeq
     * @return
     */
    public List<BoardCategory> selectBoardCategoryList(long boardSeq);

    /**
     * 게시물 카운트
     * 
     * @param boardPost
     * @return
     */
    public int selectBoardPostListCount(BoardPost boardPost);

    /**
     * 게시물 목록 조회
     * 
     * @param boardPost
     * @return
     */
    public List<BoardPost> selectBoardPostList(BoardPost boardPost);

    /**
     * 상단고정 게시물 목록 조회
     * 
     * @param boardPost
     * @return
     */
    public List<BoardPost> selectBoardTopList(BoardPost boardPost);

    /**
     * 게시물 조회수 증가
     * 
     * @param boardPost
     * @return
     */
    public int updateBoardPostReadCount(BoardPost boardPost);

    /**
     * 게시물 상세 조회
     * 
     * @param boardPost
     * @return
     */
    public BoardPost selectBoardPost(BoardPost boardPost);

    /**
     * 이전 게시물 조회
     * 
     * @param boardPost
     * @return
     */
    public BoardPost selectPrevBoardPost(BoardPost boardPost);

    /**
     * 다음 게시물 조회
     * 
     * @param boardPost
     * @return
     */
    public BoardPost selectNextBoardPost(BoardPost boardPost);

    /**
     * 이전 게시물 조회(검색조건 포함)
     * 
     * @param boardPost
     * @return
     */
    public BoardPost selectPrevBoardPostWithSearch(BoardPost boardPost);

    /**
     * 다음 게시물 조회(검색조건 포함)
     * 
     * @param boardPost
     * @return
     */
    public BoardPost selectNextBoardPostWithSearch(BoardPost boardPost);

    /**
     * 게시물 등록
     * 
     * @param boardPost
     * @return
     */
    public int insertBoardPost(BoardPost boardPost);

    /**
     * 게시물 수정
     * 
     * @param boardPost
     * @return
     */
    public int updateBoardPost(BoardPost boardPost);

    /**
     * 게시물 삭제
     * 
     * @param boardPost
     * @return
     */
    public int deleteBoardPost(BoardPost boardPost);

    /**
     * 푸시 발송 여부 수정
     * 
     * @param boardPost
     * @return
     */
    public int updatePushSendResult(BoardPost boardPost);

    /**
     * 메인 공지사항 목록 조회
     * 
     * @param param
     * @return
     */
    public List<BoardPost> selectRecentBoardPostList(Map<String, Object> param);

    /**
     * 게시물 숨김 여부 처리
     * 
     * @param param
     * @return
     */
    public int updateBoardPostHideYn(Map<String, Object> param);
}
