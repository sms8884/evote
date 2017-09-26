/**
 * Copyright (c) 2016 JAHA SMART CORP., LTD ALL RIGHT RESERVED
 */
package com.jaha.evote.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.jaha.evote.domain.Menu;
import com.jaha.evote.domain.type.RoleType;

/**
 * <pre>
 * Class Name : MenuMapper.java
 * Description : 메뉴 매퍼
 *  
 * Modification Information
 * 
 * Mod Date         Modifier    Description
 * -----------      --------    ---------------------------
 * 2016. 10. 19.     jjpark      Generation
 * </pre>
 *
 * @author jjpark
 * @since 2016. 10. 19.
 * @version 1.0
 */
@Mapper
public interface MenuMapper {

    /**
     * 메뉴조회
     * 
     * @param params
     * @return
     */
    public List<Menu> selectMenuList(@Param("rootMenuNm") String rootMenuNm, @Param("role") RoleType roleType);

    /**
     * 메뉴URL 기준 메뉴 아이디 목록 조회
     * 
     * @param menuUrl
     * @return
     */
    public List<Integer> selectMenuIdsByUrl(String menuUrl);

    /**
     * breadcrumb 조회
     * 
     * @param menuId
     * @return
     */
    public List<Menu> selectBreadcrumbList(int menuId);

}
