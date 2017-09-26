package com.jaha.evote.domain;

import java.io.Serializable;

import com.jaha.evote.common.util.XecureUtil;

/**
 * <pre>
 * Class Name : EncryptedString.java
 * Description : 암호화 문자열 정보
 *  
 * Modification Information
 * 
 * Mod Date         Modifier    Description
 * -----------      --------    ---------------------------
 * 2016. 11. 7.     jjpark      Generation
 * </pre>
 *
 * @author jjpark
 * @since 2016. 11. 7.
 * @version 1.0
 */
public class EncryptedString implements Serializable {

    private static final long serialVersionUID = -5200158399249545197L;

    protected String value;

    public EncryptedString() {}

    /**
     * @param value
     */
    public EncryptedString(String value) {
        this.value = value;
    }

    /**
     * @return
     */
    public String getValue() {
        return value;
    }

    /**
     * setValue
     * 
     * @param value
     */
    public void setValue(String value) {
        this.value = value;
    }

    /**
     * getDecValue
     * 
     * @return
     */
    public String getDecValue() {
        return XecureUtil.decString(this.value);
    }

}
