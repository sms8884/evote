/**
 * Copyright (c) 2016 JAHA SMART CORP., LTD ALL RIGHT RESERVED
 */
package com.jaha.evote.service;

import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.jaha.evote.common.util.XecureUtil;
import com.jaha.evote.domain.Account;
import com.jaha.evote.domain.AdminUser;
import com.jaha.evote.domain.Member;
import com.jaha.evote.domain.type.UserStatus;
import com.jaha.evote.mapper.AdminMapper;
import com.jaha.evote.mapper.MemberMapper;

/**
 * <pre>
 * Class Name : LoginService.java
 * Description : 로그인 서비스
 *  
 * Modification Information
 * 
 * Mod Date         Modifier    Description
 * -----------      --------    ---------------------------
 * 2016. 7. 27.     jjpark      Generation
 * </pre>
 *
 * @author jjpark
 * @since 2016. 7. 27.
 * @version 1.0
 */
@Service
public class LoginService extends BaseService {

    @Autowired
    private MemberMapper memberMapper;

    @Autowired
    private AdminMapper adminMapper;

    //    @Autowired
    //    private Messages messages;

    // =========================================================================
    // FRONT
    // =========================================================================

    /**
     * 사용자 정보 조회(패스워드 검증)
     * 
     * @param email
     * @param userPw
     * @return
     */
    public Member getLoginMemberInfo(String email, String userPw) {

        //        Member member = memberMapper.selectUserInfoByEmail(encryption.encryptTwoWay(email));
        Member member = memberMapper.selectUserInfoByEmail(XecureUtil.encString(email));

        // 사용자 정보 확인
        if (member == null) {
            logger.debug("### 사용자 정보 없음 ::: [{}]", email);
            return null;
        }

        // 회원 상태 확인
        if (!UserStatus.AVAILABLE.equals(member.getUserStat())) {
            if (UserStatus.SUSPENDED.equals(member.getUserStat())) {
                logger.debug("### 이용 정지 회원 ::: [{}]", email);
            } else if (UserStatus.WITHDRAWAL.equals(member.getUserStat())) {
                logger.debug("### 탈퇴 회원 ::: [{}]", email);
            } else {
                logger.debug("### 유령회원(?) ::: [{}]", email);
            }
            return null;
        }

        // 사이트 권한 확인
        if (!isContainsSiteCd(member.getSiteCd())) {
            logger.debug("### 사이트 권한 없음 ::: [{}]", member.getSiteCd());
            return null;
        }

        // 패스워드 확인
        if (!XecureUtil.verifyHash64(userPw, member.getUserPw().getValue())) {
            logger.debug("### Failed to verify ::: [{}]", email);
            return null;
        }

        return member;

    }


    // =========================================================================
    // ADMIN
    // =========================================================================

    /**
     * 관리자 정보 조회(패스워드 검증)
     * 
     * @param mgrId
     * @param mgrPw
     * @return
     */
    public AdminUser getLoginAdminInfo(String mgrId, String mgrPw) {

        AdminUser adminUser = adminMapper.selectAdminUserInfo(mgrId);

        // 관리자 정보 확인
        if (adminUser == null) {
            logger.debug("### 관리자 정보 없음 ::: [{}]", mgrId);
            return null;
        }

        // 사이트 권한 확인
        if (!isContainsSiteCd(adminUser.getSiteCd())) {
            logger.debug("### 사이트 권한 없음 ::: [{}]", adminUser.getSiteCd());
            return null;
        }

        // 패스워드 확인
        if (!XecureUtil.verifyHash64(mgrPw, adminUser.getMgrPw().getValue())) {
            logger.debug("### Failed to verify ::: [{}]", mgrId);
            return null;
        }

        return adminUser;
    }


    // =========================================================================
    // COMMON
    // =========================================================================

    /**
     * 최종 로그인 시간 수정
     * 
     * @param objSeq
     */
    @Transactional
    public void updateLastLoginDate(long objSeq, String pushKey, String loginIp) {
        Account account = getAccount();
        if (account != null) {
            if (account.isAdmin()) {
                adminMapper.updateLastLoginDate(objSeq, loginIp);
            } else {
                Map<String, Object> param = new HashMap<>();
                param.put("userSeq", objSeq);
                param.put("pushKey", pushKey);
                param.put("loginIp", loginIp);
                param.put("accessToken", generateToken());
                memberMapper.updateLastLoginDate(param);
            }
        }
    }

    /**
     * 토큰 생성 - 사용 여부는 미정
     * 
     * @return
     */
    private String generateToken() {
        UUID uuid = UUID.randomUUID();
        String randomUUIDString = uuid.toString();
        return randomUUIDString;
    }
}
