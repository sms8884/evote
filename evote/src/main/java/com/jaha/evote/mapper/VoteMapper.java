/**
 * Copyright (c) 2016 JAHA SMART CORP., LTD ALL RIGHT RESERVED
 */
package com.jaha.evote.mapper;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.jaha.evote.domain.VoteMaster;
import com.jaha.evote.domain.VoteRealm;
import com.jaha.evote.domain.type.AgeGroup;

/**
 * <pre>
 * Class Name : VoteMapper.java
 * Description : 투표 매퍼
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
@Mapper
public interface VoteMapper {

    /**
     * 투표정보
     * 
     * @param param
     * @return
     */
    public HashMap<String, Object> getVoteInfo(HashMap<String, Object> param);

    /**
     * 투표리스트 카운트
     * 
     * @param param
     * @return
     */
    public int voteListCount(HashMap<String, Object> param);

    /**
     * 투표리스트
     * 
     * @param param
     * @return
     */
    public List<HashMap<String, Object>> voteList(HashMap<String, Object> param);

    /**
     * 투표 저장
     * 
     * @param param
     * @return
     */
    public int insertVoteMst(HashMap<String, Object> param);

    /**
     * 투표투표분야 저장
     * 
     * @param param
     * @return
     */
    public int insertVoteRealm(HashMap<String, Object> param);

    /**
     * 투표 수정
     * 
     * @param param
     */
    public void updateVoteMst(HashMap<String, Object> param);

    /**
     * 투표 삭제
     * 
     * @param param
     */
    public void deleteVoteMst(HashMap<String, Object> param);

    /**
     * 투표결과
     * 
     * @param param
     * @return
     */
    public List<HashMap<String, Object>> voteResultList(HashMap<String, Object> param);

    /**
     * 투표자 결과
     * 
     * @param param
     * @return
     */
    public List<HashMap<String, Object>> voterResultList(HashMap<String, Object> param);

    /**
     * 투표사업 리스트 개수
     * 
     * @param param
     * @return
     */
    public int voteItemListCount(HashMap<String, Object> param);

    /**
     * 투표사업 리스트
     * 
     * @param param
     * @return
     */
    public List<HashMap<String, Object>> voteItemList(HashMap<String, Object> param);

    /**
     * 투표사업 리스트 & 투표분야명
     * 
     * @param param
     * @return
     */
    public List<HashMap<String, Object>> VoteItemWithRealmList(HashMap<String, Object> param);

    /**
     * 투표사업 정보
     * 
     * @param param
     * @return
     */
    public HashMap<String, Object> getVoteItem(HashMap<String, Object> param);

    /**
     * 투표사업 정보 저장
     * 
     * @param param
     */
    public void insertVoteItem(HashMap<String, Object> param);

    /**
     * 투표사업 정보 업데이트
     * 
     * @param param
     */
    public void updateVoteItem(HashMap<String, Object> param);

    /**
     * 투표사업 정보 삭제
     * 
     * @param param
     */
    public void deleteVoteItem(HashMap<String, Object> param);

    /**
     * 투표 사업 순서조정
     * 
     * @param param
     */
    public void ChOrderVoteItem(HashMap<String, Object> param);


    /**
     * 투표결과 임시저장
     * 
     * @param param
     */
    public void insertVoterChoiceTemp(HashMap<String, Object> param);

    /**
     * 투표결과 임시저장삭제
     * 
     * @param param
     */
    public void deleteVoterChoiceTemp(HashMap<String, Object> param);

    /**
     * 사용자가 선택한 투표사업 정보
     * 
     * @param param
     * @return
     */
    public HashMap<String, Object> getSelectVoteItem(HashMap<String, Object> param);

    /**
     * 투표결과 저장
     * 
     * @param param
     */
    public void insertVoterChoice(HashMap<String, Object> param);

    /**
     * 투표자 정보 저장
     * 
     * @param param
     */
    public void insertVoterInfo(HashMap<String, Object> param);

    /**
     * 사용자가 선택 투표사업 리스트 카운트
     * 
     * @param param
     * @return
     */
    public int voterChoiceListCnt(HashMap<String, Object> param);

    /**
     * 사용자가 선택한 투표사업 리스트
     * 
     * @param param
     * @return
     */
    public List<HashMap<String, Object>> voterChoiceList(HashMap<String, Object> param);

    /**
     * 투표자 정보
     * 
     * @param param
     * @return
     */
    public HashMap<String, Object> getVoterInfo(HashMap<String, Object> param);

    /**
     * 사용자페이지 > 결과 보기
     * 
     * @param param
     * @return
     */
    public List<HashMap<String, Object>> getUserVoteResultList(HashMap<String, Object> param);



    /**
     * 분야 마스터 리스트
     * 
     * @param param
     * @return
     */
    public List<HashMap<String, Object>> realmMastertList(HashMap<String, Object> param);

    /**
     * 분야 마스터 추가
     * 
     * @param param
     */
    public void addRealmMaster(HashMap<String, Object> param);

    /**
     * 분야 마스터 삭제
     * 
     * @param param
     */
    public void deleteRealmMst(HashMap<String, Object> param);

    /**
     * 분야 마스터 순서조정
     * 
     * @param param
     */
    public void ChOrderRealmMaster(HashMap<String, Object> param);

    /**
     * 투표분야 리스트
     * 
     * @param param
     * @return
     */
    public List<HashMap<String, Object>> voteRealmList(HashMap<String, Object> param);

    /**
     * 사용자 페이지 > 상단 분야 정보 리스트
     * 
     * @param param
     * @return
     */
    public List<HashMap<String, Object>> getUserVoteRealmList(HashMap<String, Object> param);

    /**
     * 사용자 페이지 > 투표 상세 > 해당 분야 정보 조회
     * 
     * @param param
     * @return
     */
    public HashMap<String, Object> getUserVoteRealm(HashMap<String, Object> param);

    /**
     * 투표분야 추가
     * 
     * @param param
     */
    public void addVoteRealm(HashMap<String, Object> param);

    /**
     * 투표분야 순서조정
     * 
     * @param param
     */
    public void chOrderVoteRealm(HashMap<String, Object> param);

    /**
     * 투표분야 삭제
     * 
     * @param param
     */
    public void deleteVoteRealm(HashMap<String, Object> param);

    /**
     * 사용자화면 선택항목 조회 쿼리(투표 필수 선택개수, 사용자가 선택한 개수)
     * 
     * @param param
     * @return
     */
    public HashMap<String, Object> getVoteTabCnt(HashMap<String, Object> param);

    /**
     * 투표 순서 조정
     * 
     * @param map
     * @return
     */
    public int updateVoteOrder(Map<String, Object> map);


    //=========================================================================
    // 2차 추가 
    //=========================================================================

    /**
     * 투표 마스터 기존 순서 리셋
     * 
     * @return
     */
    public int updateResetVoteMstOrder();

    /**
     * 투표 마스터 순서 조정
     * 
     * @param map
     * @return
     */
    public int updateVoteMstOrder(Map<String, Object> map);

    /**
     * 비회원 투표자 정보 저장
     * 
     * @param map
     * @return
     */
    public int insertVisitorVoterInfo(Map<String, Object> map);

    /**
     * 투표 분야 목록 조회
     * 
     * @param voteSeq
     * @param ageGroup
     * @return
     */
    public List<VoteRealm> selectVoteRealmList(@Param("voteSeq") long voteSeq, @Param("ageGroup") AgeGroup ageGroup);

    /**
     * 투표 시작 스케줄 조회
     * 
     * @return
     */
    public List<VoteMaster> selectVoteStartSchedule();

    /**
     * 투표 종료 스케줄 조회
     * 
     * @return
     */
    public List<VoteMaster> selectVoteEndSchedule();

    /**
     * 분야 최소값 조회
     * 
     * @param vote_seq
     * @return
     */
    public String selectMinRealmCd(@Param("vote_seq") String vote_seq);

}
