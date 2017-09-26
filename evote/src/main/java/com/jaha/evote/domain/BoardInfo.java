/**
 * Copyright (c) 2016 JAHA SMART CORP., LTD ALL RIGHT RESERVED
 */
package com.jaha.evote.domain;

import java.io.Serializable;
import java.util.List;

/**
 * <pre>
 * Class Name : BoardInfo.java
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
public class BoardInfo implements Serializable {

    private static final long serialVersionUID = 2449410170342414786L;

    private Board board;
    private List<BoardPost> boardPostList;
    private List<BoardPost> boardTopList;
    private List<BoardCategory> boardCategoryList;
    private int boardPushDestCount;

    private int totalCount;

    public Board getBoard() {
        return board;
    }

    public void setBoard(Board board) {
        this.board = board;
    }

    public List<BoardPost> getBoardPostList() {
        return boardPostList;
    }

    public void setBoardPostList(List<BoardPost> boardPostList) {
        this.boardPostList = boardPostList;
    }

    public List<BoardPost> getBoardTopList() {
        return boardTopList;
    }

    public void setBoardTopList(List<BoardPost> boardTopList) {
        this.boardTopList = boardTopList;
    }

    public List<BoardCategory> getBoardCategoryList() {
        return boardCategoryList;
    }

    public void setBoardCategoryList(List<BoardCategory> boardCategoryList) {
        this.boardCategoryList = boardCategoryList;
    }

    public int getTotalCount() {
        return totalCount;
    }

    public void setTotalCount(int totalCount) {
        this.totalCount = totalCount;
    }

    public int getBoardPushDestCount() {
        return boardPushDestCount;
    }

    public void setBoardPushDestCount(int boardPushDestCount) {
        this.boardPushDestCount = boardPushDestCount;
    }

}
