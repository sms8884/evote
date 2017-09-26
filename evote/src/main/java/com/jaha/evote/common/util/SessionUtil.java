package com.jaha.evote.common.util;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.util.WebUtils;

import com.jaha.evote.domain.Account;
import com.jaha.evote.domain.AdminUser;
import com.jaha.evote.domain.EncryptedString;
import com.jaha.evote.domain.ISiteInfo;
import com.jaha.evote.domain.Member;
import com.jaha.evote.domain.type.AgeGroup;
import com.jaha.evote.domain.type.RoleType;
import com.jaha.evote.domain.type.UserType;

/**
 * <pre>
 * Class Name : SessionUtil.java
 * Description : Description
 *  
 * Modification Information
 * 
 * Mod Date         Modifier    Description
 * -----------      --------    ---------------------------
 * 2016. 11. 7.     jjpark      Generation
 * 2016. 11. 20.    jjpark      RoleType 추가
 * </pre>
 *
 * @author jjpark
 * @since 2016. 11. 7.
 * @version 1.0
 */
public class SessionUtil {

    private static final Logger logger = LoggerFactory.getLogger(SessionUtil.class);

    public static Member getSessionInfo(HttpServletRequest request) {
        return (Member) WebUtils.getSessionAttribute(request, Member.ATTRIBUTE_NAME);
    }

    public void saveSessionInfo(HttpServletRequest request, final Member userInfo) {

        Member sessionMember = new Member();

        sessionMember.setRoles(userInfo.getRoles()); // Role 타입

        sessionMember.setUserType(userInfo.getUserType()); // 계정타입
        sessionMember.setSiteCd(userInfo.getSiteCd()); // 사이트코드

        sessionMember.setUserSeq(userInfo.getUserSeq());
        sessionMember.setUserNm(userInfo.getUserNm());
        sessionMember.setEmail(userInfo.getEmail());
        sessionMember.setSidoNm(userInfo.getSidoNm());
        sessionMember.setSggNm(userInfo.getSggNm());
        sessionMember.setEmdNm(userInfo.getEmdNm());
        sessionMember.setRegionCd(userInfo.getRegionCd());
        sessionMember.setNickname(userInfo.getNickname());
        sessionMember.setCmtYn(userInfo.getCmtYn());
        sessionMember.setPhone(userInfo.getPhone());
        sessionMember.setGender(userInfo.getGender());

        // 생년월일
        sessionMember.setBirthYear(userInfo.getBirthYear());
        sessionMember.setBirthDate(userInfo.getBirthDate());

        // 투표 가능여부 정보
        sessionMember.setVoteStat(userInfo.getVoteStat());
        sessionMember.setBanStartDate(userInfo.getBanStartDate());
        sessionMember.setBanEndDate(userInfo.getBanEndDate());


        // 필요한 정보 등록...

        logger.debug("### Roles :: [{}]", userInfo.getRoles());

        /*
         * [2016.10] 회원 체계 변경
         * USER ROLE(정회원 여부)
         * ROLE USER(정회원) - EMAIL, CMIT
         * ROLE GUEST(방문자) - PROPOSAL, VOTE, QNA
         * @see RoleType
         * @see UserType
         */
        //        if (userInfo.hasRole(RoleType.USER)) {
        //            sessionMember.setRoleType(RoleType.USER);
        //        } else {
        //            sessionMember.setRoleType(RoleType.GUEST);
        //        }
        //        if (UserType.EMAIL.equals(userInfo.getUserType()) || UserType.CMIT.equals(userInfo.getUserType())) {
        //            sessionMember.setRoleType(RoleType.USER);
        //        } else {
        //            sessionMember.setRoleType(RoleType.GUEST);
        //        }


        // 세션 정보 저장
        WebUtils.setSessionAttribute(request, Member.ATTRIBUTE_NAME, sessionMember);


        // 사용자 타입
        WebUtils.setSessionAttribute(request, "userType", userInfo.getUserType());  // userType
        //WebUtils.setSessionAttribute(request, "roleType", sessionMember.getRoleType()); // roleType -->> hasRole 로 변경
        WebUtils.setSessionAttribute(request, "cmtYn", userInfo.getCmtYn());    // 댓글 가능 여부

        // XXX: 안쓰이는듯
        //        if (RoleType.USER.equals(sessionMember.getRoleType())) {
        //            WebUtils.setSessionAttribute(request, "memberYn", "Y");
        //        } else {
        //            WebUtils.setSessionAttribute(request, "memberYn", "N");
        //        }

        /*
         * 연령대 만 24세 이하 : YOUNG - 청년, 만 35세 이상 : ADULT - 성인
         */
        String strBirthYear = userInfo.getBirthYear();
        String strBirthDate = userInfo.getBirthDate();
        if (StringUtils.isNotEmpty(strBirthYear) && StringUtils.isNotEmpty(strBirthDate) && strBirthDate.length() >= 4) {
            int year = StringUtils.nvlInt(strBirthYear);
            int month = StringUtils.nvlInt(StringUtils.substring(strBirthDate, 0, 2));
            int date = StringUtils.nvlInt(StringUtils.substring(strBirthDate, 2, 4));
            int intYearsDiff = DateUtils.getYearsDiff(year, month, date);

            if (intYearsDiff <= 24) {
                WebUtils.setSessionAttribute(request, "ageGroup", AgeGroup.YOUNG);
            } else {
                WebUtils.setSessionAttribute(request, "ageGroup", AgeGroup.ADULT);
            }

        }

    }


    // =========================================================================
    // ADMIN
    // =========================================================================

    public static AdminUser getAdminSessionInfo(HttpServletRequest request) {
        Account account = (Account) WebUtils.getSessionAttribute(request, AdminUser.ATTRIBUTE_NAME);
        if (account instanceof AdminUser) {
            return (AdminUser) account;
        } else {
            //request.getSession().invalidate();
            return null;
        }
    }

    public void saveAdminSessionInfo(HttpServletRequest request, final AdminUser adminUser) {

        AdminUser sessionAdminUser = new AdminUser();

        sessionAdminUser.setUserType(adminUser.getUserType()); // 계정타입
        sessionAdminUser.setSiteCd(adminUser.getSiteCd()); // 사이트코드

        sessionAdminUser.setMgrSeq(adminUser.getMgrSeq());
        sessionAdminUser.setRegionCd(adminUser.getRegionCd());
        sessionAdminUser.setMgrId(adminUser.getMgrId());
        sessionAdminUser.setMgrNm(adminUser.getMgrNm());
        sessionAdminUser.setMgrDept(adminUser.getMgrDept());
        sessionAdminUser.setMgrTel(adminUser.getMgrTel());
        sessionAdminUser.setRoles(adminUser.getRoles());

        WebUtils.setSessionAttribute(request, AdminUser.ATTRIBUTE_NAME, sessionAdminUser);

        // 관리자여부
        WebUtils.setSessionAttribute(request, "adminYn", "Y");
        //WebUtils.setSessionAttribute(request, "roleType", RoleType.ADMIN);

    }

    // =========================================================================
    // VISITOR
    // =========================================================================

    public void invalidateAndSaveVisitorSession(HttpServletRequest request, String phone, UserType userType) {

        // 기존 사이트코드 저장
        String siteCode = (String) WebUtils.getSessionAttribute(request, ISiteInfo.ATTRIBUTE_NAME);

        // 세션 만료
        request.getSession().invalidate();

        //visitor.setPhone(new EncryptedString(XecureUtil.encString(phoneNumber)));

        // 신규 세션 생성 후 세션값 저장
        WebUtils.setSessionAttribute(request, ISiteInfo.ATTRIBUTE_NAME, siteCode);
        //        WebUtils.setSessionAttribute(request, "phone", phone);
        //        WebUtils.setSessionAttribute(request, "userType", UserType.VISITOR);

        Member visitor = new Member();

        List<RoleType> roles = new ArrayList<>();
        roles.add(RoleType.GUEST);

        visitor.setRoles(roles);
        visitor.setUserType(userType);
        visitor.setSiteCd(siteCode);
        visitor.setUserSeq(0L);
        visitor.setPhone(new EncryptedString(XecureUtil.encString(phone)));
        saveSessionInfo(request, visitor); // visitor session 생성


    }

}
