/**
 * Copyright (c) 2016 JAHA SMART CORP., LTD ALL RIGHT RESERVED
 */
package com.jaha.evote.mapper;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.jaha.evote.domain.PropComment;
import com.jaha.evote.domain.Proposal;
import com.jaha.evote.domain.ProposalAudit;
import com.jaha.evote.domain.Pssrp;

/**
 * <pre>
 * Class Name : ProposalMapper.java
 * Description : 정책제안 매퍼
 *  
 * Modification Information
 * 
 * Mod Date         Modifier    Description
 * -----------      --------    ---------------------------
 * 2016. 7. 14.     shavrani      Generation
 * </pre>
 *
 * @author shavrani
 * @since 2016. 7. 14.
 * @version 1.0
 */
@Mapper
public interface ProposalMapper {

    /**
     * 메인화면 정책제안 리스트
     * 
     * @return
     */
    public List<Proposal> selectMainProposalList(@Param("siteCd") String siteCd);

    /**
     * 정책제안 리스트 조회
     * 
     * @param params
     * @return
     */
    public List<Proposal> selectProposalList(Map<String, Object> params);

    /**
     * 정책제안 엑셀 리스트 조회
     * 
     * @param params
     * @return
     */
    public List<HashMap<String, Object>> selectProposalListExcel(Map<String, Object> params);

    /**
     * 정책제안 리스트 조회결과 limit 없이 count
     * 
     * @param params
     * @return
     */
    public int selectProposalListCount(Map<String, Object> params);

    /**
     * 정책제안 단일 조회
     * 
     * @param params
     * @return
     */
    public Proposal selectProposal(Map<String, Object> params);

    /**
     * 정책제안 저장 ( ON DUPLICATE KEY UPDATE )
     * 
     * @param proposal
     * @return
     */
    public int saveProposal(Proposal proposal);

    /**
     * proposal 테이블 단일 컬럼 변경 ( params에 컬럼명과 변경될 데이터, mod_user/date 기록유무 )
     * 
     * @param params
     * @return
     */
    public int updateProposalItem(Map<String, Object> params);

    /**
     * 제안 삭제
     * 
     * @param params
     * @return
     */
    public int deleteProposal(Map<String, Object> params);

    /**
     * 제안 삭제(delete_yn = 'Y' 로 수정)
     * 
     * @param propSeq
     * @return
     */
    public int deleteVisitorProposal(long propSeq);

    /**
     * 제안공감 단일 조회
     * 
     * @param params
     * @return
     */
    public Map<String, Object> selectSympathy(Map<String, Object> params);

    /**
     * 제안공감 count
     * 
     * @param params
     * @return
     */
    public int selectSympathyCount(Map<String, Object> params);

    /**
     * 제안공감 저장
     * 
     * @param params
     * @return
     */
    public int insertSympathy(Map<String, Object> params);

    /**
     * 제안공감 삭제
     * 
     * @param params
     * @return
     */
    public int deleteSympathy(Map<String, Object> params);

    /**
     * 댓글 리스트 조회
     * 
     * @param params
     * @return
     */
    public List<PropComment> selectCommentList(Map<String, Object> params);

    /**
     * 댓글 단일 조회
     * 
     * @param params
     * @return
     */
    public PropComment selectComment(Map<String, Object> params);

    /**
     * 댓글 저장 ( ON DUPLICATE KEY UPDATE )
     * 
     * @param propComment
     * @return
     */
    public int saveComment(PropComment propComment);

    /**
     * 댓글 숨김
     * 
     * @param params
     * @return
     */
    public int hideComment(Map<String, Object> params);

    /**
     * 댓글 동의/비동의 저장 ( ON DUPLICATE KEY UPDATE )
     * 
     * @param params
     * @return
     */
    public int saveCommentAgree(Map<String, Object> params);

    /**
     * 댓글 신고 단일 조회
     * 
     * @param params
     * @return
     */
    public Map<String, Object> selectCommentReport(Map<String, Object> params);

    /**
     * 댓글 신고 저장
     * 
     * @param params
     * @return
     */
    public int insertCommentReport(Map<String, Object> params);

    /**
     * 댓글 삭제
     * 
     * @param params
     * @return
     */
    public int deleteComment(Map<String, Object> params);

    /**
     * 댓글 신고 삭제
     * 
     * @param params
     * @return
     */
    public int deleteCommentAgree(Map<String, Object> params);

    /**
     * 댓글 동의/비동의 삭제
     * 
     * @param params
     * @return
     */
    public int deleteCommentReport(Map<String, Object> params);

    /**
     * 정책제안검토 저장 ( ON DUPLICATE KEY UPDATE )
     * 
     * @param proposalAudit
     * @return
     */
    public int saveProposalAudit(ProposalAudit proposalAudit);

    /**
     * 정책제안검토 단일 조회
     * 
     * @param params
     * @return
     */
    public ProposalAudit selectProposalAudit(Map<String, Object> params);

    /**
     * 정책제안 상태값 저장
     * 
     * @param proposalAudit
     * @return
     */
    public int saveProposalStatus(ProposalAudit proposalAudit);

    /**
     * 방문객 제안 수정
     * 
     * @param proposal
     * @return
     */
    public int updateVisitorProposal(Proposal proposal);


    /**
     * 공모 리스트
     * 
     * @param params
     * @return
     */
    public List<Pssrp> selectPssrpList(Map<String, Object> params);

    /**
     * 공모 리스트 총 카운트
     * 
     * @param params
     * @return
     */

    public int selectPssrpListCount(Map<String, Object> params);

    /**
     * 공모 정보
     * 
     * @param params
     * @return
     */

    public Pssrp getPssrp(Map<String, Object> params);

    /**
     * 공모 정보 저장
     * 
     * @param params
     * @return
     */

    public int insertPssrp(Pssrp params);

    /**
     * 공모 정보 업데이트
     * 
     * @param params
     * @return
     */

    public void updatePssrp(Pssrp params);

    /**
     * 공모 정보 종료 및 삭제
     * 
     * @param params
     * @return
     */
    public void endPssrp(Map<String, Object> params);

    /**
     * 사용자 댓글 목록 갯수
     * 
     * @param param
     * @return
     */
    public int selectUserCommentCount(Map<String, Object> param);

    /**
     * 사용자 댓글 목록 조회
     * 
     * @param param
     * @return
     */
    public List<Map<String, Object>> selectUserCommentList(Map<String, Object> param);

}
