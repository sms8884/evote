/**
 * Copyright (c) 2016 JAHA SMART CORP., LTD ALL RIGHT RESERVED
 */
package com.jaha.evote.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.jaha.evote.domain.Member;

/**
 * <pre>
 * Class Name : MemberMapper.java
 * Description : 회원 매퍼
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
public interface MemberMapper {

    /**
     * 사용자 정보 조회(이메일)
     * 
     * @param email
     * @return
     */
    public Member selectUserInfoByEmail(@Param("email") String email);

    /**
     * 사용자 정보 조회 (핸드폰번호)
     * 
     * @param phone
     * @return
     */
    public Member selectUserInfoByPhone(@Param("phone") String phone);

    /**
     * id로 사용자 정보 가져오기
     * 
     * @param param
     * @return
     */
    public Member getUserInfoById(Map<String, Object> param);

    /**
     * 전화번호 개수 조회
     * 
     * @param phone
     * @return
     */
    public int selectUserPhoneCount(@Param("phone") String phone);

    /**
     * 닉네임 갯수 조회
     * 
     * @param nickname
     * @return
     */
    public int selectUserNicknameCount(@Param("nickname") String nickname, @Param("siteCd") String siteCd);

    /**
     * 최종 로그인 시간 수정
     * 
     * @param userSeq
     * @return
     */
    //public int updateLastLoginDate(@Param("userSeq") long userSeq);
    public int updateLastLoginDate(Map<String, Object> param);

    /**
     * 사용자 정보 등록
     * 
     * @param memberVO
     * @return
     */
    public int insertMember(Member memberVO);

    /**
     * USER ROLE 등록
     * 
     * @param userSeq
     * @param roleType
     * @return
     */
    public int insertMemberRole(@Param("userSeq") long userSeq);

    /**
     * 사용자 등록 이력
     * 
     * @param memberVO
     * @return
     */
    public int insertMemberHist(long userSeq);

    /**
     * 사용자 댓글 권한 변경
     */
    public int updateCommentAuth(Map<String, Object> params);

    /**
     * 회원 타입 변경(휴대폰회원 -> 이메일회원)
     * 
     * @param member
     * @return
     */
    public int updateMemberType(Member member);

    /**
     * 선택약관 동의/해제
     * 
     * @param params
     * @return
     */
    public int updateTerms(Map<String, Object> params);

    /**
     * 아이디/비밀번호 찾기 사용자 정보 조회
     * 
     * @param params
     * @return
     */
    public Member selectInquiryUser(Map<String, Object> params);

    /**
     * 비밀번호 재설정
     * 
     * @param phone
     * @param userPw
     * @return
     */
    public int resetUserpw(@Param("phone") String phone, @Param("email") String email, @Param("userPw") String userPw);

    /**
     * 사용자 정보 수정
     * 
     * @param member
     * @return
     */
    public int updateMember(Member member);

    /**
     * 사용자 비밀번호 수정
     * 
     * @param userSeq
     * @param userPw
     * @return
     */
    public int updateMemberPassword(@Param("userSeq") long userSeq, @Param("userPw") String userPw);

    /**
     * 사용자 탈퇴 처리
     * 
     * @param params
     * @return
     */
    public int updateMemberWithdrawal(Map<String, Object> params);


    //=========================================================================
    // ADMIN
    //=========================================================================

    /**
     * 선택동의 사용자 인원 조회
     * 
     * @param siteCd
     * @return
     */
    public int selectMemberAgreeListCount(@Param("siteCd") String siteCd);

    /**
     * 선택동의 사용자 목록 조회
     * 
     * @param siteCd
     * @return
     */
    public List<Member> selectMemberAgreeList(@Param("siteCd") String siteCd);

    /**
     * 사용자 카운트
     * 
     * @param param
     * @return
     */
    public int selectMemberListCount(Map<String, Object> param);

    /**
     * 사용자 목록 조회
     * 
     * @param param
     * @return
     */
    public List<Member> selectMemberList(Map<String, Object> param);

    /**
     * 사용자 목록 엑셀 다운로드
     * 
     * @param siteCd
     * @return
     */
    public List<Member> selectMemberListExcel(@Param("siteCd") String siteCd);

    /**
     * 투표 권한 수정
     * 
     * @param param
     * @return
     */
    public int updateVoteStat(Map<String, Object> param);

    /**
     * 주민참여 위원회 권한 설정
     * 
     * @param siteCd
     * @param subcmit1
     * @param subcmit2
     * @param modUser
     * @param userSeq
     * @return
     */
    public int updateGrantSubcmit(@Param("siteCd") String siteCd, @Param("subcmit1") String subcmit1, @Param("subcmit2") String subcmit2, @Param("modUser") long modUser,
            @Param("userSeq") long userSeq);

    /**
     * 주민참여 위원회 권한 해제
     * 
     * @param siteCd
     * @param modUser
     * @param userSeq
     * @return
     */
    public int updateRevokeSubcmit(@Param("siteCd") String siteCd, @Param("modUser") long modUser, @Param("userSeq") long userSeq);

    /**
     * 사용자 ROLE 조회
     * 
     * @param userSeq
     * @return
     */
    public List<String> selectMemberRoles(@Param("userSeq") long userSeq);

}
