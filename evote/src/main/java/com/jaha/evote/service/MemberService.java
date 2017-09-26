package com.jaha.evote.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.jaha.evote.common.exception.EvoteBizException;
import com.jaha.evote.common.exception.EvoteException;
import com.jaha.evote.common.util.Messages;
import com.jaha.evote.common.util.StringUtils;
import com.jaha.evote.common.util.XecureUtil;
import com.jaha.evote.domain.EncryptedString;
import com.jaha.evote.domain.Member;
import com.jaha.evote.domain.SearchList;
import com.jaha.evote.domain.common.Address;
import com.jaha.evote.domain.type.UserStatus;
import com.jaha.evote.domain.type.UserType;
import com.jaha.evote.mapper.CommitteeMapper;
import com.jaha.evote.mapper.MemberMapper;
import com.jaha.evote.mapper.ProposalMapper;
import com.jaha.evote.mapper.common.AddressMapper;

/**
 * <pre>
 * Class Name : MemberService.java
 * Description : 사용자 서비스
 *  
 * Modification Information
 * 
 * Mod Date         Modifier    Description
 * ------------     --------    ---------------------------
 * 2016. 9. 29.     jjpark      Generation
 * 2016. 11. 07.    jjpark      회원 정보 암호화
 *                              -> user_nm, phone, email
 * </pre>
 *
 * @author jjpark
 * @since 2016. 9. 29.
 * @version 1.0
 */
@Service
public class MemberService extends BaseService {

    @Autowired
    private MemberMapper memberMapper;

    @Autowired
    private AddressMapper addressMapper;

    @Autowired
    private ProposalMapper proposalMapper;

    @Autowired
    private CommitteeMapper committeeMapper;

    @Autowired
    private SmsService smsService;

    @Autowired
    private Messages messages;

    /**
     * 사용자 정보 조회 (이메일)
     * 
     * @param email
     * @return
     */
    public Member getUserInfoByEmail(String email) {
        Member member = memberMapper.selectUserInfoByEmail(XecureUtil.encString(email));
        return member;
    }

    /**
     * 사용자 정보 조회 (핸드폰번호)
     * 
     * @param email
     * @return
     */
    public Member getUserInfoByPhone(String phone) {
        Member member = memberMapper.selectUserInfoByPhone(XecureUtil.encString(phone));
        return member;

    }

    /**
     * 사이트 사용자 정보 조회 (핸드폰번호)
     * 
     * @param phone
     * @return
     */
    public Member selectSiteUserInfoByPhone(String phone) {

        Member member = memberMapper.selectUserInfoByPhone(XecureUtil.encString(phone));

        if (member != null && isContainsSiteCd(member.getSiteCd())) {
            return member;
        }

        return null;
    }

    /**
     * 핸드폰 번호 체크
     * 
     * @param phone
     * @return
     */
    public boolean existPhoneNumber(String phone) {
        /*
         * 정회원 핸드폰 번호 유무만 검색 -> 전체 회원 검색으로 변경 [2016.07.27]
         */
        int cnt = memberMapper.selectUserPhoneCount(XecureUtil.encString(phone));
        if (cnt > 0) {
            logger.debug("### 핸드폰 번호 중복 ::: [{}]", phone);
            return true;
        }
        return false;
    }

    /**
     * 닉네임 체크
     * 
     * @param nickname
     * @return
     */
    public boolean existNickname(String nickname) {
        int cnt = memberMapper.selectUserNicknameCount(nickname, getSiteCd());
        if (cnt > 0) {
            logger.debug("### 닉네임 중복 ::: [{}]", nickname);
            return true;
        }
        return false;
    }

    /**
     * 사용자 등록
     * 
     * @param param
     * @param userType
     * @return
     */
    @Transactional
    public int insertMember(HashMap<String, String> param, UserType userType) {

        // String terms1 = param.get("terms1");
        // String terms2 = param.get("terms2");
        String terms3 = param.get("terms3");
        String birthYear = param.get("birthYear");
        String birthMonth = param.get("birthMonth");
        String birthDate = param.get("birthDate");
        String phoneNumber = param.get("phoneNumber");
        String phoneCode = param.get("phoneCode"); // 인증번호 재검증 시 사용
        String phoneKey = param.get("phoneKey"); // 인증번호 재검증 시 사용
        String userEmail = param.get("userEmail");
        String userPass = param.get("userPass");
        String userName = param.get("userName");
        String nickname = param.get("nickname");
        String regionCd = param.get("regionCd");
        String gender = param.get("gender");

        // 인증번호 재검증
        //        HashMap<String, Object> smsParam = new HashMap<String, Object>();
        //        smsParam.put("code", phoneCode);
        //        smsParam.put("key", phoneKey);
        //        smsParam.put("phone", phoneNumber);
        //        HashMap<String, String> smsResult = smsMapper.checkAuthWithDestPhone(smsParam);
        HashMap<String, String> smsResult = smsService.checkAuthWithDestPhone(phoneCode, phoneKey, phoneNumber);

        if (smsResult == null) {
            // 인증받지 않은 휴대폰 번호
            throw new EvoteException("### 사용자 등록 오류 : 휴대폰 번호 인증받지 않음");
        } else {
            String destPhone = smsResult.get("DEST_PHONE");
            if (!destPhone.equals(phoneNumber)) {
                throw new EvoteException("### 사용자 등록 오류 : 인증받은 휴대폰 번호와 다름");
            }
        }

        // 휴대폰 번호 중복 체크
        if (StringUtils.isNotEmpty(phoneNumber)) {
            if (memberMapper.selectUserPhoneCount(XecureUtil.encString(phoneNumber)) > 0) {
                throw new EvoteException("### 사용자 등록 오류 : 휴대폰 번호 중복");
            }
        }

        // 이메일 체크
        if (StringUtils.isNotEmpty(userEmail)) {
            if (memberMapper.selectUserInfoByEmail(XecureUtil.encString(userEmail)) != null) {
                throw new EvoteException("### 사용자 등록 오류 : 이메일 중복");
            }
        }

        Member member = new Member();

        member.setSiteCd(getSiteCd());

        member.setRegionCd(regionCd);
        member.setGender(gender);

        member.setBirthYear(birthYear);
        member.setBirthDate(birthMonth + birthDate);

        member.setTermsAgreeYn(terms3);
        member.setPhone(new EncryptedString(XecureUtil.encString(phoneNumber)));

        member.setUserType(userType);
        member.setEmail(new EncryptedString(XecureUtil.encString(userEmail)));
        member.setUserPw(new EncryptedString(XecureUtil.hash64(userPass)));
        member.setUserNm(new EncryptedString(XecureUtil.encString(userName)));
        member.setNickname(nickname);


        // 회원 상태
        member.setUserStat(UserStatus.AVAILABLE);

        // 현 주소지
        Address addressVO = addressMapper.selectAddress(regionCd);
        if (addressVO != null) {
            member.setSidoNm(addressVO.getSidoNm()); // 시도명
            member.setSggNm(addressVO.getSggNm()); // 시군구명
            member.setEmdNm(addressVO.getEmdNm()); // 읍면동명
        }

        int result = memberMapper.insertMember(member);
        if (result > 0) {

            memberMapper.insertMemberRole(member.getUserSeq());

            // 등록 이력
            memberMapper.insertMemberHist(member.getUserSeq());
        }

        return result;
    }

    /**
     * 사용자 정보 조회
     * 
     * @param param
     * @return
     */
    public Member getUserInfoById(Map<String, Object> param) {
        Member member = memberMapper.getUserInfoById(param);
        if (member != null) {
            return member;
        }
        return null;
    }

    /**
     * 사용자 댓글 권한 변경
     */
    @Transactional
    public int updateCommentAuth(Map<String, Object> params) {
        params.put("mgrSeq", getUserSeq());
        return memberMapper.updateCommentAuth(params);
    }

    ///////////////////////////////////////////////////////////////////////////
    // 
    // 삭제
    //
    //    /**
    //     * 사용자 타입 수정
    //     * 
    //     * @param param
    //     * @param userType
    //     * @return
    //     */
    //    @Transactional
    //    @Deprecated
    //    public int updateMemberType(HashMap<String, String> param, UserType userType) {
    //
    //        Member loginMember = getLoginMember();
    //
    //        String userEmail = param.get("userEmail");
    //        String userPass = param.get("userPass");
    //        String userName = param.get("userName");
    //        String nickname = param.get("nickname");
    //
    //        // 이메일 체크
    //        if (StringUtils.isNotEmpty(userEmail)) {
    //            if (memberMapper.selectUserInfoByEmail(userEmail) != null) {
    //                throw new EvoteException("### 사용자 등록 오류 : 이메일 중복");
    //            }
    //        }
    //
    //        Member member = new Member();
    //
    //        if (UserType.EMAIL.equals(userType)) {
    //            if (StringUtils.isAnyEmpty(userEmail, userPass, userName, nickname)) {
    //                throw new EvoteException("### 사용자 등록 오류 : 이메일 회원 필수 항목 누락");
    //            }
    //
    //            member.setUserSeq(loginMember.getUserSeq());
    //
    //            member.setUserType(userType);
    //            member.setEmail(userEmail);
    //            member.setUserPw(XecureUtil.hash64(userPass));
    //            member.setUserNm(userName);
    //            member.setNickname(nickname);
    //        } else {
    //            throw new EvoteException("### 사용자 등록 오류 : 허용되지 않은 사용자 타입 - UserType [" + userType + "]");
    //        }
    //
    //        int result = memberMapper.updateMemberType(member);
    //        if (result > 0) {
    //            // 등록 이력
    //            memberMapper.insertMemberHist(member.getUserSeq());
    //        }
    //
    //        return result;
    //    }

    /**
     * 선택약관 동의/해제
     * 
     * @param params
     * @return
     */
    @Transactional
    public int updateTerms(String termsAgreeYn) {

        Member member = getLoginMember();
        if (member == null) {
            return -1;
        }

        Map<String, Object> param = new HashMap<>();
        param.put("termsAgreeYn", termsAgreeYn);
        param.put("userSeq", member.getUserSeq());

        return memberMapper.updateTerms(param);
    }


    //=========================================================================
    // 아이디/비밀번호 찾기
    //=========================================================================

    /**
     * 아이디/비밀번호 사용자 정보 조회
     * 
     * @param phone
     * @param userNm
     * @param email
     * @return
     */
    public Member selectInquiryUser(String phone, String userNm, String email) {

        if (StringUtils.isEmpty(phone)) {
            logger.info("### 핸드폰 번호 정보 없음 : PHONE [{}]", phone);
            return null;
        } else if (StringUtils.isEmpty(userNm) && StringUtils.isEmpty(email)) {
            logger.info("### 사용자 이름 또는 이메일 정보 없음 : userNm [{}], email [{}]", userNm, email);
            return null;
        }

        Map<String, Object> map = new HashMap<>();

        map.put("siteCd", getSiteCd());
        //map.put("userType", UserType.EMAIL);  // CMIT 권한 추가로 userType 항목 삭제
        map.put("userStat", UserStatus.AVAILABLE);
        map.put("phone", XecureUtil.encString(phone));
        if (StringUtils.isNotEmpty(userNm)) {
            map.put("userNm", XecureUtil.encString(userNm));
        } else if (StringUtils.isNotEmpty(email)) {
            map.put("email", XecureUtil.encString(email));
        }

        return memberMapper.selectInquiryUser(map);
    }

    /**
     * 비밀번호 재설정
     * 
     * @param phone
     * @param code
     * @param key
     * @param email
     * @param userPw
     * @return
     */
    @Transactional
    public boolean resetUserPw(String phone, String code, String key, String email, String userPw) {

        // 인증번호 재검증
        HashMap<String, String> authResult = smsService.checkAuthWithDestPhone(code, key, phone);

        if (authResult == null) {
            logger.info("### 사용자 비밀번호 재설정 실패 ::: 인증번호 검증 오류");
            return false;
        }

        // 인증번호 발송 휴대폰 번호
        String destPhone = authResult.get("DEST_PHONE");

        if (phone != null && phone.equals(destPhone)) {
            // 사용자 비밀번호 재설정
            if (memberMapper.resetUserpw(XecureUtil.encString(destPhone), XecureUtil.encString(email), XecureUtil.hash64(userPw)) > 0) {
                return true;
            }
        }

        logger.info("### 사용자 비밀번호 재설정 실패 ::: destPhone [{}], phone [{}], email [{}]", destPhone, phone, email);

        return false;
    }

    /**
     * 사용자 정보 수정
     * 
     * @param param
     */
    @Transactional
    public int updateMember(HashMap<String, String> param) {

        Member loginMember = getLoginMember();

        if (loginMember == null) {
            throw new EvoteException("### 사용자 정보 수정 오류 :: 세션 사용자 정보 없음");
        }

        String phoneNumber = param.get("phoneNumber");
        String phoneCode = param.get("phoneCode"); // 인증번호 재검증 시 사용
        String phoneKey = param.get("phoneKey"); // 인증번호 재검증 시 사용
        String regionCd = param.get("regionCd");

        Member member = new Member();

        // 휴대폰번호 변경 시 인증번호 재검증
        if (!loginMember.getPhone().equals(phoneNumber)) {

            HashMap<String, String> smsResult = smsService.checkAuthWithDestPhone(phoneCode, phoneKey, phoneNumber);

            if (smsResult == null) {
                // message.member.info.006=인증을 받지 않았습니다. 인증번호를 입력하고 인증확인을 선택해주세요.
                String message = messages.getMessage("message.member.info.006");
                logger.info("### 사용자 등록 오류 : 휴대폰 번호 인증받지 않음");
                throw new EvoteBizException(message);
            } else {
                String destPhone = smsResult.get("DEST_PHONE");
                if (!destPhone.equals(phoneNumber)) {
                    // message.member.info.006=인증을 받지 않았습니다. 인증번호를 입력하고 인증확인을 선택해주세요.
                    String message = messages.getMessage("message.member.info.006");
                    throw new EvoteBizException(message);
                }
            }

            member.setPhone(new EncryptedString(XecureUtil.encString(phoneNumber)));

        }

        member.setUserSeq(loginMember.getUserSeq());
        member.setRegionCd(regionCd);

        member.setModUser(loginMember.getUserSeq());

        Address addressVO = addressMapper.selectAddress(regionCd);
        if (addressVO != null) {
            member.setSidoNm(addressVO.getSidoNm()); // 시도명
            member.setSggNm(addressVO.getSggNm()); // 시군구명
            member.setEmdNm(addressVO.getEmdNm()); // 읍면동명
        }

        return memberMapper.updateMember(member);

    }

    /**
     * 사용자 패스워드 수정
     * 
     * @param param
     * @return
     */
    @Transactional
    public int updateMemberPassword(HashMap<String, String> param) {

        Member loginMember = getLoginMember();

        if (loginMember == null) {
            throw new EvoteException("### 사용자 정보 수정 오류 :: 세션 사용자 정보 없음");
        }

        String oldPass = param.get("oldPass");
        String newPass = param.get("newPass");

        //Member member = memberMapper.selectUserInfoByEmail(XecureUtil.encString(loginMember.getEmail().getValue()));
        Member member = memberMapper.selectUserInfoByEmail(loginMember.getEmail().getValue());

        if (!XecureUtil.verifyHash64(oldPass, member.getUserPw().getValue())) {
            return -1;
        }

        return memberMapper.updateMemberPassword(loginMember.getUserSeq(), XecureUtil.hash64(newPass));

    }

    /**
     * 사용자 탈퇴 처리
     * 
     * @return
     */
    @Transactional
    public int updateMemberWithdrawal() {

        Member loginMember = getLoginMember();

        if (loginMember == null) {
            throw new EvoteException("### 사용자 정보 수정 오류 :: 세션 사용자 정보 없음");
        }

        Map<String, Object> params = new HashMap<>();
        params.put("userSeq", loginMember.getUserSeq());
        params.put("userStat", UserStatus.WITHDRAWAL);

        return memberMapper.updateMemberWithdrawal(params);

    }


    //=========================================================================
    // ADMIN
    //=========================================================================

    /**
     * 선택동의 사용자 인원 조회
     * 
     * @return
     */
    public int selectMemberAgreeListCount() {
        return memberMapper.selectMemberAgreeListCount(getSiteCd());
    }

    /**
     * 선택동의 사용자 목록 조회
     * 
     * @return
     */
    public List<Member> selectMemberAgreeList() {
        return memberMapper.selectMemberAgreeList(getSiteCd());
    }

    /**
     * 사용자 목록 조회
     * 
     * @param param
     * @return
     */
    public SearchList<Member> selectMemberList(Map<String, Object> param) {

        param.put("siteCd", getSiteCd());

        // 검색어 암호화
        String orgSearchText = (String) param.get("searchText");
        String encSearchText = XecureUtil.encString(orgSearchText);
        param.put("encSearchText", encSearchText);

        int count = memberMapper.selectMemberListCount(param);

        List<Member> list = memberMapper.selectMemberList(param);


        return new SearchList<Member>(list, count);
    }

    /**
     * 사용자 목록 엑셀 다운로드
     * 
     * @return
     */
    public List<Member> selectMemberListExcel() {

        return memberMapper.selectMemberListExcel(getSiteCd());
    }

    /**
     * 투표 권한 수정
     * 
     * @param param
     * @return
     */
    @Transactional
    public int updateVoteStat(Map<String, Object> param) {

        param.put("modUser", getUserSeq());

        int result = memberMapper.updateVoteStat(param);

        return result;
    }

    /**
     * 댓글 목록 조회
     * 
     * @param param
     * @return
     */
    public SearchList<Map<String, Object>> selectUserCommentList(Map<String, Object> param) {

        int totalCount = proposalMapper.selectUserCommentCount(param);

        List<Map<String, Object>> cmtList = proposalMapper.selectUserCommentList(param);

        return new SearchList<Map<String, Object>>(cmtList, totalCount);
    }

    /**
     * 주민참여위원권한 설정
     * 
     * @param reqSeq
     * @param userSeq
     * @return
     */
    @Transactional
    public int updateGrantSubcmit(long reqSeq, long userSeq) {

        String siteCd = getSiteCd();
        long modUserSeq = getUserSeq();

        HashMap<String, Object> map = new HashMap<>();
        map.put("site_cd", getSiteCd());
        map.put("req_seq", reqSeq);
        map.put("user_seq", userSeq);

        HashMap<String, Object> cmitReq = committeeMapper.selectCmitContestReq(map);
        if (cmitReq != null) {
            String subcmit1 = (String) cmitReq.get("subCmitCd1");   // 분과1
            String subcmit2 = (String) cmitReq.get("subCmitCd2");   // 분과2
            return memberMapper.updateGrantSubcmit(siteCd, subcmit1, subcmit2, modUserSeq, userSeq);
        }

        return -1;
    }

    /**
     * 주민참여위원권한 해제
     * 
     * @param userSeq
     * @return
     */
    @Transactional
    public int updateRevokeSubcmit(long userSeq) {
        String siteCd = getSiteCd();
        long modUserSeq = getUserSeq();
        return memberMapper.updateRevokeSubcmit(siteCd, modUserSeq, userSeq);
    }



}
