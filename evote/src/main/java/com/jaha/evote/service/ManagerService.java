/**
 * Copyright (c) 2016 JAHA SMART CORP., LTD ALL RIGHT RESERVED
 */
package com.jaha.evote.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.jaha.evote.common.exception.EvoteBizException;
import com.jaha.evote.common.util.XecureUtil;
import com.jaha.evote.domain.AdminUser;
import com.jaha.evote.domain.EncryptedString;
import com.jaha.evote.domain.type.RoleType;
import com.jaha.evote.mapper.AdminMapper;

/**
 * <pre>
 * Class Name : ManagerService.java
 * Description : 관리자 서비스
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
@Service
public class ManagerService extends BaseService {

    @Autowired
    private AdminMapper adminMapper;

    /**
     * 관리자 목록 조회
     * 
     * @return
     */
    public List<AdminUser> selectManagerList() {
        return adminMapper.selectManagerList(getSiteCd());
    }

    /**
     * 관리자 정보 조회
     * 
     * @param mgrSeq
     * @return
     */
    public AdminUser selectManager(long mgrSeq) {
        return adminMapper.selectManager(getSiteCd(), mgrSeq);
    }

    /**
     * 관리자 정보 수정
     * 
     * @param adminUser
     * @return
     */
    @Transactional
    public int updateManager(final AdminUser adminUser) {

        AdminUser newAdminUser = new AdminUser();

        newAdminUser.setMgrSeq(getUserSeq());
        newAdminUser.setSiteCd(getSiteCd());

        newAdminUser.setMgrEmail(new EncryptedString(XecureUtil.encString(adminUser.getMgrEmail().getValue())));
        newAdminUser.setMgrNm(new EncryptedString(XecureUtil.encString(adminUser.getMgrNm().getValue())));
        newAdminUser.setMgrDept(adminUser.getMgrDept());
        newAdminUser.setMgrTel(new EncryptedString(XecureUtil.encString(adminUser.getMgrTel().getValue())));

        if ("Y".equals(adminUser.getMailReceiveYn())) {
            newAdminUser.setMailReceiveYn("Y");
        } else {
            newAdminUser.setMailReceiveYn("N");
        }

        return adminMapper.updateManager(newAdminUser);
    }

    /**
     * 관리자 암호 변경
     * 
     * @param param
     * @return
     */
    @Transactional
    public int updateManagerPasswd(Map<String, Object> param) {

        String siteCd = getSiteCd();
        long mgrSeq = getUserSeq();

        AdminUser adminUser = adminMapper.selectManager(siteCd, mgrSeq);

        String oldPass = (String) param.get("oldPass");

        if (XecureUtil.verifyHash64(oldPass, adminUser.getMgrPw().getValue())) {
            // update pw
            String mgrPw = (String) param.get("newPass");
            return adminMapper.updateManagerPasswd(siteCd, mgrSeq, XecureUtil.hash64(mgrPw));
        } else {
            // verify fail
            return -1;
        }

    }


    //=========================================================================
    // ONLY SYSTEM ADMIN
    //=========================================================================

    /**
     * 관리자 등록
     * 
     * @param adminUser
     * @return
     */
    @Transactional
    public int insertManager(AdminUser adminUser) {

        if (!hasRole(RoleType.SYSTEM)) {
            throw new EvoteBizException("");
        }

        adminUser.setSiteCd(getSiteCd());
        adminUser.setMgrPw(new EncryptedString(XecureUtil.hash64(adminUser.getMgrPw().getValue())));
        return adminMapper.insertManager(adminUser);
    }

    /**
     * 관리자 정보 삭제
     * 
     * @param mgrSeq
     * @return
     */
    @Transactional
    public int removeManager(long mgrSeq) {

        if (!hasRole(RoleType.SYSTEM)) {
            throw new EvoteBizException("");
        }

        return adminMapper.removeManager(getSiteCd(), mgrSeq);
    }

}
