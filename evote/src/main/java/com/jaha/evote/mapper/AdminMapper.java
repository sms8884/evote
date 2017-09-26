/**
 * Copyright (c) 2016 by jahasmart.com. All rights reserved.
 *
 * 2016. 7. 11.
 */
package com.jaha.evote.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.jaha.evote.domain.AdminUser;

/**
 * <pre>
 * Class Name : AdminMapper.java
 * Description : 관리자 매퍼
 *  
 * Modification Information
 * 
 * Mod Date         Modifier    Description
 * -----------      --------    ---------------------------
 * 2016. 7. 14.     jjpark      Generation
 * </pre>
 *
 * @author jjpark
 * @since 2016. 7. 14.
 * @version 1.0
 */
@Mapper
public interface AdminMapper {

    /**
     * 관리자 정보 조회
     * 
     * @param mgrSeq
     * @return
     */
    public AdminUser selectAdminUserInfo(String mgrId);

    /**
     * 최종 로그인 시간 수정
     * 
     * @param mgrSeq
     * @return
     */
    public int updateLastLoginDate(@Param("mgrSeq") long mgrSeq, @Param("loginIp") String loginIp);

    /**
     * 관리자 목록 조회
     * 
     * @param siteCd
     * @return
     */
    public List<AdminUser> selectManagerList(@Param("siteCd") String siteCd);

    /**
     * 관리자 조회
     * 
     * @param siteCd
     * @param mgrSeq
     * @return
     */
    public AdminUser selectManager(@Param("siteCd") String siteCd, @Param("mgrSeq") long mgrSeq);

    /**
     * 메일 수신 가능 관리자 목록 조회
     * 
     * @param siteCd
     * @param mgrSeq
     * @return
     */
    public List<AdminUser> selectMailReceiveManagerList(@Param("siteCd") String siteCd);

    /**
     * 관리자 등록
     * 
     * @param adminUser
     * @return
     */
    public int insertManager(AdminUser adminUser);

    /**
     * 관리자 수정
     * 
     * @param adminUser
     * @return
     */
    public int updateManager(AdminUser adminUser);

    /**
     * 관리자 삭제
     * 
     * @param siteCd
     * @param mgrSeq
     * @return
     */
    public int removeManager(@Param("siteCd") String siteCd, @Param("mgrSeq") long mgrSeq);

    /**
     * 관리자 암호 수정
     * 
     * @param siteCd
     * @param mgrSeq
     * @param mgrPw
     * @return
     */
    public int updateManagerPasswd(@Param("siteCd") String siteCd, @Param("mgrSeq") long mgrSeq, @Param("mgrPw") String mgrPw);

}
