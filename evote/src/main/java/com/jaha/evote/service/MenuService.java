/**
 * Copyright (c) 2016 JAHA SMART CORP., LTD ALL RIGHT RESERVED
 */
package com.jaha.evote.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import com.googlecode.ehcache.annotations.Cacheable;
import com.jaha.evote.domain.Menu;
import com.jaha.evote.domain.type.RoleType;
import com.jaha.evote.mapper.MenuMapper;

/**
 * <pre>
 * Class Name : MenuService.java
 * Description : 메뉴서비스
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
@Service
public class MenuService extends BaseService {

    @Autowired
    private MenuMapper menuMapper;

    @Value("${menu.root.name.admin}")
    private String defaultAdminRootMenuName;

    @Value("${menu.root.name.front}")
    private String defaultFrontRootMenuName;

    /**
     * 메뉴 목록 조회
     * 
     * @param isAdminSite
     * @param roleType
     * @return
     */
    @Cacheable(cacheName = "menuListCache")
    public List<Menu> selectMenuList(boolean isAdminSite, RoleType roleType) {

        String rootMenuNm = null;

        if (isAdminSite) {
            rootMenuNm = defaultAdminRootMenuName;
        } else {
            rootMenuNm = defaultFrontRootMenuName;
        }

        logger.debug("### rootMenuNm [{}], roleType [{}]", rootMenuNm, roleType.name());

        return menuMapper.selectMenuList(rootMenuNm, roleType);
    }

    /**
     * breadcrumb 조회
     * 
     * @param requestURI
     * @return
     */
    @Cacheable(cacheName = "breadcrumbCache")
    public List<Menu> selectBreadcrumb(String requestURI) {

        logger.debug("### requestURI :: [{}]", requestURI);

        List<Menu> breadcrumbList = null;

        List<Integer> menuIds = menuMapper.selectMenuIdsByUrl(requestURI);

        logger.debug("### menuIds size :: [{}]", menuIds.size());

        if (menuIds != null && !menuIds.isEmpty()) {
            breadcrumbList = menuMapper.selectBreadcrumbList(menuIds.get(0));
        }

        return breadcrumbList;

    }

}
