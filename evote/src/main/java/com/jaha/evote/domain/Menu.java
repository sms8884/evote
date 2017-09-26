/**
 * Copyright (c) 2016 JAHA SMART CORP., LTD ALL RIGHT RESERVED
 */
package com.jaha.evote.domain;

import java.io.Serializable;

/**
 * <pre>
 * Class Name : Menu.java
 * Description : Description
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
public class Menu implements Serializable {

    private static final long serialVersionUID = -4827016713193404053L;

    private int menuId;
    private String menuNm;
    private String menuUrl;
    private int parentId;
    private int dpOrd;
    private int depth;
    private int level;
    private String useYn;
    private String siblingValue;

    public int getMenuId() {
        return menuId;
    }

    public void setMenuId(int menuId) {
        this.menuId = menuId;
    }

    public String getMenuNm() {
        return menuNm;
    }

    public void setMenuNm(String menuNm) {
        this.menuNm = menuNm;
    }

    public String getMenuUrl() {
        return menuUrl;
    }

    public void setMenuUrl(String menuUrl) {
        this.menuUrl = menuUrl;
    }

    public int getParentId() {
        return parentId;
    }

    public void setParentId(int parentId) {
        this.parentId = parentId;
    }

    public int getDpOrd() {
        return dpOrd;
    }

    public void setDpOrd(int dpOrd) {
        this.dpOrd = dpOrd;
    }

    public int getDepth() {
        return depth;
    }

    public void setDepth(int depth) {
        this.depth = depth;
    }

    public int getLevel() {
        return level;
    }

    public void setLevel(int level) {
        this.level = level;
    }

    public String getUseYn() {
        return useYn;
    }

    public void setUseYn(String useYn) {
        this.useYn = useYn;
    }

    public String getSiblingValue() {
        return siblingValue;
    }

    public void setSiblingValue(String siblingValue) {
        this.siblingValue = siblingValue;
    }
}
